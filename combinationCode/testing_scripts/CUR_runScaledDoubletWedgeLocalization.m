% run on testing set

clear; clc;
dbstop if error;

% if (nargin < 1)
    nTPatches = 1000;
    nCPatches = 1000;
    loadFolder_singles = 'simulation1/testing/data/patchSetAdam/lfwSingle50000';
    saveFolder = ['simulation1/testing/data/patchSetAdam/lfwSingle50000/scaling/doublets/' int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches'];
% end


runParameterComments = 'none';%input('Any comments about the run?\n'); %#ok<*NASGU>

if ispc == 1
    loadLoc_singles    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles '\'];
    saveLoc    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' saveFolder '\'];
    combMatrixLocation = ['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1/training/data\patchSetAdam\lfwSingle50000\scaling\doublets/' ...
                          int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches\'];
else    
    loadLoc_singles    = ['/home/levan/HMAX/annulusExptFixedContrast/' loadFolder_singles '/'];
    saveLoc    = ['/home/levan/HMAX/annulusExptFixedContrast/' saveFolder '/'];
    combMatrixLocation = ['/home/levan/levan/HMAX/annulusExptFixedContrast/simulation1/training/data/patchSetAdam/lfwSingle50000/scaling/doublets/'...
                          int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches/'];
end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

load([combMatrixLocation 'combMatrix']);
save([saveLoc 'combMatrix_Source'],'combMatrix');
c2f_testing_singles = load([loadLoc_singles 'c2f']);
c2f_testing_singles = c2f_testing_singles.c2f;
imgHitsWedge_testing_singles = load([loadLoc_singles 'imgHitsWedge']);
imgHitsWedge_testing_singles = imgHitsWedge_testing_singles.imgHitsWedge;
nImgs = size(c2f_testing_singles,2);
%%
nDoublets = size(combMatrix,1);
combMatrix_output = zeros(nDoublets,5);

% Reorganize combMatrix_source so that its ordered by the best patches.
[~,ind] = sort(combMatrix(:,4),'descend');
combMatrix = combMatrix(ind,:);


for iDoublet = 1:nDoublets
    if mod(iDoublet,1000) == 0
        iDoublet
    end
    curDoubletInfo = combMatrix(iDoublet,:);
    newC2_Scaled = [c2f_testing_singles(curDoubletInfo(1),:);...
                    c2f_testing_singles(curDoubletInfo(2),:) .* curDoubletInfo(3)]; 
    newImgHitsWedge = [imgHitsWedge_testing_singles(curDoubletInfo(1),:); ...
                       imgHitsWedge_testing_singles(curDoubletInfo(2),:)];
    
    [newC2_min_Scaled(1,:),chosenPatchIdx(1,:)] = min(newC2_Scaled,[],1);
    
    newImgHitsWedge_Scaled = zeros(1,nImgs); % preallocate
    for iImg = 1:nImgs
        newImgHitsWedge_Scaled(1,iImg) = newImgHitsWedge(chosenPatchIdx(1,iImg),iImg);
    end
    
%     newLoc(iDoublet) = nnz(newImgHitsWedge_Scaled);
    combMatrix_output(iDoublet,:) = [curDoubletInfo(1:4) nnz(newImgHitsWedge_Scaled)];
    
    
    % clear variables
    curDoubletInfo = [];
    newC2_Scaled = [];
    newImgHitsWedge = [];
    chosenPatchIdx = [];
end

maxNewLocalization = max(combMatrix_output(:,5))/nImgs*100

% save everything
save([saveLoc 'combMatrix_output'],'combMatrix_output');

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

