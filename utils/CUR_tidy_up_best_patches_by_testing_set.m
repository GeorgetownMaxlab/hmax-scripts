%% Create a data structure with best singles, best doublets, and triplets as evaluated on combined performance on training and testing sets.
% This structure should have all the info: indices, performances, etc.
clear; close all; clc;
comments = ['This data has patches which were evaluated with face-box', ...
            'localization on the TESTING set, not wedge localization.',...
            'Its better to use face-box localization'];

% Construct the data structure for singles
threshold_testing_wedge    = 30;
threshold_doublets_testing_faceBox  = 20; % minimum percentage localization necessary to get into top patches. Patches lower than this are excluded.

% load facebox localization data on the testing set.
load(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\',...
      'data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat'],...
      'sumStatsPatch') 

% filter patches that did worse than testing faceBox-threshold.
idx_suriving_testing_faceBox_threshold = find(sumStatsPatch > threshold_doublets_testing_faceBox); 
topPatches_testing_facebox_loc         = sumStatsPatch(idx_suriving_testing_faceBox_threshold); % record the face box.

clear sumStatsPatch

    % now load the wedge localization data on the testing set, and record
    % the wedge performance of filtered patches.
    load(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\',...
          'data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat'],...
          'sumStatsPatch')
    % get the wedge performances of the patches surviging the testing faceBox-threshold.
    topPatches_testing_wedge_loc = sumStatsPatch(idx_suriving_testing_faceBox_threshold); 
    clear sumStatsPatch

% ok so now, we have filtered patches based on the testing facebox
% localization. 
% Then we recorded the wedge as well as facebox localization of those filtered
% patches.
% - topPatches_facebox_loc_testing
% - topPatches_wedge_loc_testing
    
    
%% MOVING ONTO TRAINING SET: now load the wedge-localization data on TRAINING set.
% and select those patches that survived the testing threshold.

load(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\',...
      'data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat'],...
      'sumStatsPatch')
topPatches_training_wedge_loc = sumStatsPatch(idx_suriving_testing_faceBox_threshold);

% % exclude those patches that had less than certain wedge localization on training set.
% threshold_training_wedge = 0;
% idx_suriving_training_wedge_threshold = find(topPatches_training_wedge_loc > threshold_training_wedge);
% % retain indices of only those patches that survived both thresholds.
% idx_suriving_crossValid = idx_suriving_testing_faceBox_threshold(idx_suriving_training_wedge_threshold);

% now load training data, but facebox, just to record that too in case needed.
load(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\',...
      'data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat'],...
      'sumStatsPatch')
topPatches_training_facebox_loc = sumStatsPatch(idx_suriving_testing_faceBox_threshold);

% % retains testing faceBox-performance information of only those patches that passed training performance threshold.
% topPatches_testing_facebox_loc = topPatches_testing_facebox_loc(idx_suriving_training_wedge_threshold); 
% % retains testing wedge-performance information of only those patches that passed training performance threshold.
% topPatches_wedge_loc_testing   = topPatches_wedge_loc_testing  (idx_suriving_training_wedge_threshold);
% % retains training performance information of only those patches that passed training performance threshold.
% topPatches_training_wedge_loc  = topPatches_training_wedge_loc (idx_suriving_training_wedge_threshold);

    % sort all of these values, including indices, by training wedge-performance.
    [~,sortingIdx] = sort(topPatches_training_wedge_loc,'descend');
    topPatches_testing_facebox_loc         = topPatches_testing_facebox_loc        (sortingIdx);
    topPatches_testing_wedge_loc           = topPatches_testing_wedge_loc          (sortingIdx);
    topPatches_training_wedge_loc          = topPatches_training_wedge_loc         (sortingIdx);
    topPatches_training_facebox_loc        = topPatches_training_facebox_loc       (sortingIdx);
    idx_suriving_testing_faceBox_threshold = idx_suriving_testing_faceBox_threshold(sortingIdx);
    
% record everything in a data structure and clear remaining variables
bestSingles.comments                               = comments;
bestSingles.idx_suriving_testing_faceBox_threshold = idx_suriving_testing_faceBox_threshold;
bestSingles.singles_testing_facebox_peformance     = topPatches_testing_facebox_loc;
bestSingles.singles_testing_wedge_peformance       = topPatches_testing_wedge_loc;
bestSingles.singles_training_facebox_performance   = topPatches_training_facebox_loc;
bestSingles.singles_training_wedge_performance     = topPatches_training_wedge_loc;

clearvars -except comments bestSingles
%% Construct the data structure for doublets
threshold_doublets_testing_faceBox = 30;
nImgs_training = 744;
nImgs_testing  = 720;

% load training combMatrix for doublets
load(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\',...
      'patchSetAdam\lfwSingle50000\scaling_FaceBox_switchSets\doublets\1000TPatches1000CPatches\',...
      'combMatrix_output.mat'])
% transform performances into percentage values
combMatrix_output(:,4) = combMatrix_output(:,4)/nImgs_testing  *100; % this is face-box performance on testing set
combMatrix_output(:,5) = combMatrix_output(:,5)/nImgs_training *100; % this is wedge performance on training set

idx_suriving_threshold_doublets_testing_faceBox = find(combMatrix_output(:,4) > threshold_doublets_testing_faceBox);% &...
                                             % combMatrix_output(:,5) > threshold_training_wedge);
combMatrix_output_filtered = combMatrix_output(idx_suriving_threshold_doublets_testing_faceBox,:); %#ok<FNDSB> % This will retain only those doublets that passed the FB threshold on Testing set.

    % sort all of these values, including indices, by training wedge-performance.
    [~,sortingIdx] = sort(combMatrix_output_filtered(:,5),'descend');
    combMatrix_output_filtered = combMatrix_output_filtered(sortingIdx,:);


bestDoublets.comments              = comments;
bestDoublets.idx_suriving_testing_faceBox_threshold        = combMatrix_output_filtered(:,1:2);
bestDoublets.patch2_scaling_factor = combMatrix_output_filtered(:,3);
bestDoublets.doublets_testing_facebox_performance = combMatrix_output_filtered(:,4);
bestDoublets.doublets_training_wedge_performance  = combMatrix_output_filtered(:,5);

% ideally, we would also have the wedge performance on the testing, and
% facebox performance on training.

clearvars combMatrix_output combMatrix_output_filtered idx_suriving_threshold_doublets_testing_faceBox sortingIdx

%% construct the data structure for triplets
threshold_triplets_testing_faceBox = 30;
load(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\',...
      'patchSetAdam\lfwSingle50000\scaling_FaceBox_switchSets\doublets\1000TPatches1000CPatches\',...
      'triplets\1000TPatches1000CPatches\combMatrix_output.mat'])

% transform performances into percentage values
combMatrix_output(:,6) = combMatrix_output(:,6)/nImgs_testing*100;  % this is face-box performance of doublets on testing set.
combMatrix_output(:,7) = combMatrix_output(:,7)/nImgs_testing*100;  % this is face-box performance of triplets on testing set.
combMatrix_output(:,8) = combMatrix_output(:,8)/nImgs_training *100;% this is wedge    performance of triplets on training set.

idx_suriving_threshold_triplets_testing_faceBox = find(combMatrix_output(:,7) > threshold_triplets_testing_faceBox); % &...
                                            %combMatrix_output(:,8) > threshold_training_wedge);
combMatrix_output_filtered = combMatrix_output(idx_suriving_threshold_triplets_testing_faceBox,:);

    % sort all of these values, including indices, by testing wedge-performance.
    [~,sortingIdx] = sort(combMatrix_output_filtered(:,8),'descend');
    combMatrix_output_filtered = combMatrix_output_filtered(sortingIdx,:);

bestTriplets.comments              = comments;
bestTriplets.idx_suriving_testing_faceBox_threshold = combMatrix_output_filtered(:,1:3);
bestTriplets.patch2_scaling_factor = combMatrix_output_filtered(:,4);
bestTriplets.patch3_scaling_factor = combMatrix_output_filtered(:,5);
bestTriplets.doublets_testing_facebox_performance = combMatrix_output_filtered(:,6);
bestTriplets.triplets_testing_facebox_performance  = combMatrix_output_filtered(:,7);
bestTriplets.triplets_training_wedge_performance   = combMatrix_output_filtered(:,8);

clearvars -except bestSingles bestDoublets bestTriplets comments

% save all the data
save('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\patchSetAdam\lfwSingle50000\scaling_FaceBox_switchSets\bestPatches.mat',...
    'bestSingles','bestDoublets','bestTriplets','comments');
