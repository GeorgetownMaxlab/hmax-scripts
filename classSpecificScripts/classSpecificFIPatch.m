function [c2t, c2d] = classSpecificFIPatch(targets, distractors, hmaxHome, patchSize, seedNum, nImgs, gaborSpecs, c1Space, c1Scale)
%creates and saves c1, patches, c2, FI, and plots FI using functions and preexisting code by Josh Rule
%
%targets = file location of faces
%distractors = file location of distractor images
%hmaxHome = home directory of hmax code 
%patchSize = maxSize of patches 
%seedNum = random seed number; important for replication
%nImgs = number of images you want to train and test with
%
tic;

if(nargin < 9) %initialize c1Scale
	c1Scale = 1:2:18; 
end

if(nargin < 8) %initialize c1Space
	c1Space = 8:2:22; 
end

%taken from runExperiments.m
if(nargin < 7) %gaborSpecs: info for creating Gabor filters
	gaborSpecs.orientations = [90 -45 0 45]; %filter orientations
	gaborSpecs.receptiveFieldSizes = 7:2:39; %how big the filters are
	gaborSpecs.div = 4:-.05:3.2; %frequency tuning of sinusoids
end

if(nargin < 6)
	nImgs = 100;
end

if(mod(nImgs, 2) == 1) %if there are an odd number of imgs, make it even
	nImgs = nImgs - 1;
end

rng(seedNum, 'twister');
saveLoc = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-OCV/lfw3/';

%opens up the folder specified and saves location of JPEGs for target faces and distractors
%targets = lsDir(targets, {'JPEG'}); %remember to change the extension
%targetLoc = targets;
%targets = {};
%contents = dir(targetLoc);
%for iContents = 1:length(contents)
%	if(contents(iContents).isdir == 1)
%		targets = horzcat(targets, (lsDir([targetLoc contents(iContents).name '/'], {'jpg'})));
%	end
%end
distractors = lsDir(distractors, {'jpg'}); %remember to change the extension
%shuffles the distractors
distractors = distractors(randperm(numel(distractors)));
%takes nImgs distractors by taking the first nImgs of the shuffled list and saves their location
dLoc = distractors; 
save([saveLoc 'dLoc'], 'dLoc');

%save random seed, list of targets, and list of distractors
save([saveLoc 'randomseed'], 'seedNum');
%save([saveLoc 'targets'], 'targets');
%save([saveLoc 'distractors'], 'distractors');

%split into training images and saves location
fprintf('splitting... \n');
%[training, testing] = splitIntoTrainingTesting(targets, nImgs);
%trainingLoc = training;
%testingLoc = testing(1:500);
%=================================================================================================
trainingLoc = lsDir(targets, {'jpg'});
training = trainingLoc;
load('/home/bentrans/Documents/HMAX/feature-learning/HMAX-OCV/lfw2/testingLoc.mat');
%=================================================================================================
%save([saveLoc 'trainingLoc'], 'trainingLoc');
%save([saveLoc 'testingLoc'], 'testingLoc');
%load([saveLoc 'dLoc.mat']);
%load([saveLoc 'testingLoc.mat']);
%grayscale all the images, commented code saves the grayscaled images to a new directory
fprintf('grayscaling... \n');
newTraining = {}; 
for iImg = 1:nImgs
	trainingImg = training{iImg};
	trainingImg = double(grayImage(imread(training{iImg})));
	trainingImg = double(grayImage(uint8(resizeImage(double(imread(training{iImg})), patchSize))));
	newTraining{iImg} = trainingImg;
end
training = newTraining;

%create c1
[fSize, filters, c1OL, numSimpleFilters] = init_gabor(gaborSpecs.orientations, gaborSpecs.receptiveFieldSizes, gaborSpecs.div);
fprintf('creating c1... \n');
c1r = {};
s1r = {};
%for iImg = 1:numel(training)
%	fprintf('%d \n', iImg);
%	img = training{iImg};
%	[c1, s1] = C1(img, filters, fSize, c1Space, c1Scale, c1OL);
%	c1r{iImg} = c1;
%	s1r{iImg} = s1;
%end
%save([saveLoc 'c1'], 'c1r');
%save('s1', 's1r'); %not working due to some matlab version error, not important anyways
c1r = load([saveLoc 'c1.mat']);
c1r = c1r.c1r;

for n = 1:2
%extract patches
	fprintf('extracting patches... \n');
	patches = extractedPatches(c1r, [n * 2; n * 2; 4; 10000]); %check extractedPatches and add more args if needed
	save([saveLoc 'patch' int2str(n)], 'patches'); 
%	patches = load([saveLoc 'patch' int2str(n)]);
%	patches = patches.patches;	

%START SECOND STAGE
	fprintf('converting patches to xml... \n');
	patchFile = matlabPatches2OCVPatches(filters, fSize, c1Scale, c1Space, c1OL, patches.patches, patches.sizes, 'patches', hmaxHome);
	[path, patchName, ext] = fileparts(patchFile);
	maxSize = patchSize; %maxSize x maxSize image

%matlab implementation to create C2
%	c1bands.c1Space = c1Space;
%	c1bands.c1Scale = c1Scale;
%	c2t = genC2(gaborSpecs, testingLoc, c1bands, patches.patches, patch.patches.sizes);
%	save('c2tTESTOLD', 'c2t');
%	c2d = genC2(gaborSpecs, dLoc, c1bands, patches.patches, patch.patches.sizes);
%	save('c2dTESTOLD', 'c2d');
%	fprintf('old done...');
%	c2t = genC2(gaborSpecs, testingLoc, c1bands, patches.patches, patch.patches.sizes, 1, patchSize);
%	save('c2tTEST', 'c2t');
%	c2d = genC2(gaborSpecs, dLoc, c1bands, patches.patches, patch.patches.sizes, 1, patchSize);
%	save('c2dTEST', 'c2d');
%	len = length(patches.patches{1}) / 10;
%	for i = 1:10
%		patch{1} = patches.patches{1}(:,(1 + len * (i - 1)):(len * i));
%		fprintf('creating C2 activations for test faces... \n');
%		c2t = genC2(gaborSpecs, testingLoc, c1bands, patch, patches.sizes);
%		save(['c2t' int2str(n) 'part' int2str(i)], 'c2t');
%		fprintf('creating C2 activations for distractors... \n');
%		c2d = genC2(gaborSpecs, dLoc, c1bands, patch, patches.sizes);
%		save(['c2d' int2str(n) 'part' int2str(i)], 'c2d');
%	end

%openCV implementation to create C2
	fprintf('creating C2 activations for test faces... \n');
	hmaxOCV(testingLoc, patchFile, hmaxHome, maxSize, 32);
	fprintf('converting test faces... \n');
	c2t = xmlC22matC2(testingLoc, patchName);
	save([saveLoc 'c2t' int2str(n)], 'c2t');
	c2t = [];
%	fprintf('creating C2 activations for distractors... \n');
%	hmaxOCV(dLoc, patchFile, hmaxHome, maxSize, 32);
%	fprintf('converting distractors... \n');
%	c2d = xmlC22matC2(dLoc, patchName);
%	save([saveLoc 'c2d' int2str(n)], 'c2d');
%	c2d = [];
end

toc; 


end

function [training, testing] = splitIntoTrainingTesting(targets, nTargets)

%shuffle targets and distractors (unnecessary)
targets = targets(randperm(numel(targets)));

training = targets(1:nTargets);
testing = targets(nTargets + 1:numel(targets));
%testing = targets(1:500);
%training = targets(500:numel(targets));

%shuffle to make training and testing more random (can be unnecessary)
training = training(randperm(nTargets));
testing = testing(randperm(numel(testing)));

end
