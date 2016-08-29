# ClarinStudioKaldi *stressmarks* branch

This branch is an attempt to introduce stressmarks into the lexicon.

##

Files changed driectly:

  * [data/local/dict/lexicon.txt](data/local/dict/lexicon.txt)
  * [data/local/dict/nonsilence_phones.txt](data/local/dict/nonsilence_phones.txt)
  * [data/local/dict/extra_questions.txt](data/local/dict/extra_questions.txt)

Files changed indirectly (generated using scripts):
  * data/local/dict/lexiconp.txt
  * data/lang\* directories
  * any model/graph generated using the above


## Baseline results (without stressmarks)

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

## New results (with stressmarks)
```
%WER 31.26 [ 8187 / 26189, 977 ins, 1833 del, 5377 sub ] exp/mono0/decode/wer_11_0.0
%WER 17.79 [ 4660 / 26189, 1077 ins, 770 del, 2813 sub ] exp/tri1/decode/wer_16_0.0
%WER 17.55 [ 4596 / 26189, 1076 ins, 682 del, 2838 sub ] exp/tri3b/decode.si/wer_16_0.0
%WER 17.09 [ 4475 / 26189, 1079 ins, 602 del, 2794 sub ] exp/tri3b/decode_sp.si/wer_18_0.0
%WER 17.09 [ 4475 / 26189, 1079 ins, 602 del, 2794 sub ] exp/tri3b_mmi/decode.si/wer_18_0.0
%WER 17.09 [ 4475 / 26189, 1079 ins, 602 del, 2794 sub ] exp/tri3b_mmi/decode_wb.si/wer_18_0.0
%WER 16.64 [ 4358 / 26189, 984 ins, 739 del, 2635 sub ] exp/tri2a/decode/wer_17_0.0
%WER 16.50 [ 4320 / 26189, 1056 ins, 591 del, 2673 sub ] exp/tri3b_20k/decode.si/wer_15_0.5
%WER 15.77 [ 4129 / 26189, 1023 ins, 622 del, 2484 sub ] exp/tri2b/decode/wer_16_0.0
%WER 13.53 [ 3543 / 26189, 1017 ins, 532 del, 1994 sub ] exp/tri3b/decode/wer_19_0.0
%WER 13.20 [ 3458 / 26189, 1057 ins, 446 del, 1955 sub ] exp/tri3b/decode_sp/wer_19_0.0
%WER 12.88 [ 3372 / 26189, 1055 ins, 420 del, 1897 sub ] exp/tri3b_20k/decode/wer_18_0.0
%WER 12.36 [ 3238 / 26189, 1044 ins, 403 del, 1791 sub ] exp/tri3b_mmi/decode/wer_15_0.0
%WER 11.56 [ 3028 / 26189, 894 ins, 438 del, 1696 sub ] exp/tri3b_mmi/decode_wb/wer_16_0.0
%WER 7.51 [ 1966 / 26189, 773 ins, 231 del, 962 sub ] exp/tri3b_mmi/decode_rs/wer_17_0.5
```

### Lattice oracle of exp/tri3b_mmi/decode_wb
```
3.35% [ 878 / 26189, 588 insertions, 10 deletions, 280 substitutions ]
```

