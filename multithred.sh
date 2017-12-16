#!/bin/bash

for i in `seq $1 $1`; do name='s'$i; if [ $i -ne 21 ]; then dir=./frames/$name; outputdir=$(echo $dir | sed -e "s/frames/mouth/"); mkdir -p $outputdir; python mouthExtract.py -p ./shape_predictor_68_face_landmarks.dat -i $dir -o $outputdir; fi; echo "Finish extracting mouth for $name"; done
