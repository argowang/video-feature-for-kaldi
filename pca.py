# Copyright: Junyi Wang

# This script conducts PCA on the entire feature matrix, which is aroudn 800,000x1024 in size
# The PCA will decrease the number of feature to 63
# Then normalize it
# It will take a loooooong time
# Take two arguments: 1. input feature vec file, file containing all features
# 2. output file, where you want to write to

import numpy as np
from sklearn.decomposition import PCA
from sklearn import preprocessing
import sys

#firstHalf = sys.argv[1]
#secondHalf = sys.argv[2]
input = sys.argv[1]
outputFile = sys.argv[2]

X = np.loadtxt(input, delimiter=",")

#print "The first half input shape is: ", first.shape

#second = np.loadtxt(secondHalf, delimiter=",")

#print "The second half input shape is: ", second.shape

# concatenate

#X=np.concatenate((first,second), axis=0)

print "The total size is: ", X.shape

# we want to downscale to 63 features
nf = 63

pca=PCA(n_components=nf)

pca.fit(X)

print "Can do pca"

X_new = pca.transform(X)

print "The output shape is: ", X_new.shape

print "Conduct normalization"

X_normed = preprocessing.scale(X_new)

np.savetxt(outputFile, X_normed, fmt='%1.8f', delimiter=',')
print "The output is saved to: ", outputFile
