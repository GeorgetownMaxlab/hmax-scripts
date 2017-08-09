% run on the other set. 
% NOTE: this script will works with the new combined data across
% patch-types, and uses the 30-degree wedge data.

clear; clc;
dbstop if error;

if ispc
    home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3';
else
    home = '/home/levan/HMAX/annulusExptFixedContrast/simulation3';
end
conditionLoad_testing  = 'testing';
conditionLoad_training = 'training';
% combination_type       = 'find_CPatches';
CPatchThreshold = 20;
combination_type = fullfile('find_CPatches_thresholding',['CPatchThreshold_' int2str(CPatchThreshold)]);


nTPatches_doublets_folder = 1000;
nCPatches_doublets_folder = 948;
nTPatches_triplets = 500;
nCPatches_triplets = 948;
    
    
    loadLoc_singles = (fullfile(home,conditionLoad_testing,'data','acrossPatchTypes','lfwSingle50000','fixedLocalization'));
    saveLoc         = (fullfile(home,conditionLoad_testing,'data','acrossPatchTypes','lfwSingle50000','combinations',...
                       combination_type,'doublets',...
                       [int2str(nTPatches_doublets_folder) 'TPatches' int2str(nCPatches_doublets_folder) 'CPatches'],...
                       'triplets',...
                       [int2str(nTPatches_triplets)        'TPatches' int2str(nCPatches_triplets)        'CPatches']));              
     
    combMatrixLocation_triplets = (fullfile(home,conditionLoad_training,'data','acrossPatchTypes','lfwSingle50000','combinations',...
                       combination_type,'doublets',...
                       [int2str(nTPatches_doublets_folder) 'TPatches' int2str(nCPatches_doublets_folder) 'CPatches'],...
                       'triplets',...
                       [int2str(nTPatches_triplets)        'TPatches' int2str(nCPatches_triplets)        'CPatches']))   
    
runParameterComments = '';

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

load(fullfile(combMatrixLocation_triplets,'combMatrix'));
save(fullfile(saveLoc,'combMatrix_Source'),'combMatrix');
c2f_testing_singles = load(fullfile(loadLoc_singles,'c2f'));
c2f_testing_singles = c2f_testing_singles.c2f;
imgHitsWedge_testing_singles = load(fullfile(loadLoc_singles,'imgHitsWedge'));
imgHitsWedge_testing_singles = imgHitsWedge_testing_singles.imgHitsWedge;
imgHitsWedge_testing_singles = imgHitsWedge_testing_singles.wedgeDegree_30;
nImgs = size(c2f_testing_singles,2);
%%
nTriplets         = size(combMatrix,1);
combMatrix_output = zeros(nTriplets,8);

% Reorganize combMatrix_source so that its ordered by the best triplets.
[~,ind] = sort(combMatrix(:,7),'descend');
combMatrix = combMatrix(ind,:);


for iTriplet = 1:nTriplets
    pushValue_patch2 = 0.001; %for patch #2
    pushValue_patch3 = 0.001; %for patch #3

    if mod(iTriplet,1000) == 0
        iTriplet
    end
    curTripletInfo = combMatrix(iTriplet,:);
    
    % Use the pushValue to make sure two C2 outputs aren't exactly the same
    if curTripletInfo(4) < 1
        pushValue_patch2 = -pushValue_patch2;
    end
    if curTripletInfo(5) < 1
        pushValue_patch3 = -pushValue_patch3;
    end
    
    newC2_Scaled = [c2f_testing_singles(curTripletInfo(1),:);...
                    c2f_testing_singles(curTripletInfo(2),:) .* curTripletInfo(4) + pushValue_patch2;...
                    c2f_testing_singles(curTripletInfo(3),:) .* curTripletInfo(5) + pushValue_patch3...
                    ]; 

    newImgHitsWedge = [imgHitsWedge_testing_singles(curTripletInfo(1),:); ...
                       imgHitsWedge_testing_singles(curTripletInfo(2),:);...
                       imgHitsWedge_testing_singles(curTripletInfo(3),:)];
    
    [newC2_min_Scaled(1,:),chosenPatchIdx(1,:)] = min(newC2_Scaled,[],1);
    
    newImgHitsWedge_Scaled = zeros(1,nImgs); % preallocate
    for iImg = 1:nImgs
        newImgHitsWedge_Scaled(1,iImg) = newImgHitsWedge(chosenPatchIdx(1,iImg),iImg);
    end
    
    combMatrix_output(iTriplet,:) = [curTripletInfo(1:7) nnz(newImgHitsWedge_Scaled)];
    
    
    % clear variables
    curTripletInfo = [];
    newC2_Scaled = [];
    newImgHitsWedge = [];
    chosenPatchIdx = [];
end

maxNewLocalization = max(combMatrix_output(:,8))/nImgs*100
dataKey = [{'Patch1 Index'} {'Patch2 Index'} {'Patch3 Index'} ...
           {'Patch2 SF'}    {'Patch3 SF'}    ...
           {'Training Set Doublet Localization'} ...
           {'Training Set Triplet Localization'}...
           {'Testing Set Triplet Localization'} ...
           ];
% save everything

save(fullfile(saveLoc,'combMatrix_output'),'combMatrix_output');
save(fullfile(saveLoc,'dataKey'),'dataKey');

runDateTime = datetime('now');
outputOfPWD = pwd;
scriptName  = mfilename('fullpath');
save(fullfile(saveLoc,'runParameters.mat'),...
    'runDateTime',...
    'scriptName',...
    'outputOfPWD',...
    'runParameterComments',...
    'saveLoc',...
    'loadLoc_singles'...
    );

