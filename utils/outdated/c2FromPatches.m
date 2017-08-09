function c2 = c2FromPatches(maxSize)
%OUT OF USE; MOST LIKELY NOT USABLE
%make sure that this function is in the same folder you ran classSpecificFI.m
%on my account, dLoc (distractor location) is located at:
%'/home/bentrans/Documents/distractors/'
%I forgot to save dLoc on classSpecificFI.m (I made that change) so you'll have to manually get it
gaborSpecs.orientations = [90 -45 0 45];
gaborSpecs.receptiveFieldSizes = 7:2:39;
gaborSpecs.div = 4:-.05:3.2;
[fSize, filters, c1OL,  numSimpleFilters] = init_gabor(gaborSpecs.orientations, gaborSpecs.receptiveFieldSizes, gaborSpecs.div);

c1bands.c1Scale = 1:2:18;
c1bands.c1Space = 8:2:22;

testingLoc = load('testingLoc.mat');
dLoc = load('dLoc.mat');
patches = load('patch.mat');

%------------------------------------MATLAB--------------------------------------------------
%c2t = genC2(gaborSpecs, testingLoc, c1bands, patches.patches, patches.sizes);
%c2d = genC2(gaborSpecs, dLoc, c1bands, patches.patches, patches.sizes);
%save('c2t', 'c2t');
%save('c2d', 'c2d');

%--------------------------------------OCV-----------------------------------------------
patchFile = matlabPatches2OCVPatches(filters, fSize, c1bands.c1Scale, c1bands.c1Space, c1OL, patches.patches.patches, patches.patches.sizes, 'patches', '/home/bentrans/Documents/Josh/Josh/feature-learning/');
[path, patchName, ext] = fileparts(patchFile);
hmaxHome = '/home/bentrans/Documents/Josh/Josh/feature-learning/';
fprintf('creating C2 activations for test faces... \n');
hmaxOCV(testingLoc.testingLoc, patchFile, hmaxHome, maxSize);
fprintf('converting test faces... \n');
c2t = xmlC22matC2(testingLoc.testingLoc, patchName);
save('c2t', 'c2t');
fprintf('creating C2 activations for distractors... \n');
hmaxOCV(dLoc.dLoc, patchFile, hmaxHome, maxSize);
fprintf('converting distractors... \n');
c2d = xmlC22matC2(dLoc.dLoc, patchName);
save('c2d', 'c2d');

%code to get FI
%distractors = load('c2d.mat');
%targets = load('c2t.mat');
%plotFI(targets.c2t, distractors.c2d)
end 

