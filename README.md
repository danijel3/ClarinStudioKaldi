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

## Baseline results

```
%WER 30.06 [ 7872 / 26189, 1141 ins, 1536 del, 5195 sub ] exp/mono0/decode/wer_10_0.0
%WER 17.56 [ 4598 / 26189, 1005 ins, 758 del, 2835 sub ] exp/tri1/decode/wer_16_0.0
%WER 16.75 [ 4387 / 26189, 1068 ins, 659 del, 2660 sub ] exp/tri2a/decode/wer_15_0.0
%WER 15.75 [ 4125 / 26189, 885 ins, 707 del, 2533 sub ] exp/tri2b/decode/wer_19_0.0
%WER 13.50 [ 3535 / 26189, 1066 ins, 486 del, 1983 sub ] exp/tri3b/decode/wer_18_0.0
%WER 13.10 [ 3432 / 26189, 993 ins, 453 del, 1986 sub ] exp/tri3b/decode_sp/wer_18_0.5
%WER 12.88 [ 3372 / 26189, 976 ins, 459 del, 1937 sub ] exp/tri3b_20k/decode/wer_18_0.5
%WER 12.41 [ 3251 / 26189, 1099 ins, 344 del, 1808 sub ] exp/tri3b_mmi/decode/wer_13_0.0
%WER 11.64 [ 3048 / 26189, 969 ins, 364 del, 1715 sub ] exp/tri3b_mmi/decode_wb/wer_14_0.0
%WER 7.37 [ 1930 / 26189, 752 ins, 204 del, 974 sub ] exp/tri3b_mmi/decode_rs/wer_18_0.0
```

### Lattice oracle of exp/tri3b_mmi/decode_wb

```
3.23% [ 847 / 26189, 564 insertions, 18 deletions, 265 substitutions ]
```

## NNest results

These take a little bit longer to train and require GPUs: ~2.5 hours for TDNN and >12 hours for LSTM.

### TDNN setup (nnet3)
```
%WER 9.25 [ 2423 / 26189, 697 ins, 406 del, 1320 sub ] exp/nnet3/nnet_tdnn_a/decode/wer_14_0.0
%WER 5.91 [ 1549 / 26189, 614 ins, 231 del, 704 sub ] exp/nnet3/nnet_tdnn_a/decode_rs/wer_14_0.5
```

### Oracle of nnet3 lattices
```
2.92% [ 557 / 19098, 353 insertions, 21 deletions, 183 substitutions ]
```

### LSTM setup
```
%WER 8.91 [ 2333 / 26189, 687 ins, 393 del, 1253 sub ] exp/nnet3/lstm_ld5/decode/wer_12_0.0
%WER 5.78 [ 1514 / 26189, 547 ins, 255 del, 712 sub ] exp/nnet3/lstm_ld5/decode_rs/wer_15_0.0
```

### Oracle for lstm lattices
```
2.26% [ 73 / 3227, 52 insertions, 3 deletions, 18 substitutions ]
```
