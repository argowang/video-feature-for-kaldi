#!/bin/bash

for i in `seq 1 34`;
do      
        name='s'$i
        # The grid corpus do not have video for speaker 21, we will escape that one
        if [ $i -ne 21 ] && [ ! -d "$name" ]
        then
                # download video from the website
                wget http://spandh.dcs.shef.ac.uk/gridcorpus/$name/video/$name.mpg_vcd.zip; unzip $name.mpg_vcd.zip; rm $name.mpg_vcd.zip
        fi
done