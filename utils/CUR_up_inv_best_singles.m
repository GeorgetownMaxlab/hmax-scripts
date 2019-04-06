%% EVALUATE SINGLES DATA

% This script will take the best singles from the bestPatches.mat file,
% and evaluate their performance on the upright and inverted images from
% the 2nd part of the CRCNS psychophysics experiment.

clear; close all; clc;

%% setup and load stuff
home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1';
imgSet = 'training';
scaling_condition = 'scaling_FaceBox_switchSets';
load(fullfile(home,imgSet,'data\patchSetAdam\lfwSingle50000',scaling_condition,'bestPatches.mat'));

loadFolder_singles_upright  = 'simulation1/part2Inverted_all_subj/upright\data\patchSetAdam\lfwSingle50000';
loadFolder_singles_inverted = 'simulation1/part2Inverted_all_subj/inverted\data\patchSetAdam\lfwSingle50000';

    loadLoc_singles_upright     = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles_upright  '\'];
    loadLoc_singles_inverted    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles_inverted '\'];    
    
upright_wedge_loc_singles = load([loadLoc_singles_upright 'imageDifficultyData_Wedge_50000_Patches.mat'],'sumStatsPatch');
upright_wedge_loc_singles = upright_wedge_loc_singles.sumStatsPatch;
bestSingles.singles_upright = upright_wedge_loc_singles(bestSingles.idx_suriving_testing_faceBox_threshold);

inverted_wedge_loc_singles = load([loadLoc_singles_inverted 'imageDifficultyData_Wedge_50000_Patches.mat'],'sumStatsPatch');
inverted_wedge_loc_singles = inverted_wedge_loc_singles.sumStatsPatch;
bestSingles.singles_inverted = inverted_wedge_loc_singles(bestSingles.idx_suriving_testing_faceBox_threshold);

nSingles = numel(bestSingles.idx_suriving_testing_faceBox_threshold);
%% now plot...
scatter(bestSingles.singles_inverted,bestSingles.singles_upright,...
        20,'MarkerEdgeColor','k',...
              'MarkerFaceColor','b'...
              )
xlabel('Inverted Localization')
ylabel('Upright Localization')
title(['Best ' int2str(nSingles) ' singles, after crossvalidation'])
xlim([10 50])
ylim([10 50])
grid on
hold on
plot(10:50,10:50)
legend('Pathces','45 degree line')

%% save the bestPatches.mat file
% optional to overwrite the singles data
save(fullfile(home,imgSet,'data\patchSetAdam\lfwSingle50000',scaling_condition,'bestPatches.mat'),'bestSingles','-append');
