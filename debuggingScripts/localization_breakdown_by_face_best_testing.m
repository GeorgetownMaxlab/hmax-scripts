%% Break down the results by different face's and faces.
% Maybe its just couple of bad backgrounds or faces in the part2upright set that drives
% down the whole performance.

% We will look at faceBox localization, cause they have to match anyway.
% This script takes nBestPatches as based on testing set localization.
clear; clc; close all;
dbstop if error
%% Start with breaking down the testing data.
% Start with breaking down the testing data.
exptDesign_testing = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\exptDesign.mat');
loc_data_testing   = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat');
imgHits_testing    = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\imgHitsFaceBox.mat');

all_bgs_testing            = cell2mat(exptDesign_testing.bgName);
[unique_bgs_testing,~,~]   = unique(all_bgs_testing);

for iFace = 1:length(exptDesign_testing.faceName)
    all_faces_testing(iFace) = str2double(exptDesign_testing.faceName{iFace}(1:end-4));
end
unique_faces_testing       = unique(all_faces_testing);

% Look at only top N patches.
nBestPatches = 1000;
idx_best = loc_data_testing.IndPatch(1:nBestPatches); % best n patches, determined by testing set face-box localization

% Truncate the imgHits matrix.
imgHits_testing_top_patches = imgHits_testing.imgHitsFaceBox(idx_best,:);

% Generate vector telling you how many patches hit each image.
for iImg = 1:size(imgHits_testing_top_patches,2)
    nPatches_hitting_testing(iImg)      = numel(find(imgHits_testing_top_patches(:,iImg)==1)); %#ok<*SAGROW>
    nPatches_hitting_perc_testing(iImg) = nPatches_hitting_testing(iImg)*100/nBestPatches;
end

% For each face, get the information
for iFace = 1:length(unique_faces_testing)
    idx_faces_testing{iFace}             = find(all_faces_testing == unique_faces_testing(iFace)); %#ok<*SAGROW>
    sum_per_face_instance_testing{iFace} =     nPatches_hitting_perc_testing(idx_faces_testing{iFace});
    sum_per_face_testing (iFace)         = sum(nPatches_hitting_perc_testing(idx_faces_testing{iFace}));
    mean_per_face_testing(iFace)         = round(sum_per_face_testing(iFace)/length(idx_faces_testing{iFace}));
end

%% Now load the training data
exptDesign_training = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\exptDesign.mat');
loc_data_training   = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat');
imgHits_training    = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\patchSetAdam\lfwSingle50000\imgHitsFaceBox.mat');

all_bgs_training            = cell2mat(exptDesign_training.bgName);
[unique_bgs_training,~,~]   = unique(all_bgs_training);
for iFace = 1:length(exptDesign_training.faceName)
    all_faces_training(iFace) = str2double(exptDesign_training.faceName{iFace}(1:end-4));
end
unique_faces_training       = unique(all_faces_training);

% Truncate the imgHits matrix.
imgHits_training_top_patches = imgHits_training.imgHitsFaceBox(idx_best,:);

% Generate vector telling you how many patches hit each image.
for iImg = 1:size(imgHits_training_top_patches,2)
    nPatches_hitting_training(iImg)      = numel(find(imgHits_training_top_patches(:,iImg)==1)); %#ok<*SAGROW>
    nPatches_hitting_perc_training(iImg) = nPatches_hitting_training(iImg)*100/nBestPatches;
end

% For each face, get the information
for iFace = 1:length(unique_faces_training)
    idx_faces_training{iFace}             = find(all_faces_training == unique_faces_training(iFace)); %#ok<*SAGROW>
    sum_per_face_instance_training{iFace} =     nPatches_hitting_perc_training(idx_faces_training{iFace});
    sum_per_face_training (iFace)         = sum(nPatches_hitting_perc_training(idx_faces_training{iFace}));
    mean_per_face_training(iFace)         = round(sum_per_face_training(iFace)/length(idx_faces_training{iFace}));
end



%% Now load the part2upright data
% Start with breaking down the testing data.
exptDesign_part2up = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\exptDesign.mat');
loc_data_part2up   = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat');
imgHits_part2up    = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\imgHitsFaceBox.mat');

all_bgs_part2up            = cell2mat(exptDesign_part2up.bgName);
[unique_bgs_part2up,~,~]   = unique(all_bgs_part2up);
for iFace = 1:length(exptDesign_part2up.faceName)
    all_faces_part2up(iFace) = str2double(exptDesign_part2up.faceName{iFace}(1:end-4));
end
unique_faces_part2up       = unique(all_faces_part2up);

% Truncate the imgHits matrix.
imgHits_part2up_top_patches = imgHits_part2up.imgHitsFaceBox(idx_best,:);

% Generate vector telling you how many patches hit each image.
for iImg = 1:size(imgHits_part2up_top_patches,2)
    nPatches_hitting_part2up(iImg)      = numel(find(imgHits_part2up_top_patches(:,iImg)==1)); %#ok<*SAGROW>
    nPatches_hitting_perc_part2up(iImg) = nPatches_hitting_part2up(iImg)*100/nBestPatches;
end

% For each face, get the information
for iFace = 1:length(unique_faces_part2up)
    idx_faces_part2up{iFace}             = find(all_faces_part2up == unique_faces_part2up(iFace)); %#ok<*SAGROW>
    sum_per_face_instance_part2up{iFace} =     nPatches_hitting_perc_part2up(idx_faces_part2up{iFace});
    sum_per_face_part2up (iFace)         = sum(nPatches_hitting_perc_part2up(idx_faces_part2up{iFace}));
    mean_per_face_part2up(iFace)         = round(sum_per_face_part2up(iFace)/length(idx_faces_part2up{iFace}));
end

%% Plot training
nBars = 22;
ymax  = 100;
markerSize = 4;
bar_color = [135/255,206/255,250/255];

close all;
subplot(3,1,1)
bar(mean_per_face_training,'FaceColor',bar_color)
hold on
for iFace = 1:length(unique_faces_training)
    scatter(ones(1,length(sum_per_face_instance_training{iFace}))*iFace,...
            sum_per_face_instance_training{iFace},...
            markerSize,...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','r');
%     boxplot(sum_per_face_instance_training{iface})
end
grid on
grid minor

xlim([0 nBars+1])
ylim([0 ymax])
labels = num2cell(0:nBars+1);
set(gca,'XTick',[0:nBars+1]) 
set(gca,'XTickLabel',labels)
labels_y = num2cell(0:10:100);
set(gca,'YTick',[0:10:100]) 
set(gca,'YTickLabel',labels_y)
title('Training')
ylabel('% patches hitting','FontSize',7)
%% Plot part2up
subplot(3,1,2)
bar_color = 'g';
bar(mean_per_face_part2up,'FaceColor',bar_color)
hold on
for iFace = 1:length(unique_faces_part2up)
    scatter(ones(1,length(sum_per_face_instance_part2up{iFace}))*iFace,...
                          sum_per_face_instance_part2up{iFace},...
                          markerSize,...
                          'MarkerEdgeColor','k',...
                          'MarkerFaceColor','r');
%     boxplot(sum_per_face_instance_part2up{iface})
end
% xlim([0 48])
grid on
grid minor
xlim([0 nBars+1])
ylim([0 ymax])
labels = num2cell(0:nBars+1);
set(gca,'XTick',[0:nBars+1]) 
set(gca,'XTickLabel',labels)
labels_y = num2cell(0:10:100);
set(gca,'YTick',[0:10:100]) 
set(gca,'YTickLabel',labels_y)
title('Part2 Upright')
ylabel('% patches hitting','FontSize',7)
%% Plot testing
% subplot(3,1,3)
% bar_color = [255/255,193/255,193/255];
% bar(mean_per_face_testing,'FaceColor',bar_color)
% hold on
% for iFace = 1:length(unique_faces_testing)
%     scatter(ones(1,length(sum_per_face_instance_testing{iFace}))*iFace,...
%             sum_per_face_instance_testing{iFace},...
%             markerSize,...
%             'MarkerEdgeColor','k',...
%             'MarkerFaceColor','r');
% %     boxplot(sum_per_face_instance_testing{iface})
% end
% % xlim([0 48])
% grid on
% grid minor
% 
% xlim([-24 25])
% ylim([0 ymax])
% % set(gca,'XTick',[1:12]) 
% labels = num2cell(0:49);
% set(gca,'XTick',[-24:25]) 
% set(gca,'XTickLabel',labels)
% title('Testing')
% pause
%% Plot dofference between training and part2up
subplot(3,1,3)
bar_color = [192/255,192/255,192/255];
mean_per_face_trainig_minus_part2up = mean_per_face_training-mean_per_face_part2up(1:18);
% mean_per_face_trainig_minus_part2up = [mean_per_face_trainig_minus_part2up 0 0 mean(mean_per_face_trainig_minus_part2up)];
bar(mean_per_face_trainig_minus_part2up,'FaceColor',bar_color)
hold on
% for iface = 1:length(unique_faces_part2up)
%     scatter(ones(1,length(sum_per_face_instance_training{iface}))*iface,...
%             sum_per_face_instance_training{iface}-sum_per_face_instance_part2up{iface},...
%             markerSize,...
%             'MarkerEdgeColor','k',...
%             'MarkerFaceColor','r');
% %     boxplot(sum_per_face_instance_testing{iface})
% end

grid on
grid minor
xlim([0 nBars+1])
ylim([-20 20])
labels = num2cell(0:nBars+1);
set(gca,'XTick',[0:nBars+1]) 
set(gca,'XTickLabel',labels)
title('Training - part2up')
ylabel({'Training - part2up','note different y-scale'},'FontWeight','bold');
suptitle('Broken down by Faces')
% pause