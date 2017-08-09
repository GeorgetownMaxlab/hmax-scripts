%% Custom combination clutter code
clear; clc;

loadFolder = 'patchSet4\lfwDouble100'
saveFolder = 'patchSet4\lfwCustomTriple100'
nHardImgs = 167

% Load indices of hard images (hard for the doublets).
load(['C:\Users\Levan\HMAX\annulusExpt\testingSetRuns\'...
    loadFolder '\complementaryPatches\' num2str(nHardImgs) '_hardImagesLocalizationData.mat'],...
    'IndHardImgPatches')

% Load the combination matrix of doublets, as well as indices of the best
% doublets.
load(['C:\Users\Levan\HMAX\annulusExpt\testingSetRuns\'...
    loadFolder '\combinationParameterSpace.mat'],...
    'combinationMatrix')
load(['C:\Users\Levan\HMAX\annulusExpt\testingSetRuns\'...
    loadFolder '\imageDifficultyData_4950_Patches.mat'],...
    'IndPatch')
bestDoubletIdx = IndPatch;
clearvars IndPatch;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nTopDoublets = 50;
nHardPatches = 50;
IndHardImgPatches = IndHardImgPatches(1:nHardPatches);
IndHardImgPatches = IndHardImgPatches';
HARD = repmat(IndHardImgPatches,nTopDoublets,1);

bestDoubletIdx = bestDoubletIdx(1:nTopDoublets);
MAT = combinationMatrix(bestDoubletIdx,:);
% MAT = MAT(1:nTopPatches,:);
MAT = kron(MAT,ones(nHardPatches,1));

customCombMatrix = [MAT HARD];

save(['C:\Users\Levan\HMAX\annulusExpt\testingSetRuns\' saveFolder ...
    '\' num2str(nHardImgs) '_Hard_Images_customCombMatrix.mat'],'customCombMatrix');