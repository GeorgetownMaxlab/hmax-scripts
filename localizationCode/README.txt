Localization code.

Scripts:
-----------

patchPerformanceInfo_FaceBox.m and patchPerformanceInfo_Wedge.m:
These scripts get called by CUR_genLoc.m in the end, after the main localization pipeline is finished. They simply calculate the final scrore for the patches, using either face-box or the wedge criterion, and save them in a file called patchPerformanceInfo_FaceBox.mat (or _wedge.mat)