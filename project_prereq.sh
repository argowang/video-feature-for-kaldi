#!/bin/bash

# Contain all the packages and environment configuration that you need to do before running the script
# If some wierd error occurs such as lib***/cuda_9.1/ not found, it probably occurs because the path variable is not set right
# If that kind of error occurs, go below and run all the commands that export path variables
# Recommendation: I highly recommend you run the scrip mannually line by line instead of running the script directly.

sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y install build-essential
sudo apt-get install build-essential cmake git pkg-config libjpeg8-dev libjasper-dev libpng12-dev libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev gfortran
sudo apt-get install libtiff5-dev 
sudo apt-get install libatlas-base-dev
sudo apt-get -y install flac libflac-dev; 
sudo apt-get -y install libatlas*; 
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo apt-get install python2.7-dev
sudo pip install numpy
sudo apt-get install python-numpy 
sudo apt-get -y install subversion; 
sudo apt-get -y install python-numpy swig; 
sudo apt-get -y install libgstreamer-plugins*; 
sudo apt-get -y install python-pip; sudo pip install --upgrade pip; sudo pip install ws4py; sudo pip install tornado==4; 
sudo apt-get -y install python-anyjson; 
sudo apt-get -y install libyaml-dev; sudo pip install pyyaml; 
sudo apt-get -y install libjansson-dev;
sudo apt-get -y install gnome-applets
sudo apt-get -y install sox
sudo apt-get install zip
sudo apt-get install git virtualenv python-dev ocl-icd-opencl-dev libopencv-dev python-opencv ffmpeg


# install opencv
cd ~; git clone https://github.com/Itseez/opencv.git; cd opencv; git checkout 3.0.0
cd ~
git clone https://github.com/Itseez/opencv_contrib.git
cd opencv_contrib
git checkout 3.0.0
cd ~/opencv; mkdir build; cd build; cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules -D BUILD_EXAMPLES=ON ..
make -j 8
sudo make install -j 8
sudo ldconfig

# install cuda
wget https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda_9.1.85_387.26_linux
sudo chmod 777 cuda_9.1.85_387.26_linux.run
sudo sh cuda_9.1.85_387.26_linux.run
echo 'PATH="$PATH:/usr/local/cuda-9.0/bin"' >> ~/.profile
echo 'LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-9.1/lib64"' >> ~/.profile

# install cudnn
# you have to download it yourself
tar -xvf cudnn-9.1-linux-x64-v7.solitairetheme8
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h 
sudo chmod a+r /usr/local/cuda/lib64/libcudnn*
export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH

sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libboost-all-dev libhdf5-serial-dev libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler
sudo apt-get install -y --no-install-recommends libboost-all-dev
sudo pip install scikit-image
sudo apt-get install python-matplotlib python-numpy python-pil python-scipy
sudo apt-get install build-essential cython
sudo apt-get install python-skimage
sudo pip install protobuf
sudo pip install sklearn


# install caffe
git clone https://github.com/BVLC/caffe
cd caffe

export LD_LIBRARY_PATH=/usr/local/cuda-9.1/lib64:$LD_LIBRARY_PATH
export PATH=/usr/local/cuda-9.1/bin:$PATH


'''
need to commend out two lines in Makefile.config.example as the comment mentioned for CUDA 9.1
Uncomment the cuDNN acceleration switch
uncomment the openCV option
make sure the PYTHON_INCLUDE line looks like this:
PYTHON_INCLUDE := /usr/include/python2.7 \
       /usr/local/lib/python2.7/dist-packages/numpy/core/include
Change the following two lines into these
INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial
LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib /usr/lib/x86_64-linux-gnu/hdf5/serial/
'''
cp Makefile.config.example Makefile.config
make all -j8
make test -j8
make runtest -j8
make pycaffe -j8
# change bashrc to make the path environment right
# sudo nano ~/.bashrc
# add following line
# export PYTHONPATH=~/caffe/python:$PYTHONPATH
# source ~/.bashrc

# for one time usage, do
export PYTHONPATH=~/caffe/python:$PYTHONPATH	

# install pretrained models of caffe
cd caffe; python scripts/download_model_binary.py models/bvlc_googlenet/; ./data/ilsvrc12/get_ilsvrc_aux.sh; cd ..;

# toolkit for face recognition
sudo pip install imutils
sudo apt-get install libgtk-3-dev
sudo pip install dlib
# install pretrained face recognition package
wget http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2
bzip2 -d shape_predictor_68_face_landmarks.dat.bz2



# Download my codes, you can escape that if you want to use the code I submitted. But make sure my code is in the home dir
git clone https://github.com/MrDoggie/video-feature-for-kaldi.git 
mv video-feature-for-kaldi/* .
rm -rf video-feature-for-kaldi/

# install kaldi. need to make the file by yourself
git clone https://github.com/kaldi-asr/kaldi.git kaldi-trunk --origin golden
sudo echo "deb http://dk.archive.ubuntu.com/ubuntu/ trusty main universe1
deb http://dk.archive.ubuntu.com/ubuntu/ trusty-updates main universe" >> /etc/apt/sources.list

chmod 777 data_processing.sh

for s in `find ./mychime2/* -type f -name "*sh"`;
do
	chmod 777 $s
done

for s in `find ./mychime2/* -type f -name "*pl"`;
do
	chmod 777 $s
done

for s in `find ./mychime2/* -type f -name "*py"`;
do
	chmod 777 $s
done
