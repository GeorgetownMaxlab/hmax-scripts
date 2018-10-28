function CUR_genTriplets(nTPatchesLoad,nCPatchesLoad,nTPatches,nTPatchesPerLoop,nCPatches)

%% GLOBAL STUFF
% clear; clc;
dbstop if error;

if (nargin < 1)
    nTPatchesLoad    = 500;
    nCPatchesLoad    = 500;
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
condition         = 'training';
acrossCombination = 'acrossPatchTypes';

nDoublets = nTPatchesLoad*nCPatchesLoad;
nTriplets = nTPatches    *nCPatches;

loadLoc = fullfile(home,condition,'data',acrossCombination,'lfwSingle50000','scaling_WedgeDegree_30','doublets',...
                   [int2str(nTPatchesLoad) 'TPatches' int2str(nCPatchesLoad) 'CPatches']);
               
saveLoc = fullfile(loadLoc,'triplets',[int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches']);

singlesLoc = fullfile(home,condition,'data',acrossCombination,'lfwSingle50000','fixedLocalization');

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end
diary(fullfile(saveLoc,'diary.mat'));

if mod(nTPatches,nTPatchesPerLoop)~=0
    input = 'loopping messed up'; %#ok<*NASGU>
else
    nTPatchLoops = nTPatches/nTPatchesPerLoop;
end

% load the doublet data
load(fullfile(loadLoc,'combMatrix'));
doubletCombMatrix = combMatrix; % redefine because new combMatrix is created for triplets.
combMatrix = [];
    if exist(fullfile(loadLoc,['imageDifficultyData_Wedge_' int2str(nDoublets) '_Patches.mat'])) == 0
       CUR_imageDifficultyMapWedge30('DOUBLETS','f',loadLoc,0);
    end
load(fullfile(loadLoc,['imageDifficultyData_Wedge_' int2str(nDoublets) '_Patches']),'IndPatch');



%% Start parfor loop
display('starting parfor loop')

parfor iPatchLoop = 1:nTPatchLoops
%     display('Parfor is off!!!!');
    iPatchLoop
    CUR_findScaledTriplets_Wedge30_par(...
        iPatchLoop,...
        nTPatchesPerLoop,...
        nCPatches,...
        saveLoc,...
        loadLoc,...
        singlesLoc,...
        nDoublets,...
        doubletCombMatrix)
    
    display(['done with loop ' int2str(iPatchLoop)]);
end
key = [{'Patch1 index'} {'Patch2 index'} {'Patch3 index'} {'Patch2 SF'} {'Patch3 SF'} {'Doublet Localization'} {'Triplet Localization'}];
    
%% Concatenate the output
display('Concatenating output...')
concatinateOutput_comb(saveLoc,nTPatchesPerLoop,nTPatches,nCPatches)

%% Save parameters and other variables.
display('Starting to save other variables');
pushValue = 0.001;
save(fullfile(saveLoc,'key_to_combMatrix'),'key');
CUR_make_scaledTriplet_c2_imgHitsWedge30(singlesLoc,saveLoc,nTPatches,nCPatches,pushValue)

runDateTime = datetime('now');
scriptName  = mfilename('fullpath');
save(fullfile(saveLoc,'runParameters.mat'),...
    'runDateTime',...
    'scriptName',...
    'runParameterComments',...
    'nTPatches',...
    'nCPatches',...
    'nTPatchesLoad',...
    'nCPatchesLoad',...
    'saveLoc',...
    'loadLoc',...
    'pushValue'...
    );
diary off;
end