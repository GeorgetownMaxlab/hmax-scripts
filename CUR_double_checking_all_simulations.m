% If dual monitor, make plots appear on the second one. Might need to
% restart matlab.
r = get(groot);
if size(r.MonitorPositions,1) > 1
    p = [-951.0000  119.6667  560.0000  420.0000];
%       p = [-10.2783    0.0090    1.2773    0.6353];
    set(0, 'DefaultFigurePosition', p);
end
%% Combined script for double checking simulations for CRCNS.


%% Cross-validation: overlap between the training and testing sets in terms of bg and face identity images.
clear; clc; close all;
% check if exptDesign was created correctly.

% load exptDesign for training.
training = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\exptDesign.mat');
% load for testing.
testing = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\exptDesign.mat');
% load for part1 of psychophysics
part1psych = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part1upright\exptDesign.mat');
% load for part2 of psychophysics
part2psych_coh1_upright  = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\upright\exptDesign.mat');
part2psych_coh1_inverted = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\inverted\exptDesign.mat');
part2psych_coh2_upright  = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_2nd_cohort\upright\exptDesign.mat');
part2psych_coh2_inverted = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_2nd_cohort\inverted\exptDesign.mat');

part2psych_upright  = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\exptDesign.mat');
part2psych_inverted = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\inverted\exptDesign.mat');

% bg names
display([int2str(numel(unique(cell2mat(training.bgName)))) ' bgs in Training']);
display([int2str(numel(unique(cell2mat(testing.bgName))))  ' bgs in Testing']);
assert(isempty(intersect(cell2mat(training.bgName),cell2mat(testing.bgName))),'Backgrounds aren''t different between training and testing');

% face IDs
display([int2str(numel(unique(training.faceName))) ' faces in Training']);
display([int2str(numel(unique(testing.faceName))) ' faces in Testing']);
assert(isempty(intersect(cell2mat(training.bgName),cell2mat(testing.bgName))),'Backgrounds aren''t different between training and testing');
assert(isempty(intersect(training.faceName,testing.faceName)),'Faces aren''t different between training and testing');


% Now compare with part2 where you had up/inv experiment
part2psych_upright_faces  = unique(part2psych_upright.faceName);
part2psych_upright_bgs    = unique(cell2mat(part2psych_upright.bgName));
part2psych_inverted_faces = unique(part2psych_inverted.faceName);
part2psych_inverted_bgs   = unique(cell2mat(part2psych_inverted.bgName));
% you can see that bgs and faces are the same for upright and inverted
% images. Now compare these to training/testing sets

common_faces_training_and_part2 = intersect(unique(training.faceName),part2psych_upright_faces); % part2 had 22 faces, containing all the 18 from training.
common_bgs_training_and_part2   = intersect(unique(cell2mat(training.bgName)),part2psych_upright_bgs);

common_faces_testing_and_part2  = intersect(unique(testing.faceName),part2psych_upright_faces); % 4 faces are similar.
common_bgs_testing_and_part2    = intersect(unique(cell2mat(testing.bgName)),part2psych_upright_bgs);

% result is that training bgs show up in the part2 of experiment. But none
% of the testing bgs show up in the part2. So bgs used were different.
% 
% 
%% Compare the luminance distributions
clearvars -except training testing part1psych part2psych_upright part2psych_inverted
close all;

ymin = 0;
ymax = 70;
xmin = 0;
xmax = 0.8;
bin_size = 50;

subplot(3,2,1)
hist(training.michelson_values,bin_size)
hold on
mn = mean(training.michelson_values);
md = median(training.michelson_values);
line([mn mn],[0 ymax],'Color','r')
line([md md],[0 ymax],'Color','k')
title(['Training Set, ' int2str(length(training.michelson_values)) ' Images'])
ylim([ymin ymax]);
xlim([xmin xmax]);
grid on
legend('Data','Mean','Median')

subplot(3,2,2)
hist(testing.michelson_values,bin_size)
hold on
mn = mean(testing.michelson_values);
md = median(testing.michelson_values);
line([mn mn],[0 ymax],'Color','r')
line([md md],[0 ymax],'Color','k')
title(['Testing Set, ' int2str(length(testing.michelson_values)) ' Images'])
ylim([ymin ymax]);
xlim([xmin xmax]);
grid on

subplot(3,2,3)
hist(part1psych.michelson_values,bin_size)
hold on
mn = mean(part1psych.michelson_values);
md = median(part1psych.michelson_values);
line([mn mn],[0 ymax],'Color','r')
line([md md],[0 ymax],'Color','k')
title(['Part 1 all Upright, ' int2str(length(part1psych.michelson_values)) ' Images'])
ylim([ymin ymax]);
xlim([xmin xmax]);
grid on

subplot(3,2,5)
hist(part2psych_upright.michelson_values,bin_size)
hold on
mn = mean(part2psych_upright.michelson_values);
md = median(part2psych_upright.michelson_values);
line([mn mn],[0 ymax],'Color','r')
line([md md],[0 ymax],'Color','k')
title(['Part 2 Upright, ' int2str(length(part2psych_upright.michelson_values)) ' Images'])
ylim([ymin ymax]);
xlim([xmin xmax]);
grid on


subplot(3,2,6)
hist(part2psych_inverted.michelson_values,bin_size)
hold on
mn = mean(part2psych_inverted.michelson_values);
md = median(part2psych_inverted.michelson_values);
line([mn mn],[0 ymax],'Color','r')
line([md md],[0 ymax],'Color','k')
title(['Part 2 Inverted, ' int2str(length(part2psych_inverted.michelson_values)) ' Images'])
ylim([ymin ymax]);
xlim([xmin xmax]);

grid on

%% Checking the core code.
% clear; clc;
% %% Training set runs.
% % Run 10 patches on 10 images and compare C2s.
% nReplPatches = 10;
% nReplImages  = 10;
% 
% simulations_compared = {'training','testing','part2Inverted/inverted','part2Inverted/upright'};
% for iComparison = 1:length(simulations_compared)
%     % Compare C2s.
%     origC2 = load(fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\',simulations_compared{iComparison},'\data\patchSetAdam\lfwSingle50000\c2f.mat'));
%     replC2 = load(fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\',simulations_compared{iComparison},'\data\patchSetAdam\lfwSingle10_replication\c2f.mat'));
%     DIFF = origC2.c2f(1:nReplPatches,1:nReplImages)-replC2.c2f;
%     figure
%     plot(DIFF(:))
%     title(simulations_compared{iComparison});
%     ylim([-0.001 0.001]);
%     display([simulations_compared{iComparison} ', Max diff = ' num2str(max(abs(DIFF(:))))]);
% 
%     % Compare localizations
%     origImgHitsF = load(fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\',simulations_compared{iComparison},'\data\patchSetAdam\lfwSingle50000\imgHitsFaceBox.mat'));
%     origImgHitsW = load(fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\',simulations_compared{iComparison},'\data\patchSetAdam\lfwSingle50000\imgHitsWedge.mat'));
%     replImgHitsF = load(fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\',simulations_compared{iComparison},'\data\patchSetAdam\lfwSingle10_replication\imgHitsFaceBox.mat'));
%     replImgHitsW = load(fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\',simulations_compared{iComparison},'\data\patchSetAdam\lfwSingle10_replication\imgHitsWedge.mat'));
% 
%     assert(isequal(origImgHitsF.imgHitsFaceBox(1:nReplPatches,1:nReplImages),replImgHitsF.imgHitsFaceBox));
%     assert(isequal(origImgHitsW.imgHitsWedge(1:nReplPatches,1:nReplImages),replImgHitsW.imgHitsWedge));
% end

%% Is there difference between coh1 and coh2 of part2 up/inv experiment?
% in terms of performance of patches?

%% Singles
% clear; clc;
% coh1 = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\upright\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat',...
%             'sumStatsPatch');
% coh2 = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_2nd_cohort\upright\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat',...
%             'sumStatsPatch');
% display(['Mean for Coh1 ' num2str(mean(coh1.sumStatsPatch))]);
% display(['Mean for Coh2 ' num2str(mean(coh2.sumStatsPatch))]);
% 
% plot(1:length(coh1.sumStatsPatch),coh1.sumStatsPatch,1:length(coh2.sumStatsPatch),coh2.sumStatsPatch)
% 
% %% Is there difference between having cobined coh1 and co2 c2s manually, and having actually run them as one whole?
% %% Compare C2s.
% close all; clear; clc;
% 
% % Inverted
% coh1c2 = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\inverted\data\patchSetAdam\lfwSingle50000\c2f.mat');
% coh2c2 = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_2nd_cohort\inverted\data\patchSetAdam\lfwSingle50000\c2f.mat');
% 
% all_subj_c2_manual = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\inverted\c2f.mat');
% all_subj_c2_rerun  = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\inverted\data\patchSetAdam\lfwSingle50000\c2f.mat');
% 
% isequal([coh1c2.c2f coh2c2.c2f],all_subj_c2_manual.c2f) %equal!
% isequal(all_subj_c2_manual.c2f,all_subj_c2_rerun.c2f) % they are equal!
% 
% % Upright
% coh1c2 = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\upright\data\patchSetAdam\lfwSingle50000\c2f.mat');
% coh2c2 = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_2nd_cohort\upright\data\patchSetAdam\lfwSingle50000\c2f.mat');
% 
% all_subj_c2_manual = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\c2f.mat');
% all_subj_c2_rerun  = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\c2f.mat');
% 
% isequal([coh1c2.c2f coh2c2.c2f],all_subj_c2_manual.c2f) % they are equal!
% isequal(all_subj_c2_manual.c2f,all_subj_c2_rerun.c2f) % they are equal!

%% Compare localizations
% clear; clc; close all;
% 
% %imgHitsFiles FaceBox
% coh1FB = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\upright\data\patchSetAdam\lfwSingle50000\imgHitsFaceBox.mat');
% coh2FB = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_2nd_cohort\upright\data\patchSetAdam\lfwSingle50000\imgHitsFaceBox.mat');
% 
% all_subj_FB_rerun = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\imgHitsFaceBox.mat');
% all_subj_FB_manual.imgHitsFaceBox = [coh1FB.imgHitsFaceBox coh2FB.imgHitsFaceBox];
% 
% isequal(all_subj_FB_manual.imgHitsFaceBox,all_subj_FB_rerun.imgHitsFaceBox) % They are not equal
% DIFF = all_subj_FB_rerun.imgHitsFaceBox-all_subj_FB_manual.imgHitsFaceBox;
% imagesc(DIFF);
% figure
% plot(DIFF(:));
% title('Rerun imgHitsFB - Manual imgHitsFB');
% % ylim([-0.001 0.001]);
% display(['Max diff = ' num2str(max(abs(DIFF(:))))]);
% 
% 
% %imgHits Wedge
% clear; close all;
% coh1Wedge = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\upright\data\patchSetAdam\lfwSingle50000\imgHitsWedge.mat');
% coh2Wedge = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_2nd_cohort\upright\data\patchSetAdam\lfwSingle50000\imgHitsWedge.mat');
% 
% all_subj_Wedge_rerun = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\imgHitsWedge.mat');
% all_subj_Wedge_manual = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\imgHitsWedge.mat');
% isequal(all_subj_Wedge_manual.imgHitsWedge,all_subj_Wedge_rerun.imgHitsWedge) % They are not equal
% 
% DIFF = all_subj_Wedge_rerun.imgHitsWedge - ...
%        all_subj_Wedge_manual.imgHitsWedge;
% imagesc(DIFF);
% figure
% plot(DIFF(:));
% title('Wedge: Manual C2f vs. Rerun C2');
% % ylim([-0.001 0.001]);
% display(['Manual C2f vs. Rerun C2, Max diff = ' num2str(max(abs(DIFF(:))))]);
% 
% %% Compare bestBands and bestLoc
% clear; clc; close all;
% 
% % inverted
% coh1 = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\inverted\data\patchSetAdam\lfwSingle50000\bestLocC2f.mat');
% coh2 = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_2nd_cohort\inverted\data\patchSetAdam\lfwSingle50000\bestLocC2f.mat');
% all_rerun = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\inverted\data\patchSetAdam\lfwSingle50000\bestLocC2f.mat');
% 
% manual = [coh1.bestLoc coh2.bestLoc];
% isequal(manual,all_rerun.bestLoc)
% % they're equal
% 
% %% Compare exptDesign files.
% clear; clc; close all;
% 
% coh1 = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\inverted\exptDesign.mat');
% coh2 = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_2nd_cohort\inverted\exptDesign.mat');
% allS = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\inverted\exptDesign.mat');
% 
% %coh 1
% isequal(allS.bgName(1:399),coh1.bgName)
% isequal(allS.faceName(1:399),coh1.faceName)
% isequal(allS.faceOrient(1:399),coh1.faceOrient)
% isequal(allS.imageDim(1:399),coh1.imageDim)
% isequal(allS.position(1:399),coh1.position)
% isequal(allS.positionAngle(1:399),coh1.positionAngle)
% isequal(allS.mask(1:399),coh1.mask)
% isequal(allS.originalIdx(1:399),coh1.originalIdx)
% isequal(allS.quadrant(1:399),coh1.quadrant)
% isequal(allS.faceImg(1:399),coh1.faceImg)
% 
% %coh 2
% isequal(allS.bgName(400:800),coh2.bgName)
% isequal(allS.faceName(400:800),coh2.faceName)
% isequal(allS.faceOrient(400:800),coh2.faceOrient)
% isequal(allS.imageDim(400:800),coh2.imageDim)
% isequal(allS.position(400:800),coh2.position)
% isequal(allS.positionAngle(400:800),coh2.positionAngle)
% isequal(allS.mask(400:800),coh2.mask)
% isequal(allS.originalIdx(400:800),coh2.originalIdx) % this should be different...
% isequal(allS.quadrant(400:800),coh2.quadrant)
% isequal(allS.faceImg(400:800),coh2.faceImg)

%% Check image sizes and how that impacted localization accuracy.
% clear; clc; close all;
% 
% condition = 'part2Inverted_2nd_cohort/inverted';
% 
% % Training run
% load(fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\',condition,'\data\patchSetAdam\lfwSingle50000\facesLoc.mat'));
% 
% 
% facesLoc = convertFacesLocAnnulusFixedContrast(facesLoc,ispc);
% for iImg = 1:length(facesLoc{1})
%     iImg
%    imgSizes(iImg,1:2) = size(imread(facesLoc{1}{iImg})); 
%     
% end
% [uniqueSizes ia ic] = unique(imgSizes,'rows');




