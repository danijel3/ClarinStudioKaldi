# ClarinStudioKaldi

A baseline Automatic Speech Recognition system for Polish based on Kaldi.

The scripts and files are based on WSJ Kaldi example pulled from the github on Aug, 19. 2016

## Contacts

 * Krzysztof Marasek <kmarasek@pja.edu.pl>
 * Danijel Koržinek <danijel@pja.edu.pl>
 * Łukasz Brocki <lucas@pja.eud.pl>
 * Krzysztof Wołk <kwolk@pja.edu.pl>

## About the licenses

The audio dataset is released under the license terms described in the LICENSE.audio file.

Any code in this archive that is a part of the Kaldi project (http://kaldi-asr.org) and its license terms are described in the individual files.

Any other code in the archive is released on the same terms as the majority of the Kaldi project - the Apache 2.0 License.

## Usage

Obtain Kaldi from http://kaldi-asr.org/

Modify path.sh and possibly cmd.sh.

Open and read run.sh for all the details or simply run the script.

The corpus was contructed from the full studio corpus, where 10% (55) of randomly chosen sessions were held-out for the test set. If you intend to compare your result to this baseline, we recommend not modifying the train/test set.

## Baseline results

```
%WER 30.20 [ 7909 / 26189, 1189 ins, 1480 del, 5240 sub ] exp/mono0/decode/wer_10_0.0
%WER 17.79 [ 4658 / 26189, 1095 ins, 757 del, 2806 sub ] exp/tri1/decode/wer_16_0.0
%WER 17.69 [ 4632 / 26189, 1088 ins, 651 del, 2893 sub ] exp/tri3b/decode_nosp.si/wer_16_0.0
%WER 16.97 [ 4445 / 26189, 1139 ins, 526 del, 2780 sub ] exp/tri3b/decode.si/wer_16_0.0
%WER 16.97 [ 4445 / 26189, 1139 ins, 526 del, 2780 sub ] exp/tri3b_mmi/decode.si/wer_16_0.0
%WER 16.97 [ 4445 / 26189, 1139 ins, 526 del, 2780 sub ] exp/tri3b_mmi/decode_wb.si/wer_16_0.0
%WER 16.81 [ 4402 / 26189, 1001 ins, 769 del, 2632 sub ] exp/tri2a/decode/wer_17_0.0
%WER 15.85 [ 4150 / 26189, 1040 ins, 645 del, 2465 sub ] exp/tri2b/decode/wer_17_0.0
%WER 13.65 [ 3574 / 26189, 1095 ins, 467 del, 2012 sub ] exp/tri3b/decode_nosp/wer_17_0.0
%WER 13.02 [ 3410 / 26189, 1007 ins, 447 del, 1956 sub ] exp/tri3b/decode/wer_17_0.5
%WER 12.31 [ 3225 / 26189, 1035 ins, 364 del, 1826 sub ] exp/tri3b_mmi/decode/wer_15_0.0
%WER 11.66 [ 3053 / 26189, 942 ins, 376 del, 1735 sub ] exp/tri3b_mmi/decode_wb/wer_15_0.0
%WER 8.76 [ 2294 / 26189, 771 ins, 356 del, 1167 sub ] exp/nnet3/tdnn1a_sp/decode/wer_14_0.0
%WER 7.48 [ 1960 / 26189, 755 ins, 231 del, 974 sub ] exp/tri3b_mmi/decode_rs/wer_17_0.5
%WER 6.88 [ 1801 / 26189, 488 ins, 306 del, 1007 sub ] exp/chain/tdnn1f_sp/decode/wer_10_0.5
%WER 5.77 [ 1512 / 26189, 586 ins, 259 del, 667 sub ] exp/nnet3/tdnn1a_sp/decode_rs/wer_16_1.0
%WER 4.36 [ 1143 / 26189, 403 ins, 198 del, 542 sub ] exp/chain/tdnn1f_sp/decode_rs/wer_12_0.0
```

### Lattice oracles

```
exp/tri3b_mmi/decode_wb/oracle_wer: 3.28% [ 858 / 26189, 575 insertions, 14 deletions, 269 substitutions ]
exp/nnet3/tdnn1a_sp/decode/oracle_wer: 3.01% [ 787 / 26189, 513 insertions, 28 deletions, 246 substitutions ]
exp/chain/tdnn1f_sp/decode/oracle_wer: 1.56% [ 408 / 26189, 238 insertions, 26 deletions, 144 substitutions ]
```

### Model legend

  * ``mono0`` - initial monophone model
  * ``tri1`` - initial triphone model
  * ``tri2a`` - triphone model retrained on realigned corpus
  * ``tri2b`` - triphones + context (+/-3 frames) + LDA
  * ``tri3b(nosp)`` - ``tri2b`` + SAT (fMLLR)
  * ``tri3b(si)`` - same as tri3b, but without speaker adaptation
  * ``tri3b`` - tri3b(nosp) but with lexicon rescoring and silence probabilities
  * ``tri3b_mmi`` - tri3b with MMI discriminative training
  * ``tri3b_mmi(wb)`` - ``tri3b_mmi`` decoded with a wide beam
  * ``tri3b_mmi(ts)`` - ``tri3b_mmi(wb)`` rescored with a large LM
  * ``nnet3`` - regular TDNN
  * ``nnet3(rs)`` - TDNN rescored with a large LM
  * ``chain`` - chain TDNN
  * ``chain(rs)`` chain TDNN rescored with a large LM

### Training times

All the experiment from the start (creating the initial MFCC features) to the last GMM based model (``tri3b_mmi/decode_rs``), also including all the decoding steps, took 3 hours and 29 minutes on a double Intel(R) Xeon(R) CPU E5-2690 v3 @ 2.60GHz using 40 parallel jobs.

The ``nnet3/run_ivectors_common.sh`` script took 35 minuntes to complete on the same CPU settings.

The regular TDNN model took 2 hours 34 minutes on a triple NVIDIA K80 using at most 6 parallel GPU jobs. Decoding on the 40 threads of the CPU took about 5 minutes with an average real-time factor of 1.89 (i.e. almost 2 times slower than real-time).

The chain TDNN took 1 hour 11 minuts on the same GPU settings as above. Decoding on 55 parallel CPU threads took about 2 minutes with an average real-time factor of 1.07 (i.e. almost real-time).
