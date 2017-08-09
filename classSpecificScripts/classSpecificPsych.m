function c2 = classSpecificPsych(hmaxHome, faces, scrambled, houses, inverted, configural, empty, ...
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

saveLoc = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-OCV/lfw/';
ext = 'bmp';
rng(seedNum, 'twister');
save('randomseed', 'seedNum');

[fSize, filters, c1OL, numSimpleFilters] = init_gabor(gaborSpecs.orientations, gaborSpecs.receptiveFieldSizes, gaborSpecs.div);
facesLoc = lsDir(faces, {ext});
scrambledLoc = lsDir(scrambled, {ext});
housesLoc = lsDir(houses, {ext});
invertedLoc = lsDir(inverted, {ext});
configuralLoc = lsDir(configural, {ext});
emptyLoc = lsDir(empty, {ext});
uniqueEmptyLoc = lsDir(uniqueEmpty, {ext});

save([saveLoc 'facesLoc'], 'facesLoc');
save([saveLoc 'scrambledLoc'], 'scrambledLoc');
save([saveLoc 'housesLoc'], 'housesLoc');
save([saveLoc 'invertedLoc'], 'invertedLoc');
save([saveLoc 'configuralLoc'], 'configuralLoc');
save([saveLoc 'emptyLoc'], 'emptyLoc');
save([saveLoc 'uniqueEmptyLoc'], 'uniqueEmptyLoc');
for n = 2:2
	patches = load([patches '/patch' int2str(n) '.mat']);
	patches = patches.patches;
	patch{1} = patches.patches{1}(:, 1:10000);
	fprintf('converting patches to xml... \n');
	patchFile = matlabPatches2OCVPatches(filters, fSize, c1Scale, c1Space, c1OL, patch, patches.sizes, 'patches', hmaxHome);
	[path, patchName, ext] = fileparts(patchFile);
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
	%	c2f = vertcat(c2f, genC2(gaborSpecs, facesLoc, c1bands, patches.patches{n}, patches.sizes(:, n)));
	%	save(['c2f' int2str(n)], 'c2f');
	%	c2f = [];
	%	c2s = vertcat(c2s, genC2(gaborSpecs, scrambledLoc, c1bands, patches.patches{n}, patches.sizes(:, n)));
	%	save(['c2s' int2str(n)], 'c2s');
	%	c2s = [];
	%	c2h = vertcat(c2h, genC2(gaborSpecs, housesLoc, c1bands, patches.patches{n}, patches.sizes(:, n)));
	%	save(['c2h' int2str(n)], 'c2h');
	%	c2h = [];
	%	c2i = vertcat(c2i, genC2(gaborSpecs, invertedLoc, c1bands, patches.patches{n}, patches.sizes(:, n)));
	%	save(['c2i' int2str(n)], 'c2i');
	%	c2i = [];
	%	c2c = vertcat(c2c, genC2(gaborSpecs, configuralLoc, c1bands, patches.patches{n}, patches.sizes(:, n)));
	%	save(['c2c' int2str(n)], 'c2c');
	%	c2c = [];
	%	c2e = vertcat(c2e, genC2(gaborSpecs, emptyLoc, c1bands, patches.patches{n}, patches.sizes(:, n)));
	%	save(['c2e' int2str(n)], 'c2e');
	%	c2e = [];
	%end
	%openCV implementation to create C2
	fprintf('creating C2 activations for test faces... \n');
	tic;
	hmaxOCV(facesLoc, patchFile, hmaxHome, maxSize);
	c2f = xmlC22matC2(facesLoc, patchName);
	save([saveLoc 'c2f' int2str(n)], 'c2f');
	hmaxOCV(scrambledLoc, patchFile, hmaxHome, maxSize);
	c2s = xmlC22matC2(scrambledLoc, patchName);
	save([saveLoc 'c2s' int2str(n)], 'c2s');
	hmaxOCV(housesLoc, patchFile, hmaxHome, maxSize);
	c2h = xmlC22matC2(housesLoc, patchName);
	save([saveLoc 'c2h' int2str(n)], 'c2h');
	hmaxOCV(invertedLoc, patchFile, hmaxHome, maxSize);
	c2i = xmlC22matC2(invertedLoc, patchName);
	save([saveLoc 'c2i' int2str(n)], 'c2i');
	hmaxOCV(configuralLoc, patchFile, hmaxHome, maxSize);
	c2c = xmlC22matC2(configuralLoc, patchName);
	save([saveLoc 'c2c' int2str(n)], 'c2c');
	hmaxOCV(uniqueEmptyLoc, patchFile, hmaxHome, maxSize);
	c2ue = xmlC22matC2(uniqueEmptyLoc, patchName);
	save([saveLoc 'c2ue' int2str(n)], 'c2ue');
	hmaxOCV(emptyLoc, patchFile, hmaxHome, maxSize);
	c2e = xmlC22matC2(emptyLoc, patchName);
	save([saveLoc 'c2e' int2str(n)], 'c2e'); 
	toc;
end
toc; 


end
