# Copyright: Junyi Wang

# similar to audioFrames.py
# This script calculate the duration of the audio instead
# Takes a wav file as input
import wave
import contextlib
import sys

fname = sys.argv[1]
with contextlib.closing(wave.open(fname, 'r')) as f:
	frames = f.getnframes()
	rate = f.getframerate()
	duration = frames/float(rate)
	print (duration)
