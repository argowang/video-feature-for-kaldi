#!/bin/bash

# Copyright: Junyi Wang

# This script does not need any argument. The output of the file is a zip file contain preprocessed data
# Although everything in the scripts are written using local address
# To make everything run correctly, the script and other scripts better be on the home directory 
# which means, when you do `pwd`, it should print out /Users/yourusername/

# check whether the video is downloaded
if [ ! -d "video" ]
then
        echo "There should be a video directory."
else
        # print the number of folder to check whether the download is complete
        number=$(ls -l ./video | grep -c ^d)
        # There should be 33 folders in total, if not, run to download
        if [ $number -le 32 ]
        then
                chmod 777 ./video/downloadVideo.sh
                # run the script to download video
                ./video/downloadVideo.sh
                mv s* video/
                echo "Finish downloading video"
        else
                echo "Video files exist already. Skip this step"
        fi
fi

# check whether audio is downloaded.
if [ ! -d "audio" ]
then
        echo "There should be a audio directory"
else
        number=$(ls -l ./audio | grep -c ^d)
        # there should be 3 folders in total
        if [ $number -ne 3 ]
        then
                chmod 777 ./audio/downloadAudio.sh
                ./audio/downloadAudio.sh
                mv test audio/
                mv devel audio/
                mv train audio/
                rm -r annotationFiles
                echo "Finish downloading audio"
        else
                echo "Audio files exist already. Skip this step"
        fi
fi

echo "Stage 0: Data downloading completes."

# Clean up the video file, so that only video files that have corresponding audio files are kept
python cleanVideo.py

echo "Stage 1: Video Cleaning completes."

# Notice that the chime2 audio set has a different length as the video set
# It is important to match the start and match the length

# Match start by using ffmpeg to detect the silence in the beginning and cut the 
# silence in the beginning of the video
# By trial and error the silencedetect filter works best when noise=-15:d=0.3

cutFileNum=$(find ./video/cut -type f | wc -l)
if [ $cutFileNum -ne 17670 ]
# the number dismatches, something is wrong
then
	echo "Begin matching videos and audios"
	chmod 777 cutSilence.sh
	./cutSilence.sh
else
	echo "Videos and audios are matched already. Skip this step"
fi

echo "Stage 2: Videos and Audios matching completes"

# Now we are going to extract frames from the video
mkdir -p ./frames
framesDirNum=$(find ./frames -type d | wc -l)
# we should have one folder for each video file (17670) plus 33 parent folders 17703
if [ $framesDirNum -ne 17704 ]
# the number dismatches, something is wrong
then
	echo "Begin extracting frames from the videos"
	chmod 777 extractFrames.sh
	./extractFrames.sh
else
	echo "Frames have been extracted from videos. Skip this step"
fi

echo "Stage 3: Frames extraction completes"

# Now we are going to extract mouth areas from the frames
# first download the pretrained face recognizer
if [ ! -f ./shape_predictor_68_face_landmarks.dat ]
then
	wget http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2
	bzip2 -d shape_predictor_68_face_landmarks.dat.bz2
	rm shape_predictor_68_face_landmarks.dat.bz2
	echo "Pretrained face recognizer downloaded complete"
else
	echo "Pretrained face recognizer exists. Start to extract mouth"
fi

mkdir -p ./mouth
# sometimes the terminal stucks with the find command, idk why. If it stucks here, just manlly type the find command in the terminal
# once get the result, rerun the script
mouthDirNum=$(find ./mouth -type d | wc -l)

# the number should be the same as the framesDirNum since we are simply extracting mouth from frames
if [ $mouthDirNum -ne 17704 ]
then
	for i in `seq 1 34`;
	do
		name='s'$i
		if [ $i -ne 21 ]
		then
		# for each speaker, go through each frame dir and extract the mouth part
			# run the python script to extract mouth area
			dir=./frames/$name
			outputdir=$(echo $dir | sed -e "s/frames/mouth/")
			mkdir -p $outputdir
			python mouthExtract.py -p ./shape_predictor_68_face_landmarks.dat -i $dir -o $outputdir 
		fi
		echo "Finish extracting mouth for $name"
	done
fi

# After generating the mouth pictures, we should notice that for s8. 57 video files are missing due to deteriorate videos.
# To make later data processing easier, we are going to generate place holder directories for these files.
# s8 should be 474 directly after the above script
s8size=$(ls ./mouth/s8 | wc -l)
if [ $s8size -ne 531 ]
then
	for d in ./frames/s8/*;
	do
		dirName=$(echo $d | cut -d "/" -f4);
		mkdir -p ./mouth/s8/$dirName;
	done
fi
echo "Stage 4: Mouth Extraction completes"

# Now begin the exciting feature extraction
# This will store the order of input
mkdir -p ./features
for i in `seq 1 34`;
do
	name='s'$i
	if [ $i -ne 21 ] && [ ! -f ./features/$name/$name.list ]
	then
		mkdir -p ./features/$name
		find `pwd`/mouth/$name -type f -exec echo {} \; | sort -V > ./features/$name/$name.list
		# run the script and output to $name.vec
		echo "Begin extracting features for $i."
		python featureExtract.py -i ./features/$name/$name.list -o ./features/$name/$name.vec
		echo "Finish extracting features for $i."
	fi
done

echo "Stage 5: Feature Extraction completes"

# now concatenate all lists together to do PCA
if [ ! -f ./features/entire.vec ] || [ ! -f ./features/entire.list ]
then
	touch ./features/entire.vec
	touch ./features/entire.list
fi

listNum=$(wc -l ./features/entire.list | cut -d " " -f1)
vecNum=$(wc -l ./features/entire.vec | cut -d " " -f1)

if [ $listNum -ne 831716 ] || [ $vecNum -ne 831716 ]
then
	rm ./features/entire.list
	rm ./features/entire.vec
	touch ./features/entire.vec
	touch ./features/entire.list
	for i in `seq 1 34`;
	do
		if [ $i -ne 21 ]
		then
			cat ./features/s$i/s$i.list >> ./features/entire.list
			cat ./features/s$i/s$i.vec >> ./features/entire.vec
		fi
	done
	# seperate each element using , make it easier to process later
	cp ./features/entire.vec ./features/entire.vec.copy
	sed -i ./features/entire.vec -e "s/ /, /g"
	echo "Finish concatenation."
fi

echo "Stage 6: Data Concatenation completes"

# conduct PCA on the data to downgrade the features size into 63
# Notice, it will take a long time
if [ ! -f ./features/pca_entire.vec ]
then
	echo "Begin feature selection"
	python ./pca.py ./features/entire.vec ./features/pca_entire.vec
fi
echo "Stage 7: Feature Selection Compeletes"

# put the corresponding feature vec into the correct folder
if [ ! -f ./features/output.list ]
then
	cp ./features/entire.list ./features/output.list
	sed -i ./features/output.list -e "s/mouth/features/"
	sed -i ./features/output.list -e "s/\.jpg//"
	echo "Output direction generation completes"
fi

featDirNum=$(find ./features/ -type d | wc -l)
# this number should be 17704, with 17704 being the same as the number of videos
# if not, do this again
if [ $featDirNum -ne 17704 ]
then
	echo "Start writing features to corresponding files"
	chmod 777 ./writeFeatures.sh
	./writeFeatures.sh ./features/output.list ./features/pca_entire.vec
	echo "Finish writing features to corresponding files"
fi

# again since s8 has broken videos, it is important to make a place holder for them and fill in
# null features for it
s8size=$(find ./features/s8 -type d | wc -l)
if [ $s8size -ne 532 ]
then
	for d in ./frames/s8/*;
	do
		dirName=$(echo $d | cut -d "/" -f4);
		mkdir -p ./features/s8/$dirName;
	done
fi

# This step will duplicate each frame for four times so the vidoe and the audio have the same number of frames
# Also take care of files that do not match duration, by padding feature of empty image
# the finalNum should equal to the number of video
finalNum=$(find ./final/* -type f | wc -l)
if [ $finalNum -ne 23520 ] && [ $finalNum -ne 17670 ]
then
	chmod 777 finalizeFeat.sh
	./finalizeFeat.sh 1 34
	echo "Finish generating ark file for each video"
fi

# last step, for devel and test set, duplicate the ark file. Since the video features are the same under different SNR
if [ ! -d ./final/devel/isolated/3dB ] || [ ! -d ./final/test/isolated/3dB ]
then
	cp -R ./final/devel/isolated/0dB ./final/devel/isolated/3dB
	cp -R ./final/test/isolated/0dB ./final/test/isolated/3dB
	# then, we need to modify the ark file, replace 0dB with 3dB
	for f in ./final/devel/isolated/3dB/*;
	do
		sed -i $f -e "s/0dB/3dB/"
	done

	for f in ./final/test/isolated/3dB/*;
	do
		sed -i $f -e "s/0dB/3dB/"
	done
fi

if [ ! -d ./final/devel/isolated/6dB ] || [ ! -d ./final/test/isolated/6dB ]
then
	cp -R ./final/devel/isolated/0dB ./final/devel/isolated/6dB
	cp -R ./final/test/isolated/0dB ./final/test/isolated/6dB
	# then, we need to modify the ark file, replace 0dB with 6dB
	for f in ./final/devel/isolated/6dB/*;
	do
		sed -i $f -e "s/0dB/6dB/"
	done

	for f in ./final/test/isolated/6dB/*;
	do
		sed -i $f -e "s/0dB/6dB/"
	done
fi

if [ ! -d ./final/devel/isolated/9dB ] || [ ! -d ./final/test/isolated/9dB ]
then
	cp -R ./final/devel/isolated/0dB ./final/devel/isolated/9dB
	cp -R ./final/test/isolated/0dB ./final/test/isolated/9dB
	# then, we need to modify the ark file, replace 0dB with 9dB
	for f in ./final/devel/isolated/9dB/*;
	do
		sed -i $f -e "s/0dB/9dB/"
	done

	for f in ./final/test/isolated/9dB/*;
	do
		sed -i $f -e "s/0dB/9dB/"
	done
fi

if [ ! -d ./final/devel/isolated/m3dB ] || [ ! -d ./final/test/isolated/m3dB ]
then
	cp -R ./final/devel/isolated/0dB ./final/devel/isolated/m3dB
	cp -R ./final/test/isolated/0dB ./final/test/isolated/m3dB
	# then, we need to modify the ark file, replace 0dB with m3dB
	for f in ./final/devel/isolated/m3dB/*;
	do
		sed -i $f -e "s/0dB/m3dB/"
	done

	for f in ./final/test/isolated/m3dB/*;
	do
		sed -i $f -e "s/0dB/m3dB/"
	done
fi

if [ ! -d ./final/devel/isolated/m6dB ] || [ ! -d ./final/test/isolated/m6dB ]
then
	cp -R ./final/devel/isolated/0dB ./final/devel/isolated/m6dB
	cp -R ./final/test/isolated/0dB ./final/test/isolated/m6dB
	# then, we need to modify the ark file, replace 0dB with m6dB
	for f in ./final/devel/isolated/m6dB/*;
	do
		sed -i $f -e "s/0dB/m6dB/"
	done

	for f in ./final/test/isolated/m6dB/*;
	do
		sed -i $f -e "s/0dB/m6dB/"
	done
fi
echo "Stage 8: All features are in right place and in right format"

finalBinNum=$(find ./finalbin/* -type f | wc -l)
if [ $finalBinNum -ne 23520 ]
then
	# last step, convert the feature file to kaldi binary format
	for f in `find ./final/* -type f`;
	do
		finalPath=$(echo $f | cut -d "/" -f 1-5 | sed -e "s/final/finalbin/")
		# echo $finalPath
		mkdir -p $finalPath
		finalFileName=$(echo $f | sed -e "s/final/finalbin/")
		echo $finalFileName
		# use kalditool to convert things into binary
		./kaldi-trunk/src/featbin/copy-feats ark,t:$f ark:$finalFileName
	done
	tar -zcvf videoFeatures.tar.gz ./finalbin/*
fi

echo "Final Stage Completes! Video Features are extracted successfully. It can be found at './videoFeatures.tar.gz'"
