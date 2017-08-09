% helper function.
clear; clc; close all;

reduceFileSize   = 0;
createExptDesign = 0;
testCoordsMatch  = 0;
extractImages    = 1;

%% compress Florence's .mat files to be smaller
% clear; clc;
% % loadLoc = '/home/scholl/levan/originalData/';
% % loadLoc = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_2nd_cohort/raw_data';
% loadLoc = 'C:\Users\levan\Desktop/CRCNS_Raw_Data_Files/';
% dataFiles = sort_nat(lsDir(loadLoc,{'mat'}));
% 
% for i = 1:length(dataFiles)
%     i
%    load(dataFiles{i},'trialOutput');
%    save(dataFiles{i},'trialOutput');
% end

%% Creating the exptDesign variable with all the info. 
if createExptDesign
    saveLoc = 'C:\Users\Levan\HMAX\annulusExptFixedContrast\simulation3\';
    saveFolder = 'part2upinv';
    separateOrient = 1
    if ~exist(fullfile(saveLoc,saveFolder),'dir')
        mkdir(fullfile(saveLoc,saveFolder))
    end
    
    filesToLoad = sort_nat(lsDir(fullfile(saveLoc,saveFolder,'raw_data'),{'mat'})');
    masterIdx   = 1;
    
    if ~separateOrient % If its not the up/inv set, so all images have same orientation
        
        for iFile = 1:length(filesToLoad)
            iFile
            load(filesToLoad{iFile})
            numTrials = length(trialOutput.trials);
            sanity(iFile) = numTrials;
            
            for iTrial = 1:numTrials
                exptDesign(masterIdx).faceImg       = trialOutput.trials(iTrial).faceequalized;
                exptDesign(masterIdx).faceName      = str2double(trialOutput.trials(iTrial).face(1:end-4));
                exptDesign(masterIdx).bgName        = trialOutput.trials(iTrial).bgname;
                exptDesign(masterIdx).position      = trialOutput.trials(iTrial).CoordsVisage;
                exptDesign(masterIdx).positionAngle = trialOutput.trials(iTrial).angle;
                exptDesign(masterIdx).mask          = trialOutput.trials(iTrial).NameMaskVisage;
                exptDesign(masterIdx).quadrant      = trialOutput.trials(iTrial).Cadran;
                exptDesign(masterIdx).imageDim      = size(trialOutput.trials(iTrial).imagepated);
                exptDesign(masterIdx).faceOrient    = trialOutput.trials(iTrial).faceorinv;
                masterIdx = masterIdx + 1;
            end
        end
    else % THIS HAS NOT BEEN DOUBLE CHECKED ON THE DATASET YET.
        originalIdxCounter = 1;
        for iFile = 1:length(filesToLoad)
            iFile
            load(filesToLoad{iFile})
            numTrials     = length(trialOutput.trials);
            sanity(iFile) = numTrials;
            
            for iTrial = 1:numTrials
                if trialOutput.trials(iTrial).faceorinv == 1 % 1 is upright, 2 is inverted.
                    exptDesign(masterIdx).faceImg       = trialOutput.trials(iTrial).faceequalized;
                    exptDesign(masterIdx).faceName      = str2double(trialOutput.trials(iTrial).face(1:end-4));
                    exptDesign(masterIdx).bgName        = trialOutput.trials(iTrial).bgname;
                    exptDesign(masterIdx).position      = trialOutput.trials(iTrial).CoordsVisage;
                    exptDesign(masterIdx).positionAngle = trialOutput.trials(iTrial).angle;
                    exptDesign(masterIdx).mask          = trialOutput.trials(iTrial).NameMaskVisage;
                    exptDesign(masterIdx).quadrant      = trialOutput.trials(iTrial).Cadran;
                    exptDesign(masterIdx).imageDim      = size(trialOutput.trials(iTrial).imagepated);
                    exptDesign(masterIdx).faceOrient    = trialOutput.trials(iTrial).faceorinv;
                    exptDesign(masterIdx).originalIdxCounter = originalIdxCounter;                    
                    masterIdx = masterIdx + 1;
                end
                originalIdxCounter = originalIdxCounter + 1;
            end
        end
        
    end
    save(fullfile(saveLoc,saveFolder,'upright','exptDesign.mat'),'exptDesign')
end
%% test that coordinates match with angle
if testCoordsMatch
    dbstop if error
    condition = 'part2upinv';
    
    home = fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3',condition);
    
    load(fullfile(home,'upright','exptDesign.mat'));
    
    for i = 1:size(exptDesign,2)
        [angle_rad{i}, RHO] = cart2pol(exptDesign(i).position(2)-(exptDesign(i).imageDim(2)/2),...
            (exptDesign(i).imageDim(1)/2)-exptDesign(i).position(1));
        angle_deg{i} = radtodeg(angle_rad{i});
        
        if angle_deg{i} < 0
            angle_deg{i} = 360 + angle_deg{i};
        end
        
        [X{i}, Y{i}] = pol2cart(angle_rad{i},RHO);
        location{i} = ceil([X{i} Y{i}]);
        
        diff(i) = angle_deg{i} - exptDesign(i).positionAngle;
    end
    
    plot(diff) 
    % sometimes angle_deg is 0 (or 360) while positionAngle is 360 (or 0), which shows up as large difference. 
    % But in the localization code the distance is calculated in radians so that doesn't matter.
end
%% getting all images, w/o cross validation separation
if extractImages
    separateOrient = 1;
    if separateOrient
        % THE CODE FOR separateOrient HAS NOT BEEN DOUBLE CHECKED
        home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\';
        condition = 'part2upinv';
        sub_condition = 'upright';
        
        dataFiles = sort_nat(lsDir(fullfile(home,condition,'raw_data'),{'mat'}));
        saveFolder = fullfile(home,condition,sub_condition,'images');
        
        if ~exist(saveFolder)
            mkdir(saveFolder)
        end
        
        imgIdx  = 1;
        exptIdx = 1;
        for iData = 1:length(dataFiles)
            iData
            load(dataFiles{iData});
            numTrials = length(trialOutput.trials);
            
            for iTrial = 1:numTrials
                if trialOutput.trials(iTrial).faceorinv == 1
                    %        imgIdx = numTrials*(iData-1)+iTrial;
                    %        sanityCheck{imgIdx} = imgIdx;
                    imgName = ['imageIdx'  int2str(imgIdx) ...
                               '_exptIdx' int2str(exptIdx) ...
                               '_faceName' trialOutput.trials(iTrial).face(1:end-4) ...
                               '_bgName'   int2str(trialOutput.trials(iTrial).bgname) ...
                               '.png'];
                    
                    imwrite(uint8(trialOutput.trials(iTrial).imagepated),fullfile(saveFolder,imgName));
                    
                    facesLoc{1}{imgIdx} = fullfile(saveFolder,imgName);
                    
                    sanity(imgIdx)       = imgIdx;
                    imgIdx               = imgIdx + 1;
                    sanityCheck(exptIdx) = exptIdx;
                end
                exptIdx = exptIdx + 1;
            end
        end
        save(fullfile(home,condition,sub_condition,'facesLoc.mat'), 'facesLoc');
        
    elseif ~separateOrient
        
        home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\';
        condition = 'part1upright';
        
        dataFiles = sort_nat(lsDir(fullfile(home,condition,'raw_data'),{'mat'}));
        saveFolder = fullfile(home,condition,'images');
        
        if ~exist(saveFolder)
            mkdir(saveFolder)
        end
        
        imgIdx  = 1;
        for iData = 1:length(dataFiles)
            iData
            load(dataFiles{iData});
            numTrials = length(trialOutput.trials);
            
            for iTrial = 1:numTrials
                %        imgIdx = numTrials*(iData-1)+iTrial;
                %        sanityCheck{imgIdx} = imgIdx;
                imgName = ['imageIdx'  int2str(imgIdx) ...
                           '_faceName' trialOutput.trials(iTrial).face(1:end-4) ...
                           '_bgName'   int2str(trialOutput.trials(iTrial).bgname) ...
                           '.png'];
                
%                 imwrite(uint8(trialOutput.trials(iTrial).imagepated),fullfile(saveFolder,imgName));
                
                facesLoc{1}{imgIdx,1} = fullfile(saveFolder,imgName);
                
                sanity(imgIdx) = imgIdx;
                imgIdx = imgIdx + 1;
            end % iTrial
            
        end % iData
        
        save(fullfile(home,condition,'facesLoc.mat'), 'facesLoc');

    end % if separateOrient
    
end % if extractImages

% %% EEG EXPERIMENT: get all faces, at 7 degrees, and on the right side.
% clear; clc;
% % load('exptDesign.mat');
% load('C:\Users\levan\HMAX\eeg_up_inv\face_orientation.mat')
% condition = 'eeg_up_inv';
%
% dataFiles = sort_nat(lsDir(['C:\Users\levan\HMAX\'...
%     condition '\raw_data'],{'mat'}));
% saveFolder = ['C:\Users\levan\HMAX\'...
%     condition '\images\'];
% 
% if ~exist(saveFolder)
%     mkdir(saveFolder)
% end
% 
% toKeep = [1,2,5,6];
% toExcl = setdiff(1:35,toKeep);
% 
% masterSet = [];
% 
% for iData = 1:length(dataFiles)
%     iData
%     load(dataFiles{iData},'trialOutput');
%     numTrials = length(trialOutput.trials);
%     
%     temp = squeeze(struct2cell(trialOutput.trials));
%     temp(toExcl,:) = [];
%     
%     masterSet = horzcat(masterSet,temp);
%     
%     
%     
% end
% 
% %%
% 
% %% EEG EXPERIMENT IMAGES: get all the images without differentiating
% clear; clc;
% % load('exptDesign.mat');
% condition = 'eeg_up_inv';
% 
% dataFiles = sort_nat(lsDir(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\'...
%     condition '\raw_data'],{'mat'}));
% saveFolder = ['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\'...
%     condition '\deg1\images\'];
% 
% if ~exist(saveFolder)
%     mkdir(saveFolder)
% end
% 
% imgIdx  = 1;
% exptIdx = 1;
% for iData = 1:length(dataFiles)
%     iData
%     load(dataFiles{iData});
%     numTrials = length(trialOutput.trials);
%     
%    for iTrial = 1:numTrials
%        if trialOutput.trials(iTrial).targeteccentricity == 1
% %        imgIdx = numTrials*(iData-1)+iTrial;
% %        sanityCheck{imgIdx} = imgIdx;
%            imwrite(uint8(trialOutput.trials(iTrial).imagepated),...
%                [saveFolder 'imageIdx' int2str(imgIdx) ...
%                '_exptIdx' int2str(exptIdx) ...
%                '_faceName_' trialOutput.trials(iTrial).face '.png']);
%    
%            facesLoc{1}{imgIdx} = ...
%                ([saveFolder 'imageIdx' int2str(imgIdx) ...
%                '_exptIdx' int2str(exptIdx) ...
%                '_faceName_' trialOutput.trials(iTrial).face '.png']);  
%            sanity(imgIdx) = imgIdx;
%            imgIdx = imgIdx + 1;
%            sanityCheck(exptIdx) = exptIdx;
%        end
%        exptIdx = exptIdx + 1;
%    end
% end
% % save([saveFolder 'facesLoc.mat'], 'facesLoc');
% 
% %% save the faces themselves from the exptdesign file
% clear; clc; close;
% load('exptDesign.mat')
% condition = 'part2Inverted_2nd_cohort/inverted';
% 
% [uniqueFaces, Idx, ~] = unique(faceName);
% 
% saveFolder = ['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\'...
%     condition '\face_images\'];
% 
% if ~exist(saveFolder)
%     mkdir(saveFolder)
% end
% 
% for iFace = 1:length(Idx)
%     faceChosen = Idx(iFace);
%    imwrite(faceImg{faceChosen},...
%    [saveFolder faceName{faceChosen}(1:end-4) '.png']); 
% end

%% Creating the exptDesign variable with all the info. 
% clear; clc; 
% saveLoc = 'C:\Users\Levan\HMAX\annulusExptFixedContrast\simulation2\';
% saveFolder = 'set1/';
%     if ~exist(fullfile(saveLoc,saveFolder),'dir')
%         mkdir(fullfile(saveLoc,saveFolder))
%     end
% 
% filesToLoad = sort_nat(lsDir(fullfile(saveLoc,saveFolder,'raw_data'),{'mat'})');
% masterIdx   = 1;
% originalIdxCounter = 1;
% 
% for iFile = 1:length(filesToLoad)
%     iFile
% load(filesToLoad{iFile})
% numTrials = length(trialOutput.trials);
% sanity(iFile) = numTrials;
% 
%     for iTrial = 1:numTrials
%             iTrial
%     %         masterIdx = numTrials*(iFile-1) + iTrial;
%             faceImg{masterIdx}       = trialOutput.trials(iTrial).faceequalized;
%             faceName{masterIdx}      = trialOutput.trials(iTrial).face;
%             bgName{masterIdx}        = trialOutput.trials(iTrial).bgname;
%             position{masterIdx}      = trialOutput.trials(iTrial).CoordsVisage;
%             positionAngle(masterIdx) = trialOutput.trials(iTrial).angle;
%     %         vignette{masterIdx}      = trialOutput.trials(iTrial).vignette;
%             mask{masterIdx}          = trialOutput.trials(iTrial).NameMaskVisage;
%             quadrant(masterIdx)      = trialOutput.trials(iTrial).Cadran;
%             imageDim{masterIdx}      = size(trialOutput.trials(iTrial).imagepated);
%             faceOrient(masterIdx)    = trialOutput.trials(iTrial).faceorinv;
%             originalIdx(masterIdx)   = originalIdxCounter;
%     %         sanity(masterIdx) = masterIdx;
%             masterIdx = masterIdx + 1;
%         originalIdxCounter = originalIdxCounter + 1;
%     end
% end
% 
% save(fullfile(saveLoc,saveFolder,'exptDesign.mat'),'faceImg','faceName','bgName','position',...
%     'positionAngle','mask','quadrant','imageDim', 'faceOrient')%, 'originalIdx');


%% Creating the exptDesign variable with upright/inverted separation
% clear; clc; 
% saveLoc = 'C:\Users\Levan\HMAX\annulusExptFixedContrast\simulation2\';
% saveFolder = 'set1/';
%     if ~exist(fullfile(saveLoc,saveFolder),'dir')
%         mkdir(fullfile(saveLoc,saveFolder))
%     end
% 
% filesToLoad = sort_nat(lsDir(fullfile(saveLoc,saveFolder,'raw_data'),{'mat'})');
% masterIdx   = 1;
% originalIdxCounter = 1;
% 
% for iFile = 1:length(filesToLoad)
%     iFile
% load(filesToLoad{iFile})
% numTrials = length(trialOutput.trials);
% sanity(iFile) = numTrials;
% 
%     for iTrial = 1:numTrials
% 
%         if trialOutput.trials(iTrial).faceorinv == 1 % 1 is upright, 2 is inverted.
%     %         iTrial
%     %         masterIdx = numTrials*(iFile-1) + iTrial;
%             faceImg{masterIdx}       = trialOutput.trials(iTrial).faceequalized;
%             faceName{masterIdx}      = trialOutput.trials(iTrial).face;
%             bgName{masterIdx}        = trialOutput.trials(iTrial).bgname;
%             position{masterIdx}      = trialOutput.trials(iTrial).CoordsVisage;
%             positionAngle(masterIdx) = trialOutput.trials(iTrial).angle;
%     %         vignette{masterIdx}      = trialOutput.trials(iTrial).vignette;
%             mask{masterIdx}          = trialOutput.trials(iTrial).NameMaskVisage;
%             quadrant(masterIdx)      = trialOutput.trials(iTrial).Cadran;
%             imageDim{masterIdx}      = size(trialOutput.trials(iTrial).imagepated);
%             faceOrient(masterIdx)    = trialOutput.trials(iTrial).faceorinv;
%             originalIdx(masterIdx)   = originalIdxCounter;
%     %         sanity(masterIdx) = masterIdx;
%             masterIdx = masterIdx + 1;
%         end
%         originalIdxCounter = originalIdxCounter + 1;
%     end
% end
% 
% save(fullfile(saveLoc,saveFolder,'exptDesign.mat'),'faceImg','faceName','bgName','position',...
%     'positionAngle','mask','quadrant','imageDim', 'faceOrient')%, 'originalIdx');



%% Generate training/testing indices
% clear; clc;
% load('exptDesign.mat');
% uniqueFaceImgs = unique(faceImg);
% nUniqueImgs = length(uniqueFaceImgs);
% 
% % generate the indeces for training vs. testing.
% trainingIdx = randperm(nUniqueImgs,nUniqueImgs/2);
% testingIdx = setdiff(1:nUniqueImgs,trainingIdx);
% trainingFaces = uniqueFaceImgs(trainingIdx);
% testingFaces = uniqueFaceImgs(testingIdx);
% save('exptDesign','bgImg','faceImg','mask','positionAngle','position',...
%     'uniqueFaceImgs','trainingIdx','testingIdx','trainingFaces','testingFaces');

%% use the cross valid indices to generate facesLoc file. 
% clear; clc;
% condition = 'normalized';
% subject = 's10';
% 
% datafolder = lsDir(['C:\Users\levan\HMAX\annulusExptFixedContrast\' subject '\' condition '\raw_data'],{'mat'});
% saveFolder = ['C:\Users\levan\HMAX\annulusExptFixedContrast\' subject '\' condition '\images\sandbox\'];
% 
% load(['C:\Users\levan\HMAX\annulusExptFixedContrast\' subject '\' condition '\exptDesign.mat'],...
%     'trainingFaces','testingFaces');
% 
% 
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
%        if any(strcmp(trainingFaces,trialOutput.trials(iTrial).face))
%            imwrite(uint8(trialOutput.trials(iTrial).imagepated),[saveFolder 'image' int2str(imgIdx) '_' trialOutput.trials(iTrial).face(1:end-4) '.png']);
%            facesLocTraining{1}{nameIdxTraining} = [saveFolder 'image' int2str(imgIdx) '_' trialOutput.trials(iTrial).face(1:end-4) '.png'];
%            nameIdxTraining = nameIdxTraining + 1;
%            trainingFacesIdx(nameIdxTraining) = imgIdx;
%        else
%            imwrite(uint8(trialOutput.trials(iTrial).imagepated),[saveFolder 'image' int2str(imgIdx) '_' trialOutput.trials(iTrial).face(1:end-4) '.png']);
%            facesLocTesting{1}{nameIdxTesting}   = [saveFolder 'image' int2str(imgIdx) '_' trialOutput.trials(iTrial).face(1:end-4) '.png'];
%            nameIdxTesting =  nameIdxTesting + 1;
%            testingFacesIdx(nameIdxTesting) = imgIdx;
%        end
%    end
% end
% % facesLoc = facesLocTraining;
% % save facesLocTraining facesLoc
% % facesLoc = facesLocTesting;
% % save facesLocTesting facesLoc
% save trainingFacesIdx trainingFacesIdx
% save testingFacesIdx  testingFacesIdx

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% below this line you have all the old script, in case you need it later.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% save annulus images from Florence's .mat files
% clear; clc;
% load('C:\Users\levan\Desktop\newData\s03\s03_session1_20160413-1250.mat');
% 
% saveFolder = 'C:\Users\levan\Desktop\newData\images2\';
% if ~exist(saveFolder)
%     mkdir(saveFolder)
% end
% 
% for iTrial = 1:length(trialOutput.trials)
%     imwrite(uint8(trialOutput.trials(iTrial).imagepated),[saveFolder 'image' int2str(iTrial) '.png']);
% end

%% create image array

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







