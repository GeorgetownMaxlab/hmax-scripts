% %% extracting images from annulus expt data
% 
% clear; clc; close;
% 
% saveLoc = 'C:\Users\Levan\HMAX\annulusExpt\';
% saveFolder = 'images2\';
%     if ~exist([saveLoc saveFolder],'dir')
%         mkdir([saveLoc saveFolder])
%     end
% 
% filesToLoad = lsDir([saveLoc 'raw_data'],{'mat'});
% 
% for iFile = 1:length(filesToLoad)
%     
% load(filesToLoad{iFile},'trialOutput','stimulus')
% 
%     for iTrial = 1:length(trialOutput.trials)
%         iTrial
%         imwrite(uint8(trialOutput.trials(iTrial).imagepated),...
%             [saveLoc saveFolder filesToLoad{iFile}(end-28:end-18) '_image'...
%             int2str(iTrial) '.jpeg'], 'jpeg');
%     end
% 
% end

%% Generate the list of images.

% facesLoc{1} = lsDir([saveLoc saveFolder],{'BMP'});
% save([saveLoc 'facesLocWin.mat'],'facesLoc');

% %% Get the file with best patch indices.
% clear; clc;
% load('C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\patchSet2\lfw50Doubles100HardPatches\customCombMatrix.mat')
% load('C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\patchSet2\lfw50Doubles100HardPatches\imageDifficultyData_5000_Patches.mat',...
%     'IndPatch')
% 
% bestCombinations = customCombMatrix(IndPatch,:);
% IndPatch = unique(bestCombinations);
% save('C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\patchSet2\lfw50Doubles100HardPatches\bestCombinations.mat','bestCombinations','IndPatch');

%% adapting localization code for annulus expt. 
% 
% clear; clc; close;
% 
% saveLoc = 'C:\Users\Levan\HMAX\annulusExpt\';
% saveFolder = 'patchSet2\';
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
% load(filesToLoad{iFile},'trialOutput','stimulus')
% numTrials = length(trialOutput.trials);
% 
%     for iTrial = 1:numTrials
% %         iTrial
% 
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
%           positionAngle(numTrials*(iFile-1)+iTrial) = trialOutput.trials(iTrial).angle;
% 
% 
%         % Must add another one for the type of backgroun used. 
%     end
% end

% save([saveLoc saveFolder 'exptDesign.mat'],'position','faceImg');
% save([saveLoc saveFolder 'exptDesign.mat'],'position','faceImg');

% 
% %% Plot some heatmaps.
% % clear; clc; close;
% % load('C:\Users\Levan\HMAX\annulusExpt\patchSet2\sandbox\s2f1.mat')
% % load('C:\Users\Levan\HMAX\annulusExpt\patchSet2\sandbox\facesLoc.mat')
% % load('C:\Users\Levan\HMAX\annulusExpt\patchSet2\sandbox\bestBandsC2f1.mat')
% % 
% % p = 1;
% % img = 5;
% % 
% % subplot(1,2,1)
% %     subimage(imread(facesLoc{1}{img}))
% % subplot(1,2,2)
% %     imagesc(s2f{img}{p}{bestBands{1}(p,img)})
% % 
% % %% 
% % i = 1;
% % for iFile = 1:length(filesToLoad)
% %     for iTrial = 1:length(trialOutput.trials)
% % 
% % V(i) = 64*(iFile-1)+iTrial
% % i = i + 1;
% %     end
% % end
% 
% 
% %% Testing subfunction of the annulusLocalization script. 
% clear; clc;
% i = 1
% for sub = 1:3
%     for ses = 1:5
%         for img = 1:64
%             V(i) = 64*(5*(sub-1)+ses-1)+img
%             i = i + 1;
%         end
%     end
% end

%% redesign custom combination matrix for combining annulus experimental data
% clear; clc;
% load('C:\Users\Levan\HMAX\annulusExpt\patchSet2\bestCombinations.mat')
% 
% MAT = bestCombinations;
% 
% for i = 1:length(MAT(:))
%     idx = find(IndPatch == MAT(i))
%     MAT(i) = idx;
% end
% 
% customCombMatrix = MAT;
% save('C:\Users\Levan\HMAX\annulusExpt\patchSet2\lfwSingle146\customCombInfo.mat',...
%     'bestCombinations','IndPatch','customCombMatrix');
% 
% 

%% testing different formats of images
% clear; clc;
% imgName1 = 'imageJPG.jpg'
% imgName2 = 'imageJPGtoBMP_imwrite.BMP'
% img1 = double(grayImage(uint8(double(imread(imgName1)))));
% img2 = double(grayImage(uint8(double(imread(imgName2)))));
% 
% isequal(img1,img2)
% 
%% Concatinate three training set runs
% clear; clc;
% load('imgHitsMapf_1-160.mat')
% 
% imgHitsMaster = imgHits;
% load('imgHitsMapf_161-320.mat')
% imgHitsMaster = [imgHitsMaster imgHits];
% load('imgHitsMapf_321-480.mat')
% imgHitsMaster = [imgHitsMaster imgHits];
% 
% imgHits = imgHitsMaster;
% save('imgHitsMapf','imgHits');
% 
% %% sanity check
% clear; clc;
% load('sanityCheck1-160.mat')
% 
% sanityCheckMaster = sanityCheck;
% load('sanityCheck161-320.mat')
% sanityCheckMaster = [sanityCheckMaster sanityCheck];
% load('sanityCheck321-480.mat')
% sanityCheckMaster = [sanityCheckMaster sanityCheck];
% 
% sanityCheck = sanityCheckMaster;
% % save('sanityCheck','sanityCheck');
% 

%% Compare wedge localization to face-box localization
% clear; clc;
% load('imgHitsFaceBox.mat')
% load('imgHitsWedge.mat')
% load('bestBandsC2f.mat')
% 
% count = 0;
% 
% for iPatch = 1:size(imgHitsWedge,1)
%     for iImg = 1:size(imgHitsWedge,2) 
%         if imgHitsFaceBox(iPatch,iImg) == 1 && imgHitsWedge(iPatch,iImg) ~= 1
%             fprintf('ERROR\n')
%             iPatch
%             iImg
%             count = count + 1;
% %             BAND(count) = bestBands(iPatch,iImg);
%         end
%     end
%     
% end
% count
% %% Concatinate imgHits wedge patchSet2
% clear; clc;
% load('imgHitsWedge1-100.mat')
% imgHitsMaster = imgHitsWedge;
% load('imgHitsWedge101-200.mat')
% imgHitsMaster = [imgHitsMaster imgHitsWedge];
% load('imgHitsWedge201-300.mat')
% imgHitsMaster = [imgHitsMaster imgHitsWedge];
% load('imgHitsWedge301-400.mat')
% imgHitsMaster = [imgHitsMaster imgHitsWedge];
% load('imgHitsWedge401-480.mat')
% imgHitsMaster = [imgHitsMaster imgHitsWedge];
% 
% imgHitsWedge = imgHitsMaster;
% save('imgHitsWedge','imgHitsWedge');
% 
% %% %% Concatinate imgHits face box patchSet2
% clear; clc;
% load('imgHitsFaceBox1-100.mat')
% imgHitsMaster = imgHitsFaceBox;
% load('imgHitsFaceBox101-200.mat')
% imgHitsMaster = [imgHitsMaster imgHitsFaceBox];
% load('imgHitsFaceBox201-300.mat')
% imgHitsMaster = [imgHitsMaster imgHitsFaceBox];
% load('imgHitsFaceBox301-400.mat')
% imgHitsMaster = [imgHitsMaster imgHitsFaceBox];
% load('imgHitsFaceBox401-480.mat')
% imgHitsMaster = [imgHitsMaster imgHitsFaceBox];
% 
% imgHitsFaceBox = imgHitsMaster;
% save('imgHitsFaceBox','imgHitsFaceBox');
% 
% %% Concatinate imgHits wedge patchSet4
% clear; clc;
% load('imgHitsWedge1-160.mat')
% imgHitsMaster = imgHitsWedge;
% load('imgHitsWedge161-320.mat')
% imgHitsMaster = [imgHitsMaster imgHitsWedge];
% load('imgHitsWedge321-480.mat')
% imgHitsMaster = [imgHitsMaster imgHitsWedge];
% 
% imgHitsWedge = imgHitsMaster;
% save('imgHitsWedge','imgHitsWedge');
% 
% %% Concatinate imgHits face box patchSet4
% clear; clc;
% load('imgHitsFaceBox1-160.mat')
% imgHitsMaster = imgHitsFaceBox;
% load('imgHitsFaceBox161-320.mat')
% imgHitsMaster = [imgHitsMaster imgHitsFaceBox];
% load('imgHitsFaceBox321-480.mat')
% imgHitsMaster = [imgHitsMaster imgHitsFaceBox];
% 
% imgHitsFaceBox = imgHitsMaster;
% save('imgHitsFaceBox','imgHitsFaceBox');
% 
% clear; clc;
% load('imgHitsWedge1-160.mat')
% imgHitsMaster = imgHitsWedge;
% load('imgHitsWedge161-320.mat')
% imgHitsMaster = [imgHitsMaster imgHitsWedge];
% load('imgHitsWedge321-480.mat')
% imgHitsMaster = [imgHitsMaster imgHitsWedge];
% 
% imgHitsWedge = imgHitsMaster;
% save('imgHitsWedge','imgHitsWedge');


% 
% %% Concat best bands
% clear; clc;
% bestBands = horzcat(bestBands{:});
% bestBandsMaster = bestBands;
% bestBandsMaster = [bestBandsMaster bestBands];
% bestBands = bestBandsMaster;
% 
% %% concatinate all data.
% facesLocMaster{1} = facesLoc{1};
% facesLocMaster{1} = [facesLocMaster{1} facesLoc{1}];
% facesLoc{1} = facesLocMaster{1};



%% Gen hard image localization data for annulus experiment
% load('C:\Users\Levan\HMAX\annulusExpt\testingSetRuns\patchSet2\lfwDouble100\imageDifficultyData_100_Patches.mat')




%% Custom combination clutter code
% clear; clc;
% 
% loadFolder = 'patchSet3\lfwDouble100'
% saveFolder = 'patchSet3\lfwCustomTriple100'
% nHardImgs = 40
% 
% % Load indices of hard images (hard for the doublets).
% load(['C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\'...
%     loadFolder '\complementaryPatches\' num2str(nHardImgs) '_hardImagesLocalizationData.mat'],...
%     'IndHardImgPatches')
% 
% % Load the combination matrix of doublets, as well as indices of the best
% % doublets.
% load(['C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\'...
%     loadFolder '\combinationParameterSpace.mat'],...
%     'combinationMatrix')
% load(['C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\'...
%     loadFolder '\imageDifficultyData_4950_Patches.mat'],...
%     'IndPatch')
% bestDoubletIdx = IndPatch;
% clearvars IndPatch;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nTopDoublets = 50;
% nHardPatches = 50;
% IndHardImgPatches = IndHardImgPatches(1:nHardPatches);
% IndHardImgPatches = IndHardImgPatches';
% HARD = repmat(IndHardImgPatches,nTopDoublets,1);
% 
% bestDoubletIdx = bestDoubletIdx(1:nTopDoublets);
% MAT = combinationMatrix(bestDoubletIdx,:);
% % MAT = MAT(1:nTopPatches,:);
% MAT = kron(MAT,ones(nHardPatches,1));
% 
% customCombMatrix = [MAT HARD];
% 
% save(['C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\' saveFolder ...
%     '\' num2str(nHardImgs) '_Hard_Images_customCombMatrix.mat'],'customCombMatrix');