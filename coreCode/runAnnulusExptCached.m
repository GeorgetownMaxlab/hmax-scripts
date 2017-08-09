function runAnnulusExptNew(locationFileToLoad, ...
    saveFolder, quadType, idxFaceStart, idxFaceEnd, ...
    keepS2, maxSize, RESIZE, cachedImgs) % 10 input arguments

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
% keepS2: logical. 1 if need to keep the S2 files (will take lots of memory)

%% Define global variables and set the stage up.
tic;
dbstop if error;

c1Scale = 1:2:18;
c1Space = 8:2:22;
c1bands.c1Space = c1Space;
c1bands.c1Scale = c1Scale;
%gaborSpecs: info for creating Gabor filters
gaborSpecs.orientations = [90 -45 0 45]; %filter orientations
gaborSpecs.receptiveFieldSizes = 7:2:39; %how big the filters are
gaborSpecs.div = 4:-.05:3.2; %frequency tuning of sinusoids 

% [fSize, filters, c1OL, numSimpleFilters] = init_gabor(gaborSpecs.orientations, gaborSpecs.receptiveFieldSizes, gaborSpecs.div);
% init_gabor is being implemented in genC2. None of the outputs get used in
% this code. So I leave it commented out.
if (nargin < 8)
    keepS2      = 0
end

if (nargin < 1)
    locationFileToLoad = 'exampleImagesCached.mat';
    saveFolder = 'output';
    quadType = 'f';
    idxFaceStart = 1;
    idxFaceEnd = 10;
    keepS2 = 0;
    maxSize = flintmax;
    RESIZE = 0;
    cachedImgs = 'yes';
end


if ispc == 1 
    loadLoc         = 'C:\Users\levan\Desktop\tempHMAX\'
    saveLoc         = ['C:\Users\levan\Desktop\tempHMAX\' saveFolder '\']
    patchesLoc      = ('C:\Users\levan\Desktop\tempHMAX\')
%     emptyImgLoc = ('C:\Users\Levan\Desktop\HMAX\naturalFaceImages\naturalFaceImages2\');
else
%     loadLoc         = '/home/levan/HMAX/annulusExpt/' 
%     saveLoc         = ['/home/levan/HMAX/annulusExpt/' saveFolder '/']
%     patchesLoc      = ('/home/levan/HMAX/patches/patchSet6/')
%     emptyImgLoc = ('/home/levan/HMAX/naturalFaceImages/naturalFaceImages2/');
end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

seedNum = 1234;
rng(seedNum, 'twister');
save([saveLoc 'randomseed'], 'seedNum');

load([loadLoc locationFileToLoad]);
% Are there cached pre-processed images?
if strcmp(cachedImgs,'no') == 1
    display('Pre-processing images');
    [exampleImagesCached] = preprocessImgs(loadLoc,locationFileToLoad,exampleImages);
    display('Done Pre-processing images');
end 
facesLoc = exampleImagesCached(idxFaceStart:idxFaceEnd);
% else
%     % Load empty images
%     load([emptyImgLoc 'emptyLoc.mat']);
%     save([saveLoc 'emptyLoc'], 'emptyLoc');
% end

%% Load Patches and reformat:

% If loading specific indices of patches
%     load([loadLoc loadFolder 'imageDifficultyData_'...
%         num2str(nPatchesAnalyzed) '_Patches'],'IndPatch');    
%     load([patchesLoc 'patches.mat']);
%     patches = ps;
%     orderedIndex = IndPatch;
%     topPatches = orderedIndex(1:nPatchesAnalyzed);
%     
%     for i = 1:length(topPatches)
%     	patch{1}(:, i) = patches.patches{1}(:, topPatches(i));
%     end
%     fprintf('loaded AND SORTED the patches\n');
    
% If loading and testing all of the patches
    load([patchesLoc 'universal_patch_set.mat'],'patches','patchSizes');
%     patches = ps;
%     patch{1} = patches.patches{1}(:,1:nPatchesAnalyzed);
    fprintf('loaded the patches\n');
%% Save parameter space.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
runDateTime = datetime('now');
outputOfPWD = pwd;
runParameterComments = 'none'; %input('Any comments about run?\n');
save([saveLoc 'runParameters' int2str(idxFaceStart) '-' int2str(idxFaceEnd) '.mat'],...
    'runDateTime',...
    'outputOfPWD',...
    'runParameterComments',...
    'idxFaceStart',...
    'idxFaceEnd',...
    'seedNum',...
    'keepS2',...
    'quadType',...
    'locationFileToLoad',...
    'saveLoc',...
    'loadLoc',...
    'patchesLoc',...
    'RESIZE',...
    'maxSize',...
    'cachedImgs'...
    );
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	patches = load([patches 'patch1.mat']);
% 	patch{1} = patches.patches{1}(:, ((10000 * (n - 1)) + 1):10000 * n);
% 	fprintf('converting patches to xml... \n');
% 	patchFile = matlabPatches2OCVPatches(filters, fSize, c1Scale, c1Space, c1OL, patch, patches.sizes, 'patches', hmaxHome);
% 	[path, patchName, ext] = fileparts(patchFile);
% 	maxSize = 0; %max height size

%% matlab implementation to create C2    
%     if strcmp(quadType,'f') == 1
        fprintf('creating C2 activations FOR FACES!!!... \n');
        c2f = [];
            [c2f, ~, bestBands, bestLoc, s2f] = genC2(gaborSpecs, facesLoc, c1bands, patches, patchSizes, 1, maxSize, keepS2, RESIZE);
            save([saveLoc 'c2f' int2str(idxFaceStart) '-' int2str(idxFaceEnd)], 'c2f');
            save([saveLoc 'bestBandsC2f' int2str(idxFaceStart) '-' int2str(idxFaceEnd)], 'bestBands');
            save([saveLoc 'bestLocC2f' int2str(idxFaceStart) '-' int2str(idxFaceEnd)], 'bestLoc');
            save([saveLoc 's2f' int2str(idxFaceStart) '-' int2str(idxFaceEnd)], 's2f');
            c2f = [];
%     else
%         fprintf('creating C2 activations FOR EMPTY!!!... \n');
%         c2e = [];
%             [c2e, ~, bestBands, bestLoc, s2e] = genC2(gaborSpecs, emptyLoc, c1bands, patches, patchSizes, 1, maxSize, keepS2, RESIZE);
%             save([saveLoc 'c2e' int2str(i)], 'c2e');
%             save([saveLoc 'bestBandsC2e' int2str(i)], 'bestBands');
%             save([saveLoc 'bestLocC2e' int2str(i)], 'bestLoc');
%             save([saveLoc 's2e' int2str(i)], 's2e');
%             c2e = [];
%     end
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
