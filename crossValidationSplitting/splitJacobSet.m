%% Simulation 4: split the faces and bgs into two sets.
clear; clc; dbstop if error;

home = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM';

facePath = fullfile(home,'HumanaeFaces5Processed','faces');
facesLoc  = lsDir(facePath,{'jpg'});

bgPath   = fullfile(home,'Backgrounds_not_used_by_florence_unique_normalized');
bgsLoc    = lsDir(bgPath,{'png'});

% Split the faces.
randomIdxs      = randperm(length(facesLoc));
trainingFaceIdx = randomIdxs(1:length(randomIdxs)/2);
trainingFaces   = facesLoc(trainingFaceIdx);

testingFaceIdx  = randomIdxs(length(randomIdxs)/2+1:end);
testingFaces    = facesLoc(testingFaceIdx);

% Split the bgs
randomIdxs    = randperm(length(bgsLoc));
trainingBgIdx = randomIdxs(1:length(randomIdxs)/2);
trainingBgs   = bgsLoc(trainingBgIdx);
 
testingBgIdx  = randomIdxs(length(randomIdxs)/2+1:end);
testingBgs    = bgsLoc(testingBgIdx);

crossValidInfo.trainingFaces = trainingFaces;
crossValidInfo.testingFaces  = testingFaces;
crossValidInfo.trainingBgs   = trainingBgs;
crossValidInfo.testingBgs    = testingBgs;
