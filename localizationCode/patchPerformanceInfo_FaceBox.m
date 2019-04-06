function patchPerformanceInfo_FaceBox(...
    loadLoc,...
    saveLoc)

% This function will use the imgHitsFaceBox, which is an nPatch X nImages
% file containins 1 or 0 indicating whether that patch hit the face in that
% image. This script will then simply calculate summary performance
% statistics for each patch.

if (nargin < 1)
    loadLoc = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation2\set2\data\patchSet_3x1\lfwSingle50000\newCode_saveAngles3';
    saveLoc = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation2\set2\data\patchSet_3x1\lfwSingle50000\newCode_saveAngles3\sandbox';
end

if ~exist(saveLoc)
    mkdir(saveLoc)
end

load(fullfile(loadLoc,'imgHitsFaceBox.mat'));

[nPatches,nImgs] = size(imgHitsFaceBox);

sumStatsPatch = (sum(imgHitsFaceBox,2)/nImgs)*100;
sumStatsImg   = (sum(imgHitsFaceBox,1)/nPatches)*100;

[sortSumStatsPatch, idx_best_patches] = sort(sumStatsPatch,'descend'); %#ok<*ASGLU>
[sortSumStatsImg,   idx_best_imgs]    = sort(sumStatsImg  ,'descend');

%% Save
save(fullfile(saveLoc,'patchPerformanceInfo_FaceBox.mat'),'sortSumStatsPatch','idx_best_patches','sortSumStatsImg','idx_best_imgs');
end