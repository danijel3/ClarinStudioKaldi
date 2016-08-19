#!/bin/bash

echo -n "Would you like to clean everything all the experiments in this project? (type yes): "
read f
if [[ "$f" != "yes" ]] ; then
	echo "Exitting..."
	exit 1
fi


echo "Cleaning directory..."
rm -rf feat
rm -rf exp
rm -rf data/lang
rm -rf data/local/lang
rm -f data/local/lm.arpa
rm -f data/local/vocab_full.txt
rm -f data/local/dict/lexicon.txt
rm -f data/local/dict/lexiconp.txt
echo "Done!"
