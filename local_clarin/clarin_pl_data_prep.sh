#!/bin/bash

#you can change this here, if you want it on a different partition, for example
AUDIO_DL_PATH=./data


(
	cd $AUDIO_DL_PATH
	if [ ! -f audio.tar.gz ] ; then
		echo "Downloading audio from the Clarin-pl website (~4.6GB)..."
		curl -O http://mowa.clarin-pl.eu/korpusy/audio.tar.gz
	fi

	if [ ! -d audio	] ; then
		echo "Extracting files..."
		tar xf audio.tar.gz
	else
		echo "Files already extracted?"
		echo "Remove the audio dir to extract them egain..."
	fi
)


echo Generating file lists using proper paths...
python local_clarin/generate_lists.py $AUDIO_DL_PATH/audio data

utils/utt2spk_to_spk2utt.pl data/train/utt2spk > data/train/spk2utt
utils/utt2spk_to_spk2utt.pl data/test/utt2spk > data/test/spk2utt
