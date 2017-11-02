#!/bin/bash

. ./path.sh

#you can change this here, if you want it on a different partition, for example
AUDIO_DL_PATH=audio

if [ ! -d $AUDIO_DL_PATH ] ; then mkdir -p $AUDIO_DL_PATH ; fi
pushd $AUDIO_DL_PATH
if [ ! -f audio.tar.gz ] ; then
	echo "Downloading audio from the Clarin-pl website (~4.6GB)..."
	curl -O http://mowa.clarin-pl.eu/korpusy/audio.tar.gz
else
	echo "File already downloaded! Checking if download is consistent..."
	curl -O http://mowa.clarin-pl.eu/korpusy/audio.md5sum
	if ! md5sum -c audio.md5sum ; then
		echo "Download doesn't match the one on the server! "
		echo "Erase the audio.tar.gz file (and audio folder) and run this script again!"
		exit -1
	fi
fi

if [ ! -d audio	] ; then
	echo "Extracting files..."
	tar xf audio.tar.gz
else
	echo "Files already extracted?"
	echo "Remove the audio dir to extract them again..."
fi
popd


if [ ! -d data ] ; then mkdir data ; fi

echo Generating file lists using proper paths...
python local_clarin/generate_lists.py $AUDIO_DL_PATH/audio data local_clarin

echo Generating spk2utt...
utils/utt2spk_to_spk2utt.pl data/train/utt2spk > data/train/spk2utt
utils/utt2spk_to_spk2utt.pl data/test/utt2spk > data/test/spk2utt

echo Preparing dictionary...
if [ ! -d data/local ] ; then mkdir data/local ; fi

cut -f2- -d' ' < data/train/text | tr ' ' '\n' | sort -u > data/local/train.wlist
if [ x"$(which ngram)" != x"" ]
then
	ngram -lm local_clarin/arpa.lm.gz -unk -write-vocab data/local/lm.wlist
else
	perl local_clarin/extract_vocab.pl local_clarin/arpa.lm.gz > data/local/lm.wlist
fi
tail -n +5 data/local/lm.wlist | cat data/local/train.wlist - | sort -u > data/local/all.wlist
if [ ! -f local_clarin/model.fst ] ; then gunzip -c local_clarin/model.fst.gz > local_clarin/model.fst ; fi
local_clarin/clarin_prepare_dict.sh data/local/all.wlist data/local/dict_nosp
