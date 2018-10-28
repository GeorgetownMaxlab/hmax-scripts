%% Plot various wedge degrees on single plot.
clear; clc; dbstop if error;
close all;

nPatches = 50000;

% load faceBox info
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\data\patchSet_3x2\lfwSingle50000\fixedLocalization\patchPerformanceInfo_FaceBox.mat');
    % Resort patches
    [sorted,idx] = sort(idx_best_patches,'ascend');
    sumStatsPatch_faceBox = sortSumStatsPatch(idx);
    sumStatsPatch_faceBox = sumStatsPatch_faceBox(1:nPatches);


% Load various wedge degree infos.
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\data\patchSet_3x2\lfwSingle50000\fixedLocalization\patchPerformanceInfo_Wedge_10.mat');
    % Resort patches
    [sorted,idx] = sort(idx_best_patches,'ascend');
    sumStatsPatch_wedge10 = sortSumStatsPatch(idx);
    sumStatsPatch_wedge10 = sumStatsPatch_wedge10(1:nPatches);
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\data\patchSet_3x2\lfwSingle50000\fixedLocalization\patchPerformanceInfo_Wedge_20.mat');
    % Resort patches
    [sorted,idx] = sort(idx_best_patches,'ascend');
    sumStatsPatch_wedge20 = sortSumStatsPatch(idx);
    sumStatsPatch_wedge20 = sumStatsPatch_wedge20(1:nPatches);
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\data\patchSet_3x2\lfwSingle50000\fixedLocalization\patchPerformanceInfo_Wedge_30.mat');
    % Resort patches
    [sorted,idx] = sort(idx_best_patches,'ascend');
    sumStatsPatch_wedge30 = sortSumStatsPatch(idx);
    sumStatsPatch_wedge30 = sumStatsPatch_wedge30(1:nPatches);
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\data\patchSet_3x2\lfwSingle50000\fixedLocalization\patchPerformanceInfo_Wedge_45.mat');
    % Resort patches
    [sorted,idx] = sort(idx_best_patches,'ascend');
    sumStatsPatch_wedge45 = sortSumStatsPatch(idx);
    sumStatsPatch_wedge45 = sumStatsPatch_wedge45(1:nPatches);
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\data\patchSet_3x2\lfwSingle50000\fixedLocalization\patchPerformanceInfo_Wedge_90.mat');
    % Resort patches
    [sorted,idx] = sort(idx_best_patches,'ascend');
    sumStatsPatch_wedge90 = sortSumStatsPatch(idx);
    sumStatsPatch_wedge90 = sumStatsPatch_wedge90(1:nPatches);

% Start plotting
scaleMin = 0;
scaleMax = 60;

scatter(sumStatsPatch_faceBox,sumStatsPatch_wedge10,...
        10,'MarkerEdgeColor','k',...
              'MarkerFaceColor','y'...
              )
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
grid minor
hold on

scatter(sumStatsPatch_faceBox,sumStatsPatch_wedge20,...
        10,'MarkerEdgeColor','k',...
              'MarkerFaceColor','r'...
              )

scatter(sumStatsPatch_faceBox,sumStatsPatch_wedge30,...
        10,'MarkerEdgeColor','k',...
              'MarkerFaceColor','g'...
              )
scatter(sumStatsPatch_faceBox,sumStatsPatch_wedge45,...
        10,'MarkerEdgeColor','k',...
              'MarkerFaceColor','b'...
              )
scatter(sumStatsPatch_faceBox,sumStatsPatch_wedge90,...
        10,'MarkerEdgeColor','k',...
              'MarkerFaceColor','c'...
              )
legend('10 degrees','20 degrees','30 degrees','45 degrees','90 degrees');

plot(scaleMin:scaleMax,scaleMin:scaleMax,'r');
xlabel('Face-Box performance');
ylabel('Wedge performance');
title('Comparing face-box to various sized wedge performances');

pause
%% Combined singles and doublets plot
%Start with doublets.
clear; clc; dbstop if error;

home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\';
simulation = 'simulation7'
condition  = 'testing'
combination_type = 'find_CPatches';
perfUsed         = 'fbox_x_fbox';
% perfUsed         = '';
patches_type     = 'patchSet_3x2';

% nImgsTraining = 1659;
nImgsTraining = 1000;
nImgsTesting  = 1008;
% nImgsTesting  = 766;
% nImgsTesting  = 923; % Florence's high contrast data.
% nImgsTesting  = 1000;
nPatches      = 50000;

nTPatches     = 2000;
nCPatches     = 3000;

scaleMin = 0;
scaleMax = 60;

% Load the combMatrix
load(fullfile(home,simulation,condition,'data',patches_type,'lfwSingle50000',...
              'combinations',combination_type,'doublets',...
              [int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches_' perfUsed],...
              'combMatrix_output.mat'));

% Transform performances into percentages
combMatrix_output(:,4) = combMatrix_output(:,4)*100/nImgsTraining;
combMatrix_output(:,5) = combMatrix_output(:,5)*100/nImgsTesting;

% Plot
figure
scatter(combMatrix_output(:,4),combMatrix_output(:,5),...
        10,'MarkerEdgeColor','k',...
              'MarkerFaceColor','y'...
              )
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now singles
clear; clc; dbstop if error; %close all;

home = 'C:\Users\levan\HMAX\annulusExptFixedContrast';
nPatches = 50000;

% Load set 1 data
set1_simulation = 'simulation3'
set1_condition  = 'part1upright'
load(fullfile(home,set1_simulation,set1_condition,'data\patchSet_3x2\lfwSingle50000\fixedLocalization\patchPerformanceInfo_FaceBox.mat'));
% load(fullfile(home,set1_simulation,set1_condition,'data\patchSet_3x2\lfwSingle50000\fixedLocalization\patchPerformanceInfo_Wedge_30.mat')); display('Singles data shows wedge performance');
    % Get the first nPatches patch performance.
    [sorted_indices,idx] = sort(idx_best_patches,'ascend');
    sumStatsPatch_set1 = sortSumStatsPatch(idx);
    sumStatsPatch_set1 = sumStatsPatch_set1(1:nPatches);

% Load set 2 data.
set2_simulation = 'simulation7'
set2_condition  = 'training'
load(fullfile(home,set2_simulation,set2_condition,'data\patchSet_3x2\lfwSingle50000\fixedLocalization\patchPerformanceInfo_FaceBox.mat'));
    % Resort patches
    [sorted,idx] = sort(idx_best_patches,'ascend');
    sumStatsPatch_set2 = sortSumStatsPatch(idx);
    sumStatsPatch_set2 = sumStatsPatch_set2(1:nPatches);

% Plotting purple line
nTPatchesAbove = 2000;
lowest_TPatch_loc = sortSumStatsPatch(nTPatchesAbove);
    
% Sart plotting
scaleMin = 0;
scaleMax = 60;

hold on
scatter(sumStatsPatch_set2,sumStatsPatch_set1,...
            10,'MarkerEdgeColor','k',...
              'MarkerFaceColor','r'...
              );
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
hold on

% Add legends, 45 degree line, etc.
legend('Doublets','Singles');
title([set2_simulation ' vs Subject Images generalization'])
plot(scaleMin:scaleMax,scaleMin:scaleMax)
plot(ones(1,61)*lowest_TPatch_loc,0:60);
xlabel(['Face-box perf. on ' set2_simulation])
ylabel('Face-box perf. on subject images')

%% Plot performance of singles on set1 and set2.
% Change what files are loaded for set1 and set2 to compare various
% options.
clear; clc; dbstop if error; %close all;

home = 'C:\Users\levan\HMAX\annulusExptFixedContrast';
nPatches = 50000;

% Load set 1 data
set1_simulation = 'simulation3';
set1_condition  = 'part1upright';
load(fullfile(home,set1_simulation,set1_condition,'data\patchSet_3x2\lfwSingle50000\fixedLocalization\patchPerformanceInfo_FaceBox.mat'));
    % Get the first nPatches patch performance.
    [sorted_indices,idx] = sort(idx_best_patches,'ascend');
    sumStatsPatch_set1 = sortSumStatsPatch(idx);
    sumStatsPatch_set1 = sumStatsPatch_set1(1:nPatches);

% Load set 2 data.
set2_simulation = 'simulation6';
set2_condition  = 'training';
load(fullfile(home,set2_simulation,set2_condition,'data\patchSet_3x2\lfwSingle50000\fixedLocalization\patchPerformanceInfo_FaceBox.mat'));
    % Resort patches
    [sorted,idx] = sort(idx_best_patches,'ascend');
    sumStatsPatch_set2 = sortSumStatsPatch(idx);
    sumStatsPatch_set2 = sumStatsPatch_set2(1:nPatches);

% Sart plotting
scaleMin = 0;
scaleMax = 60;

figure
scatter(sumStatsPatch_set2,sumStatsPatch_set1,...
            10,'MarkerEdgeColor','k',...
              'MarkerFaceColor','r'...
              );
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
hold on
plot(scaleMin:scaleMax,scaleMin:scaleMax)
hold off
title(['Single Patches. ' set2_simulation ' vs ' set1_simulation])
xlabel([ int2str(nPatches) ' patches on ' set2_simulation ' set'])
ylabel([ int2str(nPatches) ' patches on ' set1_simulation ' set'])

%% Plot doublets on various sets of images
clear; clc; dbstop if error;

home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\';
simulation = 'simulation5';
condition  = 'testing';
combination_type = 'find_CPatches';
perfUsed         = 'fbox_x_fbox';
% perfUsed         = '';
patches_type     = 'patchSet_3x2';

% nImgsTraining = 1659;
nImgsTraining = 1000;
nImgsTesting  = 1008;
% nImgsTesting  = 766;
% nImgsTesting  = 923; % Florence's high contrast data.
% nImgsTesting  = 1000;
nPatches      = 50000;

nTPatches     = 3000;
nCPatches     = 2000;

scaleMin = 0;
scaleMax = 60;

% Load the combMatrix
load(fullfile(home,simulation,condition,'data',patches_type,'lfwSingle50000',...
              'combinations',combination_type,'doublets',...
              [int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches_' perfUsed],...
              'combMatrix_output.mat'));

% Transform performances into percentages
combMatrix_output(:,4) = combMatrix_output(:,4)*100/nImgsTraining;
combMatrix_output(:,5) = combMatrix_output(:,5)*100/nImgsTesting;

% Plot
figure
scatter(combMatrix_output(:,4),combMatrix_output(:,5),...
        10,'MarkerEdgeColor','k',...
              'MarkerFaceColor','y'...
              )
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
hold on
plot(scaleMin:scaleMax,scaleMin:scaleMax)
hold off
title(['Doublet Generalization simulation5 vs subject images. ' perfUsed])
% xlabel('Face-box performance on Jacob''s training set')
% ylabel('Face-box performance on Control annulus images')
xlabel('Face-box performance on simulation5 training set')
ylabel('Face-box performance on subject images')
% 
%% Plot doublet performance on Florence and Control side-by-side
% clear; clc; close all; dbstop if error;
% 
% % Load florence data
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\data\patchSet_3x2\lfwSingle50000\high_contrast_data\combinations\find_CPatches\doublets\1000TPatches100CPatches_fbox_x_fbox\combMatrix_output.mat')
% % nImgsTesting = 1008;
% nImgsTesting = 923;
% 
% florencePerf = combMatrix_output(:,5)*100/nImgsTesting;
% 
% % Load control data
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation4\control_v2\data\patchSet_3x2\lfwSingle50000\combinations\find_CPatches\doublets\1000TPatches100CPatches_fbox_x_fbox\combMatrix_output.mat')
% nImgsTesting = 766;
% controlPerf = combMatrix_output(:,5)*100/nImgsTesting;
% 
% figure
% scatter(controlPerf,florencePerf,...
%         10,'MarkerEdgeColor','k',...
%               'MarkerFaceColor','r'...
%               )
% scaleMin = 0;
% scaleMax = 45;
% xlim([scaleMin scaleMax])
% ylim([scaleMin scaleMax])
% grid on
% hold on
% plot(scaleMin:scaleMax,scaleMin:scaleMax)
% hold off
% title('Doublets Patches. Control vs Florence')
% xlabel('Doublets on control set')
% ylabel('Doublets on Florence''s set')
% 
