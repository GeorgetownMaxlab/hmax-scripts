function CUR_runScaledDoublet_wedge30(nTPatches,nCPatches,combination_type,CPatchThreshold)
% run on the other set. 
% NOTE: this script will works with the new combined data across
% patch-types, and uses the 30-degree wedge data.

% clear; clc;
dbstop if error;

if (nargin < 4)
    CPatchThreshold = 20;
end
if (nargin < 3)
%     combination_type = 'find_CPatches';
    combination_type = fullfile('find_CPatches_thresholding',['CPatchThreshold_' int2str(CPatchThreshold)]);
end
if (nargin < 1)  
    nTPatches = 1000;
    nCPatches = 948;
end

if ispc
    home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3';
else
    home = '/home/levan/HMAX/annulusExptFixedContrast/simulation3';
end
conditionLoad_testing = 'testing';
conditionLoad_training = 'training';
conditionSplit = 'acrossPatchTypes';

loadLoc_singles        = fullfile(home,conditionLoad_testing,'data',conditionSplit,'lfwSingle50000','fixedLocalization');
saveLoc                = fullfile(home,conditionLoad_testing,'data',conditionSplit,'lfwSingle50000','combinations',...
                                  combination_type,'doublets',...
                                 [int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches']);
combMatrixLoc_doublets = fullfile(home,conditionLoad_training,'data',conditionSplit,'lfwSingle50000','combinations',...
                                  combination_type,'doublets',...
                                  [int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches']...
                                  );

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end


runParameterComments = 'none';%input('Any comments about the run?\n'); %#ok<*NASGU>

load(fullfile(combMatrixLoc_doublets,'combMatrix'));
save(fullfile(saveLoc,'combMatrix_Source'),'combMatrix');
c2f_testing_singles = load(fullfile(loadLoc_singles,'c2f')); % the variable name says "testing" but its actually c2 file for training set. See above description.
c2f_testing_singles = c2f_testing_singles.c2f;
imgHitsWedge_testing_singles = load(fullfile(loadLoc_singles,'imgHitsWedge'));
imgHitsWedge_testing_singles = imgHitsWedge_testing_singles.imgHitsWedge;
imgHitsWedge_testing_singles = imgHitsWedge_testing_singles.wedgeDegree_30;
nImgs = size(c2f_testing_singles,2);
%% Start main script
nDoublets         = size(combMatrix,1);
combMatrix_output = zeros(nDoublets,5);

% Reorganize combMatrix_source so that its ordered by the best patches.
[~,ind] = sort(combMatrix(:,4),'descend');
combMatrix = combMatrix(ind,:);

for iDoublet = 1:nDoublets
    pushValue = 0.001;

    if mod(iDoublet,1000) == 0
        iDoublet
    end
    curDoubletInfo = combMatrix(iDoublet,:);
    
    % Use the pushValue to make sure two C2 outputs aren't exactly the same
    if curDoubletInfo(3) < 1
        pushValue = -pushValue;
    end
    
    newC2_Scaled    = [c2f_testing_singles(curDoubletInfo(1),:);...
                       c2f_testing_singles(curDoubletInfo(2),:) .* curDoubletInfo(3) + pushValue]; 
           
    newImgHitsWedge = [imgHitsWedge_testing_singles(curDoubletInfo(1),:); ...
                       imgHitsWedge_testing_singles(curDoubletInfo(2),:)];
    
    [newC2_min_Scaled(1,:),chosenPatchIdx(1,:)] = min(newC2_Scaled,[],1);
    
    newImgHitsWedge_Scaled = zeros(1,nImgs); % preallocate
    for iImg = 1:nImgs
        newImgHitsWedge_Scaled(1,iImg) = newImgHitsWedge(chosenPatchIdx(1,iImg),iImg);
    end
    
    combMatrix_output(iDoublet,:) = [curDoubletInfo(1:4) nnz(newImgHitsWedge_Scaled)];
    
    
    % clear variables
    curDoubletInfo = [];
    newC2_Scaled = [];
    newImgHitsWedge = [];
    chosenPatchIdx = [];
end

maxNewLocalization = max(combMatrix_output(:,5))/nImgs*100

% save everything
save(fullfile(saveLoc,'combMatrix_output'),'combMatrix_output');

runDateTime = datetime('now');
scriptName  = mfilename('fullpath');
save(fullfile(saveLoc,'runParameters.mat'),...
    'runDateTime',...
    'scriptName',...
    'runParameterComments',...
    'saveLoc',...
    'loadLoc_singles'...
    );

end