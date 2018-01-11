# Copyright: Junyi Wang

# This script is used to remove video that has no corresponding audio file and
# cutting video to the same length as the audio
# The chime2 dataset is a subset of GRID dataset. Therefore only some audio file is used
import subprocess
import os

# declare a list containing 34 lists. s_list[0] is not used to avoid confusion
s_list = [[] for x in range(35)]

for i in range(1,35):
	# add in audio train dataset
	for root, dirs, files in os.walk("./audio/train/isolated/id"+str(i)):
		for file in files:
			# we do not want the extension
			basename = file.split(".")[0]
			s_list[i].append(basename)
	#print len(s_list[i])

path = ["0dB", "3dB", "6dB", "9dB", "m3dB", "m6dB"]

for each in path:
	# add in audio dev dataset
	for root, dirs, files in os.walk("./audio/devel/isolated/"+each):
		for file in files:
			# the file in dev has the format s1_lbwb9n.wav
			fields = file.split("_")
			# index specify which list it goes to
			index = int(fields[0][1:])
			# fields[1] specify the name of the file
			# but we only want the basename without extension
			basename = fields[1].split(".")[0]
			s_list[index].append(basename)

	# add in audio test dataset
	for root, dirs, files in os.walk("./audio/test/isolated/"+each):
		for file in files:
			fields = file.split("_")
			index = int(fields[0][1:])
			basename = fields[1].split(".")[0]
			s_list[index].append(basename)

sum = 0
for i in range(1,35):
#	print len(s_list[i])
	# remove duplicated name
	s_list[i] = set(s_list[i])
#	print "s" + str(i) + ": " + str(len(s_list[i]))
	sum += len(s_list[i])
print "There are " + str(sum) + " data in total"

# now remove video that does not have corresponding audio
for i in range(1,35):
	for root, dirs, files in os.walk("./video/s"+str(i)):
		for file in files:
			basename = file.split(".")[0]
			if basename not in s_list[i]:
				os.remove(os.path.join(root, file))

