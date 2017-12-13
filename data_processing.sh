#!/bin/bash

# check whether the video is downloaded
if [ ! -d "video" ]
then
        echo "There should be a video directory."
else
        # print the number of folder to check whether the download is complete
        number=$(ls -l ./video | grep -c ^d)
        # There should be 33 folders in total, if not, run to download
        if [ $number -ne 33 ]
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