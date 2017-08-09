% This script takes the patches that prefer UP or INV images or are
% NEUTRAL, and looks at their performance on EEG UP and INV images.

clear; clc; close all;
dbstop if error;

load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatches.mat')

eeg_up_perf = load('C:\Users\levan\HMAX\eeg_up_inv\upright\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat');
eeg_up_perf = eeg_up_perf.sumStatsPatch;

% Load C2 file for SINGLES
eeg_s_upImgs_c2 = load('C:\Users\levan\HMAX\eeg_up_inv\upright\data\patchSetAdam\lfwSingle50000\c2f.mat');
eeg_s_upImgs_c2 = eeg_s_upImgs_c2.c2f;
eeg_s_invImgs_c2 = load('C:\Users\levan\HMAX\eeg_up_inv\inverted\data\patchSetAdam\lfwSingle50000\c2f.mat');
eeg_s_invImgs_c2 = eeg_s_invImgs_c2.c2f;

% Load C2 file for DOUBLETS
eeg_d_upImgs_c2 = load('C:\Users\levan\HMAX\eeg_up_inv\upright\data\patchSetAdam\lfwSingle50000\doublets/c2f.mat');
eeg_d_upImgs_c2 = eeg_d_upImgs_c2.c2f;
eeg_d_invImgs_c2 = load('C:\Users\levan\HMAX\eeg_up_inv\inverted\data\patchSetAdam\lfwSingle50000\doublets/c2f.mat');
eeg_d_invImgs_c2 = eeg_d_invImgs_c2.c2f;

% Load C2 file for SINGLES
eeg_t_upImgs_c2 = load('C:\Users\levan\HMAX\eeg_up_inv\upright\data\patchSetAdam\lfwSingle50000\triplets/c2f.mat');
eeg_t_upImgs_c2 = eeg_t_upImgs_c2.c2f;
eeg_t_invImgs_c2 = load('C:\Users\levan\HMAX\eeg_up_inv\inverted\data\patchSetAdam\lfwSingle50000\triplets/c2f.mat');
eeg_t_invImgs_c2 = eeg_t_invImgs_c2.c2f;

%% Analyze NEUTRAL-patches on EEG images
figure

% Get original indices for singles, doublets, triplets
idx_original_s = bestSingles.idx_crossValid(preference_analysis.s_idx_neutral);
idx_original_d = preference_analysis.d_idx_neutral;
idx_original_t = preference_analysis.t_idx_neutral;

% Get average C2 values for singles, doublets, triplets
avgC2_s_neutralPatches_upEEGimgs  = mean(eeg_s_upImgs_c2 (idx_original_s,:),2);
avgC2_s_neutralPatches_invEEGimgs = mean(eeg_s_invImgs_c2(idx_original_s,:),2);
avgC2_d_neutralPatches_upEEGimgs  = mean(eeg_d_upImgs_c2 (idx_original_d,:),2);
avgC2_d_neutralPatches_invEEGimgs = mean(eeg_d_invImgs_c2(idx_original_d,:),2);
avgC2_t_neutralPatches_upEEGimgs  = mean(eeg_t_upImgs_c2 (idx_original_t,:),2);
avgC2_t_neutralPatches_invEEGimgs = mean(eeg_t_invImgs_c2(idx_original_t,:),2);

% Plot for singles
subplot(1,3,1)
scatter(avgC2_s_neutralPatches_invEEGimgs,avgC2_s_neutralPatches_upEEGimgs,...
        20,'MarkerEdgeColor','k',...
        'MarkerFaceColor','b'...
        )
xlabel('Average C2 on Inverted EEG Images') 
ylabel('Average C2 on Upright EEG Images') 
title([int2str(length(idx_original_s)) ' NEUTRAL singles'])
xlim([0 0.35])
ylim([0 0.35])
grid on
hold on
plot(0:0.01:0.25,0:0.01:0.25,'k')
legend('Pathces','45 degree line')

% Plot for doublets
subplot(1,3,2)
scatter(avgC2_d_neutralPatches_invEEGimgs,avgC2_d_neutralPatches_upEEGimgs,...
        20,'MarkerEdgeColor','k',...
        'MarkerFaceColor','b'...
        )
xlabel('Average C2 on Inverted EEG Images') 
ylabel('Average C2 on Upright EEG Images') 
title([int2str(length(idx_original_d)) ' NEUTRAL doublets'])
xlim([0 0.35])
ylim([0 0.35])
grid on
hold on
plot(0:0.01:0.25,0:0.01:0.25,'k')
legend('Pathces','45 degree line')
% Plot for singles
subplot(1,3,3)
scatter(avgC2_t_neutralPatches_invEEGimgs,avgC2_t_neutralPatches_upEEGimgs,...
        20,'MarkerEdgeColor','k',...
        'MarkerFaceColor','b'...
        )
xlabel('Average C2 on Inverted EEG Images') 
ylabel('Average C2 on Upright EEG Images') 
title([int2str(length(idx_original_t)) ' NEUTRAL triplets'])
xlim([0 0.35])
ylim([0 0.35])
grid on
hold on
plot(0:0.01:0.25,0:0.01:0.25,'k')
legend('Pathces','45 degree line')

%% Analyze INV-patches on EEG images
figure
% Get original indices for singles, doublets, triplets
idx_original_s = bestSingles.idx_crossValid(preference_analysis.s_idx_inv_sign);
idx_original_d = preference_analysis.d_idx_inv_sign;
idx_original_t = preference_analysis.t_idx_inv_sign;

% Get average C2 values for singles, doublets, triplets
avgC2_s_invPatches_upEEGimgs  = mean(eeg_s_upImgs_c2 (idx_original_s,:),2);
avgC2_s_invPatches_invEEGimgs = mean(eeg_s_invImgs_c2(idx_original_s,:),2);
avgC2_d_invPatches_upEEGimgs  = mean(eeg_d_upImgs_c2 (idx_original_d,:),2);
avgC2_d_invPatches_invEEGimgs = mean(eeg_d_invImgs_c2(idx_original_d,:),2);
avgC2_t_invPatches_upEEGimgs  = mean(eeg_t_upImgs_c2 (idx_original_t,:),2);
avgC2_t_invPatches_invEEGimgs = mean(eeg_t_invImgs_c2(idx_original_t,:),2);

% Plot for singles
subplot(1,3,1)
scatter(avgC2_s_invPatches_invEEGimgs,avgC2_s_invPatches_upEEGimgs,...
        20,'MarkerEdgeColor','k',...
        'MarkerFaceColor','r'...
        )
xlabel('Average C2 on Inverted EEG Images') 
ylabel('Average C2 on Upright EEG Images') 
title([int2str(length(idx_original_s)) ' INVERTED singles'])
% xlim([0 0.25])
% ylim([0 0.25])
grid on
hold on
plot(0:0.01:0.25,0:0.01:0.25,'k')
legend('Pathces','45 degree line')

% Plot for doublets
subplot(1,3,2)
scatter(avgC2_d_invPatches_invEEGimgs,avgC2_d_invPatches_upEEGimgs,...
        20,'MarkerEdgeColor','k',...
        'MarkerFaceColor','r'...
        )
xlabel('Average C2 on Inverted EEG Images') 
ylabel('Average C2 on Upright EEG Images') 
title([int2str(length(idx_original_d)) ' INVERTED doublets'])
% xlim([0 0.25])
% ylim([0 0.25])
grid on
hold on
plot(0:0.01:0.25,0:0.01:0.25,'k')
legend('Pathces','45 degree line')
% Plot for singles
subplot(1,3,3)
scatter(avgC2_t_invPatches_invEEGimgs,avgC2_t_invPatches_upEEGimgs,...
        20,'MarkerEdgeColor','k',...
        'MarkerFaceColor','r'...
        )
xlabel('Average C2 on Inverted EEG Images') 
ylabel('Average C2 on Upright EEG Images') 
title([int2str(length(idx_original_t)) ' INVERTED triplets'])
% xlim([0 0.25])
% ylim([0 0.25])
grid on
hold on
plot(0:0.01:0.25,0:0.01:0.25,'k')
legend('Pathces','45 degree line')

%% Analyze UP-patches on EEG images
figure
% Get original indices for singles, doublets, triplets
idx_original_s = bestSingles.idx_crossValid(preference_analysis.s_idx_up_sign);
idx_original_d = preference_analysis.d_idx_up_sign;
idx_original_t = preference_analysis.t_idx_up_sign;

% Get average C2 values for singles, doublets, triplets
avgC2_s_upPatches_upEEGimgs  = mean(eeg_s_upImgs_c2 (idx_original_s,:),2);
avgC2_s_upPatches_invEEGimgs = mean(eeg_s_invImgs_c2(idx_original_s,:),2);
avgC2_d_upPatches_upEEGimgs  = mean(eeg_d_upImgs_c2 (idx_original_d,:),2);
avgC2_d_upPatches_invEEGimgs = mean(eeg_d_invImgs_c2(idx_original_d,:),2);
avgC2_t_upPatches_upEEGimgs  = mean(eeg_t_upImgs_c2 (idx_original_t,:),2);
avgC2_t_upPatches_invEEGimgs = mean(eeg_t_invImgs_c2(idx_original_t,:),2);

% Plot for singles
subplot(1,3,1)
scatter(avgC2_s_upPatches_invEEGimgs,avgC2_s_upPatches_upEEGimgs,...
        20,'MarkerEdgeColor','k',...
        'MarkerFaceColor','g'...
        )
xlabel('Average C2 on Inverted EEG Images') 
ylabel('Average C2 on Upright EEG Images') 
title([int2str(length(idx_original_s)) ' UPRIGHT singles'])
% xlim([0 0.25])
% ylim([0 0.25])
grid on
hold on
plot(0:0.01:0.25,0:0.01:0.25,'k')
legend('Pathces','45 degree line')

% Plot for doublets
subplot(1,3,2)
scatter(avgC2_d_upPatches_invEEGimgs,avgC2_d_upPatches_upEEGimgs,...
        20,'MarkerEdgeColor','k',...
        'MarkerFaceColor','g'...
        )
xlabel('Average C2 on Inverted EEG Images') 
ylabel('Average C2 on Upright EEG Images') 
title([int2str(length(idx_original_d)) ' UPRIGHT doublets'])
% xlim([0 0.25])
% ylim([0 0.25])
grid on
hold on
plot(0:0.01:0.25,0:0.01:0.25,'k')
legend('Pathces','45 degree line')
% Plot for singles
subplot(1,3,3)
scatter(avgC2_t_upPatches_invEEGimgs,avgC2_t_upPatches_upEEGimgs,...
        20,'MarkerEdgeColor','k',...
        'MarkerFaceColor','g'...
        )
xlabel('Average C2 on Inverted EEG Images') 
ylabel('Average C2 on Upright EEG Images') 
title([int2str(length(idx_original_t)) ' UPRIGHT triplets'])
% xlim([0 0.25])
% ylim([0 0.25])
grid on
hold on
plot(0:0.01:0.25,0:0.01:0.25,'k')
legend('Pathces','45 degree line')

