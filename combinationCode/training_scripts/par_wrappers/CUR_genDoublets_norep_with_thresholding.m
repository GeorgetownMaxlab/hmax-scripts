function CUR_genDoublets_norep_with_thresholding(nPatchesAnalyzed,nTPatches,nTPatchesPerLoop,nCPatches,condition,CPatchThreshold)

% This configuration of the script ignores the order of indices of the
% TPatch and CPatch when looking for doublets. So a doublet with TPatch and
% CPatch indices of (1,100) and (100,1) are not both recorded. 

% This script additionally uses a performance threshold for choosing the
% complementary patches, so that none of the patches below that threshold
% are considered for doublets.

%% GLOBAL STUFF
% clear; clc;
dbstop if error;
mainStartTime = tic;

if (nargin < 6)
    CPatcheThreshold = 15;
end
if (nargin < 5)
    condition = 'training4';
end

acrossCombination = 'acrossPatchTypes';
% CPatchThreshold = 15;
combination_type  = fullfile('find_CPatches_thresholding',['CPatchThreshold_' int2str(CPatchThreshold)]);

if (nargin < 1)
    nPatchesAnalyzed = 80000;
    nTPatches        = 500;
    nTPatchesPerLoop = 25;
    nCPatches        = 500;
end

runParameterComments = 'none';%input('Any comments about the run?\n'); %#ok<*NASGU>

if ispc
    home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3';
else
    home = '/home/levan/HMAX/annulusExptFixedContrast/simulation3';
end

loadLoc = fullfile(home,condition,'data',acrossCombination,'lfwSingle50000','fixedLocalization');
saveLoc = fullfile(home,condition,'data',acrossCombination,'lfwSingle50000','combinations',combination_type,'doublets',...
                   [int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches']...
                   );

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

if mod(nTPatches,nTPatchesPerLoop)~=0
    input = 'loopping messed up'; %#ok<*NASGU>
else
    nTPatchLoops = nTPatches/nTPatchesPerLoop;
end

% load the variables
% Note: variables get loaded for each loop. This slows it down, but
% otherwise I was getting an error.

% Define a threshold for CPatches
% Double check that nCPatches number of CPatches exist that pass that
% threshold
load(fullfile(loadLoc,'patchPerformanceInfo_Wedge_30.mat'));
cPatchesSurviving = idx_best_patches(sortSumStatsPatch >= CPatchThreshold);
assert(numel(cPatchesSurviving) >= nCPatches,['Only ' int2str(numel(cPatchesSurviving)) ' survive. You wanted ' int2str(nCPatches) ' .Lower the threshold or lower the nCPatches combined']);

%% Start parfor loop
display('starting parfor loop')

parfor iPatchLoop = 1:nTPatchLoops
%     display('Parfor is off!!!!');
%     iPatchLoop
    CUR_findScaledDoublets_Wedge30_par_with_thresholding(...
        nPatchesAnalyzed,...
        iPatchLoop,...
        nTPatchesPerLoop,...
        nCPatches,...
        saveLoc,...
        loadLoc,...
        cPatchesSurviving)
    
    display(['done with loop ' int2str(iPatchLoop)]);
end
key = [{'Top Patch'} {'Complementary Patch'} {'SF'} {'New Localization'}];
    
%% Concatenate the output
display('Concatenating output...')
concatinateOutput_comb(saveLoc,nTPatchesPerLoop,nTPatches,nCPatches)

%% Get rid of the repeated doublets

load(fullfile(saveLoc,'combMatrix.mat'));
indices = combMatrix(:,1:2);

for iRow = 1:size(indices,1)
   indices(iRow,:) = sort(indices(iRow,:),'ascend'); 
end

[~,ia,~] = unique(indices,'rows');
combMatrix = combMatrix(ia,:);
save(fullfile(saveLoc,'combMatrix.mat'),'combMatrix');

%% Save parameters and other variables.
display('Starting to save other variables');
pushValue = 0.001;
CUR_make_scaledDoublet_c2_imgHitsWedge30(loadLoc,saveLoc,nTPatches,nCPatches,pushValue)

runDateTime = datetime('now');
scriptName  = mfilename('fullpath');
save(fullfile(saveLoc,'runParameters.mat'),...
    'runDateTime',...
    'scriptName',...
    'runParameterComments',...
    'nPatchesAnalyzed',...
    'nTPatches',...
    'nTPatchesPerLoop',...
    'nCPatches',...
    'saveLoc',...
    'loadLoc',...
    'pushValue',...
    'CPatchThreshold'...
    );
mainEndTime = toc(mainStartTime);
end