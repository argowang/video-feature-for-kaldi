#!/bin/bash

sudo apt-get -y install build-essential
git clone https://github.com/kaldi-asr/kaldi.git kaldi-trunk --origin golden
sudo echo "deb http://dk.archive.ubuntu.com/ubuntu/ trusty main universe1
deb http://dk.archive.ubuntu.com/ubuntu/ trusty-updates main universe" >> /etc/apt/sources.list
sudo apt-get -y update
sudo apt-get -y install g++-4.9
sudo rm /usr/bin/gcc
sudo ln -s /usr/bin/gcc-4.9 /usr/bin/gcc
sudo rm /usr/bin/g++
sudo ln -s /usr/bin/g++-4.9 /usr/bin/g++

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
                                                 