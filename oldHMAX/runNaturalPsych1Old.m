function c2 = runNaturalPsych1Old(faces, patches, seedNum, gaborSpecs, c1Space, c1Scale)
%creates c2 for psychophysics quadrants and saves the coordinates of the best locations and bands; use localization.m for evaluation
%
%hmaxHome: home directory of hmax code 
%faces: location of unique natural face images; should be a mat file (see compareImages.m in utils)
%patches: location of patches
%seedNum: random seed; important for replication!!! 
%gaborSpecs, c1Space, c1Scale: see C2.m
tic;
% dbstop if error;
if(nargin < 7) c1Scale = 1:2:18; end;

if(nargin < 6) c1Space = 8:2:22; end;

if(nargin < 5) %gaborSpecs: info for creating Gabor filters
	gaborSpecs.orientations = [90 -45 0 45]; %filter orientations
	gaborSpecs.receptiveFieldSizes = 7:2:39; %how big the filters are
	gaborSpecs.div = 4:-.05:3.2; %frequency tuning of sinusoids
end
if(nargin < 1)
	%faces = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages/postSeparation/lfwSingle10k-20k/facesLoc.mat';
	faces = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/trainingTestingArraysIncorrect/facesLocTesting.mat'
	%empty = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages/postSeparation/lfwSingle10k-20k/emptyLoc.mat';
    patches = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-OCV/lfw/';
	seedNum = 1234;
end

saveLoc = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/testingSetRuns/comparePreviousDoubles/'
% initialSaveLoc = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/';
ext = 'bmp';
%load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages/orderedIndex.mat');
%load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages/postSeparation/lfwSingle1-10k/orderedIndex.mat');
load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/trainingTestingArraysIncorrect/bestPatchesTrainingSet.mat');
orderedIndex = IndPatch;
rng(seedNum, 'twister');
save('randomseed', 'seedNum');

[fSize, filters, c1OL, numSimpleFilters] = init_gabor(gaborSpecs.orientations, gaborSpecs.receptiveFieldSizes, gaborSpecs.div);

patches = load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-OCV/lfw/patch1.mat');
patches = patches.patches;
nPatchesAnalyzed = 100
topPatches = orderedIndex(1:nPatchesAnalyzed);
for i = 1:length(topPatches)
	patch{1}(:, i) = patches.patches{1}(:, topPatches(i));
end
load(faces);
facesLoc = facesLocTesting;
save([saveLoc 'facesLoc'], 'facesLoc');

for n = 1:1
%	patches = load([patches 'patch1.mat']);
%	patch{1} = patches.patches{1}(:, ((10000 * (n - 1)) + 1):10000 * n);
%	fprintf('converting patches to xml... \n');
%	patchFile = matlabPatches2OCVPatches(filters, fSize, c1Scale, c1Space, c1OL, patch, patches.sizes, 'patches', hmaxHome);
%	[path, patchName, ext] = fileparts(patchFile);
	maxSize = 0; %max height size

	%matlab implementation to create C2
	c1bands.c1Space = c1Space;
	c1bands.c1Scale = c1Scale;
	c2f = []; %faces
%	saveLoc = [initialSaveLoc 'single' int2str(((10000 * (n-1)) + 1)) '-' int2str((10000 * n)) '/'];
%	system(['rm -rf ' saveLoc]);
%	system(['mkdir ' saveLoc]);
%	fprintf([saveLoc '\n']);
	fprintf('creating C2 activations... \n');
	%for n = 1:2%length(patches.patches)
	for i = 1:length(facesLoc)
		[c2f, ~, bestBands, bestLoc, s2f] = genC2(gaborSpecs, facesLoc{i}, c1bands, patch, patches.sizes, 1, 0, 2, 0, 0);
		save([saveLoc 'c2f' int2str(i)], 'c2f');
		save([saveLoc 'bestBandsC2f' int2str(i)], 'bestBands');
		save([saveLoc 'bestLocC2f' int2str(i)], 'bestLoc');
		save([saveLoc 's2f' int2str(i)], 's2f');
		c2f = [];
	end
%	for i = 1:length(emptyLoc)
%		[c2e, ~, bestBands, bestLoc, s2e] = genC2(gaborSpecs, emptyLoc{i}, c1bands, patch, patches.sizes, 1, 0, 0, 0, 0);
%		save([saveLoc 'c2e' int2str(i)], 'c2e');
%		save([saveLoc 'bestBandsC2e' int2str(i)], 'bestBands');
%		save([saveLoc 'bestLocC2e' int2str(i)], 'bestLoc');
%		save([saveLoc 's2e' int2str(i)], 's2e');
%		c2e = [];
%	end
	%openCV implementation to create C2
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
end
toc; 


end
