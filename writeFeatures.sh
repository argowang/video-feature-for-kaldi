#!/bin/bash

# Copyright: Junyi Wang
# write each frame's feature to the corresponding file
# Takes two arguments 1. the entire.vec 2. the output.list

while IFS= read -r dir && IFS= read -r feat <&3;
do
	# echo "writing to $dir with input $feat"
	# create inter folders
	interDir=$(echo $dir | cut -d "/" -f 1-6)
	# echo $interDir
	mkdir -p $interDir
	echo $feat > $dir
done < $1 3<$2


