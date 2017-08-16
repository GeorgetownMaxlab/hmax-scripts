function CUR_runAnnulusExpt2(locationFileToLoad, saveFolder, condition,...
                             nPatchesAnalyzed, nPatchesPerLoop, startingPatchLoopIdx,endingPatchLoopIdx, ...
                             nImgsAnalyzed, nImgsPerLoop, nImgsPerWorker, ...
                             patchesFolder,keepS2, maxSize, RESIZE)

% This is a cleaned up version of CUR_runAnnulusExpt.m. Unnecessary, old
% variables have been removed.
% Localization is off until its adjusted for various patchSizes. 

% For quickie analysis, run this command:
% CUR_runAnnulusExpt2('annulusExptFixedContrast/simulation4/testing/facesLoc.mat',...
%                     'annulusExptFixedContrast/simulation4/testing/data/patchSet_3x2/lfwSingle50000',...
%                     'annulusExptFixedContrast/simulation4/testing/',...
%                     50000,12500,1,4,...
%                     1659,237,8,...
%                     'patchSet_3x2')

%creates c2 for images and saves the coordinates of the best locations and
%bands;

% VARIABLES

% nPatchesPerLoop - number of patches that will be run per loop through images.
%                   Total of nPatchesAnalyzed/nPatchesPerLoop loops will be
%                   run.

% condition - serves as input to localization code. Specifies the path to
%             exptDesign.mat file for the simulations. 

%% Define global variables and set the stage up.
% mainStartTime = tic;
dbstop if error;
% diary([saveFolder 'cmdLine']);

c1Scale = 1:2:18;
c1Space = 8:2:22;
c1bands.c1Space = c1Space;
c1bands.c1Scale = c1Scale;

%gaborSpecs: info for creating Gabor filters
gaborSpecs.orientations = [90 -45 0 45]; %filter orientations
gaborSpecs.receptiveFieldSizes = 7:2:39; %how big the filters are
gaborSpecs.div = 4:-.05:3.2; %frequency tuning of sinusoids 
  
if (nargin < 13)
    maxSize = 579;
    RESIZE = 1;
end
if (nargin < 12)
    keepS2 = 0;
end
if (nargin < 11)
    patchesFolder = 'patchSetAdam';
end

if ispc == 1
    pcStatus = 1;
    loadLoc         = 'C:/Users/levan/HMAX/';
    saveLoc         = fullfile(loadLoc,saveFolder)
    patchesLoc      = ('C:/Users/levan/HMAX/patches/');
else
    pcStatus = 0;
    loadLoc         = '/home/levan/HMAX/';
    saveLoc         = fullfile(loadLoc,saveFolder)
    patchesLoc      = ('/home/levan/HMAX/patches/');
end

display(['patches used are ' patchesFolder]);

% %%% OLD SIMULATION? %%%
% oldSimulation = 1;
% 
% if oldSimulation
%     load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\data\patchSet_3x2\lfwSingle50000\runParameters.mat',...
%         'condition',...
%         'keepS2',...
%         'locationFileToLoad',...
%         'maxSize',...
%         'nImgsAnalyzed',...
%         'nImgsPerLoop',...
%         'nImgsPerWorker',...
%         'nPatchesAnalyzed',...
%         'nPatchesPerLoop',...
%         'RESIZE'...
%         );
% end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

seedNum = 1234;
rng(seedNum, 'twister');
save(fullfile(saveLoc,'randomseed'), 'seedNum');
diary(fullfile(saveLoc,'diary.mat'));

% Load face images
load(fullfile(loadLoc,locationFileToLoad));
facesLoc = convertFacesLocAnnulusFixedContrast(facesLoc,pcStatus);
    facesLoc{1} = facesLoc{1}(1:nImgsAnalyzed);
    save(fullfile(saveLoc,'facesLoc'),'facesLoc');

%% Save parameter space.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
runDateTime = datetime('now');
scriptName  = mfilename('fullpath');
runParameterComments = 'none'; %input('Any comments about run?\n');
save(fullfile(saveLoc,'runParameters.mat'),...
    'runDateTime',...
    'scriptName',...
    'runParameterComments',...
    'seedNum',...
    'keepS2',...
    'locationFileToLoad',...
    'condition',...
    'nPatchesAnalyzed',...
    'nPatchesPerLoop',...
    'nImgsAnalyzed',...
    'nImgsPerLoop',...
    'nImgsPerWorker',...
    'saveLoc',...
    'saveFolder',...
    'loadLoc',...
    'patchesLoc',...
    'patchesFolder',...
    'startingPatchLoopIdx',...
    'endingPatchLoopIdx',...
    'RESIZE',...
    'maxSize'...
    );
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	patches = load([patches 'patch1.mat']);
% 	patch{1} = patches.patches{1}(:, ((10000 * (n - 1)) + 1):10000 * n);
% 	fprintf('converting patches to xml... \n');
% 	patchFile = matlabPatches2OCVPatches(filters, fSize, c1Scale, c1Space, c1OL, patch, patches.sizes, 'patches', hmaxHome);
% 	[path, patchName, ext] = fileparts(patchFile);
% 	maxSize = 0; %max height size

%% matlab implementation to create C2
% If loading and testing all of the patches
    load(fullfile(patchesLoc,patchesFolder,'patches.mat'))

if mod(nImgsAnalyzed,nImgsPerLoop)~=0 || mod(nPatchesAnalyzed,nPatchesPerLoop)~=0
    input = 'loopping messed up'
else
    nImgLoops   = nImgsAnalyzed/nImgsPerLoop;
    nPatchLoops = nPatchesAnalyzed/nPatchesPerLoop;
end

% Patch loop begin.
for iPatchLoop = startingPatchLoopIdx:endingPatchLoopIdx
    
    idxPatchStart = (iPatchLoop-1)*nPatchesPerLoop+1;
    idxPatchEnd   = (iPatchLoop)*nPatchesPerLoop;
    
    patches{1}    = ps.patches{1}(:,idxPatchStart:idxPatchEnd);
    patchSizes    = [ps.sizes(1:3,:); nPatchesPerLoop];


        % Predifine to concatinate later.
        c2fPatchLoop = [];
        bestBandsPatchLoop = []; %#ok<*NASGU>
        bestLocPatchLoop = [];
        s2fPatchLoop = [];

        % Image loop begin.
        for iImgLoop = 1:nImgLoops
            %             iPatchLoop
            iImgLoop
            imgLoopTic = tic;
            idxImgsStart = (iImgLoop-1)*nImgsPerLoop+1;
            idxImgsEnd   = (iImgLoop)  *nImgsPerLoop;
            c2f = [];
            
            [c2f, ~, bestBands, bestLoc, s2f] = genC2(gaborSpecs, facesLoc{1}(idxImgsStart:idxImgsEnd), ...
                c1bands, patches, patchSizes, 1, maxSize, keepS2, ...
                RESIZE, nImgsPerWorker);
            
            c2fPatchLoop       = [c2fPatchLoop c2f]; %#ok<*AGROW>
            bestBands          = horzcat(bestBands{:});
            bestLoc            = horzcat(bestLoc{:});
            bestBandsPatchLoop = [bestBandsPatchLoop bestBands];
            bestLocPatchLoop   = [bestLocPatchLoop bestLoc];
            s2fPatchLoop       = [s2fPatchLoop s2f];
            
            save(fullfile(saveLoc,['c2f_patches'       int2str(idxPatchStart) '-' int2str(idxPatchEnd) 'allImages']),'c2fPatchLoop');
            save(fullfile(saveLoc,['bestBands_patches' int2str(idxPatchStart) '-' int2str(idxPatchEnd) 'allImages']),'bestBandsPatchLoop');
            save(fullfile(saveLoc,['bestLoc_patches'   int2str(idxPatchStart) '-' int2str(idxPatchEnd) 'allImages']),'bestLocPatchLoop');
%             save(fullfile(saveLoc,['s2f_patches'       int2str(idxPatchStart) '-' int2str(idxPatchEnd) 'allImages']),'s2fPatchLoop');
            c2f       = [];
            bestBands = [];
            bestLoc   = [];
            
            imgLoopToc = toc(imgLoopTic)
        end % img loop
end % patch loop

%% Concatinate all the output
concatinateOutput(saveLoc,nPatchesPerLoop,nPatchesAnalyzed);
%% Run localization code
% display('starting localization code...');
% CUR_annulusWedgeAndBoxLocalization_resizing_diff_patchSizes(nPatchesAnalyzed,patchSizes(:,1),saveFolder,condition);
diary off
%% openCV implementation to create C2
%	fprintf('creating C2 activations for test faces... \n');
%	tic;
%	hmaxOCV(facesLoc, patchFile, hmaxHome, maxSize);
%	c2f = xmlC22matC2(facesLoc, patchName);
%	save([saveLoc 'c2f' int2str(n)], 'c2f');
%	hmaxOCV(scrambledLoc, patchFile, hmaxHome, maxSize);
%	c2s = xmlC22matC2(scrambledLoc, patchName);
%	save([saveLoc 'c2s' int2str(n)], 'c2s');
%	hmaxOCV(housesLoc, patchFile, hmaxHome, maxSize);
%	c2h = xmlC22matC2(housesLoc, patchName);
%	save([saveLoc 'c2h' int2str(n)], 'c2h');
%	hmaxOCV(invertedLoc, patchFile, hmaxHome, maxSize);
%	c2i = xmlC22matC2(invertedLoc, patchName);
%	save([saveLoc 'c2i' int2str(n)], 'c2i');
%	hmaxOCV(configuralLoc, patchFile, hmaxHome, maxSize);
%	c2c = xmlC22matC2(configuralLoc, patchName);
%	save([saveLoc 'c2c' int2str(n)], 'c2c');
%	hmaxOCV(uniqueEmptyLoc, patchFile, hmaxHome, maxSize);
%	c2ue = xmlC22matC2(uniqueEmptyLoc, patchName);
%	save([saveLoc 'c2ue' int2str(n)], 'c2ue');
%	hmaxOCV(emptyLoc, patchFile, hmaxHome, maxSize);
%	c2e = xmlC22matC2(emptyLoc, patchName);
%	save([saveLoc 'c2e' int2str(n)], 'c2e'); 
% end
% mainEndTime = toc(mainStartTime);
% mainRunTime = mainStartTime - mainEndTime
end
