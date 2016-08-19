#!/bin/bash

echo Generating file lists using proper paths...
(
        cd data
        python generate_lists.py
)

echo Generating simple LM...
ngram-count -text data/local/text -lm data/local/lm.arpa -order 3 -kndiscount -unk -write-vocab data/local/vocab_full.txt

echo PPL on training data:
ngram -lm data/local/lm.arpa -ppl data/local/text

echo PPL on test data:
ngram -lm data/local/lm.arpa -ppl data/local/test

transcriber_path=/home/guest/transcriber

if [ ! -f $transcriber_path/transcriber ] 
then
	echo "G2P transcriber missing!"
	echo "I will use the default lexicon..."

	cp data/local/lexicon_default.txt data/local/dict/lexicon.txt

	echo "WARNING: this lexicon works only with the provided language corpus!"
	echo "WARNING: if you want to use a different vocabulary, please change the"
	echo "WARNING: file in data/local/dict/lexicon.txt"
else
	echo Generating lexicon...
	$transcriber_path/transcriber -r $transcriber_path/transcription.rules -w transcriber_path/replacement.rules -i data/local/vocab_full.txt -o data/local/dict/lexicon.txt
	
	sed -i "/^-pau- /d" data/local/dict/lexicon.txt
	sed -i "s/^<s> .*$/<s> sil/" data/local/dict/lexicon.txt
	sed -i "s/^<\/s> .*$/<\/s> sil/" data/local/dict/lexicon.txt
	sed -i "s/^<unk> .*$/<unk> sil/" data/local/dict/lexicon.txt
fi
