#!/bin/bash

. ./path.sh ## set the paths in this file correctly!
. ./cmd.sh ## You'll want to change cmd.sh to something that will work on your system.
           ## This relates to the queue.

# exits script if error occurs anywhere
# you might not want to do this for interactive shells.
set -e

#check if the user wants to clean the project
local_clarin/clarin_pl_clean.sh

export nj=40 ##number of concurrent processes

# This is a shell script, but it's recommended that you run the commands one by
# one by copying and pasting into the shell.

#run some initial data preparation (look at the file for more details):
local_clarin/clarin_pl_data_prep.sh

#prepare the lang directory
utils/prepare_lang.sh data/local/dict "<unk>" data/local/lang data/lang

#make G.fst
utils/format_lm.sh data/lang data/local/arpa.lm.gz data/local/dict/lexicon.txt data/lang_test

# Make MFCC features.
# mfccdir should be some place where you want to store MFCC features (~225MB in size)
mfccdir=feat
for x in train test ; do 
 steps/make_mfcc.sh --cmd "$train_cmd" --nj $nj \
   data/$x exp/make_mfcc/$x $mfccdir
 steps/compute_cmvn_stats.sh data/$x exp/make_mfcc/$x $mfccdir
done

#train Monophone system
steps/train_mono.sh --nj $nj --cmd "$train_cmd" \
  data/train data/lang exp/mono0

#test Monophone system
utils/mkgraph.sh --mono data/lang_test exp/mono0 exp/mono0/graph
steps/decode.sh --nj $nj --cmd "$decode_cmd" \
  exp/mono0/graph data/test exp/mono0/decode

#align using the Monophone system
steps/align_si.sh --nj $nj --cmd "$train_cmd" \
   data/train data/lang exp/mono0 exp/mono0_ali

#train initial Triphone system
steps/train_deltas.sh --cmd "$train_cmd" \
    2000 10000 data/train data/lang exp/mono0_ali exp/tri1

#test initial Triphone system
utils/mkgraph.sh data/lang_test exp/tri1 exp/tri1/graph
steps/decode.sh --nj $nj --cmd "$decode_cmd" \
  exp/tri1/graph data/test exp/tri1/decode

#re-align using the initial Triphone system
steps/align_si.sh --nj $nj --cmd "$train_cmd" \
  data/train data/lang exp/tri1 exp/tri1_ali

#train tri2a, which is deltas + delta-deltas
steps/train_deltas.sh --cmd "$train_cmd" \
  2500 15000 data/train data/lang exp/tri1_ali exp/tri2a

#test tri2a
utils/mkgraph.sh data/lang_test exp/tri2a exp/tri2a/graph
steps/decode.sh --nj $nj --cmd "$decode_cmd" \
  exp/tri2a/graph data/test exp/tri2a/decode

#train tri2b, which is tri2a + LDA
steps/train_lda_mllt.sh --cmd "$train_cmd" \
   --splice-opts "--left-context=3 --right-context=3" \
   2500 15000 data/train data/lang exp/tri1_ali exp/tri2b

#test tri2b
utils/mkgraph.sh data/lang_test exp/tri2b exp/tri2b/graph
steps/decode.sh --nj $nj --cmd "$decode_cmd" \
  exp/tri2b/graph data/test exp/tri2b/decode


#re-align tri2b system
steps/align_si.sh  --nj $nj --cmd "$train_cmd" \
  --use-graphs true data/train data/lang exp/tri2b exp/tri2b_ali 


#from 2b system, train 3b which is LDA + MLLT + SAT.
steps/train_sat.sh --cmd "$train_cmd" \
  2500 15000 data/train data/lang exp/tri2b_ali exp/tri3b

#test tri3b
utils/mkgraph.sh data/lang_test exp/tri3b exp/tri3b/graph
steps/decode_fmllr.sh --nj $nj --cmd "$decode_cmd" \
  exp/tri3b/graph data/test exp/tri3b/decode


#get pronounciation probabilities and silence information 
./steps/get_prons.sh data/train data/lang exp/tri3b || exit  1;

#recreate dict with new pronounciation and silence probabilities
./utils/dict_dir_add_pronprobs.sh data/local/dict exp/tri3b/pron_counts_nowb.txt exp/tri3b/sil_counts_nowb.txt exp/tri3b/pron_bigram_counts_nowb.txt data/local/dict_sp

#recreate lang directory
utils/prepare_lang.sh data/local/dict_sp "<unk>" data/local/lang_sp data/lang_sp

#recreate G.fst
utils/format_lm.sh data/lang_sp data/local/arpa.lm.gz data/local/dict_sp/lexicon.txt data/lang_test_sp

#test tri3b on sp
utils/mkgraph.sh data/lang_test_sp exp/tri3b exp/tri3b/graph_sp
steps/decode_fmllr.sh --nj $nj --cmd "$decode_cmd" \
  exp/tri3b/graph_sp data/test exp/tri3b/decode_sp


#increase the number of mixtures
steps/mixup.sh --cmd "$train_cmd" \
   20000 data/train data/lang_sp exp/tri3b exp/tri3b_20k

#test the larger model
steps/decode_fmllr.sh --cmd "$decode_cmd" --nj $nj \
   exp/tri3b/graph_sp data/test exp/tri3b_20k/decode 

#from 3b system, align all data
steps/align_fmllr.sh --nj $nj --cmd "$train_cmd" \
  data/train data/lang_sp exp/tri3b exp/tri3b_ali

#train MMI on tri3b (LDA+MLLT+SAT)
steps/make_denlats.sh --nj $nj --cmd "$train_cmd" \
  --transform-dir exp/tri3b_ali data/train data/lang_sp exp/tri3b \
  exp/tri3b_denlats
steps/train_mmi.sh --cmd "$train_cmd" data/train data/lang_sp exp/tri3b_ali exp/tri3b_denlats exp/tri3b_mmi

#test MMI
steps/decode_fmllr.sh --nj $nj --cmd "$decode_cmd" \
  --alignment-model exp/tri3b/final.alimdl --adapt-model exp/tri3b/final.mdl \
  exp/tri3b/graph_sp data/test exp/tri3b_mmi/decode

#decode MMI using wider beam
steps/decode_fmllr.sh --nj $nj --cmd "$decode_cmd" \
  --alignment-model exp/tri3b/final.alimdl --adapt-model exp/tri3b/final.mdl \
  --beam 24 --lattice-beam 12 \
  exp/tri3b/graph_sp data/test exp/tri3b_mmi/decode_wb

#compute the oracle on the last decoding result - to see how much is possible using these lattices
./steps/oracle_wer.sh data/test data/lang_sp exp/tri3b_mmi/decode_wb

#download a large LM (~843MB)
if [ ! -f data/local/large.arpa.gz ] ; then
(
	cd data/local
	curl -O http://mowa.clarin-pl.eu/korpusy/large.arpa.gz
)
fi

#create the const-arpa lang dir
./utils/build_const_arpa_lm.sh data/local/large.arpa.gz data/lang_sp data/lang_carpa

#perform rescoring using the large LM in carpa format (much faster than regular arpa)
./steps/lmrescore_const_arpa.sh data/lang_test_sp data/lang_carpa data/test exp/tri3b_mmi/decode_wb exp/tri3b_mmi/decode_rs

# Getting results
cat exp/*/decode*/scoring_kaldi/best_wer | sort -k2nr
cat exp/*/decode*/oracle_wer


# NNET - run this only if you have a fast computer with GPUs!
# ./local_clarin/clarin_ivector_common.sh
# ./local_clarin/clarin_tdnn.sh --stage 8
# ./steps/nnet3/oracle_wer.sh data/test data/lang exp/nnet3/nnet_tdnn_a/decode
# ./steps/lmrescore_const_arpa.sh data/lang_test_sp data/lang_carpa data/test exp/nnet3/nnet_tdnn_a/decode exp/nnet3/nnet_tdnn_a/decode_rs
# cat exp/nnet3/nnet_tdnn_a/decode*/scoring_kaldi/best_wer | sort -k2nr
# cat exp/nnet3/nnet_tdnn_a/decode/oracle_wer

# LSTM - this one is even slower to train!
# ./local_clarin/clarin_lstm.sh --stage 8
# ./steps/nnet3/oracle_wer.sh data/test data/lang exp/nnet3/lstm_ld5/decode
# ./steps/lmrescore_const_arpa.sh data/lang_test_sp data/lang_carpa data/test exp/nnet3/lstm_ld5/decode exp/nnet3/lstm_ld5/decode_rs
# cat exp/nnet3/lstm_ld5/decode*/scoring_kaldi/best_wer | sort -k2nr
# cat exp/nnet3/lstm_ld5/decode/oracle_wer
