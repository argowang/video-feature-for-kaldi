#!/bin/bash

# Copyright: Junyi Wang

# This script duplicates the video features by four times so the video frames could match audio frames
# Since the audio has a sample rate slightly lower than 100FPS, there will be some extra frames.
# The script will remove the extra frames. The script will also take care of video that does not match in duration

# first generate for training
for i in `seq $1 $2`;
do
	if [ $i -ne 21 ]
	then
		audioDir=./audio/train/isolated/id$i
		mkdir -p ./final/train/isolated/id$i
		rm ./final/train/isolated/id$i/*
		for f in $audioDir/*;
		do
			outputParent=$(echo $audioDir | sed -e 's/audio/final/')
			mkdir -p $outputParent
	#		echo $outputParent
			outputPath=$(echo $f | sed -e 's/audio/final/' | sed -e 's/wav$/ark/')
	#		echo $outputPath
			touch $outputPath
			fileName=$(echo $outputPath | cut -d "/" -f 6 | cut -d "." -f1)
	#		echo $fileName
			audioFrames=$(python ./audioFrames.py $audioDir/$fileName.wav)
	#		echo $audioFrames
			videoFrames=$(find ./features/s$i/$fileName/ -type f | wc -l | cut -d " " -f1)
			videoFrames=$(( $videoFrames*4 ))
			if [ $videoFrames -le $audioFrames ]
			then
				echo "$fileName Bad Bad. Audio has $audioFrames frames and video has $videoFrames frames"
			fi
			# else
			# copy each feature 4 times

			for feat in `ls -v ./features/s$i/$fileName/*`;
			do
				cat $feat >> $outputPath
				cat $feat >> $outputPath
				cat $feat >> $outputPath
				cat $feat >> $outputPath
			done

			if [ $videoFrames -le $audioFrames ]
			then
				mv $outputPath $outputPath.temp
				addOn=$(( $audioFrames-$videoFrames ))
				for count in `seq 1 $addOn`;
				do
					echo "-1.07526939,1.33056536,0.23520028,7.29039088,-0.65575064,-3.73824602,4.34948465,0.04636360,-1.02028523,6.08075967,4.88683092,5.20192609,5.40194182,1.01913696,0.63609746,0.88357561,-1.18532006,-2.72838976,-2.27406292,2.48721767,1.16506734,-0.58038554,-0.97110891,-1.25225009,0.21546026,-1.73226597,-1.79507346,-0.71758321,0.71688353,-0.74939777,-0.25992405,-0.39686163,-0.42525826,-0.21534144,-0.35415515,-1.19992667,0.35281466,-0.39188971,-0.36769794,0.96715358,0.69761494,0.06574137,0.72561776,-0.01499276,0.47068934,1.00712963,-0.35086580,0.54018274,0.13499968,-0.39829489,-0.00325554,0.17271029,-0.63013400,0.92017746,0.08295302,0.79556779,0.02186913,-0.28973214,-0.40193193,0.16317657,0.36195938,0.25184432,0.43931196" >> $outputPath.temp
				done
			else
				# need to match the frames of audio
				head -$audioFrames $outputPath > $outputPath.temp
				# add header and square brackets
				rm $outputPath
			fi
			if [ $i -le 9 ]
			then
				echo "s0$i"_"$fileName"_isolated [ >> $outputPath
			else
				echo "s$i"_"$fileName"_isolated [ >> $outputPath
			fi
			echo "$(cat $outputPath.temp) ]" >> $outputPath

			# remember we add comma before, now we need to remove it
			sed -i $outputPath -e "s/,/ /g"
			rm $outputPath.temp
	#		echo "Finish creating $outputPath"
	#		echo $videoFrames
		done
		echo "s$i video features for training set is finalized"

		# begin finialzing devel set features for s$i
		devAudioDir=./audio/devel/isolated/0dB
		mkdir -p ./final/devel/isolated/0dB
		rm ./final/devel/isolated/0dB/s$i\_*
		for f in `find $devAudioDir/* -type f -name "s$i\_*"`
		do
			# echo $f
			outputParent=$(echo $devAudioDir | sed -e 's/audio/final/')
			mkdir -p $outputParent
			outputPath=$(echo $f | sed -e 's/audio/final/' | sed -e 's/wav$/ark/')
			touch $outputPath
			fileName=$(echo $outputPath | cut -d "/" -f 6 | cut -d "." -f1)
			#echo $fileName
			audioFrames=$(python ./audioFrames.py $devAudioDir/$fileName.wav)
			#echo $audioFrames
			fileBaseName=$(echo $fileName | cut -d "_" -f2)
			#echo $fileBaseName
	 		videoFrames=$(find ./features/s$i/$fileBaseName/ -type f | wc -l | cut -d " " -f1)
			videoFrames=$(( $videoFrames*4 ))

			for feat in `ls -v ./features/s$i/$fileBaseName/*`;
			do
				cat $feat >> $outputPath
				cat $feat >> $outputPath
				cat $feat >> $outputPath
				cat $feat >> $outputPath
			done

			if [ $videoFrames -le $audioFrames ]
			then
				mv $outputPath $outputPath.temp
				addOn=$(( $audioFrames-$videoFrames ))
				for count in `seq 1 $addOn`;
				do
					echo "-1.07526939,1.33056536,0.23520028,7.29039088,-0.65575064,-3.73824602,4.34948465,0.04636360,-1.02028523,6.08075967,4.88683092,5.20192609,5.40194182,1.01913696,0.63609746,0.88357561,-1.18532006,-2.72838976,-2.27406292,2.48721767,1.16506734,-0.58038554,-0.97110891,-1.25225009,0.21546026,-1.73226597,-1.79507346,-0.71758321,0.71688353,-0.74939777,-0.25992405,-0.39686163,-0.42525826,-0.21534144,-0.35415515,-1.19992667,0.35281466,-0.39188971,-0.36769794,0.96715358,0.69761494,0.06574137,0.72561776,-0.01499276,0.47068934,1.00712963,-0.35086580,0.54018274,0.13499968,-0.39829489,-0.00325554,0.17271029,-0.63013400,0.92017746,0.08295302,0.79556779,0.02186913,-0.28973214,-0.40193193,0.16317657,0.36195938,0.25184432,0.43931196" >> $outputPath.temp 
				done
			else
				# need to match the frames of audio
				head -$audioFrames $outputPath > $outputPath.temp
				# add header and square brackets
				rm $outputPath
			fi

			if [ $i -le 9 ]
			then
				echo "s0$i"_"$fileBaseName"_0dB [ >> $outputPath
			else
				echo "s$i"_"$fileBaseName"_0dB [ >> $outputPath
			fi
			echo "$(cat $outputPath.temp) ]" >> $outputPath

			sed -i $outputPath -e "s/,/ /g"
			rm $outputPath.temp
		done
		echo "s$i video features for devel set is finalized"

		# finally start working on test set
		testAudioDir=./audio/test/isolated/0dB
		mkdir -p ./final/test/isolated/0dB
		rm ./final/test/isolated/0dB/s$i\_*
		for f in `find $testAudioDir/* -type f -name "s$i\_*"`
		do
			outputParent=$(echo $testAudioDir | sed -e 's/audio/final/')
			mkdir -p $outputParent
			outputPath=$(echo $f | sed -e 's/audio/final/' | sed -e 's/wav$/ark/')
			touch $outputPath
			fileName=$(echo $outputPath | cut -d "/" -f 6 | cut -d "." -f1)
			#echo $fileName
			audioFrames=$(python ./audioFrames.py $testAudioDir/$fileName.wav)
			#echo $audioFrames
			fileBaseName=$(echo $fileName | cut -d "_" -f2)
			#echo $fileBaseName
	 		videoFrames=$(find ./features/s$i/$fileBaseName/ -type f | wc -l | cut -d " " -f1)
			videoFrames=$(( $videoFrames*4 ))

			for feat in `ls -v ./features/s$i/$fileBaseName/*`;
			do
				cat $feat >> $outputPath
				cat $feat >> $outputPath
				cat $feat >> $outputPath
				cat $feat >> $outputPath
			done

			if [ $videoFrames -le $audioFrames ]
			then
				mv $outputPath $outputPath.temp
				addOn=$(( $audioFrames-$videoFrames ))
				for count in `seq 1 $addOn`;
				do
					echo "-1.07526939,1.33056536,0.23520028,7.29039088,-0.65575064,-3.73824602,4.34948465,0.04636360,-1.02028523,6.08075967,4.88683092,5.20192609,5.40194182,1.01913696,0.63609746,0.88357561,-1.18532006,-2.72838976,-2.27406292,2.48721767,1.16506734,-0.58038554,-0.97110891,-1.25225009,0.21546026,-1.73226597,-1.79507346,-0.71758321,0.71688353,-0.74939777,-0.25992405,-0.39686163,-0.42525826,-0.21534144,-0.35415515,-1.19992667,0.35281466,-0.39188971,-0.36769794,0.96715358,0.69761494,0.06574137,0.72561776,-0.01499276,0.47068934,1.00712963,-0.35086580,0.54018274,0.13499968,-0.39829489,-0.00325554,0.17271029,-0.63013400,0.92017746,0.08295302,0.79556779,0.02186913,-0.28973214,-0.40193193,0.16317657,0.36195938,0.25184432,0.43931196" >> $outputPath.temp 
				done
			else
				# need to match the frames of audio
				head -$audioFrames $outputPath > $outputPath.temp
				# add header and square brackets
				rm $outputPath
			fi

			if [ $i -le 9 ]
			then
				echo "s0$i"_"$fileBaseName"_0dB [ >> $outputPath
			else
				echo "s$i"_"$fileBaseName"_0dB [ >> $outputPath
			fi
			echo "$(cat $outputPath.temp) ]" >> $outputPath

			sed -i $outputPath -e "s/,/ /g"
			rm $outputPath.temp
		done
		echo "s$i video features for test set is finalized"
	fi
done

# in case s21 is generated by mistake
rm ./final/devel/isolated/0dB/s21*
rm ./final/test/isolated/0dB/s21*
