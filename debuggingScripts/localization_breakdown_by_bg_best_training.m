%% Break down the results by different bg's and faces.
% Maybe its just couple of bad faces in the part2upright set that drives
% down the whole performance.

% We will look at faceBox localization, cause they have to match anyway. 
clear; clc; close all;

%% Start with breaking down the training data.
exptDesign_training = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\exptDesign.mat');
loc_data_training   = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat');
imgHits_training    = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\patchSetAdam\lfwSingle50000\imgHitsFaceBox.mat');

all_bgs_training            = cell2mat(exptDesign_training.bgName);
[unique_bgs_training,~,~]   = unique(all_bgs_training);
unique_faces_training       = sort_nat(unique(exptDesign_training.faceName));

% Look at only top N patches.
nBestPatches = 1000;
idx_best = loc_data_training.IndPatch(1:nBestPatches); % best n patches, determined by training set face-box localization

% Truncate the imgHits matrix.
imgHits_training_top_patches = imgHits_training.imgHitsFaceBox(idx_best,:);

% Generate vector telling you how many patches hit each image.
for iImg = 1:size(imgHits_training_top_patches,2)
    nPatches_hitting_training(iImg)      = numel(find(imgHits_training_top_patches(:,iImg)==1)); %#ok<*SAGROW>
    nPatches_hitting_perc_training(iImg) = nPatches_hitting_training(iImg)*100/nBestPatches;
end

% For each bg, get the information
for iBg = 1:length(unique_bgs_training)
    idx_bgs_training{iBg}             = find(all_bgs_training == unique_bgs_training(iBg)); %#ok<*SAGROW>
    sum_per_bg_instance_training{iBg} =     nPatches_hitting_perc_training(idx_bgs_training{iBg});
    sum_per_bg_training (iBg)         = sum(nPatches_hitting_perc_training(idx_bgs_training{iBg}));
    mean_per_bg_training(iBg)         = round(sum_per_bg_training(iBg)/length(idx_bgs_training{iBg}));
end

%% Now load the testing data
% Start with breaking down the testing data.
exptDesign_testing = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\exptDesign.mat');
loc_data_testing   = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat');
imgHits_testing    = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\imgHitsFaceBox.mat');

all_bgs_testing            = cell2mat(exptDesign_testing.bgName);
[unique_bgs_testing,~,~]   = unique(all_bgs_testing);
unique_faces_testing       = sort_nat(unique(exptDesign_testing.faceName));

% Truncate the imgHits matrix.
imgHits_testing_top_patches = imgHits_testing.imgHitsFaceBox(idx_best,:);

% Generate vector telling you how many patches hit each image.
for iImg = 1:size(imgHits_testing_top_patches,2)
    nPatches_hitting_testing(iImg)      = numel(find(imgHits_testing_top_patches(:,iImg)==1)); %#ok<*SAGROW>
    nPatches_hitting_perc_testing(iImg) = nPatches_hitting_testing(iImg)*100/nBestPatches;
end

% For each bg, get the information
for iBg = 1:length(unique_bgs_testing)
    idx_bgs_testing{iBg}             = find(all_bgs_testing == unique_bgs_testing(iBg)); %#ok<*SAGROW>
    sum_per_bg_instance_testing{iBg} =     nPatches_hitting_perc_testing(idx_bgs_testing{iBg});
    sum_per_bg_testing (iBg)         = sum(nPatches_hitting_perc_testing(idx_bgs_testing{iBg}));
    mean_per_bg_testing(iBg)         = round(sum_per_bg_testing(iBg)/length(idx_bgs_testing{iBg}));
end

%% Now load the part2upright data
% Start with breaking down the testing data.
exptDesign_part2up = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\exptDesign.mat');
loc_data_part2up   = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat');
imgHits_part2up    = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\imgHitsFaceBox.mat');

all_bgs_part2up            = cell2mat(exptDesign_part2up.bgName);
[unique_bgs_part2up,~,~]   = unique(all_bgs_part2up);
unique_faces_part2up       = sort_nat(unique(exptDesign_part2up.faceName));

% Truncate the imgHits matrix.
imgHits_part2up_top_patches = imgHits_part2up.imgHitsFaceBox(idx_best,:);

% Generate vector telling you how many patches hit each image.
for iImg = 1:size(imgHits_part2up_top_patches,2)
    nPatches_hitting_part2up(iImg)      = numel(find(imgHits_part2up_top_patches(:,iImg)==1)); %#ok<*SAGROW>
    nPatches_hitting_perc_part2up(iImg) = nPatches_hitting_part2up(iImg)*100/nBestPatches;
end

% For each bg, get the information
for iBg = 1:length(unique_bgs_part2up)
    idx_bgs_part2up{iBg}             = find(all_bgs_part2up == unique_bgs_part2up(iBg)); %#ok<*SAGROW>
    sum_per_bg_instance_part2up{iBg} =     nPatches_hitting_perc_part2up(idx_bgs_part2up{iBg});
    sum_per_bg_part2up (iBg)         = sum(nPatches_hitting_perc_part2up(idx_bgs_part2up{iBg}));
    mean_per_bg_part2up(iBg)         = round(sum_per_bg_part2up(iBg)/length(idx_bgs_part2up{iBg}));
end

%% Plot training
nBars = 48;
markerSize = 4;
bar_color = [135/255,206/255,250/255];

close all;
subplot(3,1,1)
bar(mean_per_bg_training,'FaceColor',bar_color)
hold on
for iBg = 1:length(unique_bgs_training)
    scatter(ones(1,length(sum_per_bg_instance_training{iBg}))*iBg,...
            sum_per_bg_instance_training{iBg},...
            markerSize,...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','r');
%     boxplot(sum_per_bg_instance_training{iBg})
end
grid on
grid minor

xlim([0 nBars+1])
labels = num2cell(0:nBars+1);
set(gca,'XTick',[0:nBars+1]) 
set(gca,'XTickLabel',labels)
title('Training')
ylabel('Percentage patches hitting','FontSize',7)
%% Plot part2up
subplot(3,1,2)
bar_color = 'g';
bar(mean_per_bg_part2up,'FaceColor',bar_color)
hold on
for iBg = 1:length(unique_bgs_part2up)
    scatter(ones(1,length(sum_per_bg_instance_part2up{iBg}))*iBg,...
                          sum_per_bg_instance_part2up{iBg},...
                          markerSize,...
                          'MarkerEdgeColor','k',...
                          'MarkerFaceColor','r');
%     boxplot(sum_per_bg_instance_part2up{iBg})
end
% xlim([0 48])
grid on
grid minor
xlim([0 nBars+1])
labels = num2cell(0:nBars+1);
set(gca,'XTick',[0:nBars+1]) 
set(gca,'XTickLabel',labels)
title('Part2 Upright')
%% Plot testing
subplot(3,1,3)
bar_color = [255/255,193/255,193/255];
bar(mean_per_bg_testing,'FaceColor',bar_color)
hold on
for iBg = 1:length(unique_bgs_testing)
    scatter(ones(1,length(sum_per_bg_instance_testing{iBg}))*iBg,...
            sum_per_bg_instance_testing{iBg},...
            markerSize,...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','r');
%     boxplot(sum_per_bg_instance_testing{iBg})
end
% xlim([0 48])
grid on
grid minor

xlim([-24 25])
% set(gca,'XTick',[1:12]) 
labels = num2cell(0:49);
set(gca,'XTick',[-24:25]) 
set(gca,'XTickLabel',labels)
title('Testing')
pause