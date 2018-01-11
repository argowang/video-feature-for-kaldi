# Copyright: Junyi Wang
# This script uses a pretrained face detector to extract ROI
# Takes three arguments
# 1. shape-predictor: a pretrained facial landmark predicator
# 2. image-Path: path to all images. Notice it is not the path of images, but the folder that contains all images
# 3. outputPath: where the extracted mouths are going to

# import the necessary packages
from imutils import face_utils
import numpy as np
import argparse
import imutils
import dlib
import cv2
import os

TARGET_SIZE=256
# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-p", "--shape-predictor", required=True, help="path to pretrained facial landmark predicator")
ap.add_argument("-i", "--imagePath", required=True, help="path to input image")
ap.add_argument("-o", "--outputPath", required=True, help="output path")
args = vars(ap.parse_args())

# initialize dlib's face detector and then create the facial landmark predicotr
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor(args["shape_predictor"])
# predictor = dlib.shape_predictor("./shape_predictor_68_face_landmarks.dat")

for baseroot, basedirs, basefiles in os.walk(args["imagePath"]):
	for eachdir in basedirs:
		for root, dirs, files in os.walk(os.path.join(baseroot, eachdir)):
			for file in files:
				print "Processing: " + root+ "/" + file
				file = os.path.join(root, file)
				# load the input image, resize it, and convert it to grayscale
				image = cv2.imread(file)
				# first try out resizing to width of 360 pixels which is the default width
				image = imutils.resize(image, width=360)
				gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

				# detect faces in the grayscale image 
				rects = detector(gray,1)

				# the video should only contain one face, meaning the size of rects should be one
				# but there are conditions where the video is corrupted, therefore no face could be recognized
				try:
					rect = rects[0]
					shape = predictor(gray, rect)
					shape = face_utils.shape_to_np(shape)
					# in the end we only want a gray scale image, therefore overwrite the color image with gray one
					image = cv2.cvtColor(gray, cv2.COLOR_GRAY2BGR)
					# extract the ROI mouth area as a seperate image
					(x, y, w, h) = cv2.boundingRect(np.array([shape[48:68]]))
					# if (w>h):
					#roi = image[y:y+h, x:x+w]
					roi = image[y-w/2+h/2:y+h/2+w/2, x:x+w]
					roi = imutils.resize(roi, width=64, inter=cv2.INTER_CUBIC)
					border_top = (TARGET_SIZE-h)/2
					border_left = (TARGET_SIZE-w)/2

					# add border to the original picture so the resolution is not changed and we get the desired size
					roi=cv2.copyMakeBorder(roi, top=border_top, bottom=border_top, left=border_left, right=border_left, borderType=cv2.BORDER_CONSTANT)

					# show the mouth part
					# cv2.imshow("ROI", roi)
					# cv2.imshow("Image", clone)
					# cv2.waitKey(0)

				# if it is the case that no face could be recognized
				# we generate an empty picture with full black
				except:
					roi = np.zeros((TARGET_SIZE, TARGET_SIZE, 3), np.uint8)

				# Output
				path = args["outputPath"]
				outputFields = file.split("/")
				outputDir = os.path.join(path, outputFields[3])
				if not os.path.exists(outputDir):
					os.makedirs(outputDir)
				outputName = outputFields[4]
				imageName = os.path.join(outputDir, outputName)
				# print imageName
				cv2.imwrite(imageName, roi)


