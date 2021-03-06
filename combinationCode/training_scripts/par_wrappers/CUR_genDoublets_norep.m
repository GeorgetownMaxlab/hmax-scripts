function CUR_genDoublets_norep(nPatchesAnalyzed,nTPatches,nTPatchesPerLoop,nCPatches,simulation,condition)

% the prefix "gen" usually means that the function will parallelize
% calculations. 

% This is a general wrapper script for efficiently creating doublet
% combinations of patches.

% This configuration of the script ignores the order of indices of the
% TPatch and CPatch when looking for doublets. So a doublet with TPatch and
% CPatch indices of (1,100) and (100,1) are cosidered as same and one is skipped. 

% Script calls CUR_findScaledDoublets_FaceBox_par.m and CUR_make_scaledDoublet_c2_imgHitsFaceBox

%% GLOBAL STUFF
% clear; clc;
dbstop if error;
mainStartTime = tic;

if (nargin < 6)
    condition = 'training';
end

% Variable specifying the name of the subfolder for saving the data in.
% Specifies which patch-types were combined. For some simulations, 
% different-sized patches were combined.
acrossCombination = 'patchSet_3x2'; 
% Variable specifying the name of the subfolder to save data in. Specifies
% which strategy of finding complementary patches was used. "find_CPatches" 
% simply looks for top complementary patches, whereas "find_CPatches_thresholding"
% Only considers CPatches that have certain absolute performance value.
combination_type  = 'find_CPatches'; 

if (nargin < 1)
    nPatchesAnalyzed = 50000;
    nTPatches        = 100;
    nTPatchesPerLoop = 10;
    nCPatches        = 1000;
end

runParameterComments = 'none';%input('Any comments about the run?\n'); %#ok<*NASGU>

if ispc
    home = fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast',simulation);
else
    home = fullfile('/home/levan/HMAX/annulusExptFixedContrast',simulation);
end

loadLoc = fullfile(home,condition,'data',acrossCombination,'lfwSingle50000');
saveLoc = fullfile(home,condition,'data',acrossCombination,'lfwSingle50000','combinations',combination_type,'doublets',...
                   [int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches']...
                   );
               
if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

diary(fullfile(saveLoc,'diary.mat'));

if mod(nTPatches,nTPatchesPerLoop)~=0
    input = 'loopping messed up'; %#ok<*NASGU>
else
    nTPatchLoops = nTPatches/nTPatchesPerLoop;
end

% load the variables
% Note: variables get loaded for each loop. This slows it down, but
% otherwise I was getting an error.

%% Start parfor loop
display('starting parfor loop')

parfor iPatchLoop = 1:nTPatchLoops
%     display('Parfor is off!!!!');
%     display('Combining based on FACE-BOX');
%     display('Combining based on WEDGE');    
    display(['Patch loop is ' int2str(iPatchLoop)]);
    CUR_findScaledDoublets_FaceBox_par(...
        nPatchesAnalyzed,...
        iPatchLoop,...
        nTPatchesPerLoop,...
        nCPatches,...
        saveLoc,...
        loadLoc)
    
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
save(fullfile(saveLoc,'key.mat'),'key');

%% Save parameters and other variables.
display('Starting to save other variables');
pushValue = 0.001;
CUR_make_scaledDoublet_c2_imgHitsFaceBox(loadLoc,saveLoc,nTPatches,nCPatches,pushValue)

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
    'pushValue'...
    );
mainEndTime = toc(mainStartTime);
end