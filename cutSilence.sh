#!/bin/bash

# Copyright: Junyi Wang
# This is a script that match the onset and duration of the video with the audio

for i in `seq 1 34`;
do
	name='id'$i
	if [ $i -ne 21 ]
	then
		# processing train dataset
		for wavname in ./audio/train/isolated/$name/*;
		do
			duration=$(python ./duration.py $wavname)
			# echo $duration
			suffix=".wav"
			mpgname=$(echo $wavname | cut -d "/" -f6 | sed -e "s/wav$/mpg/")
			mpgpath=./video/s$i/$mpgname
			#echo $mpgname
			# calculate the silence end using a noise filter that detect noise with -15dB and has a duration of 0.3s
			silence=$(ffmpeg -i $mpgpath -af silencedetect=noise=-15dB:d=0.3 -f null - 2> vol.txt; cat vol.txt | grep -m 1 "silence_end:" | cut -d " " -f5)
			# echo $silence
			mkdir -p ./video/cut/s$i/
			output=./video/cut/s$i/$(echo $mpgname | sed -e "s/\.mpg$/\.mp4/")
			# echo $output
			# remove the silent beginning of the video, and cut with the duration of audio
			ffmpeg -y -hide_banner -loglevel panic -i $mpgpath -ss 00:00:0$silence -t $duration -strict -2 $output
		done
		echo "$name training set cut complete"

		prefix='s'$i'_'
		# process devel dataset
		for wavname in ./audio/devel/isolated/0dB/$prefix*;
		do
                        duration=$(python ./duration.py $wavname) 
                        # echo $duration
                        suffix=".wav"
                        mpgname=$(echo $wavname | cut -d "/" -f6 | cut -d "_" -f2 | sed -e "s/wav$/mpg/")
                        mpgpath=./video/s$i/$mpgname
#                        echo $mpgpath
                        # calculate the silence end
                        silence=$(ffmpeg -i $mpgpath -af silencedetect=noise=-15dB:d=0.3 -f null - 2> vol.txt; cat vol.txt | grep -m 1 "silence_end:" | cut -d " " -f5)
 #                       echo $silence
                        mkdir -p ./video/cut/s$i/
                        output=./video/cut/s$i/$(echo $mpgname | sed -e "s/\.mpg$/\.mp4/")
                        #echo $output
                       ffmpeg -y -hide_banner -loglevel panic -i $mpgpath -ss 00:00:0$silence -t $duration -strict -2 $output
		done
		echo "$name devel set cut complete"

		# process test dataset
		for wavname in ./audio/test/isolated/0dB/$prefix*;
		do
                        duration=$(python ./duration.py $wavname) 
#                        echo $duration
                        suffix=".wav"
                        mpgname=$(echo $wavname | cut -d "/" -f6 | cut -d "_" -f2 | sed -e "s/wav$/mpg/")
                        mpgpath=./video/s$i/$mpgname
                        #echo $mpgname
                        # calculate the silence end
                        silence=$(ffmpeg -i $mpgpath -af silencedetect=noise=-15dB:d=0.3 -f null - 2> vol.txt; cat vol.txt | grep -m 1 "silence_end:" | cut -d " " -f5)
#                        echo $silence
                        mkdir -p ./video/cut/s$i/
                        output=./video/cut/s$i/$(echo $mpgname | sed -e "s/\.mpg$/\.mp4/")
                        #echo $output
                        ffmpeg -y -hide_banner -loglevel panic -i $mpgpath -ss 00:00:0$silence -t $duration -strict -2 $output
		done
		echo "$name test set cut complete"
	fi
	echo "$name cut complete"
done
