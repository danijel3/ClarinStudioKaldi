#!/bin/bash

#you can change this here, if you want it on a different partition, for example
AUDIO_DL_PATH=./data


(
	cd $AUDIO_DL_PATH
	if [ ! -f audio.tar.gz ] ; then
		echo "Downloading audio from the Clarin-pl website (~4.6GB)..."
		curl -O http://mowa.clarin-pl.eu/korpusy/audio.tar.gz
	fi
	
	echo "Extracting files..."
	tar xvf audio.tar.gz
)


echo Generating file lists using proper paths...
python local_clarin/generate_lists.py
