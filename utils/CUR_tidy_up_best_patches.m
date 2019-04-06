%% Create a data structure with best singles, best doublets, and triplets as evaluated on combined performance on training and testing sets.
% This structure should have all the info: indices, performances, etc.
clear; close all; clc;
comments = ['This data has patches which were evaluated with face-box', ...
            'localization on the training set, not wedge localization.',...
            'Its better to use face-box localization'];

% Construct the data structure for singles
threshold_training_wedge    = 30;
threshold_training_faceBox  = 15; % minimum percentage localization necessary to get into top patches. Patches lower than this are excluded.

% load facebox localization data on the training set.
load(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\',...
      'data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat'],...
      'sumStatsPatch') 

% filter patches that did worse than training faceBox-threshold.
idx_suriving_training_faceBox_threshold = find(sumStatsPatch > threshold_training_faceBox); 
nPatches_surviving_training             = length(idx_suriving_training_faceBox_threshold);
topPatches_facebox_loc_training         = sumStatsPatch(idx_suriving_training_faceBox_threshold); % record the face box.

clear sumStatsPatch

    % now load the wedge localization data on the training set, and record
    % the wedge performance of filtered patches.
    load(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\',...
          'data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat'],...
          'sumStatsPatch')
    % get the wedge performances of the patches surviging the training faceBox-threshold.
    topPatches_wedge_loc_training = sumStatsPatch(idx_suriving_training_faceBox_threshold); 
    clear sumStatsPatch

% ok so now, we have filtered patches based on the training facebox
% localization. 
% Then we recorded the wedge as well as facebox localization of those filtered
% patches.
% - topPatches_facebox_loc_training
% - topPatches_wedge_loc_training
    
    
%% MOVING ONTO TESTING SET: now load the wedge-localization data on TESTING set.
% and select those patches that survived the training threshold.

load(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\',...
      'data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat'],...
      'sumStatsPatch')
topPatches_wedge_loc_testing = sumStatsPatch(idx_suriving_training_faceBox_threshold);

% exclude those patches that had less than certain wedge localization on testing set.
threshold_testing_wedge = 30;
idx_suriving_testing_wedge_threshold = find(topPatches_wedge_loc_testing > threshold_testing_wedge);
% retain indices of only those patches that survived both thresholds.
idx_suriving_crossValid = idx_suriving_training_faceBox_threshold(idx_suriving_testing_wedge_threshold);

% now load testing data, but facebox, just to record that too in case needed.
% load(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\',...
%       'data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat'],...
%       'sumStatsPatch')
% topPatches_facebox_loc_testing = sumStatsPatch(idx_suriving_crossValid);

topPatches_facebox_loc_training = topPatches_facebox_loc_training(idx_suriving_testing_wedge_threshold); 
% retains training faceBox-performance information of only those patches that passed testing performance threshold.
topPatches_wedge_loc_training   = topPatches_wedge_loc_training  (idx_suriving_testing_wedge_threshold);
% retains training wedge-performance information of only those patches that passed testing performance threshold.
topPatches_wedge_loc_testing    = topPatches_wedge_loc_testing   (idx_suriving_testing_wedge_threshold);
% retains testing performance information of only those patches that passed testing performance threshold.

    % sort all of these values, including indices, by testing wedge-performance.
    [~,sortingIdx] = sort(topPatches_wedge_loc_testing,'descend');
    topPatches_facebox_loc_training = topPatches_facebox_loc_training(sortingIdx);
    topPatches_wedge_loc_training   = topPatches_wedge_loc_training  (sortingIdx);
    topPatches_wedge_loc_testing    = topPatches_wedge_loc_testing   (sortingIdx);
    idx_suriving_crossValid         = idx_suriving_crossValid        (sortingIdx);
    
% record everything in a data structure and clear remaining variables
bestSingles.comments       = comments;
bestSingles.idx_crossValid = idx_suriving_crossValid;
bestSingles.singles_training_crossValid_facebox_peformance = topPatches_facebox_loc_training;
bestSingles.singles_training_crossValid_wedge_peformance   = topPatches_wedge_loc_training;
% bestSingles.singles_testing_crossValid_facebox_performance = topPatches_facebox_loc_testing;
bestSingles.singles_testing_crossValid_wedge_performance   = topPatches_wedge_loc_testing;

clearvars -except comments bestSingles
%% Construct the data structure for doublets
threshold_training_faceBox = 30;
threshold_TESTING_wedge    = 30;
nImgs_training = 744;
nImgs_testing  = 720;

% load testing combMatrix for doublets
load(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\',...
      'patchSetAdam\lfwSingle50000\scaling_facebox\doublets\1000TPatches1000CPatches\',...
      'combMatrix_output.mat'])
% transform performances into percentage values
combMatrix_output(:,4) = combMatrix_output(:,4)/nImgs_training*100; % this is face-box performance on training set
combMatrix_output(:,5) = combMatrix_output(:,5)/nImgs_testing *100; % this is wedge performance on TESTING set

idx_suriving_testing_wedge_threshold = find(combMatrix_output(:,4) > threshold_training_faceBox &...
                                            combMatrix_output(:,5) > threshold_TESTING_wedge);
combMatrix_output_filtered = combMatrix_output(idx_suriving_testing_wedge_threshold,:); %#ok<FNDSB>

    % sort all of these values, including indices, by testing wedge-performance.
    [~,sortingIdx] = sort(combMatrix_output_filtered(:,5),'descend');
    combMatrix_output_filtered = combMatrix_output_filtered(sortingIdx,:);


bestDoublets.comments              = comments;
bestDoublets.idx_crossValid        = combMatrix_output_filtered(:,1:2);
bestDoublets.patch2_scaling_factor = combMatrix_output_filtered(:,3);
bestDoublets.doublets_training_crossValid_facebox_performance   = combMatrix_output_filtered(:,4);
bestDoublets.doublets_testing_crossValid_wedge_performance      = combMatrix_output_filtered(:,5);

% ideally, we would also have the wedge performance on the training, and
% facebox performance on testing.

clearvars combMatrix_output combMatrix_output_filtered idx_suriving_testing_wedge_threshold sortingIdx

%% construct the data structure for triplets
load(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\',...
      'patchSetAdam\lfwSingle50000\scaling_FaceBox\doublets\1000TPatches1000CPatches\',...
      'triplets\1000TPatches1000CPatches\combMatrix_output.mat'])

% transform performances into percentage values
combMatrix_output(:,6) = combMatrix_output(:,6)/nImgs_training*100; % this is face-box performance of doublets on training set.
combMatrix_output(:,7) = combMatrix_output(:,7)/nImgs_training*100; % this is face-box performance of triplets on training set.
combMatrix_output(:,8) = combMatrix_output(:,8)/nImgs_testing *100; % this is wedge    performance of triplets on testing set.

idx_suriving_testing_wedge_threshold = find(combMatrix_output(:,7) > threshold_training_faceBox &...
                                            combMatrix_output(:,8) > threshold_TESTING_wedge);
combMatrix_output_filtered = combMatrix_output(idx_suriving_testing_wedge_threshold,:);

    % sort all of these values, including indices, by testing wedge-performance.
    [~,sortingIdx] = sort(combMatrix_output_filtered(:,8),'descend');
    combMatrix_output_filtered = combMatrix_output_filtered(sortingIdx,:);

bestTriplets.comments              = comments;
bestTriplets.idx_crossValid        = combMatrix_output_filtered(:,1:3);
bestTriplets.patch2_scaling_factor = combMatrix_output_filtered(:,4);
bestTriplets.patch3_scaling_factor = combMatrix_output_filtered(:,5);
bestTriplets.doublets_training_crossValid_facebox_performance = combMatrix_output_filtered(:,6);
bestTriplets.triplet_training_crossValid_facebox_performance  = combMatrix_output_filtered(:,7);
bestTriplets.triplet_testing_crossValid_wedge_performance     = combMatrix_output_filtered(:,8);

clearvars -except bestSingles bestDoublets bestTriplets comments

% save all the data
save('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_faceBox\bestPatches.mat',...
    'bestSingles','bestDoublets','bestTriplets','comments');
