function runAnnulusExptMask_CUR(targetImages, saveFolder, quadType, ...
    nPatchesAnalyzed, nPatchesPerLoop, nImgsAnalyzed, nImgsPerLoop,...
    nImgsPerWorker, keepS2, maxSize, RESIZE) %  input arguments



%creates c2 for images and saves the coordinates of the best locations and
%bands;

% seedNum: random seed; important for replication!!! 
% gaborSpecs, c1Space, c1Scale: see C2.m
% locationFileToLoad: a string. Name of the file that has the paths to the images
                    % being analyzed; For example, 'facesLocTesting.mat'.
% loadFolder: a string. Name of the specific subfolder to load patch
              % indices from.
% saveFolder: a string. Name of the folder to save data in.
% quadType: a string. Either 'f' for faces or 'e' for empty.
% nPatchesAnalyzed: a double. number of patches being analyzed.
% COMBINATION: a double. 0 if no combination used. 2 if coubining doublets.
                % 3 if combining triplets. This vatiable will perform
                % combination using the *within scale band combination*
                % strategy. A different combination strategy is better -
                % see combinePatches.m for info.
% BLUR: logical. 1 if doing spatial blurring at the S2 level.
% keepS2: logical. 1 if need to keep the S2 files (will take lots of memory)

%% Define global variables and set the stage up.
tic;
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

if (nargin < 9)
    RESIZE = 0;
    keepS2 = 0;
    maxSize = flintmax;
end

if strcmp(targetImages,'training')
    locationFileToLoad = 'trainingTestingSplit/facesLocTraining';
else
    locationFileToLoad = 'trainingTestingSplit/facesLocTesting';
end


if ispc == 1
    loadLoc         = 'C:\Users\levan\HMAX\annulusExpt\'
    saveLoc         = ['C:\Users\levan\HMAX\annulusExpt\' saveFolder '\']
    patchesLoc      = ('C:\Users\levan\HMAX\patches\patchSetAdam\')
    locationFileToLoad = strcat(locationFileToLoad,'Win');
else
    loadLoc         = '/home/levan/HMAX/annulusExpt/' 
    saveLoc         = ['/home/levan/HMAX/annulusExpt/' saveFolder '/']
    patchesLoc      = ('/home/levan/HMAX/patches/patchSetAdam/')
%     emptyImgLoc = ('/home/levan/HMAX/naturalFaceImages/naturalFaceImages2/');
end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

seedNum = 1234;
rng(seedNum, 'twister');
save([saveLoc 'randomseed'], 'seedNum');
diary([saveLoc 'diary.mat']);
load([loadLoc '/maskingMatrices/idxPixel.mat']);
% parpool(30);

if strcmp(quadType,'f') == 1
    % Load face images
    load([loadLoc locationFileToLoad]);
        facesLoc{1} = facesLoc{1}(1:nImgsAnalyzed);
        save([saveLoc 'facesLoc'],'facesLoc');
else
    % Load empty images
    load([emptyImgLoc 'emptyLoc.mat']);
    save([saveLoc 'emptyLoc'], 'emptyLoc');
end

%% Save parameter space.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
runDateTime = datetime('now');
outputOfPWD = pwd;
scriptName  = mfilename('fullpath');
runParameterComments = 'none'; %input('Any comments about run?\n');
save([saveLoc 'runParameters.mat'],...
    'runDateTime',...
    'scriptName',...
    'outputOfPWD',...
    'runParameterComments',...
    'seedNum',...
    'keepS2',...
    'quadType',...
    'locationFileToLoad',...
    'nPatchesAnalyzed',...
    'nPatchesPerLoop',...
    'nImgsAnalyzed',...
    'nImgsPerLoop',...
    'nImgsPerWorker',...
    'saveLoc',...
    'loadLoc',...
    'patchesLoc',...
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
    load([patchesLoc 'patches.mat']);

if mod(nImgsAnalyzed,nImgsPerLoop)~=0 || mod(nPatchesAnalyzed,nPatchesPerLoop)~=0
    input = 'lopping messed up';
else
    nImgLoops = nImgsAnalyzed/nImgsPerLoop;
    nPatchLoops = nPatchesAnalyzed/nPatchesPerLoop;
end

% Patch loop begin.
for iPatchLoop = 1:nPatchLoops
    idxPatchStart = (iPatchLoop-1)*nPatchesPerLoop+1;
    idxPatchEnd   = (iPatchLoop)*nPatchesPerLoop;
    
    patches{1} = ps.patches{1}(:,idxPatchStart:idxPatchEnd);
    patchSizes = [ps.sizes(1:3,:); nPatchesPerLoop];


        % Predifine to concatinate later.
        c2fPatchLoop = [];
        bestBandsPatchLoop = []; %#ok<*NASGU>
        bestLocPatchLoop = [];
        s2fPatchLoop = [];

        for iImgLoop = 1:nImgLoops
            iPatchLoop
            iImgLoop
            idxImgsStart = (iImgLoop-1)*nImgsPerLoop+1;
            idxImgsEnd    = (iImgLoop)*nImgsPerLoop;
                c2f = [];
                    [c2f, ~, bestBands, bestLoc, s2f] = genC2Mask(gaborSpecs, facesLoc{1}(idxImgsStart:idxImgsEnd), c1bands, patches, patchSizes, 1, maxSize, keepS2, RESIZE, nImgsPerWorker,idxPixel);
                        c2fPatchLoop       = [c2fPatchLoop c2f];
%                         bestBandsPatchLoop = [bestBandsPatchLoop bestBands];
%                         bestLocPatchLoop   = [bestLocPatchLoop bestLoc];
                        
                        bestBands = horzcat(bestBands{:});
                        bestLoc   = horzcat(bestLoc{:});
                        bestBandsPatchLoop = [bestBandsPatchLoop bestBands]; %#ok<*AGROW>
                        bestLocPatchLoop   = [bestLocPatchLoop bestLoc];


                        save([saveLoc 'c2f_patches'       int2str(idxPatchStart) '-' int2str(idxPatchEnd) 'allImages'],      'c2fPatchLoop');
                        save([saveLoc 'bestBands_patches' int2str(idxPatchStart) '-' int2str(idxPatchEnd) 'allImages'],'bestBandsPatchLoop');
                        save([saveLoc 'bestLoc_patches'   int2str(idxPatchStart) '-' int2str(idxPatchEnd) 'allImages'],  'bestLocPatchLoop');
                        c2f = [];
        end % img loop
end % patch loop

%% Concatinate all the output
concatinateOutput(saveLoc,nPatchesPerLoop,nPatchesAnalyzed);
%% Run localization code
annulusWedgeAndBoxLocalization_resizingCUR(nPatchesAnalyzed,saveFolder);

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
toc;
end
