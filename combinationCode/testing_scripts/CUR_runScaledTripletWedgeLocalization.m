% run on testing set
clear; clc;
dbstop if error;

% if (nargin < 1)
    nTPatches_doublets_folder = 1000;
    nCPatches_doublets_folder = 1000;
    nTPatches = 100;
    nCPatches = 1000;
    loadFolder_singles = 'simulation1/testing/data/patchSetAdam/lfwSingle50000';
    saveFolder = ['simulation1/testing/data/patchSetAdam/lfwSingle50000/scaling/doublets/' ...
                   int2str(nTPatches_doublets_folder) 'TPatches' int2str(nCPatches_doublets_folder) 'CPatches/triplets/' ...
                   int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches'];
% end


runParameterComments = 'none';%input('Any comments about the run?\n'); %#ok<*NASGU>

if ispc == 1
    loadLoc    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles '\'];
    saveLoc    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' saveFolder '\'];
    combMatrixLocation = ['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1/training/data\patchSetAdam\lfwSingle50000\scaling/doublets/' ...
                   int2str(nTPatches_doublets_folder) 'TPatches' int2str(nCPatches_doublets_folder) 'CPatches/triplets/' ...
                   int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches/'];
else    
    loadLoc    = ['/home/levan/HMAX/annulusExptFixedContrast/' loadFolder_singles '/'];
    saveLoc    = ['/home/levan/HMAX/annulusExptFixedContrast/' saveFolder '/'];
    combMatrixLocation = ['/home/levan/levan/HMAX/annulusExptFixedContrast/simulation1/training/data/patchSetAdam/lfwSingle50000/scaling/doublets/' ...
                   int2str(nTPatches_doublets_folder) 'TPatches' int2str(nCPatches_doublets_folder) 'CPatches/triplets/' ...
                   int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches/'];
end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

load([combMatrixLocation 'combMatrix']);
save([saveLoc 'combMatrix_Source'],'combMatrix');
c2f_testing_singles = load([loadLoc 'c2f']);
c2f_testing_singles = c2f_testing_singles.c2f;
imgHitsWedge_testing_singles = load([loadLoc 'imgHitsWedge']);
imgHitsWedge_testing_singles = imgHitsWedge_testing_singles.imgHitsWedge;
nImgs = size(c2f_testing_singles,2);
%%
nTriplets = size(combMatrix,1);
combMatrix_output = zeros(nTriplets,8);

% Reorganize combMatrix_source so that its ordered by the best triplets.
[~,ind] = sort(combMatrix(:,7),'descend');
combMatrix = combMatrix(ind,:);

for iTriplet = 1:nTriplets
    if mod(iTriplet,1000) == 0
        iTriplet
    end
    curTripletInfo = combMatrix(iTriplet,:);
    
    newC2_Scaled = [c2f_testing_singles(curTripletInfo(1),:);...
                    c2f_testing_singles(curTripletInfo(2),:) .* curTripletInfo(4);...
                    c2f_testing_singles(curTripletInfo(3),:) .* curTripletInfo(5)...
                    ]; 

    newImgHitsWedge = [imgHitsWedge_testing_singles(curTripletInfo(1),:); ...
                       imgHitsWedge_testing_singles(curTripletInfo(2),:);...
                       imgHitsWedge_testing_singles(curTripletInfo(3),:)];
    
    [newC2_min_Scaled(1,:),chosenPatchIdx(1,:)] = min(newC2_Scaled,[],1);
    
    newImgHitsWedge_Scaled = zeros(1,nImgs); % preallocate
    for iImg = 1:nImgs
        newImgHitsWedge_Scaled(1,iImg) = newImgHitsWedge(chosenPatchIdx(1,iImg),iImg);
    end
    
%     newLoc(iDoublet) = nnz(newImgHitsWedge_Scaled);
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
    'loadLoc'...
    );

