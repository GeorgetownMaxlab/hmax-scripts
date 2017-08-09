% run on testing set
clear; clc;
dbstop if error;

% if (nargin < 1)
    loadFolder = 'testingRuns/patchSetAdam/lfwSingle50000';
    saveFolder = 'testingRuns/patchSetAdam/lfwSingle50000/scaling/100TPatches1000CPatches/';
    combMatrixLocation = 'C:\Users\levan\HMAX\annulusExpt\trainingRuns\patchSetAdam\lfwSingle50000\scaling\100TPatches1000CPatches\';
% end


runParameterComments = 'none';%input('Any comments about the run?\n'); %#ok<*NASGU>

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

load([combMatrixLocation 'combMatrix']);
save([saveLoc 'combMatrix_Sourse'],'combMatrix');
load([loadLoc 'c2f']);
load([loadLoc 'imgHitsWedge']);
nImgs = size(c2f,2);
%%
nDoublets = size(combMatrix,1);
combMatrix_output = zeros(nDoublets,5);
for iDoublet = 1:nDoublets
    if mod(iDoublet,1000) == 0
        iDoublet
    end
    curDoubletInfo = combMatrix(iDoublet,:);
    newC2_Scaled = [c2f(curDoubletInfo(1),:);...
                    c2f(curDoubletInfo(2),:) .* curDoubletInfo(3)]; 
    newImgHitsWedge = [imgHitsWedge(curDoubletInfo(1),:); ...
                       imgHitsWedge(curDoubletInfo(2),:)];
    
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
    'loadLoc'...
    );

