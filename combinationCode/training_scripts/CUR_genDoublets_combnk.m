function CUR_genDoublets_combnk(nPatchesAnalyzed,nTPatches,nTPatchesPerLoop,condition)

% This configuration of the script simply takes top N patches and creates 
% doublets of all possible combinations. It does not implement the
% complementary patch strategy.

% The script still uses the scaling approach.

%% GLOBAL STUFF
% clear; clc;
dbstop if error;
mainStartTime = tic;

if (nargin < 5)
    condition = 'training';
end

acrossCombination = 'acrossPatchTypes';
combination_type  = 'combnk_patches';

if (nargin < 1)
    nPatchesAnalyzed = 80000;
    nTPatches        = 500;
    nTPatchesPerLoop = 25;
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

%% create the combinations of doublets with combnk
doublet_combs = combnk(1:nTPatches,2);




%% Start parfor loop
display('starting parfor loop')

parfor iPatchLoop = 1:nTPatchLoops
%     display('Parfor is off!!!!');
%     iPatchLoop
    CUR_findScaledDoublets_Wedge30_par_combnk(...
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