% sort C2, bestBands, and bestLoc by patch performance.
clear; clc;

loadFolder = 'trainingRuns/patchSetAdam/lfwSingle50000';
saveFolder = 'trainingRuns/patchSetAdam/lfwSingle50000';
nPatchesAnalyzed = 50000;
quadType = 'f';

if ispc == 1
    loadLoc    = ['C:\Users\Levan\HMAX\annulusExpt\' loadFolder '\']
    saveLoc    = ['C:\Users\Levan\HMAX\annulusExpt\' saveFolder '\']
else    
    loadLoc    = ['/home/levan/HMAX/annulusExpt/' loadFolder '/']
    saveLoc    = ['/home/levan/HMAX/annulusExpt/' saveFolder '/']
end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

%% Load the files.
load([loadLoc 'c2'          quadType '.mat'])
load([loadLoc 'bestBandsC2' quadType '.mat'])
load([loadLoc 'bestLocC2'   quadType '.mat'])
load([loadLoc 'imageDifficultyData_Wedge_' int2str(nPatchesAnalyzed) '_Patches.mat'],'IndPatch')


%% Sort everything.

c2f       = c2f      (IndPatch,:);
bestBands = bestBands(IndPatch,:);
bestLoc   = bestLoc  (IndPatch,:,:);

%% save new variables.

save([saveLoc 'c2'          quadType 'Sorted.mat'],'c2f');
save([saveLoc 'bestBandsC2' quadType 'Sorted.mat'],'bestBands');
save([saveLoc 'bestLocC2'   quadType 'Sorted.mat'],'bestLoc');






