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





