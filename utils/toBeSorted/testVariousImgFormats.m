function c2 = testVariousImgFormats
% This function will test whether feeding images formatted in different
% data types will make a difference in C2 output.

% Data types considered are: uint8, uint16, double, and single.


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


dataType = 'single_faceimages';

    locationFileToLoad = 'facesLocTraining.mat';
    saveFolder = dataType;

if ispc == 1 
    loadLoc         = 'C:\Users\levan\HMAX\testDataTypes\'
    saveLoc         = ['C:\Users\levan\HMAX\testDataTypes\' saveFolder '\']
    patchesLoc      = ('C:\Users\levan\HMAX\testDataTypes\')
    cd(loadLoc)
%     emptyImgLoc = ('C:\Users\Levan\Desktop\HMAX\naturalFaceImages\naturalFaceImages2\');
else
    loadLoc         = '/home/levan/HMAX/testDataTypes/' 
    saveLoc         = ['/home/levan/HMAX/testDataTypes/' saveFolder '/']
    patchesLoc      = ('/home/levan/HMAX/testDataTypes/')
end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

seedNum = 1234;
rng(seedNum, 'twister');
save([saveLoc 'randomseed'], 'seedNum');
diary([saveLoc 'diary.mat']);

% Load face images
load([loadLoc locationFileToLoad]);
nImgsAnalyzed = 200;
nImgsPerWorker = 10;
exampleImages = facesLoc{1};
exampleImages = exampleImages(1:nImgsAnalyzed);


%% Load Patches
    load([patchesLoc 'universal_patch_set.mat']);
    fprintf('loaded the patches\n');
%% Save parameter space.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
runDateTime = datetime('now');
outputOfPWD = pwd;
runParameterComments = 'none'; %input('Any comments about run?\n');
save([saveLoc 'runParameters.mat'],...
    'runDateTime',...
    'outputOfPWD',...
    'runParameterComments',...
    'seedNum',...
    'locationFileToLoad',...
    'saveLoc',...
    'loadLoc',...
    'patchesLoc'...
    );
%% matlab implementation to create C2    
    fprintf('creating C2 activations FOR FACES!!!... \n');
        c2f = [];
            [c2f, ~, bestBands, bestLoc, s2f] = genC2(gaborSpecs, exampleImages, c1bands, patches, patchSizes, 1, flintmax, 0, 0, nImgsPerWorker);
            save([saveLoc 'c2f'], 'c2f');
            save([saveLoc 'bestBandsC2f'], 'bestBands');
            save([saveLoc 'bestLocC2f'], 'bestLoc');
            save([saveLoc 's2f'], 's2f');
            runTime = toc
            save([saveLoc 'runTime'], 'runTime');

%% Compare with the etalon output.
etalonC2 = load([loadLoc 'etalonOutput/c2f1-10.mat']);
etalonC2 = etalonC2.c2f(:,1:nImgsAnalyzed);

if isequal(c2f,etalonC2)
    display('EQUAL')
else
    diff = etalonC2 - c2f;
    maxDiff = max(abs(diff(:)));
    plot(diff(:));
    fprintf(['Max difference is ' int2str(maxDiff) '\n']);   
end
diary off;
end
