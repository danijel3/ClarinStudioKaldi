# ClarinStudioKaldi

A baseline Automatic Speech Recognition system for Polish based on Kaldi.

The scripts and files are based on WSJ Kaldi example pulled from the github on Aug, 11. 2017

## Contacts

 * Krzysztof Marasek <kmarasek@pja.edu.pl>
 * Danijel Koržinek <danijel@pja.edu.pl>
 * Łukasz Brocki <lucas@pja.eud.pl>
 * Krzysztof Wołk <kwolk@pja.edu.pl>
 
## Citation

If you use this in your reaserch, please cite this paper:

> *Danijel Koržinek, Krzysztof Marasek, Łukasz Brocki, and Krzysztof Wołk* **Polish read speech corpus for speech tools and services** In Selected papers from the CLARIN Annual Conference 2016, Aix-en-Provence, 26–28 October 2016, CLARIN Common Language Resourcesand Technology Infrastructure, number 136, pages 54–62. LinköpingUniversity Electronic Press, Linköpings universitet, 2017.


## About the licenses

The audio dataset is released under the license terms described in the LICENSE.audio file.

Any code in this archive that is a part of the Kaldi project (http://kaldi-asr.org) and its license terms are described in the individual files.

Any other code in the archive is released on the same terms as the majority of the Kaldi project - the Apache 2.0 License.

## Usage

Obtain Kaldi from http://kaldi-asr.org/

Modify path.sh and possibly cmd.sh.

Open and read run.sh for all the details or simply run the script.

The corpus was contructed from the full studio corpus, where ~10% (55) of randomly chosen sessions were held-out for the test set. No speaker can be a part of both train and test sets.
If you intend to compare your result to this baseline, we recommend not modifying the train/test set.

## Baseline results

```
%WER 29.90 [ 8684 / 29043, 913 ins, 1868 del, 5903 sub ] exp/mono0/decode/wer_10_0.0
%WER 16.48 [ 4787 / 29043, 719 ins, 847 del, 3221 sub ] exp/tri3b/decode_nosp.si/wer_16_0.0
%WER 15.89 [ 4615 / 29043, 750 ins, 767 del, 3098 sub ] exp/tri3b/decode.si/wer_17_0.0
%WER 15.89 [ 4615 / 29043, 750 ins, 767 del, 3098 sub ] exp/tri3b_mmi/decode.si/wer_17_0.0
%WER 15.89 [ 4615 / 29043, 750 ins, 767 del, 3098 sub ] exp/tri3b_mmi/decode_wb.si/wer_17_0.0
%WER 15.88 [ 4613 / 29043, 660 ins, 851 del, 3102 sub ] exp/tri1/decode/wer_15_0.0
%WER 15.24 [ 4426 / 29043, 672 ins, 795 del, 2959 sub ] exp/tri2a/decode/wer_15_0.0
%WER 14.75 [ 4285 / 29043, 612 ins, 826 del, 2847 sub ] exp/tri2b/decode/wer_17_0.0
%WER 12.20 [ 3542 / 29043, 710 ins, 552 del, 2280 sub ] exp/tri3b/decode_nosp/wer_17_0.0
%WER 11.82 [ 3432 / 29043, 671 ins, 548 del, 2213 sub ] exp/tri3b/decode/wer_17_0.5
%WER 11.21 [ 3256 / 29043, 728 ins, 520 del, 2008 sub ] exp/tri3b_mmi/decode/wer_15_0.5
%WER 11.01 [ 3198 / 29043, 674 ins, 597 del, 1927 sub ] exp/tri3b_mmi/decode_wb/wer_17_0.5
%WER 7.37 [ 2140 / 29043, 381 ins, 416 del, 1343 sub ] exp/nnet3/tdnn1a_sp/decode/wer_13_0.0
%WER 5.73 [ 1663 / 29043, 182 ins, 378 del, 1103 sub ] exp/chain/tdnn1f_sp/decode/wer_10_1.0
%WER 5.30 [ 1540 / 29043, 457 ins, 340 del, 743 sub ] exp/tri3b_mmi/decode_rs/wer_17_1.0
%WER 3.53 [ 1025 / 29043, 262 ins, 229 del, 534 sub ] exp/nnet3/tdnn1a_sp/decode_rs/wer_14_0.0
%WER 2.45 [ 711 / 29043, 113 ins, 184 del, 414 sub ] exp/chain/tdnn1f_sp/decode_rs/wer_13_0.0
```

### Lattice oracles

```
exp/tri3b_mmi/decode_wb/oracle_wer: 2.31% [ 672 / 29043, 330 insertions, 25 deletions, 317 substitutions ]
exp/nnet3/tdnn1a_sp/decode/oracle_wer: 1.56% [ 453 / 29043, 174 insertions, 36 deletions, 243 substitutions ]
exp/chain/tdnn1f_sp/decode/oracle_wer: 0.82% [ 237 / 29043, 57 insertions, 25 deletions, 155 substitutions ]
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
  * ``tri3b_mmi(rs)`` - ``tri3b_mmi(wb)`` rescored with a large LM
  * ``nnet3`` - regular TDNN
  * ``nnet3(rs)`` - TDNN rescored with a large LM
  * ``chain`` - chain TDNN
  * ``chain(rs)`` chain TDNN rescored with a large LM

### Training times

All the experiment from the start (creating the initial MFCC features) to the last GMM based model (``tri3b_mmi/decode_rs``), also including all the decoding steps, took 3 hours and 29 minutes on a double Intel(R) Xeon(R) CPU E5-2690 v3 @ 2.60GHz using 40 parallel jobs.

The ``nnet3/run_ivectors_common.sh`` script took 35 minuntes to complete on the same CPU settings.

The regular TDNN model took 2 hours 34 minutes on a triple NVIDIA K80 using at most 6 parallel GPU jobs. Decoding on the 40 threads of the CPU took about 5 minutes with an average real-time factor of 1.89 (i.e. almost 2 times slower than real-time).

The chain TDNN took 1 hour 11 minuts on the same GPU settings as above. Decoding on 55 parallel CPU threads took about 2 minutes with an average real-time factor of 1.07 (i.e. almost real-time).
