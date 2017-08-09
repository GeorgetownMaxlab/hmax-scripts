% This script will plot two scatterplots per patch-type. One compares
% localization on inverted vs. upright images from part2 of experiments,
% another compares localization on the training set of images to that of
% upright images from part 2.

% The script loads the bestPatches.mat file that has the data obtained from
% training the patches on the original testing set, and testing them on the
% original training set. 

clear; clc; close all;
home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1';
imgSet = 'training';
scaling_condition = 'scaling_FaceBox_switchSets';
load(fullfile(home,imgSet,'data\patchSetAdam\lfwSingle50000',scaling_condition,'bestPatches.mat'));
  
nSingles = numel (bestSingles.idx_suriving_testing_faceBox_threshold);
nDoublets = numel(bestDoublets.idx_suriving_testing_faceBox_threshold);
nTriplets = numel(bestTriplets.idx_suriving_testing_faceBox_threshold);
%% Plot singles inverted vs. upright localization
scaleMin = 10;
scaleMax = 60;
subplot(1,2,1)
scatter(bestSingles.singles_inverted,bestSingles.singles_upright,...
        20,'MarkerEdgeColor','k',...
              'MarkerFaceColor','b'...
              )
xlabel('Inverted Localization')
ylabel('Upright Localization')
title(['Best ' int2str(nSingles) ' singles.'])
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
hold on
plot(scaleMin:scaleMax,scaleMin:scaleMax)
legend('Patches','45 degree line')
hold off
%% Plot training vs. upright loc
subplot(1,2,2)
scatter(bestSingles.singles_training_wedge_performance,bestSingles.singles_upright,...
        20,'MarkerEdgeColor','k',...
              'MarkerFaceColor','b'...
              )
xlabel('Training Localization')
ylabel('Upright Localization')
title(['Best ' int2str(nSingles) ' singles.'])
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
hold on
plot(scaleMin:scaleMax,scaleMin:scaleMax)
legend('Patches','45 degree line')
hold off

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot up/inv doublets
figure
subplot(1,2,1)
scatter(bestDoublets.doublets_inverted,bestDoublets.doublets_upright,...
        20,'MarkerEdgeColor','k',...
              'MarkerFaceColor','b'...
              )
xlabel('Inverted Localization')
ylabel('Upright Localization')
title(['Best ' int2str(length(bestDoublets.idx_suriving_testing_faceBox_threshold)) ' doublets.'])
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
hold on
plot(scaleMin:scaleMax,scaleMin:scaleMax)
legend('Patches','45 degree line')
hold off

% Plot training/up doublets
subplot(1,2,2)
scatter(bestDoublets.doublets_training_wedge_performance,bestDoublets.doublets_upright,...
        20,'MarkerEdgeColor','k',...
              'MarkerFaceColor','b'...
              )
xlabel('Training Localization')
ylabel('Upright Localization')
title(['Best ' int2str(length(bestDoublets.idx_suriving_testing_faceBox_threshold)) ' doublets.'])
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
hold on
plot(scaleMin:scaleMax,scaleMin:scaleMax)
legend('Patches','45 degree line')
hold off

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot up/inv triplets
figure
subplot(1,2,1)
scatter(bestTriplets.triplets_inverted,bestTriplets.triplets_upright,...
        1,'MarkerEdgeColor','k',...
              'MarkerFaceColor','b'...
              )
xlabel('Inverted Localization')
ylabel('Upright Localization')
title(['Best ' int2str(length(bestTriplets.idx_suriving_testing_faceBox_threshold)) ' triplets.'])
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
hold on
plot(scaleMin:scaleMax,scaleMin:scaleMax)
hold off

% Plot up/inv triplets
subplot(1,2,2)
scatter(bestTriplets.triplets_training_wedge_performance,bestTriplets.triplets_upright,...
        1,'MarkerEdgeColor','k',...
              'MarkerFaceColor','b'...
              )
xlabel('Training Localization')
ylabel('Upright Localization')
title(['Best ' int2str(length(bestTriplets.idx_suriving_testing_faceBox_threshold)) ' triplets.'])
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
hold on
plot(scaleMin:scaleMax,scaleMin:scaleMax)
legend('Patches','45 degree line')
hold off