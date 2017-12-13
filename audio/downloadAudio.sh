#!/bin/bash

# check whether the audio is downloaded
if [ ! -d "train" ]
then
        # not downloaded yet, download it
        wget ftp://ftp.dcs.shef.ac.uk/share/spandh/chime_challenge/grid/train_isolated.tgz
        tar xvzf train_isolated.tgz
        rm train_isolated.tgz
        mv aasp-chime-grid/* .
        rmdir aasp-chime-grid
        echo "Train set has been downloaded"
else
        echo "Train set exists. Skip this step"
fi

if [ ! -d "devel" ]
then
        wget ftp://ftp.dcs.shef.ac.uk/share/spandh/chime_challenge/grid/devel_isolated.tgz
        tar xvzf devel_isolated.tgz
        rm devel_isolated.tgz
        mv aasp-chime-grid/* .
        rmdir aasp-chime-grid
        echo "Dev set has been downladed"
else
        echo "Dev set exists. Skip this step"
fi

if [ ! -d "test" ]
then
        wget ftp://ftp.dcs.shef.ac.uk/share/spandh/chime_challenge/grid/test_isolated.tgz
        tar xvzf test_isolated.tgz
        rm test_isolated.tgz
        mv aasp-chime-grid/* .
        rmdir aasp-chime-grid
        echo "Test set has been downloaded"
else
        echo "Test set exists. Skip this step"
fi