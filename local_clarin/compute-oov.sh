#!/bin/bash

use_srilm=false
use_lex=false
print_oov=false
echo "$0 $@"  # Print the command line for logging

[ -f ./path.sh ] && . ./path.sh; # source the path.
. parse_options.sh || exit 1;

if [ $# != 3 ]; then
   echo "Usage: compute_oov.sh [options] <data-dir> <vocab-file> <tmp-dir>"
   echo "  Computes the OOV rates."
   echo "Options:"
   echo "  --use_srilm      # use SRILM to compute the rates (default:false)"
   echo "  --use_lex        # use lexicon instead of vocab file (default: false)"
   echo "  --print_oov      # print OOV words to screen (default: false)"
   exit 1;
fi;

data=$1
vocab=$2
tmp=$3

mkdir -p $tmp

for f in $data/text $vocab; do
    [ ! -f $f ] && echo "compute-oov.sh: no such file $f" && exit 1;
done

if $use_srilm; then
    echo 'Computing using SRILM...'

    cut -f2- -d' ' $data/text > $tmp/text
    ngram-count -text $tmp/text -write $tmp/counts
    if $use_lex; then
        cut -f1 -d' ' $vocab | sort -u > $tmp/vocab
    else
        sort -u $vocab -o $tmp/vocab
    fi
    
    compute-oov-rate $tmp/vocab $tmp/counts > $tmp/oov
else
    echo 'Computing OOV...'

    cut -f2- -d' ' $data/text > $tmp/text
    tr ' ' '\n' < $tmp/text | sed '/^\s*$/d' | sort | uniq -c | tail -n +1 > $tmp/counts
    
    if $use_lex; then
        cut -f1 -d' ' $vocab | sort -u > $tmp/vocab
    else
        sort -u $vocab -o $tmp/vocab
    fi

    awk '{print $2}' < $tmp/counts > $tmp/iv

    comm -23 $tmp/iv $tmp/vocab > $tmp/oov.list

    grep -f $tmp/oov.list $tmp/counts > $tmp/oov.counts

    iv_num=`wc -l < $tmp/iv`
    iv_count=`awk '{sum+=$1} END {print sum}' $tmp/counts`
    oov_num=`wc -l < $tmp/oov.list`
    oov_count=`awk '{sum+=$1} END {print sum}' $tmp/oov.counts`

    awk 'BEGIN {printf "Number of OOVs: %d / %d = %.5f%%\n", '$oov_num', '$iv_num', ('$oov_num'/'$iv_num')*100 }' > $tmp/oov
    awk 'BEGIN {printf "Number of OOV counts: %d / %d = %.5f%%\n", '$oov_count', '$iv_count', ('$oov_count'/'$iv_count')*100 }' >> $tmp/oov

    if $print_oov ; then
        echo "OOV words:"
        sort -k1nr,2 $tmp/oov.counts
        echo "---end oov words"
    fi
fi

cat $tmp/oov

exit 0;
