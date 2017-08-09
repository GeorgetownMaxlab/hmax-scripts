% run on the other set. 
% The script is currently adjusted to run the combined doublets on the
% training set of images.

clear; clc;
dbstop if error;

% type_localization will determine whether the script will use the best
% patches of the training set as based on their wedge-localization values
% or face-box localization values.

% type_localization = input('Either ''scaling_FaceBox'' or ''scaling_wedge''\n'); % this is also appended to save dir.
type_localization = 'scaling_FaceBox_switchSets';

% if (nargin < 1)
    nTPatches_doublets_folder = 1000;
    nCPatches_doublets_folder = 1000;
    nTPatches_triplets = 1000;
    nCPatches_triplets = 1000;
    loadFolder_singles = 'simulation1/training/data/patchSetAdam/lfwSingle50000';
    saveFolder = ['simulation1/training/data/patchSetAdam/lfwSingle50000/'...
                   type_localization '/doublets/'...
                   int2str(nTPatches_doublets_folder) 'TPatches' int2str(nCPatches_doublets_folder) 'CPatches/triplets/' ...
                   int2str(nTPatches_triplets) 'TPatches' int2str(nCPatches_triplets) 'CPatches'];
% end


% runParameterComments = input('Any comments about the run?\n'); %#ok<*NASGU>
runParameterComments = '';

if ispc == 1
    loadLoc_singles    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles '\'];
    saveLoc            = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' saveFolder '\'];
    combMatrixLocation_triplets = ['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1/testing/data\patchSetAdam\lfwSingle50000\'...
                          type_localization '/doublets/' ...
                          int2str(nTPatches_doublets_folder) 'TPatches' int2str(nCPatches_doublets_folder) 'CPatches/triplets/' ...
                          int2str(nTPatches_triplets)        'TPatches' int2str(nCPatches_triplets)        'CPatches/'];
else    
    loadLoc_singles    = ['/home/levan/HMAX/annulusExptFixedContrast/' loadFolder_singles '/'];
    saveLoc            = ['/home/levan/HMAX/annulusExptFixedContrast/' saveFolder '/'];
    combMatrixLocation_triplets = ['/home/levan/HMAX/annulusExptFixedContrast/simulation1/testing/data/patchSetAdam/lfwSingle50000/'...
                          type_localization '/doublets/' ...
                          int2str(nTPatches_doublets_folder) 'TPatches' int2str(nCPatches_doublets_folder) 'CPatches/triplets/' ...
                          int2str(nTPatches_triplets)        'TPatches' int2str(nCPatches_triplets)        'CPatches/'];
end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

load([combMatrixLocation_triplets 'combMatrix']);
save([saveLoc 'combMatrix_Source'],'combMatrix');
c2f_testing_singles = load([loadLoc_singles 'c2f']); % the variable name says "testing" but its actually c2 file for training set. See above description.
c2f_testing_singles = c2f_testing_singles.c2f;
imgHitsWedge_testing_singles = load([loadLoc_singles 'imgHitsWedge']);
imgHitsWedge_testing_singles = imgHitsWedge_testing_singles.imgHitsWedge;
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
           {'Testing Set Doublet Localization'} ...
           {'Testing Set Triplet Localization'}...
           {'Training Set Triplet Localization'} ...
           ];
% save everything

save([saveLoc 'combMatrix_output'],'combMatrix_output');
save([saveLoc 'dataKey'],'dataKey');

runDateTime = datetime('now');
outputOfPWD = pwd;
scriptName  = mfilename('fullpath');
save([saveLoc 'runParameters.mat'],...
    'runDateTime',...
    'scriptName',...
    'outputOfPWD',...
    'runParameterComments',...
    'saveLoc',...
    'loadLoc_singles'...
    );

