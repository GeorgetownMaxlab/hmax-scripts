function runExperiment();
%wrapper function to run chunks of code at a time 
%will change repeatedly!!!!

targets = '/home/bentrans/Documents/lfwbBox/';
distractors = '/home/bentrans/Documents/AnimalDB/';
hmaxHome = '/home/bentrans/Documents/HMAX/feature-learning/';
patchSize = 100;
seedNum = 1234;
nImgs = 551;

[c2t, c2d] = classSpecificFIPatch(targets, distractors, hmaxHome, patchSize, seedNum, nImgs);

addpath('/home/bentrans/Documents/HMAX/feature-learning/utils/');

%topNPatch = topAUC(1, 400, '/home/bentrans/Documents/HMAX/feature-learning/HMAX-OCV/lfw2/');
%getBestPatches(topNPatch, 1);

rmpath('/home/bentrans/Documents/HMAX/feature-learning/utils/');

classSpecificPsych();

end
