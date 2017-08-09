function c2 = classSpecificPsychMAT1(hmaxHome, faces, scrambled, houses, inverted, configural, empty, ...
													patches, seedNum, gaborSpecs, c1Space, c1Scale)
%creates and saves c1, patches, c2, FI, and plots FI using functions and preexisting code by Josh Rule
%
%hmaxHome: home directory of hmax code 
%
%patches: hall of fame patches (see bestPatches.m in 'utils')
%seedNum: random seed; important for replication!!! 
%gaborSpecs, c1Space, c1Scale: see C2.m
tic;

if(nargin < 12) c1Scale = 1:2:18; end;

if(nargin < 11) c1Space = 8:2:22; end;

%taken from runExperiments.m
if(nargin < 10) %gaborSpecs: info for creating Gabor filters
	gaborSpecs.orientations = [90 -45 0 45]; %filter orientations
	gaborSpecs.receptiveFieldSizes = 7:2:39; %how big the filters are
	gaborSpecs.div = 4:-.05:3.2; %frequency tuning of sinusoids
end
if(nargin < 1)
	hmaxHome = '/home/bentrans/Documents/HMAX/feature-learning/';
	faces = '/home/bentrans/Documents/Psychophysics/faces/';
	scrambled = '/home/bentrans/Documents/Psychophysics/scrambledFaces/';
	houses = '/home/bentrans/Documents/Psychophysics/houses/';
	inverted = '/home/bentrans/Documents/Psychophysics/invertedFaces/';
	configural = '/home/bentrans/Documents/Psychophysics/configuralFaces/';
	empty = '/home/bentrans/Documents/Psychophysics/empty/';
	uniqueEmpty = '/home/bentrans/Documents/Psychophysics/UniqueEmpty/';
	patches = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-OCV/lfw/';
	seedNum = 1234;
end

saveLoc = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/lfwTriples50Part1Distractors/';
ext = 'bmp';
%load('/home/bentrans/Documents/Psychophysics/Analysis/HMAX-OCV/lfw/compareAUC/compareAUC.mat');
load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/lfwBorder/orderedIndex.mat');
rng(seedNum, 'twister');
save('randomseed', 'seedNum');

[fSize, filters, c1OL, numSimpleFilters] = init_gabor(gaborSpecs.orientations, gaborSpecs.receptiveFieldSizes, gaborSpecs.div);
faces = lsDir(faces, {ext});
faces = faces(1:ceil(length(faces) / 2));
scrambled = lsDir(scrambled, {ext});
scrambled = scrambled(1:ceil(length(scrambled) / 2));
houses = lsDir(houses, {ext});
houses = houses(1:ceil(length(houses) / 2));
inverted = lsDir(inverted, {ext});
inverted = inverted(1:ceil(length(inverted) / 2));
configural = lsDir(configural, {ext});
configural = configural(1:ceil(length(configural) / 2));
empty = lsDir(empty, {ext});
empty = empty(1:ceil(length(empty) / 2));
uniqueEmpty = lsDir(uniqueEmpty, {ext});
uniqueEmpty = uniqueEmpty(1:ceil(length(uniqueEmpty) / 2));


count = ones(1, 4);
for iImg = 1:length(faces)
	quad = str2num(faces{iImg}(length(faces{iImg}) - 4));
	facesLoc{quad}{count(quad)} = faces{iImg};
	count(quad) = count(quad) + 1;
end

count = ones(1, 4);
for iImg = 1:length(scrambled)
	quad = str2num(scrambled{iImg}(length(scrambled{iImg}) - 4));
	scrambledLoc{quad}{count(quad)} = scrambled{iImg};
	count(quad) = count(quad) + 1;
end

count = ones(1, 4);
for iImg = 1:length(houses)
	quad = str2num(houses{iImg}(length(houses{iImg}) - 4));
	housesLoc{quad}{count(quad)} = houses{iImg};
	count(quad) = count(quad) + 1;
end

count = ones(1, 4);
for iImg = 1:length(inverted)
	quad = str2num(inverted{iImg}(length(inverted{iImg}) - 4));
	invertedLoc{quad}{count(quad)} = inverted{iImg};
	count(quad) = count(quad) + 1;
end

count = ones(1, 4);
for iImg = 1:length(configural)
	quad = str2num(configural{iImg}(length(configural{iImg}) - 4));
	configuralLoc{quad}{count(quad)} = configural{iImg};
	count(quad) = count(quad) + 1;
end

count = ones(1, 4);
for iImg = 1:length(empty)
	quad = str2num(empty{iImg}(length(empty{iImg}) - 4));
	emptyLoc{quad}{count(quad)} = empty{iImg};
	count(quad) = count(quad) + 1;
end

count = ones(1, 4);
for iImg = 1:length(uniqueEmpty)
	quad = str2num(uniqueEmpty{iImg}(length(uniqueEmpty{iImg}) - 4));
	uniqueEmptyLoc{quad}{count(quad)} = uniqueEmpty{iImg};
	count(quad) = count(quad) + 1;
end

%save([saveLoc 'facesLoc'], 'facesLoc');
save([saveLoc 'scrambledLoc'], 'scrambledLoc');
save([saveLoc 'housesLoc'], 'housesLoc');
save([saveLoc 'invertedLoc'], 'invertedLoc');
save([saveLoc 'configuralLoc'], 'configuralLoc');
save([saveLoc 'emptyLoc'], 'emptyLoc');
save([saveLoc 'uniqueEmptyLoc'], 'uniqueEmptyLoc');
for n = 1:1
	patches = load([patches '/patch' int2str(n) '.mat']);
	patches = patches.patches;
	topPatches = index(1:50); %compareAUC.sortedIndexFvsUE(1:1);
	for i = 1:length(topPatches)
		patch{1}(:, i) = patches.patches{1}(:, topPatches(i));
	end
%	patch{1} = patches.patches{1}(:, 1:10000);
	fprintf('converting patches to xml... \n');
%	patchFile = matlabPatches2OCVPatches(filters, fSize, c1Scale, c1Space, c1OL, patch, patches.sizes, 'patches', hmaxHome);
%	[path, patchName, ext] = fileparts(patchFile);
	patchSize = 0; %make this more flexible. Incorporate while calling function%, or nargin place.
	maxSize = patchSize; %max height size

	%matlab implementation to create C2
	c1bands.c1Space = c1Space;
	c1bands.c1Scale = c1Scale;
	c2f = []; %faces
	c2s = []; %scrambled faces
	c2h = []; %housesc2i = []; %inverted faces
	c2i = []; %inverted faces
	c2c = []; %configural faces
	c2e = []; %empty
	c2ue = []; %uniqueEmpty
	fprintf('creating C2 activations... \n');
	%for n = 1:2%length(patches.patches)
	for i = 1:length(facesLoc)
%		[c2f, ~, bestBands, bestLoc, s2f] = genC2(gaborSpecs, facesLoc{i}, c1bands, patch, patches.sizes, 1, 0, 19600);
%		save([saveLoc 'c2f' int2str(i)], 'c2f');
%		save([saveLoc 'bestBandsC2f' int2str(i)], 'bestBands');
%		save([saveLoc 'bestLocC2f' int2str(i)], 'bestLoc');
%		save([saveLoc 's2f' int2str(i)], 's2f');
%		c2f = [];
%		s2f = [];
		[c2ue, ~, bestBands, bestLoc, s2ue] = genC2(gaborSpecs, uniqueEmptyLoc{i}, c1bands, patch, patches.sizes, 1, 0, 3);
		save([saveLoc 'c2ue' int2str(i)], 'c2ue');
		save([saveLoc 'bestBandsC2ue' int2str(i)], 'bestBands');
		save([saveLoc 'bestLocC2ue' int2str(i)], 'bestLoc');
		save([saveLoc 's2ue' int2str(i)], 's2ue');
		c2ue = [];
		s2ue = [];
		[c2c, ~, bestBands, bestLoc, s2c] = genC2(gaborSpecs, configuralLoc{i}, c1bands, patch, patches.sizes, 1, 0, 3);
		save([saveLoc 'c2c' int2str(i)], 'c2c');
		save([saveLoc 'bestBandsC2c' int2str(i)], 'bestBands');
		save([saveLoc 'bestLocC2c' int2str(i)], 'bestLoc');
		save([saveLoc 's2c' int2str(i)], 's2c');
		c2c = [];
		s2c = [];
		[c2s, ~, bestBands, bestLoc, s2s] = genC2(gaborSpecs, scrambledLoc{i}, c1bands, patch, patches.sizes, 1, 0, 3);
		save([saveLoc 'c2s' int2str(i)], 'c2s');
		save([saveLoc 'bestBandsC2s' int2str(i)], 'bestBands');
		save([saveLoc 'bestLocC2s' int2str(i)], 'bestLoc');
		save([saveLoc 's2s' int2str(i)], 's2s');
		c2s = [];
		s2s = [];
		[c2h, ~, bestBands, bestLoc, s2h] = genC2(gaborSpecs, housesLoc{i}, c1bands, patch, patches.sizes, 1, 0, 3);
		save([saveLoc 'c2h' int2str(i)], 'c2h');
		save([saveLoc 'bestBandsC2h' int2str(i)], 'bestBands');
		save([saveLoc 'bestLocC2h' int2str(i)], 'bestLoc');
		save([saveLoc 's2h' int2str(i)], 's2h');
		c2h = [];
		s2h = [];
		[c2i, ~, bestBands, bestLoc, s2i] = genC2(gaborSpecs, invertedLoc{i}, c1bands, patch, patches.sizes, 1, 0, 3);
		save([saveLoc 'c2i' int2str(i)], 'c2i');
		save([saveLoc 'bestBandsC2i' int2str(i)], 'bestBands');
		save([saveLoc 'bestLocC2i' int2str(i)], 'bestLoc');
	save([saveLoc 's2i' int2str(i)], 's2i');
		c2i = [];
		s2i = [];
		[c2e, ~, bestBands, bestLoc, s2e] = genC2(gaborSpecs, emptyLoc{i}, c1bands, patch, patches.sizes, 1, 0, 3);
		save([saveLoc 'c2e' int2str(i)], 'c2e');
		save([saveLoc 'bestBandsC2e' int2str(i)], 'bestBands');
		save([saveLoc 'bestLocC2e' int2str(i)], 'bestLoc');
		save([saveLoc 's2e' int2str(i)], 's2e');
		c2e = [];
		s2e = [];
	end
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
	toc;
end
toc; 


end
