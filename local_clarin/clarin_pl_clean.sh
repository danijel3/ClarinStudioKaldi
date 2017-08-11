#!/bin/bash

echo -n "Would you like to clean all the data and experiments in this project? (type yes): "
read f
if [[ "$f" != "yes" ]] ; then
	echo "Exitting..."
	exit 1
fi


echo "Cleaning directory..."
rm -rf exp
rm -rf data
echo "Done!"
