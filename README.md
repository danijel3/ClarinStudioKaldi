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
%WER 29.68 [ 7773 / 26189, 999 ins, 1682 del, 5092 sub ] exp/mono0/decode/wer_11_0.0
%WER 17.45 [ 4570 / 26189, 1013 ins, 698 del, 2859 sub ] exp/tri3b/decode.si/wer_17_0.0
%WER 17.45 [ 4570 / 26189, 1013 ins, 698 del, 2859 sub ] exp/tri3b_mmi/decode.si/wer_17_0.0
%WER 17.45 [ 4570 / 26189, 1013 ins, 698 del, 2859 sub ] exp/tri3b_mmi/decode_wb.si/wer_17_0.0
%WER 17.18 [ 4498 / 26189, 889 ins, 828 del, 2781 sub ] exp/tri1/decode/wer_17_0.0
%WER 17.11 [ 4482 / 26189, 1021 ins, 655 del, 2806 sub ] exp/tri3b_20k/decode.si/wer_16_0.0
%WER 16.28 [ 4263 / 26189, 939 ins, 686 del, 2638 sub ] exp/tri2a/decode/wer_16_0.0
%WER 15.82 [ 4143 / 26189, 979 ins, 620 del, 2544 sub ] exp/tri2b/decode/wer_16_0.0
%WER 13.40 [ 3509 / 26189, 1012 ins, 474 del, 2023 sub ] exp/tri3b/decode/wer_18_0.0
%WER 13.07 [ 3423 / 26189, 928 ins, 516 del, 1979 sub ] exp/tri3b_20k/decode/wer_20_0.0
%WER 12.59 [ 3296 / 26189, 1048 ins, 412 del, 1836 sub ] exp/tri3b_mmi/decode/wer_14_0.0
%WER 11.98 [ 3137 / 26189, 973 ins, 419 del, 1745 sub ] exp/tri3b_mmi/decode_wb/wer_14_0.0
%WER 7.56 [ 1980 / 26189, 700 ins, 289 del, 991 sub ] exp/tri3b_mmi/decode_rs/wer_19_0.5
```

### Lattice oracle of exp/tri3b_mmi/decode_wb

```
3.30% [ 865 / 26189, 567 insertions, 13 deletions, 285 substitutions ]
```

## NNest results

These take a little bit longer to train and require GPUs (~2.5 hours)

### TDNN setup (nnet3)
```
%WER 9.72 [ 2545 / 26189, 792 ins, 406 del, 1347 sub ] exp/nnet3/nnet_tdnn_a/decode/wer_12_0.0
%WER 6.24 [ 1634 / 26189, 613 ins, 257 del, 764 sub ] exp/nnet3/nnet_tdnn_a/decode_rs/wer_16_0.0
```

### Oracle of nnet3 lattices
```
3.13% [ 598 / 19098, 355 insertions, 23 deletions, 220 substitutions ]
```
