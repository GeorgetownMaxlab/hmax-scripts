% %% Visualizing S1 and C1 of images. Useful for developing the HMAX figure for the paper
% % close;
% % iImg = 1;
% % iBand = 1;
% % iScale = 1;
% % iOrient = 1;
% % 
% % img = s1r{1,iImg}{1,iBand}{1,iScale}{1,iOrient};
% % 
% % % crop the image
% % nCrop = 40;
% % imgCrop = img(nCrop:end-nCrop,nCrop:end-nCrop);
% % 
% % subplot(1,2,1)
% % imagesc(img);
% % subplot(1,2,2)
% % imagesc(imgCrop);
% 
% %% Visualizing C1 representations
% % close;
% % iImg = 1;
% % iBand = 9;
% % iScale = 1;
% % iOrient = 1;
% % 
% % % nCrop = iBand*5;
% % % imgC1Crop = imgC1(nCrop:end-nCrop,nCrop:end-nCrop);
% % 
% % imgC1 = c1r{1,iImg}{1,iBand}; % includes all 4 orientations
% % 
% % subplot(2,2,1)
% % imagesc(imgC1(:,:,iOrient));
% % subplot(2,2,2)
% % imagesc(imgC1(:,:,iOrient+1));
% % subplot(2,2,3)
% % imagesc(imgC1(:,:,iOrient+2));
% % subplot(2,2,4)
% % imagesc(imgC1(:,:,iOrient+3));
% 
% %% image resizing problems
% clear; close all;
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\upright\facesLoc.mat')
% idx1 = 1;
% idx2 = 344;
% maxSize = 579;
% 
% img1 = imread(facesLoc{1}{idx1});
% img2 = imread(facesLoc{1}{idx2});
% 
% img1res = resizeImage(img1,maxSize);
% img2res = resizeImage(img2,maxSize);
% 
% imshow(uint8(img1res))
% figure
% imshow(uint8(img2res))
% 
% %% visualize differences in size of faces after resizing
% clear; clc; close all;
% maxSize = 579;
% 
% % training. Originals are 730x927 pixels
% exptDesign_Training = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\exptDesign.mat');
% facesLoc_Training = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\facesLoc.mat');
% facesLoc_Training = facesLoc_Training.facesLoc;
% 
% faceName = exptDesign_Training.faceName(1);
% imgOrig_training = imread(facesLoc_Training{1}{1});
% imgResi_training = resizeImage(imgOrig_training,maxSize);
% 
% 
% 
% 
% CUR_annulusWedgeAndBoxLocalization_resizing(50000,'annulusExptFixedContrast/simulation1/part2Inverted/upright/data/patchSetAdam/lfwSingle50000','annulusExptFixedContrast/simulation1/part2Inverted/upright/')
% CUR_annulusWedgeAndBoxLocalization_resizing(50000,'annulusExptFixedContrast/simulation1/part2Inverted/inverted/data/patchSetAdam/lfwSingle50000','annulusExptFixedContrast/simulation1/part2Inverted/inverted/')
% 
% 
% CUR_annulusWedgeAndBoxLocalization_resizing(50000,'annulusExptFixedContrast/simulation1/part2Inverted_2nd_cohort/upright/data/patchSetAdam/lfwSingle50000','annulusExptFixedContrast/simulation1/part2Inverted_2nd_cohort/upright/')
% CUR_annulusWedgeAndBoxLocalization_resizing(50000,'annulusExptFixedContrast/simulation1/part2Inverted_2nd_cohort/inverted/data/patchSetAdam/lfwSingle50000','annulusExptFixedContrast/simulation1/part2Inverted_2nd_cohort/inverted/')
% 
% CUR_annulusWedgeAndBoxLocalization_resizing(50000,'annulusExptFixedContrast/simulation1/part2Inverted_all_subj/upright/data/patchSetAdam/lfwSingle50000','annulusExptFixedContrast/simulation1/part2Inverted_all_subj/upright/')
% CUR_annulusWedgeAndBoxLocalization_resizing(50000,'annulusExptFixedContrast/simulation1/part2Inverted_all_subj/inverted/data/patchSetAdam/lfwSingle50000','annulusExptFixedContrast/simulation1/part2Inverted_all_subj/inverted/')
% 
%% Compare before/after switching of the training and testing sets.
clear; clc; close all;
scaleMin = 10;
scaleMax = 60;
% Before: 

% Get indices of top 1000 patches on training set.
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat','IndPatch')
idx_top_training = IndPatch(1:1000);

load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat','sumStatsPatch')
top_training_patches_on_testing = sumStatsPatch(idx_top_training);

load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat','sumStatsPatch')
top_training_patches_on_part2up = sumStatsPatch(idx_top_training);

scatter(top_training_patches_on_testing,top_training_patches_on_part2up,...
        20,'MarkerEdgeColor','k',...
              'MarkerFaceColor','b'...
              )
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
hold on
plot(scaleMin:scaleMax,scaleMin:scaleMax)
hold off
title('Before the switch')
xlabel('Top 1000 patches on old testing set')
ylabel('Top 1000 patches on part2up set')

% after
% Get indices of top 1000 patches on training set.
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat','IndPatch')
idx_top_testing = IndPatch(1:1000);

load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat','sumStatsPatch')
top_testing_patches_on_training = sumStatsPatch(idx_top_testing);

load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat','sumStatsPatch')
top_testing_patches_on_part2up = sumStatsPatch(idx_top_testing);

figure
scatter(top_testing_patches_on_training,top_testing_patches_on_part2up,...
            20,'MarkerEdgeColor','k',...
              'MarkerFaceColor','b'...
              )
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
hold on
plot(scaleMin:scaleMax,scaleMin:scaleMax)
title('After the switch')
xlabel('Top 1000 patches on old training set')
ylabel('Top 1000 patches on part2up set')