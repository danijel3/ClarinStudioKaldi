#!/bin/bash

#you can change this here, if you want it on a different partition, for example
AUDIO_DL_PATH=./data


(
	cd $AUDIO_DL_PATH
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
)


echo Generating file lists using proper paths...
python local_clarin/generate_lists.py $AUDIO_DL_PATH/audio data

echo Removing BOMs from data...
sed -i 's/\xef\xbb\xbf//g' data/test/text
sed -i 's/\xef\xbb\xbf//g' data/train/text

echo Removing empty lines...
python local_clarin/remove_empty.py data/train/text
python local_clarin/remove_empty.py data/test/text

echo Generating spk2utt...
utils/utt2spk_to_spk2utt.pl data/train/utt2spk > data/train/spk2utt
utils/utt2spk_to_spk2utt.pl data/test/utt2spk > data/test/spk2utt
