function best_patches_across_patch_types_testingSet(conditionTraining,conditionBeingCombined)
% This script will 

% clear; clc; close all;

%% Predefine global stuff
display('Is condition defined correctly???')
if (nargin < 1)
    conditionTraining       = 'training4';
    conditionBeingCombined  = 'testing4';
end
splitID    = 'lfwSingle50000';
simulation = 'simulation3';
if ispc
    home = fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast',simulation);
else
    home = fullfile('/home/levan/HMAX/annulusExptFixedContrast',simulation);
end
saveLoc   = fullfile(home,conditionBeingCombined,'data','acrossPatchTypes','lfwSingle50000','fixedLocalization');
if ~exist(saveLoc)
    mkdir(saveLoc)
end

tasks = {'patchSet_2x3','patchSet_3x2','patchSet_1x3','patchSetAdam'};

nTopPatches = 20000;

% Predefine
for iTaskName = 1:numel(tasks)
    patchSizes{iTaskName} = repmat(tasks(iTaskName),nTopPatches,1);
end
patchSizes = patchSizes';
patchSizes = vertcat(patchSizes{:});


c2f_big            = [];
bestBands_big      = [];
bestLoc_big        = [];
imgHitsFaceBox_big = [];
imgHitsWedge_big.wedgeDegree_90 = [];
imgHitsWedge_big.wedgeDegree_45 = [];
imgHitsWedge_big.wedgeDegree_30 = [];
imgHitsWedge_big.wedgeDegree_20 = [];
imgHitsWedge_big.wedgeDegree_15 = [];
imgHitsWedge_big.wedgeDegree_10 = [];
sumStatsPatch_big     = [];
idx_best_patches_big  = [];

%% Start
for iTask = 1:numel(tasks)
    iTask
    loadLoc = fullfile(home,conditionBeingCombined,'data',tasks{iTask},splitID);
    
    display('starting to load C2 and loc files...')
    load(fullfile(loadLoc,'c2f.mat'));
    load(fullfile(loadLoc,'bestBandsC2f.mat'));
    load(fullfile(loadLoc,'bestLocC2f.mat'));
    load(fullfile(loadLoc,'fixedLocalization','imgHitsFaceBox.mat'));
    load(fullfile(loadLoc,'fixedLocalization','imgHitsWedge.mat'));
    load(fullfile(loadLoc,'fixedLocalization','patchPerformanceInfo_Wedge_30.mat'));
    display('done loading.')
    
    % Load the corresponding performance file on the training set. Then
    % take take the top N patches as based on those performances, so that
    % the patches are kept the same across training/testing combination.
    loadLocTraining      = fullfile(home,conditionTraining,'data',tasks{iTask},splitID);
    trainingPerformances = load(fullfile(loadLocTraining,'fixedLocalization','patchPerformanceInfo_Wedge_30.mat'));
    
    % Re-sort the sortSumStatsPatch of the testing set
    [~,idx_back_sort] = sort(idx_best_patches,'ascend');
    sumStatsPatch     = sortSumStatsPatch(idx_back_sort);
    
    
    % Take only the topN best patches
%     idx_best_patches  = idx_best_patches (1:nTopPatches);
    idx_best_patches_from_training  = trainingPerformances.idx_best_patches(1:nTopPatches);
    sumStatsPatch = sumStatsPatch(idx_best_patches_from_training);
%     figure
%     plot(sortSumStatsPatch)

    % sort the c2-related matrices by best patches.
    c2f            = c2f           (idx_best_patches_from_training,:);
    bestBands      = bestBands     (idx_best_patches_from_training,:);
    bestLoc        = bestLoc       (idx_best_patches_from_training,:,:);
    imgHitsFaceBox = imgHitsFaceBox(idx_best_patches_from_training,:);
    imgHitsWedge.wedgeDegree_90 = imgHitsWedge.wedgeDegree_90(idx_best_patches_from_training,:);
    imgHitsWedge.wedgeDegree_45 = imgHitsWedge.wedgeDegree_45(idx_best_patches_from_training,:);
    imgHitsWedge.wedgeDegree_30 = imgHitsWedge.wedgeDegree_30(idx_best_patches_from_training,:);
    imgHitsWedge.wedgeDegree_20 = imgHitsWedge.wedgeDegree_20(idx_best_patches_from_training,:);
    imgHitsWedge.wedgeDegree_15 = imgHitsWedge.wedgeDegree_15(idx_best_patches_from_training,:);    
    imgHitsWedge.wedgeDegree_10 = imgHitsWedge.wedgeDegree_10(idx_best_patches_from_training,:);    
    
    % Concatenate the matrices
    c2f_big               = [c2f_big;c2f];
    bestBands_big         = [bestBands_big;bestBands];
    bestLoc_big           = [bestLoc_big;bestLoc];
    sumStatsPatch_big     = [sumStatsPatch_big;sumStatsPatch];
    imgHitsFaceBox_big    = [imgHitsFaceBox_big;imgHitsFaceBox];
    
    imgHitsWedge_big.wedgeDegree_90 = [imgHitsWedge_big.wedgeDegree_90;imgHitsWedge.wedgeDegree_90];
    imgHitsWedge_big.wedgeDegree_45 = [imgHitsWedge_big.wedgeDegree_45;imgHitsWedge.wedgeDegree_45];
    imgHitsWedge_big.wedgeDegree_30 = [imgHitsWedge_big.wedgeDegree_30;imgHitsWedge.wedgeDegree_30];
    imgHitsWedge_big.wedgeDegree_20 = [imgHitsWedge_big.wedgeDegree_20;imgHitsWedge.wedgeDegree_20];
    imgHitsWedge_big.wedgeDegree_15 = [imgHitsWedge_big.wedgeDegree_15;imgHitsWedge.wedgeDegree_15];
    imgHitsWedge_big.wedgeDegree_10 = [imgHitsWedge_big.wedgeDegree_10;imgHitsWedge.wedgeDegree_10];
end

%% Take the new, combined matrix. Sort it by the combined sortSumStats OF THE TRAINING SET 
% load(fullfile(home,conditionTraining,'data','acrossPatchTypes','lfwSingle50000','fixedLocalization','meta_idx_best_patches_big.mat'));
% % [meta_sortSumStatsPatch_big,meta_idx_best_patches_big] = sort(sortSumStatsPatch_big,'descend');
% meta_sumStatsPatch_big = sumStatsPatch_big(meta_idx_best_patches_big);
% 
% % Reorganize everything
% c2f            = c2f_big           (meta_idx_best_patches_big,:);
% bestBands      = bestBands_big     (meta_idx_best_patches_big,:);
% bestLoc        = bestLoc_big       (meta_idx_best_patches_big,:,:);
% imgHitsFaceBox = imgHitsFaceBox_big(meta_idx_best_patches_big,:);
% clearvars c2f_big bestBands_big bestLoc_big imgHitsFaceBox_big
% imgHitsWedge.wedgeDegree_90 = imgHitsWedge_big.wedgeDegree_90(meta_idx_best_patches_big,:);
% imgHitsWedge.wedgeDegree_45 = imgHitsWedge_big.wedgeDegree_45(meta_idx_best_patches_big,:);
% imgHitsWedge.wedgeDegree_30 = imgHitsWedge_big.wedgeDegree_30(meta_idx_best_patches_big,:);
% imgHitsWedge.wedgeDegree_20 = imgHitsWedge_big.wedgeDegree_20(meta_idx_best_patches_big,:);
% imgHitsWedge.wedgeDegree_15 = imgHitsWedge_big.wedgeDegree_15(meta_idx_best_patches_big,:);    
% imgHitsWedge.wedgeDegree_10 = imgHitsWedge_big.wedgeDegree_10(meta_idx_best_patches_big,:);   
% clearvars imgHitsWedge_big
% [sortSumStatsPatch,idx_best_patches] = sort(meta_sumStatsPatch_big,'descend');
% % idx_best_patches_from_training  = 1:size(c2f,1); % since patches are sorted, the idx of best ones will simply be progression from first to last.
% patchSizes        = patchSizes(meta_idx_best_patches_big);

%% DO NOT SORT IT BY ANYTHING! SAVE THE RAW MATRIX, just also save the sortSumStatsPatch file with its idx_best_patches. 
[sortSumStatsPatch,idx_best_patches] = sort(sumStatsPatch_big,'descend');

% Rename everything
c2f            = c2f_big;            clearvars c2f_big
bestBands      = bestBands_big;      clearvars bestBands_big
bestLoc        = bestLoc_big;        clearvars bestLoc_big
imgHitsFaceBox = imgHitsFaceBox_big; clearvars imgHitsFaceBox_big

imgHitsWedge.wedgeDegree_90 = imgHitsWedge_big.wedgeDegree_90;
imgHitsWedge.wedgeDegree_45 = imgHitsWedge_big.wedgeDegree_45;
imgHitsWedge.wedgeDegree_30 = imgHitsWedge_big.wedgeDegree_30;
imgHitsWedge.wedgeDegree_20 = imgHitsWedge_big.wedgeDegree_20;
imgHitsWedge.wedgeDegree_15 = imgHitsWedge_big.wedgeDegree_15;    
imgHitsWedge.wedgeDegree_10 = imgHitsWedge_big.wedgeDegree_10;
clearvars imgHitsWedge_big

%% Save everything

save(fullfile(saveLoc,'imgHitsFaceBox.mat'),'imgHitsFaceBox');
save(fullfile(saveLoc,'imgHitsWedge.mat'),  'imgHitsWedge','-v7.3');

save(fullfile(saveLoc,'patchPerformanceInfo_Wedge_30.mat'),'sortSumStatsPatch','idx_best_patches');

save(fullfile(saveLoc,'c2f.mat'),'c2f');
save(fullfile(saveLoc,'bestBandsC2f.mat'),'bestBands');
save(fullfile(saveLoc,'bestLocC2f.mat'),'bestLoc');
save(fullfile(saveLoc,'imgHitsFaceBox.mat'),'imgHitsFaceBox');
save(fullfile(saveLoc,'patchSizeNames.mat'),'patchSizes');
end