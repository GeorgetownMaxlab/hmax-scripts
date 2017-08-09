function CUR_genTriplets_norep(nTPatchesLoad,nCPatchesLoad,nTPatches,nTPatchesPerLoop,nCPatches,condition)

%% GLOBAL STUFF
% clear; clc;
dbstop if error;

if (nargin < 1)
    nTPatchesLoad    = 10;
    nCPatchesLoad    = 10;
    nTPatches        = 10;
    nTPatchesPerLoop = 5;
    nCPatches        = 10;
end

runParameterComments = 'none';%input('Any comments about the run?\n'); %#ok<*NASGU>

if ispc
    home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3';
else
    home = '/home/levan/HMAX/annulusExptFixedContrast/simulation3';
end
if (nargin < 6)
    condition         = 'training';
end
acrossCombination = 'acrossPatchTypes';
combination_type  = 'find_CPatches';

loadLoc = fullfile(home,condition,'data',acrossCombination,'lfwSingle50000','combinations',combination_type,'doublets',...
                   [int2str(nTPatchesLoad) 'TPatches' int2str(nCPatchesLoad) 'CPatches']...
                   );
               
saveLoc = fullfile(loadLoc,'triplets',[int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches'] ...
                   );

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

nDoublets = size(doubletCombMatrix,1);%nTPatchesLoad*nCPatchesLoad;
nTriplets = nTPatches    *nCPatches;

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

%% Get rid of the repeated triplets

load(fullfile(saveLoc,'combMatrix.mat'));
indices = combMatrix(:,1:3);

for iRow = 1:size(indices,1)
   indices(iRow,:) = sort(indices(iRow,:),'ascend'); 
end

[~,ia,~] = unique(indices,'rows');
combMatrix = combMatrix(ia,:);
save(fullfile(saveLoc,'combMatrix.mat'),'combMatrix');

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