% This script will check whether there is a consistent difference in the
% performance of top patches on the variously sized images from the part2up
% image-set of the CRCNS psychophisics experiment.

% The part2up had three different sizes of images:
% - 
% -
% -

% The script should also make sure that any difference in performance over
% these images isn't due to luminance differences or frequencies of faceIDs
% or background IDs being used.

clear; clc; close all;

%% First, see if three sets consistently differ on luminance, faceID, or bgID.

% Load facesLoc and exptDesign files.
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\facesLoc.mat');
facesLoc = convertFacesLocAnnulusFixedContrast(facesLoc,ispc);
exptDesign = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\exptDesign.mat');
nImgs = length(facesLoc{1});
% Get sizes of images. This has been done and added to exptDesign file.
% for iImg = 1:length(facesLoc{1})
%     iImg
%     dims(iImg,1:2) = size(imread(facesLoc{1}{iImg}));
% end

[uni_dims,ia,ic]= unique(exptDesign.dims,'rows');
nSize1 = numel(find(ic == 1));
nSize2 = numel(find(ic == 2));
nSize3 = numel(find(ic == 3));

idxSize1 = ia(1):ia(2)-1;
idxSize2 = ia(2):ia(3)-1;
idxSize3 = ia(3):nImgs;
assert(isequal((nSize1+nSize2+nSize3),nImgs))

%% Calculate and plot luminances of different image sets.
% xMin = 0; xMax = 1;
% yMin = 0; yMax = 140;
% 
% subplot(1,3,1)
% hist(exptDesign.michelson_values(idxSize1))
% xlim([xMin xMax])
% ylim([yMin yMax])
% subplot(1,3,2)
% hist(exptDesign.michelson_values(idxSize2))
% xlim([xMin xMax])
% ylim([yMin yMax])
% subplot(1,3,3)
% hist(exptDesign.michelson_values(idxSize3))
% xlim([xMin xMax])
% ylim([yMin yMax])

%% Compare localization on face-box data
locDataFaceBox = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat');
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\imgHitsFaceBox.mat');

% Average over all patches
locSize1 = mean(locDataFaceBox.sumStatsImg(idxSize1));
locSize2 = mean(locDataFaceBox.sumStatsImg(idxSize2));
locSize3 = mean(locDataFaceBox.sumStatsImg(idxSize3));

% Take top 1000
testingLocData = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\imageDifficultyData_FaceBox_50000_Patches.mat');
idx_top_patches = testingLocData.IndPatch(1:1000);

imgHitsFaceBox_topPatches = imgHitsFaceBox(idx_top_patches,:);
sumStatsImg_top_patches = mean(imgHitsFaceBox_topPatches,1)*100;
locSize1_TP = mean(sumStatsImg_top_patches(idxSize1));
locSize2_TP = mean(sumStatsImg_top_patches(idxSize2));
locSize3_TP = mean(sumStatsImg_top_patches(idxSize3));




