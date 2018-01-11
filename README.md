Environment:
- Ubuntu 16.04
- Python: 2.7
- openCV: 3.0
- Cuda: 9.1

Packages:
Please refer to:
### project_prereq.sh
Contain all the packages and environment configurations that need to be set before runnning any script
I highly recommend you run the script mannually line by line to avoid any error
You must run the script in the right order to avoid dependency problem

Notice:
Although I've checked that dirs used in the script are relative paths, it is the safest to put everything on the home directory to avoid tiny chance of malbehavior.

# Data Processing
This part contains all files related with data processing procedure.

Executables:
## data_processing.sh
A end-to-end pipeline that process the raw videos and generate video features. The end file will be videoFeatures.tar.gz
Argument: N/A

### ./video/downloadVideo.sh
Automatically download the raw video and unzip them
Argument: N/A

### ./audio/downloadAudio.sh
Automatically download the raw audio and unzip them

### cleanVideo.py
Remove video that has no corresponding audio
Argument: N/A

### cutSilence.sh
Match onset and duration of video with audio
Argument: N/A

#### duration.py
Calculate the duration of the audio
Argument: a .wav file

#### audioFrames.py
Extract number of frames of an audio
Argument: a .wav file

### extractFrames.sh
Extract all frames from a video into jpg files
Argument: N/A

### mouthExtract.py
Use pretrained face detector to extract ROI
Argument:
- shape-predictor: a pretrained facial landmark predicator (will be downloaded by the ./dataProcessing.sh if not exist)
- image-Path: path to all images. Notice it is not the path of images, but the folder that contains all images
- outputPath: where the extracted mouths are going to 
Usage: python mouthExtract.py -p <shape-predictor> -i <imageDir> -o <outputDir>

### featureExtract.py
Use pretrained googLeNet to extract features
Argument: 
- text file containing directories to images
- text file where the features will be written to
Usage: python featureExtract.py -i <input file> -o <output file>

### pca.py
Conduct PCA on the features. Pick out 63 features and normalize them.
Argument:
- Input vec file: a file contains features of every video
- Output vec file: a file contains the after-processed features of every video

### writeFeatures.sh
Write each frame's feature to the corresponding file 
Argument:
- entire.vec: a file containing all after-pca features
- output.list: a file containing the output path corresponding to the entire.vec

### finalizeFeat.sh
Duplicate each feature by four times to match the frames of video and audio. Also take care of extra or missing frames.
Argument: N/A

-------------------------------------------------------

# AVSR Training
This part contains all files related with AVSR system training procedure.
All the contents in this part are in the myChime2 folder.
The codes in this part are mainly adopted from the Chime2 in the kaldi toolkit.
Minor changes are made in the run.sh file to append audio features and video features.

To run this part:
1. change the WAV_ROOT in the path.sh to the according folder that contains audio data. It needs to be absolute path
change the KALDI_ROOT to the according folder that contains kaldi toolkit. It needs to be absolute path 
NOTICE: DO NOT CHANGE VIDEO_ROOT
2. mkdir -p ./proc/video
copy the videoFeatures.tar.gz file generated from the data processing part or provided by Junyi to myChime2/proc/video
tar -xzf ./proc/video/videoFeatures.tar.gz -C ./proc/video
cp -R ./proc/video/finalbin/* ./proc/video/
rm -rf ./proc/video/finalbin
to extract the videoFeatures
3. go back and make sure everything in the folder is executable (should be set executable by project_prereq.sh)
4. go to run_all.sh to choose which version do you want to run
5. ./run_all.sh

Executables:

### run_all.sh
Higher function that select which features are used in run.sh

### run.sh
Modified version of myChime2 run.sh
Remove some process such as filterbank feature extraction
Add in feature append function

### path.sh
Set path environment

### cmd.sh
Set the configuartion

### local/*
Various scripts that conduct feature processing. Adopted from kaldi toolkit




