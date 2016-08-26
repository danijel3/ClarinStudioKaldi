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

From the begnning, until rescoring tri3b_mmi using the large const-arpa model, it takes about 5 hours to run, with nj=10.

The corpus was contructed from the full studio corpus, where 10% (55) of randomly chosen sessions were held-out for the test set. If you intend to compare your result to this baseline, we recommend not modifying the train/test set.

## LM description

TODO

## Baseline results

```
%WER 30.28 [ 7929 / 26189, 1185 ins, 1532 del, 5212 sub ] exp/mono0/decode/wer_10_0.0
%WER 17.61 [ 4613 / 26189, 1011 ins, 710 del, 2892 sub ] exp/tri3b/decode.si/wer_17_0.0
%WER 17.61 [ 4613 / 26189, 1011 ins, 710 del, 2892 sub ] exp/tri3b_mmi/decode.si/wer_17_0.0
%WER 17.61 [ 4613 / 26189, 1011 ins, 710 del, 2892 sub ] exp/tri3b_mmi/decode_wb.si/wer_17_0.0
%WER 17.26 [ 4520 / 26189, 1007 ins, 768 del, 2745 sub ] exp/tri1/decode/wer_16_0.0
%WER 17.19 [ 4501 / 26189, 998 ins, 701 del, 2802 sub ] exp/tri3b_20k/decode.si/wer_17_0.0
%WER 16.75 [ 4387 / 26189, 1104 ins, 660 del, 2623 sub ] exp/tri2a/decode/wer_15_0.0
%WER 15.82 [ 4143 / 26189, 990 ins, 657 del, 2496 sub ] exp/tri2b/decode/wer_17_0.0
%WER 13.69 [ 3584 / 26189, 1041 ins, 529 del, 2014 sub ] exp/tri3b/decode/wer_19_0.0
%WER 13.43 [ 3516 / 26189, 987 ins, 567 del, 1962 sub ] exp/tri3b_20k/decode/wer_18_0.5
%WER 13.23 [ 3465 / 26189, 1185 ins, 453 del, 1827 sub ] exp/tri3b_mmi/decode/wer_15_0.0
%WER 12.38 [ 3242 / 26189, 991 ins, 490 del, 1761 sub ] exp/tri3b_mmi/decode_wb/wer_16_0.0
%WER 7.69 [ 2015 / 26189, 798 ins, 256 del, 961 sub ] exp/tri3b_mmi/decode_rs/wer_19_0.0
```

### Lattice oracle of exp/tri3b_mmi/decode_wb

```
3.27% [ 857 / 26189, 561 insertions, 16 deletions, 280 substitutions ]
```

## NNest results

These take a little bit longer to train and require GPUs: ~2.5 hours for TDNN and >12 hours for LSTM.

### TDNN setup (nnet3)
```
%WER 9.59 [ 2512 / 26189, 699 ins, 497 del, 1316 sub ] exp/nnet3/nnet_tdnn_a/decode/wer_14_0.0
%WER 6.11 [ 1601 / 26189, 602 ins, 275 del, 724 sub ] exp/nnet3/nnet_tdnn_a/decode_rs/wer_16_0.0
```

### Oracle of nnet3 lattices
```
3.07% [ 587 / 19098, 354 insertions, 27 deletions, 206 substitutions ]
```

### LSTM setup
```
%WER 9.03 [ 2366 / 26189, 680 ins, 416 del, 1270 sub ] exp/nnet3/lstm_ld5/decode/wer_11_0.0
%WER 5.85 [ 1531 / 26189, 580 ins, 242 del, 709 sub ] exp/nnet3/lstm_ld5/decode_rs/wer_12_0.0
```

### Oracle for lstm lattices
```
1.92% [ 62 / 3227, 48 insertions, 1 deletions, 13 substitutions ]
```
