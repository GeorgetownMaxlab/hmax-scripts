Localization code.

Scripts:
-----------

CUR_genLoc.m:
The main wrapper script for running localization code efficiently, using parallelization.

CUR_annulus_FaceBox_and_AngularDegree_Calculation:
The main localization code called by the CUR_genLoc.m script. It calls the patchDimensionsInPixelSpace.m script to check whether C2 overlaps with the face location in an image.

CUR_annulus_Wedge_Calculation.m:
See description inside the script.

CUR_imageDifficultyMap scripts: 
these 3 scripts take the output of the localization script and calculates summary statistics such as which patches were the best, which images were the hardest, etc.

patchPerformanceInfo_FaceBox.m and patchPerformanceInfo_Wedge.m:
These scripts get called by CUR_genLoc.m in the end, after the main localization pipeline is finished. They simply calculate the final scrore for the patches, using either face-box or the wedge criterion, and save them in a file called patchPerformanceInfo_FaceBox.mat (or _wedge.mat)