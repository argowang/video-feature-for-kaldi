# Copyright: Junyi Wang
# This script uses pre-trained googLeNet to extract features
# Takes 2 arguements. The first is the input file. The input file should be a text file containing the directories to all images
# to be processed
# The second is the output file, where the script will write the features into
# usage: python featureExtract.py -i <input file> -o <output file>

import numpy as np
import os, sys, getopt

# Main path to the caffe installation
caffe_root = './caffe/'

# Model prototxt file
model_prototxt = caffe_root + 'models/bvlc_googlenet/deploy.prototxt'

# Model caffemodel file
model_trained = caffe_root + 'models/bvlc_googlenet/bvlc_googlenet.caffemodel'

# File containing the class labels
imagenet_labels = caffe_root + 'data/ilsvrc12/synset_words.txt'

# Path to the mean image (used for input processing)
mean_path = caffe_root + 'python/caffe/imagenet/ilsvrc_2012_mean.npy'

# Name of the layer we want to extract
layer_name = 'pool5/7x7_s1'

sys.path.insert(0, caffe_root + 'python')

# Set flag so only output warning
os.environ['GLOG_minloglevel'] = '2'
import caffe

def main(argv):
	inputfile=''
	outputfile=''

	try:
		opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
	except getopt.GetoptError:
		print 'caffe_feature_extractor.py -i <inputfile> -o <outputfile>'
		sys.exit(2)

	for opt, arg in opts:
			if opt == '-h':
				print 'caffe_feature_extractor.py -i <inputfile> -o <outputfile>'
				sys.exit()
			elif opt in ("-i"):
				inputfile = arg
			elif opt in ("-o"):
				outputfile = arg

	print 'Reading images from: ', inputfile
	print 'Writing vectors to: ', outputfile

	# setting cpu to extract feature
	caffe.set_mode_gpu()

	# Load in caffe model, set preprocessing parameters
	net = caffe.Classifier(model_prototxt, model_trained,
							mean=np.load(mean_path).mean(1).mean(1),
							channel_swap=(2,1,0),
							raw_scale=255,
							image_dims=(256,256))
	# Load class labels, we won't need it tho
	with open(imagenet_labels) as f:
		labels = f.readlines()

	counter = 0
	# Process one image at a time, print prediction and write feature vector to outputfile
	with open(inputfile, 'r') as reader:
		with open(outputfile, 'w') as writer:
			writer.truncate()
			for image_path in reader:
				image_path = image_path.strip()
				input_image=caffe.io.load_image(image_path)
				prediction = net.predict([input_image], oversample=False)
				# print os.path.basename(image_path), ' : ' , labels[prediction[0].argmax()].strip() , ' (', prediction[0][prediction[0].argmax()] , ')'
				np.savetxt(writer, net.blobs[layer_name].data[0].reshape(1,-1), fmt='%.8g')
				counter+=1
				if counter%1000 == 0:
					print "Finished extracting " + str(counter) + " features."

if __name__ == "__main__":
	main(sys.argv[1:])
