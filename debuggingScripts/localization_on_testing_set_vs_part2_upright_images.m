%% Compare the singles performance on testing set and part2 upright images.

% For some reason, they are different by about 10%. Luminances don't seem
% to differ that much. So:
% 1. Take maybe 100 best patches, on the training set face-box
% localization.
% 2. Run C2 values for them through all the images.
% 3. Run localization while checking step by step that everything is correct.
% 4. If results differ, break down the performances by bg, faceID, or luminance of image...

%% Going back to raw data, training set localization.
clear; clc; close all;
nBestPatches = 1000;
xMax = 1000;

% load the localization data
training_data_fb    = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat',...
                      'IndPatch','sortSumStatsPatch','sumStatsPatch');
testing_data_fb     = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat',...
                      'IndPatch','sortSumStatsPatch','sumStatsPatch');
part2up_data_fb     = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat',...
                      'IndPatch','sortSumStatsPatch','sumStatsPatch');
training_data_wedge = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat',...
                      'IndPatch','sortSumStatsPatch','sumStatsPatch');
testing_data_wedge  = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat',...
                      'IndPatch','sortSumStatsPatch','sumStatsPatch');
part2up_data_wedge  = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat',...
                      'IndPatch','sortSumStatsPatch','sumStatsPatch');                 
                  
idx_best = testing_data_fb.IndPatch(1:nBestPatches); % best n patches, determined by training set face-box localization

% Now look at how these top patches do with wedge-localization on all three
% sets: training, testing, and part2 upright images.
subplot(2,1,1)
plot(training_data_wedge.sumStatsPatch(idx_best))
hold on
plot(testing_data_wedge.sumStatsPatch(idx_best))
plot(part2up_data_wedge.sumStatsPatch(idx_best),'g')
legend('Training','Testing','Part2 Up')
xlim([0 xMax])
xlabel('Patches')
ylabel('Performance')
title('Wedge Localization')

% Do the same for face-box localization
subplot(2,1,2)
plot(training_data_fb.sumStatsPatch(idx_best))
hold on
plot(testing_data_fb.sumStatsPatch(idx_best))
plot(part2up_data_fb.sumStatsPatch(idx_best),'g')
legend('Training','Testing','Part2 Up')
xlim([0 xMax])
xlabel('Patches')
ylabel('Performance')
title('Face Box Localization')
% Result: overall, still part2up is lower than testing set
% 
% 
%% For different sized images, compare face-box dimensions, original and resized.
% % The resized ones should match.
% clear; clc;
% large = load('C:\Users\levan\Desktop\largeImg.mat');
% medium = load('C:\Users\levan\Desktop\mediumImg.mat');
% small = load('C:\Users\levan\Desktop\smallImg.mat');
% 
% width_s  = small.faceBoxResized(2) - small.faceBoxResized(1)
% height_s = small.faceBoxResized(4) - small.faceBoxResized(3)
% 
% width_m  = medium.faceBoxResized(2) - medium.faceBoxResized(1)
% height_m = medium.faceBoxResized(4) - medium.faceBoxResized(3)
% 
% width_l  = large.faceBoxResized(2) - large.faceBoxResized(1)
% height_l = large.faceBoxResized(4) - large.faceBoxResized(3)
% % Result: they are largely the same. With about max 2.5 pixel difference.
% % Idea: define the face box after resizing has happened.
% 
% %% Does HMAX do same kind of resizing as the localization code?
% clear; clc;
% CUR_runAnnulusExpt('annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\facesLoc.mat', ...
%                    'annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\sandbox', ...
%                    'annulusExptFixedContrast\simulation1\part2Inverted_all_subj',1,1,800,800,1)
% % Result: yes.




