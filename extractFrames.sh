#!/bin/bash

# This script is used to extract frames from the cutted videos
# The frame rate should be 25fps

# The extracted frames will be stored in frames
mkdir -p frames

for i in `seq 19 34`;
do
	name='s'$i
	if [ $i -ne 21 ]
	then
		# create dir for each speaker
		mkdir -p frames/$name
		for file in ./video/cut/$name/*;
		do
			# create a dir for each video to store the frames
			basename=$(echo $file | cut -d "/" -f5 | cut -d "." -f1)
			mkdir -p frames/$name/$basename
			ffmpeg -y -hide_banner -loglevel panic -i $file ./frames/$name/$basename/%d.jpg
		done
		echo "Finish extracting frames for $name"
	fi
done
