function total_imgs = generate_crossvalid_files(crossValidInfo)

% This script uses the crossValidInfo.mat file to select the training faces
% and training backgrouns, and then find images that contain only those
% faces and bgs across various image sets that we have.

% The script then loops through the folders contaitning C2 and related data
% for different types of patches, and filters those files to contain on the
% selected images.

dbstop if error
if ispc 
    home = 'C:\Users\levan\HMAX\annulusExptFixedContrast';
else
    home = '/home/levan/HMAX/annulusExptFixedContrast';
end
simulation = 'simulation3';
if (nargin < 1)
    % Load the cross validation information
    load(fullfile(home,simulation,'crossValidInfo_1821-281-91_2017-May-08-09-47-20.mat'))
end

%% Start the task loop
tasks = {'patchSetAdam','patchSet_2x3','patchSet_3x2','patchSet_1x2','patchSet_2x1','patchSet_1x3','patchSet_3x1'};

for iTask = 1:numel(tasks)
    tasks{iTask}
    %% Start looping through different image sets!
    
    imgSets(1,:) = {'part1upright','part2upinv/upright','set1',       'set2'};
    imgSets(2,:) = {'simulation3', 'simulation3',       'simulation2','simulation2'};
%     imgSets(1,:) = {'part1upright','part2upinv/upright'};%,'set1',       'set2'};
%     imgSets(2,:) = {'simulation3', 'simulation3',      };% 'simulation2','simulation2'};
    for iSet = 1:size(imgSets,2)
        iSet
        % load all the files
        load(fullfile(home,imgSets{2,iSet},imgSets{1,iSet},'exptDesign.mat'));
        load(fullfile(home,imgSets{2,iSet},imgSets{1,iSet},'data',tasks{iTask},'lfwSingle50000','c2f.mat'));
        load(fullfile(home,imgSets{2,iSet},imgSets{1,iSet},'data',tasks{iTask},'lfwSingle50000','bestBandsC2f.mat'));
        load(fullfile(home,imgSets{2,iSet},imgSets{1,iSet},'data',tasks{iTask},'lfwSingle50000','bestLocC2f.mat'));
        load(fullfile(home,imgSets{2,iSet},imgSets{1,iSet},'data',tasks{iTask},'lfwSingle50000','facesLoc.mat'));
        facesLoc = convertFacesLocAnnulusFixedContrast(facesLoc,ispc);
        
        % Get the faceNames and bgNames
        faceName_num = cell2mat({exptDesign(:).faceName})';
        bgName_num   = cell2mat({exptDesign(:).bgName})';
        
        if strcmp(imgSets{1,iSet},'part2upinv/upright')
            imgSets{1,iSet} = 'part2upright';
        end
        
        % Find images with only the training faces and bgs
        eval(['idx_training_faces_'  imgSets{1,iSet} ' = find(ismember(faceName_num,crossValidInfo.training_faces));']);
        eval(['idx_training_bgs_'    imgSets{1,iSet} ' = find(ismember(bgName_num  ,crossValidInfo.training_bgs));']);
        eval(['idx_training_images_' imgSets{1,iSet} ' = intersect(idx_training_faces_' imgSets{1,iSet} ',idx_training_bgs_' imgSets{1,iSet} ');']);
        
        % Find images with only the testing faces and bgs
        eval(['idx_testing_faces_'  imgSets{1,iSet} ' = find(ismember(faceName_num,crossValidInfo.testing_faces));']);
        eval(['idx_testing_bgs_'    imgSets{1,iSet} ' = find(ismember(bgName_num  ,crossValidInfo.testing_bgs));']);
        eval(['idx_testing_images_' imgSets{1,iSet} ' = intersect(idx_testing_faces_' imgSets{1,iSet} ',idx_testing_bgs_' imgSets{1,iSet} ');']);
        
        %%%%%%%%%%%%% Filter all the files to contain only training images.%%%%%%%%%%%%%%%
        eval(['exptDesign_training_' imgSets{1,iSet} '   = exptDesign (1,idx_training_images_' imgSets{1,iSet} ');']);
        eval(['c2f_training_'        imgSets{1,iSet} '   = c2f        (:,idx_training_images_' imgSets{1,iSet} ');']);
        eval(['bestBands_training_'  imgSets{1,iSet} '   = bestBands  (:,idx_training_images_' imgSets{1,iSet} ');']);
        eval(['bestLoc_training_'    imgSets{1,iSet} '   = bestLoc    (:,idx_training_images_' imgSets{1,iSet} ',:);']);
        eval(['facesLoc_training_'   imgSets{1,iSet} '{1}= facesLoc{1}(idx_training_images_' imgSets{1,iSet} ');']);
        
        %%%%%%%%%%%% Filter all the files to contain only testing images.%%%%%%%%%%%%%%%%%
        eval(['exptDesign_testing_' imgSets{1,iSet} '   = exptDesign (1,idx_testing_images_' imgSets{1,iSet} ');']);
        eval(['c2f_testing_'        imgSets{1,iSet} '   = c2f        (:,idx_testing_images_' imgSets{1,iSet} ');']);
        eval(['bestBands_testing_'  imgSets{1,iSet} '   = bestBands  (:,idx_testing_images_' imgSets{1,iSet} ');']);
        eval(['bestLoc_testing_'    imgSets{1,iSet} '   = bestLoc    (:,idx_testing_images_' imgSets{1,iSet} ',:);']);
        eval(['facesLoc_testing_'   imgSets{1,iSet} '{1}= facesLoc{1}(idx_testing_images_' imgSets{1,iSet} ');']);
        
        % if exptDesign is from part2, remove the "originalIdxCounter" field
        if strcmp(imgSets{1,iSet},'part2upright')
            
            eval(['exptDesign_training_' imgSets{1,iSet} '   = rmfield(exptDesign_training_' imgSets{1,iSet} ',''originalIdxCounter'');']);
            eval(['exptDesign_testing_'  imgSets{1,iSet} '   = rmfield(exptDesign_testing_'  imgSets{1,iSet} ',''originalIdxCounter'');']);
            
        end
    end
    
    %% Now combine all the training files
    display('Combining training files');
    c2f_training_final         = [c2f_training_part1upright ...
        c2f_training_part2upright ...
        c2f_training_set1 ...
        c2f_training_set2];
    
    bestBands_training_final   = [bestBands_training_part1upright ...
        bestBands_training_part2upright ...
        bestBands_training_set1 ...
        bestBands_training_set2];
    
    bestLoc_training_final     = [bestLoc_training_part1upright ...
        bestLoc_training_part2upright ...
        bestLoc_training_set1 ...
        bestLoc_training_set2];
    
    facesLoc_training_final{1} = [facesLoc_training_part1upright{1}; ...
        facesLoc_training_part2upright{1}; ...
        facesLoc_training_set1{1}; ...
        facesLoc_training_set2{1}];
    
    exptDesign_training_final  = [exptDesign_training_part1upright ...
        exptDesign_training_part2upright ...
        exptDesign_training_set1 ...
        exptDesign_training_set2];
    %% Now combine all the testing files
    % For testing set, we only take the images from part1upright.
    display('Combining testing files...');    
    c2f_testing_final         =  [c2f_testing_part1upright ...
                                 c2f_testing_part2upright ...
                                 c2f_testing_set1 ...
                                 c2f_testing_set2];
    
    bestBands_testing_final   = [bestBands_testing_part1upright ...
                                 bestBands_testing_part2upright ...
                                 bestBands_testing_set1 ...
                                 bestBands_testing_set2];
    
    bestLoc_testing_final     = [bestLoc_testing_part1upright ...
                                 bestLoc_testing_part2upright ...
                                 bestLoc_testing_set1 ...
                                 bestLoc_testing_set2];
    
    facesLoc_testing_final{1} = [facesLoc_testing_part1upright{1}; ...
                                 facesLoc_testing_part2upright{1}; ...
                                 facesLoc_testing_set1{1}; ...
                                 facesLoc_testing_set2{1}];
    
    exptDesign_testing_final  = [exptDesign_testing_part1upright ...
                                 exptDesign_testing_part2upright ...
                                 exptDesign_testing_set1 ...
                                 exptDesign_testing_set2];
    % pause(1)
    %% Check dimensions...
%     pause(1)
%     figure
%     imagesc(bestBands_testing_final)
%     figure
%     imagesc(bestBands_training_final)
%     figure
%     imagesc(c2f_training_final)
%     figure
%     imagesc(c2f_testing_final)
    %% Visualize all.
    
    
    %% Save the training files
    display('Saving training files...');    
    c2f       = c2f_training_final;
    bestBands = bestBands_training_final;
    bestLoc   = bestLoc_training_final;
    facesLoc  = facesLoc_training_final;
    exptDesign = exptDesign_training_final;
    
    display('Make sure the following variable is correct:');
    conditionTraining = 'training4'
    saveLoc_training = fullfile(home,'simulation3',conditionTraining,'data',tasks{iTask},'lfwSingle50000');
    if ~exist(saveLoc_training)
        mkdir(saveLoc_training)
    end
    
    save(fullfile(saveLoc_training,'c2f.mat'),      'c2f');
    save(fullfile(saveLoc_training,'bestBandsC2f.mat'),'bestBands');
    save(fullfile(saveLoc_training,'bestLocC2f.mat'),  'bestLoc');
    save(fullfile(saveLoc_training,'facesLoc.mat'), 'facesLoc');
    save(fullfile(home,'simulation3',conditionTraining,'exptDesign.mat'), 'exptDesign');
    
    clearvars -except iTask tasks crossValidInfo home c2f_testing_final bestBands_testing_final bestLoc_testing_final ...
              facesLoc_testing_final exptDesign_testing_final% clear stuff just in case
    
    
    %% Save the testing files
    display('Saving testing files...');        
    c2f       = c2f_testing_final;
    bestBands = bestBands_testing_final;
    bestLoc   = bestLoc_testing_final;
    facesLoc  = facesLoc_testing_final;
    exptDesign = exptDesign_testing_final;
    
    display('Make sure the following variable is correct:');    
    conditionTesting = 'testing4'
    saveLoc_testing = fullfile(home,'simulation3',conditionTesting,'data',tasks{iTask},'lfwSingle50000');
    if ~exist(saveLoc_testing)
        mkdir(saveLoc_testing)
    end
    
    save(fullfile(saveLoc_testing,'c2f.mat'),      'c2f');
    save(fullfile(saveLoc_testing,'bestBandsC2f.mat'),'bestBands');
    save(fullfile(saveLoc_testing,'bestLocC2f.mat'),  'bestLoc');
    save(fullfile(saveLoc_testing,'facesLoc.mat'), 'facesLoc');
    save(fullfile(home,'simulation3',conditionTesting,'exptDesign.mat'), 'exptDesign');
    
    clearvars -except iTask tasks crossValidInfo home % clear stuff just in case

end % task

end