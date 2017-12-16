#!/bin/bash

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

# Clean up the video file, so that the video file and the audio file met
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
mouthDirNum=$(find ./mouth -type d | wc -l)
# the number should be the same as the framesDirNum since we are simply extracting mouth from frames
if [ "$mouthDirNum" != "$frameDirNum" ]
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

# After generating the mouth pictures, we should notice that for s8. A lot of files are missing due to deteriorate videos.
# To make later data processing easier, we are going to generate place holder directories for these files.
for d in ./frames/s8/*;
do
	dirName=$(echo $d | cut -d "/" -f4);
	mkdir -p ./mouth/s8/$dirName;
done

echo "Stage 4: Mouth Extraction completes"


