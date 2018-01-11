# Copyright: Junyi Wang

# This is a helper script that extracts the number of frames of an audio
# Take a wav file as input and output to terminal

import wave
import contextlib
import sys

# the frame_length is 25ms and the frame_shift is 10ms in Kaldi
FRAME_LENGTH = 25
FRAME_SHIFT = 10

fname = sys.argv[1]
with contextlib.closing(wave.open(fname, 'r')) as f:
	frames = f.getnframes()
	rate = f.getframerate()
	duration = frames/float(rate)
	# use this formula to calculate the number of frames of the audio
	# (1 + ((length - frame_length) / frame_shift));
	length=int(duration*1000)
	frames = (1+((length - FRAME_LENGTH) / FRAME_SHIFT))
	print frames
