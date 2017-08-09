% helper function.

%% save annulus images from Florence's .mat files
% clear; clc;
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\preBehavioral\320_trialsAnnulus\s666_session1_20160331-1318.mat','trialOutput');
% 
% saveFolder = 'C:\Users\levan\HMAX\annulusExptFixedContrast\preBehavioral\tmp\';
% 
% for iTrial = 1:length(trialOutput.trials)
%     imwrite(uint8(trialOutput.trials(iTrial).imagepated),[saveFolder 'image' int2str(iTrial) '.jpeg']);
% end
% 
% %% create image array
% 
% imgNames = lsDir('C:\Users\levan\HMAX\annulusExptFixedContrast\preBehavioral\tmp\',{'jpeg'});

%% parse the cross validation 
% clear; clc;
% datafolder = lsDir('C:\Users\levan\HMAX\annulusExptFixedContrast\preBehavioral\raw_data',{'mat'});
% faceFiles = lsDir('C:\Users\levan\HMAX\annulusExptFixedContrast\preBehavioral\Blur_Levan\CroppedFaces',{'png'});
% saveFolder = 'C:\Users\levan\HMAX\annulusExptFixedContrast\preBehavioral\images\';
% 
% for iFace = 1:length(faceFiles)
%     faceFiles{iFace} = faceFiles{iFace}(84:end);
% end
% 
% % separate face files randomly. 
% trainingIdx = randperm(57,29);
% testingIdx = setdiff(1:57,trainingIdx);
% trainingFaces = faceFiles(trainingIdx);
% testingFaces = faceFiles(testingIdx);
% 
% nameIdxTraining = 1;
% nameIdxTesting = 1;
% 
% for iData = 1:length(datafolder)
%     iData
%     load(datafolder{iData},'trialOutput');
% 
%    for iTrial = 1:length(trialOutput.trials)
%        if isempty(find(strcmp(trainingFaces,trialOutput.trials(iTrial).face))) == 0
%            imwrite(uint8(trialOutput.trials(iTrial).imagepated),[saveFolder 'trainingSet\image' int2str(nameIdxTraining) '_' trialOutput.trials(iTrial).face '.jpeg']);
%            nameIdxTraining = nameIdxTraining + 1;
%        else
%            imwrite(uint8(trialOutput.trials(iTrial).imagepated),[saveFolder 'testingSet\image' int2str(nameIdxTesting) '_' trialOutput.trials(iTrial).face '.jpeg']);
%            nameIdxTesting =  nameIdxTesting + 1;
%        end 
%    end
% end


%% editing facesLoc names
% clear; 
% f = load('C:\Users\levan\HMAX\annulusExptFixedContrast\preBehavioral\facesLocTraining.mat');
% 
% facesLoc{1} = f.facesLoc;
% 
% save facesLocTraining facesLoc

%% adapting localization code for annulus expt. 
% clear; clc; 
% saveLoc = 'C:\Users\Levan\HMAX\annulusExptFixedContrast\preBehavioral\';
% saveFolder = 'sandbox\';
%     if ~exist([saveLoc saveFolder],'dir')
%         mkdir([saveLoc saveFolder])
%     end
% 
% filesToLoad = lsDir([saveLoc 'raw_data'],{'mat'});
% % filesToLoad = filesToLoad(4:end);
% % catFace = [];
% 
% for iFile = 1:length(filesToLoad)
%     iFile
% load(filesToLoad{iFile},'trialOutput')
% numTrials = length(trialOutput.trials);
% 
%     for iTrial = 1:numTrials
% %         iTrial
% 
%         masterIdx = numTrials*(iFile-1) + iTrial;
%         faceImg{masterIdx}  = trialOutput.trials(iTrial).face;
%         position{masterIdx} = trialOutput.trials(iTrial).CoordsVisage;
%         positionAngle(masterIdx)    = trialOutput.trials(iTrial).angle;
% %         angleDeg = trialOutput.trials(iTrial).targetpolarangle;
% %         angleRad = degtorad(angleDeg);
% % 
% %         [X,Y] = pol2cart(angleRad,280);
% %         X = round(927/2 + X); %hard coded dimensions of image. Make this automatic.
% %         Y = round(730/2 - Y); %X and Y now are row and column coordinates. 
% %         position{numTrials*(iFile-1)+iTrial} = [X Y];
% %         faceImg {numTrials*(iFile-1)+iTrial} = trialOutput.trials(iTrial).face;
%         
% %         position{numTrials*(iFile-1)+iTrial} = trialOutput.Coords(iTrial).face; 
% %         %contains the position of the stimulus, in rows and columnts.
% %         faceImg {numTrials*(iFile-1)+iTrial} = trialOutput.trials(iTrial).face;
% %         % Contains the name of the face image used. 
% 
% %           positionAngle(numTrials*(iFile-1)+iTrial) = trialOutput.trials(iTrial).angle;
% 
% 
%         % Must add another one for the type of backgroun used. 
%     end
% end
% 
% save([saveLoc saveFolder 'exptDesign.mat'],'position','faceImg','positionAngle');

%% cross valid separation. Redoing...
% clear; clc;
% load('exptDesign.mat');
% uniqueFaceImgs = unique(faceImg);
% 
% % generate the indeces for training vs. testing.
% trainingIdx = randperm(40,20);
% testingIdx = setdiff(1:40,trainingIdx);
% trainingFaces = uniqueFaceImgs(trainingIdx);
% testingFaces = uniqueFaceImgs(testingIdx);
% save('exptDesign','faceImg','positionAngle','position','trainingFaces','testingFaces');
% 
% datafolder = lsDir('C:\Users\levan\HMAX\annulusExptFixedContrast\preBehavioral\raw_data',{'mat'});
% saveFolder = 'C:\Users\levan\HMAX\annulusExptFixedContrast\preBehavioral\images\';
% 
% nameIdxTraining = 1;
% nameIdxTesting = 1;
% 
% for iData = 1:length(datafolder)
%     iData
%     load(datafolder{iData},'trialOutput');
%     numTrials = length(trialOutput.trials);
%     
%    for iTrial = 1:numTrials;
%        imgIdx = numTrials*(iData-1)+iTrial;
%        sanityCheck{imgIdx} = imgIdx;
%        if isempty(find(strcmp(trainingFaces,trialOutput.trials(iTrial).face))) == 0
%            imwrite(uint8(trialOutput.trials(iTrial).imagepated),[saveFolder 'image' int2str(imgIdx) '_' trialOutput.trials(iTrial).face '.jpeg']);
%            facesLocTraining{1}{nameIdxTraining} = [saveFolder 'image' int2str(imgIdx) '_' trialOutput.trials(iTrial).face '.jpeg'];
%            nameIdxTraining = nameIdxTraining + 1;
%        else
%            imwrite(uint8(trialOutput.trials(iTrial).imagepated),[saveFolder 'image' int2str(imgIdx) '_' trialOutput.trials(iTrial).face '.jpeg']);
%            facesLocTesting{1}{nameIdxTesting}   = [saveFolder 'image' int2str(imgIdx) '_' trialOutput.trials(iTrial).face '.jpeg'];
%            nameIdxTesting =  nameIdxTesting + 1;
%        end
%    end
% end
% save facesLocTrainingWin facesLocTraining
% save facesLocTestingWin facesLocTesting


%% convert facesLoc
% clear;
% load('facesLocTrainingWin.mat');
% for i = 1:length(facesLoc{1})
%     
%      facesLoc{1}{i} = strrep(facesLoc{1}{i},'C:\Users\Levan\HMAX\annulusExptFixedContrast\preBehavioral\images\',...
%          '/home/levan/HMAX/annulusExptFixedContrast/preBehavioral/images/');
%     
% end
% facesLoc{1}{1}

% %% Test whether conversion to double or single makes difference if done many times.
% clear; clc;
% load('facesLocTestingWin.mat');
% img = imread(facesLoc{1}{1});
% doubleImg = double(img);
% singleImg = single(img);
% 
% nCon = 1000;
% 
% for iCon = 1:nCon
%    imgOut = single(img);
%    imgOut = double(img);    
% end
% 
% isequal(imgOut,img)
% 
% 
% %% now test if averaging makes a difference
% clear; clc;
% load('facesLocTestingWin.mat');
% img = imread(facesLoc{1}{1});
% doubleImg = double(img);
% singleImg = single(img);
% 
% nCon = 500
% imgOut_single = single(zeros(size(img)));
% imgOut_double = double(zeros(size(img)));
% for iCon = 1:nCon
%     iCon
%    imgOut_single = imgOut_single + singleImg;
%    imgOut_double = imgOut_double + double(img);
% end
% 
% isequal(imgOut_single,imgOut_double)

%% compress Florence's .mat files to be smaller
% 
% loadLoc = 'C:\Users\levan\Desktop\newData\s01\';
% saveLoc = 'C:\Users\levan\Desktop\newData\s01\small\';
% dataFiles = lsDir(loadLoc,{'mat'});
% 
% for i = 1:length(dataFiles)
%    load(dataFiles{i},'trialOutput');
%    save(dataFiles{i},'trialOutput');  
% end

%% test sizes of various img formats
% clear; clc;
% load('s01_session1_20160408-1835.mat');
% 
% ext = '.jpeg';
% img = uint8(trialOutput.trials(1).imagepated);
% imwrite(img,['./sandbox/img1' ext]);
% imgread = imread(['./sandbox/img1' ext]);
% 
% diff = img - imgread;
% whos
% max(diff(:))
% min(diff(:))
% imagesc(diff)

%% Debugging the localization code.
% clear; clc;
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\justTraining\original\results\patchSetAdam\lfwSingle100\sanityCheck.mat')
% 
% c2 = sanityCheck.c2_loc_rad;
% face = sanityCheck.face_loc_rad;
% 
% hits = zeros(size(c2));
% 
% criterionInRad = deg2rad(45);    
% 
% for iPatch = 1:size(c2,1)
%     for iImg = 1:length(size(c2,2))
%         if abs(angleDiff(c2(iPatch,iImg),face(iPatch,iImg))) < criterionInRad
%             display('hit');
%             hits(iPatch,iImg) = 1;
%         end
% 
%     end
% end

%% Comparing S2 matrices for original and normalized images.
% clear; clc; close;
% norm = load('C:\Users\levan\HMAX\annulusExptFixedContrast\justTraining\original\results\sandbox\s2\normalized\s2f_patches1-5allImages.mat');
% norm = norm.s2fPatchLoop;
% 
% orig = load('C:\Users\levan\HMAX\annulusExptFixedContrast\justTraining\original\results\sandbox\s2\original\s2f_patches1-5allImages.mat');
% orig = orig.s2fPatchLoop;
% 
% nImgs = 1%size(norm,2)
% count = 0;
% 
% for iImg = 1:nImgs
%    for iPatch = 1
%        for iBand = 1
%            subplot(nImgs,2,iImg+count)
%            imagesc(norm{3}{iPatch}{iBand})
%            title('Normalized')
%            subplot(nImgs,2,iImg+count+1)
%            imagesc(orig{3}{iPatch}{iBand})      
%            title('NON-normalized')   
%            count = count + 1;
%        end
%    end
% end
% iBand = 1;
% iImg = 1;
% iPatch = 1;
% 
% diff1 = orig{1}{iPatch}{iBand} - norm{1}{iPatch}{iBand};
% diff2 = orig{2}{iPatch}{iBand} - norm{2}{iPatch}{iBand};
% diff3 = orig{3}{iPatch}{iBand} - norm{3}{iPatch}{iBand};
% 
% subplot(1,3,1) 
% imagesc(diff1)
% title('Image 1 Subtraction')
% subplot(1,3,2)
% imagesc(diff2)
% title('Image 2 Subtraction')
% subplot(1,3,3)
% imagesc(diff3)
% title('Image 3 Subtraction')

%% Plot the difference between localization of contrast normalized and non-normalized images
clear; clc; close;
load('C:\Users\levan\HMAX\annulusExptFixedContrast\s10\original\trainingRuns\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat');
orig = sumStatsPatch;
origSort = sortSumStatsPatch;
load('C:\Users\levan\HMAX\annulusExptFixedContrast\s10\normalized\trainingRuns\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat')
norm = sumStatsPatch;
normSort = sortSumStatsPatch;


plot(origSort,'lineWidth',2);
hold on
plot(normSort,'lineWidth',2);
legend('NON-normalized','normalized')
xlabel('patches. Each set is INDEPENDENTLY sorted from best to worst')
ylabel('Localization')
title('Compare contrast normalized VS original images');


hold off
figure
diff = norm - orig;
hist(diff);
title('Normalized score - non-normalized score')
ylabel('Count');
mean(diff);

%% rename cropped lfw images.
clear; clc;
files = lsDir('C:\Users\levan\Desktop\lfwcrop_color\faces',{'ppm'});

parfor iImg = 1:length(files)
    
    img = imread(files{iImg});
    imwrite(img,['C:\Users\levan\Desktop\lfwcrop_color\facesPNG\image'...
                 int2str(iImg) '.png']);
end

%% grayscale the lfw images
clear; clc;
files = lsDir('C:\Users\levan\HMAX\lfwcrop_color\facesPNG\',{'png'});

for iImg = 1:length(files)
    
    img = rgb2gray(imread(files{iImg}));
    imwrite(img,['C:\Users\levan\HMAX\lfwcrop_color\facesPNG_grayed\image'...
                 int2str(iImg) '.png']);
end
    




