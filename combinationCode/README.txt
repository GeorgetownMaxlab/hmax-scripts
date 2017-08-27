CUR_combinePatchesAnnulus.m - combining patches (either doublets or triplets) through winner take all strategy. Does a MAX operation across all scale bands of all patches being combined. The script does not implement any relative scaling of responses from patches.

CUR_findScaledDoublets.m - old script for taking top N T-patches, finding a set of complementary C-patches for each T-patch, and then finding the optimal scaling factor for the doublet. This script used the wedge criterion.

CUR_findScaledDoublets_FaceBox.m - same as CUR_findScaledDoublets.m except uses the face box criterion.

CUR_genDoublets_norep.m - this is the best one to use, as of 2017-08-24. It uses the original combination strategy, of finding T-patches and C-patches, then scaling factors, and then removing from the data those doublets that have the same indices, such as doublet consisting of (100,1) t-patch and c-patch and (1,100) t-patch and c-patch.