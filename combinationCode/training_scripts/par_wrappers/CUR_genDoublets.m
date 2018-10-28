function CUR_genDoublets(nPatchesAnalyzed,nTPatches,nTPatchesPerLoop,nCPatches,condition)

% This script implements parallelization of creation of doublets, by
% parallelizing the Top patch loop. 

% It calls CUR_findScaledDoublets_Wedge30_par.m code to implement each loop
% of the top patches.

%% GLOBAL STUFF
% clear; clc;
dbstop if error;
mainStartTime = tic;

if (nargin < 5)
    condition = 'training';
end

acrossCombination = 'acrossPatchTypes';

if (nargin < 1)
    nPatchesAnalyzed = 80000;
    nTPatches        = 100;
    nTPatchesPerLoop = 10;
    nCPatches        = 100;
end

runParameterComments = 'none';%input('Any comments about the run?\n'); %#ok<*NASGU>

if ispc
    home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3';
else
    home = '/home/levan/HMAX/annulusExptFixedContrast/simulation3';
end

loadLoc = fullfile(home,condition,'data',acrossCombination,'lfwSingle50000','fixedLocalization');
saveLoc = fullfile(home,condition,'data',acrossCombination,'lfwSingle50000','scaling_WedgeDegree_30','doublets',...
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

%% Start parfor loop
display('starting parfor loop')

parfor iPatchLoop = 1:nTPatchLoops
%     display('Parfor is off!!!!');
%     iPatchLoop
    CUR_findScaledDoublets_Wedge30_par(...
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
    'pushValue'...
    );
mainEndTime = toc(mainStartTime);
end