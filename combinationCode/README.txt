This folder contains myriad of variations of code for various strategies of combining patches.

Latest training scripts that were used in simulations are:
---------------------------------------------------------

CUR_genDoublets_norep.m:
For creation of doublets from the training set of images. Finds complementary patches, avoiding repetition of combinations. See inside for description. See which scripts it calls.

CUR_genTriplets_norep.m:
Analogous to CUR_genDoublets_norep.m script, but creates triplets from the training images using already existing doublets and another complementary third patch.


Latest testing scripts used in simulations are:
------------------------------------------------
CUR_runScaledDoublet_FaceBox.m:
Uses the doublets created on the training set, and evaluates them on the testing set of images, using face-box criterion.

CUR_runScaledDoublet_wedge30.m:
Uses the doublets created on the training set, and evaluates them on the testing set of images, using the 30 degree wedge criterion.

CUR_runScaledTriplet_wedge30.m:
Uses the triplets created on the training set, and evaluates them on the testing set of images, using the 30 degree wedge criterion.
