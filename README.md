# hmax-scripts

These scripts are adaptations of the HMAX to the analysis of the CRCNS project. 
The HMAX was used to detect faces in images that were seen by participants during behavioral and EEG experiments.

Only the scripts used with HMAX simulations. Actual output files are located elsewhere.

Folders contain scripts that were originally provided by Josh Rule to Levan Bokeria and Ben Trans. 

Notes:
- Many scripts start with "CUR_" appended to the name. This stands for "current", and was appended to scripts that were used at the time, to distinguish them from similarly named scripts that were out of date.

## Scripts:

CUR_metaRun_C2_loop.m:
A convenient wrapper script to run CUR_runAnnulusExpt2.m for different sized patches.


## Folders

annulusImageScripts/:  
Scripts used to manipulate images: annulize them, view contrast distribution, extract images from raw output files from CRCNS behavioral experiments, etc.

blurringAnnulusScripts/:  
The scripts in this folder perform blurring of the edges of the annulus that is superimposed on an image. 

classSpecificScripts/:   
contains old code. Not used anymore.  

clusteringScripts/:
Scripts used for clustering patches.  

combinationCode/:  
all the code used for creating various types of combinations of doublets and triplets of patches.  

coreCode/:  
main HMAX code doing all the S1, C1, S2, C2 calculations. Start with CUR_runAnnulusExpt2.m, which was a wrapper script to run various types of analysis.

crossValidationSplitting/:  
Used in simulation3 and 4. Not useful anymore. See inside.

debuggingScripts/:  
Debugging scripts used by Levan, safe to delete.

humanae_processing/:  
Set of scripts used to paste the Humanae images into backgrounds.

localizationScripts/:  
Set of scripts used to test whether the C2 of a patch came from the face in the image. See inside for descriptions.

maskingScripts/:  
Seems like set of core HMAX code with some masking variation, used in older simulaitons for data in /annulusExpt/ folder, so before the issue with face contrasts was discovered and we moved to /annulusExptFixedContrast/. Code is probably fine to delete.

patchPixelRecreation/:  
Set of scripts used to recreate the pixel location in the image that gave rize to particular C2 value.

scratchFunScripts/:  
Scripts for code development and testing. Safe to delete.

EEG_analysis_scripts:/  
Set of scripts used to analyze the images from the EEG experiment of CRCNS run by Florence Campana.

utils/:  
various helper scripts as well as old scripts used with quad-simulations when we used to split up the image into four quadrants and see if the patch hit the correct quadrant. 
