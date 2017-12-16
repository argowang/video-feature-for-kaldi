#!/bin/bash

sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y install build-essential
sudo apt-get install build-essential cmake git pkg-config libjpeg8-dev libjasper-dev libpng12-dev libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev gfortran
sudo apt-get install libtiff5-dev 
sudo apt-get install libatlas-base-dev
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo apt-get install python2.7-dev
sudo pip install numpy
sudo apt-get install python-numpy 

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

# install caffe
git clone https://github.com/BVLC/caffe
cd caffe

export LD_LIBRARY_PATH=/usr/local/cuda-9.1/lib64:$LD_LIBRARY_PATH
export PATH=/usr/local/cuda-9.1/bin:$PATH

cp Makefile.config.example Makefile.config
make all -j8
make test -j8
make runtest -j8
make pycaffe -j8



git clone https://github.com/MrDoggie/video-feature-for-kaldi.git 
mv video-feature-for-kaldi/* .
rm -rf video-feature-for-kaldi/
git clone https://github.com/kaldi-asr/kaldi.git kaldi-trunk --origin golden
sudo echo "deb http://dk.archive.ubuntu.com/ubuntu/ trusty main universe1
deb http://dk.archive.ubuntu.com/ubuntu/ trusty-updates main universe" >> /etc/apt/sources.list
sudo apt-get -y update


sudo apt-get -y install linux-headers-$(uname -r);
sudo apt-get -y install flac libflac-dev; 
sudo apt-get -y install libatlas*; 
sudo apt-get -y install subversion; 
sudo apt-get -y install speex libspeex-dev; 
sudo apt-get -y install python-numpy swig; 
sudo apt-get -y install gstreamer-1.0 libgstreamer-1.0-dev; 
sudo apt-get -y install libgstreamer-plugins*; 
sudo apt-get -y install python-pip; sudo pip install --upgrade pip; sudo pip install ws4py; sudo pip install tornado==4; 
sudo apt-get -y install python-anyjson; 
sudo apt-get -y install libyaml-dev; sudo pip install pyyaml; 
sudo apt-get -y install libjansson-dev;
sudo apt-get -y install gnome-applets
sudo apt-get -y install sox

wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run
sudo chmod 777 cuda_9.0.176_384.81_linux-run
sudo sh cuda_9.0.176_384.81_linux-run
echo 'PATH="$PATH:/usr/local/cuda-9.0/bin"' >> ~/.profile
echo 'LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-9.0/lib64"' >> ~/.profile
source ~/.profile
sudo rm /usr/local/cuda/bin/gcc
sudo rm /usr/local/cuda/bin/g++
sudo ln -s /usr/bin/gcc-4.9 /usr/local/cuda/bin/gcc
sudo ln -s /usr/bin/g++-4.9 /usr/local/cuda/bin/g++

sudo apt-get install zip
sudo apt-get install git virtualenv python-dev ocl-icd-opencl-dev libopencv-dev python-opencv ffmpeg


# git clone https://github.com/dthpham/butterflow.git
# cd butterflow; sudo python setup.py install; cd ..
sudo pip install imutils
sudo apt-get install build-essential cmake
sudo apt-get install libgtk-3-dev
sudo apt-get install libboost-all-dev
sudo pip install scipy
sudo pip install scikit-image
sudo pip install dlib

sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev


git clone https://github.com/BVLC/caffe.git

# need to commend out two lines in Makefile.config.example as the comment mentioned
# Uncomment to use `pkg-config` to specify OpenCV library paths in Makefile.config.example
# also append /usr/include/hdf5/serial/ to the end of INCLUDE_DIRS in Makefile.config.example
# and rename hdf5_hl and hdf5 to hdf5_serial_hl and hdf5_serial in the Makefile
# need to use CPU only mode. otherwise wont work

cd caffe; cp Makefile.config.example Makefile.config;make all;make test;make runtest; make pycaffe; cd ..
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64/

# You need to set the PYTHONPATH before using caffe
# export CAFFE_ROOT=/home/<username>/caffe/
# export PYTHONPATH=/home/<username>/caffe/distribute/python:$PYTHONPATH
# export PYTHONPATH=/home/<username>/caffe/python:$PYTHONPATH

cd caffe; python scripts/download_model_binary.py models/bvlc_googlenet/; ./data/ilsvrc12/get_ilsvrc_aux.sh; cd ..;

chmod 777 data_processing.sh

[  FAILED  ] 2 tests, listed below:
[  FAILED  ] BatchReindexLayerTest/2.TestGradient, where TypeParam = caffe::GPUDevice<float>
[  FAILED  ] BatchReindexLayerTest/3.TestGradient, where TypeParam = caffe::GPUDevice<double>