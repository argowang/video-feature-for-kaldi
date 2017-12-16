import wave
import contextlib
import sys

fname = sys.argv[1]
with contextlib.closing(wave.open(fname, 'r')) as f:
	frames = f.getnframes()
	rate = f.getframerate()
	duration = frames/float(rate)
	print (duration)
