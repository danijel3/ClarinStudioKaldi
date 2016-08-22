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
rm -rf data/lang_test
rm -rf data/lang_carpa
rm -rf data/local/lang
find data/train ! -name 'sessions' -type f -exec rm -f {} +
find data/test ! -name 'sessions' -type f -exec rm -f {} +
rm -rf data/train/split*
rm -rf data/test/split*
echo "Done!"
