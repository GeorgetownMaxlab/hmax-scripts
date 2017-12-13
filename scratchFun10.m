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
% clear; clc; close all;
% scaleMin = 10;
% scaleMax = 60;
% % Before:
%
% % Get indices of top 1000 patches on training set.
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat','IndPatch')
% idx_top_training = IndPatch(1:1000);
%
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat','sumStatsPatch')
% top_training_patches_on_testing = sumStatsPatch(idx_top_training);
%
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat','sumStatsPatch')
% top_training_patches_on_part2up = sumStatsPatch(idx_top_training);
%
% scatter(top_training_patches_on_testing,top_training_patches_on_part2up,...
%         20,'MarkerEdgeColor','k',...
%               'MarkerFaceColor','b'...
%               )
% xlim([scaleMin scaleMax])
% ylim([scaleMin scaleMax])
% grid on
% hold on
% plot(scaleMin:scaleMax,scaleMin:scaleMax)
% hold off
% title('Before the switch')
% xlabel('Top 1000 patches on old testing set')
% ylabel('Top 1000 patches on part2up set')
%
% % after
% % Get indices of top 1000 patches on training set.
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat','IndPatch')
% idx_top_testing = IndPatch(1:1000);
%
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat','sumStatsPatch')
% top_testing_patches_on_training = sumStatsPatch(idx_top_testing);
%
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat','sumStatsPatch')
% top_testing_patches_on_part2up = sumStatsPatch(idx_top_testing);
%
% figure
% scatter(top_testing_patches_on_training,top_testing_patches_on_part2up,...
%             20,'MarkerEdgeColor','k',...
%               'MarkerFaceColor','b'...
%               )
% xlim([scaleMin scaleMax])
% ylim([scaleMin scaleMax])
% grid on
% hold on
% plot(scaleMin:scaleMax,scaleMin:scaleMax)
% title('After the switch')
% xlabel('Top 1000 patches on old training set')
% ylabel('Top 1000 patches on part2up set')

%% Plot singles and doublets on the training/testing on Jacob's dataset
% clear; clc; dbstop if error;
%
% home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\';
% simulation = 'simulation3';
% condition  = 'part1upright';
% combination_type = 'find_CPatches';
% patches_type     = 'patchSet_3x2';
%
% nImgsTraining = 1659;
% nImgsTesting  = 1008;
% nPatches      = 25000;
%
% nTPatches     = 1000;
% nCPatches     = 100;
%
% scaleMin = 0;
% scaleMax = 60;
%
% % Load the combMatrix
% load(fullfile(home,simulation,condition,'data',patches_type,'lfwSingle50000',...
%               'combinations',combination_type,'doublets',...
%               [int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches'],...
%               'combMatrix_output.mat'));
%
% % Transform performances into percentages
% combMatrix_output(:,4) = combMatrix_output(:,4)*100/nImgsTraining;
% combMatrix_output(:,5) = combMatrix_output(:,5)*100/nImgsTesting;
%
% % Plot
% scatter(combMatrix_output(:,4),combMatrix_output(:,5),...
%         20,'MarkerEdgeColor','k',...
%               'MarkerFaceColor','b'...
%               )
% xlim([scaleMin scaleMax])
% ylim([scaleMin scaleMax])
% grid on
% hold on
% plot(scaleMin:scaleMax,scaleMin:scaleMax)
% hold off
% title('Generalization to Florence''s Images')
% xlabel('Face-box performance on Jacob''s training set')
% ylabel('Wedge performance on Florence''s annulus images')

%% Crop the masks and face images used by Florence.
% clear; clc; dbstop if error;
% 
% home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\face_images_from_Florence';
% 
% maskPaths = lsDir(fullfile(home,'MaskTokeep'),{'jpg'});
% facePaths = lsDir(fullfile(home,'used_in_psych'),{'jpg'});
% 
% distToBorder = 15; % how much space to leave in the cropped images.
% 
% for iImg = 1:length(facePaths)
%     
%     % Load the files
%     faceImg = imread(facePaths{iImg});
%     [pathstr,name,ext] = fileparts(facePaths{iImg});
%     maskImg = imread(fullfile(home,'MaskToKeep',[name ext]));
%     
%     [row,col] = find(maskImg > 50); % Using 50 because some masks have black backgrounds of value 12 instead of 0. 
%     
%     minCol = min(col); % leftmost edge of mask.
%     maxCol = max(col); % rightmost edge of mask.
%     minRow = min(row); % topmost edge.
%     maxRow = max(row); % bottommost edge.
%     
%     % Decide how much to subtract.
%     if minRow <= distToBorder
%         topCut = 0;
%     else
%         topCut = distToBorder;
%     end
%     
%     if size(maskImg,1) - maxRow <= distToBorder
%         botCut = 0;
%     else
%         botCut = distToBorder;
%     end
%     
%     % Do the crop
%     newMask =  maskImg((minRow - topCut):(size(maskImg) - botCut),...
%                        (minCol - distToBorder):(maxCol + distToBorder));
%     newFace =  faceImg((minRow - topCut):(size(maskImg) - botCut),...
%                        (minCol - distToBorder):(maxCol + distToBorder));
% %     imagesc(newMask);
%     
%     % Write the new mask
%     imwrite(newMask,fullfile(home,'MaskToKeep_cropped',[name '.png']));
%     imwrite(newFace,fullfile(home,'used_in_psych_cropped',[name '.png']));
%     
% end

%% Compare contrast distributions of faces in Florences images and my images.

% clear; clc; dbstop if error; %close all;
% 
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\exptDesign.mat')
% 
% 
% for iImg = 1:length(exptDesign)
%     
%     face_michelson(iImg) = (max(exptDesign(iImg).faceImg(:)) - min(exptDesign(iImg).faceImg(:)))/...
%                            (max(exptDesign(iImg).faceImg(:)) + min(exptDesign(iImg).faceImg(:)));
%                      
% end
% 
% figure
% hist(face_michelson,10)
% ylim([0 300]);
% 
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation4\control_v2\exptDesign.mat')
% 
% cellVersion = squeeze(struct2cell(exptDesign));
% ourMichelsons = cell2mat(cellVersion(8,:));
% 
% figure;
% hist(ourMichelsons,10)
% xlim([0 0.8])
% ylim([0 300]);

%%

% CUR_runAnnulusExpt2('annulusExptFixedContrast/simulation4/control_v2/facesLoc.mat',...
%                     'annulusExptFixedContrast/simulation4/control_v2/data/patchSet_3x2/lfwSingle50000',...
%                     'annulusExptFixedContrast/simulation4/control_v2/',...
%                     50000,6250,[],[],...
%                     766,383,12,...
%                     'patchSet_3x2',...
%                     0,579,1)

% CUR_runAnnulusExpt2('annulusExptFixedContrast/simulation4/control/facesLoc.mat',...
%                     'annulusExptFixedContrast/simulation4/control/data/patchSet_3x2/lfwSingle50000',...
%                     'annulusExptFixedContrast/simulation4/control/',...
%                     20,5,[],[],...
%                     20,5,3,...
%                     'patchSet_3x2',...
%                     0,579,1)

%% Plot performance of singles on Florences and our images
% images that were created with Jacob's bgs and Florences faces.
clear; clc; dbstop if error; %close all;

nPatches = 50000;

% Load set 1 data
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\data\patchSet_3x2\lfwSingle50000\fixedLocalization\patchPerformanceInfo_FaceBox.mat');

% Get the first nPatches patch performance.
[sorted_indices,idx] = sort(idx_best_patches,'ascend');
sumStatsPatch_set1 = sortSumStatsPatch(idx);
sumStatsPatch_set1 = sumStatsPatch_set1(1:nPatches);

% Load set 2 data.
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation5\training\data\patchSet_3x2\lfwSingle50000\fixedLocalization\patchPerformanceInfo_FaceBox.mat')
% Resort patches
[sorted,idx] = sort(idx_best_patches,'ascend');
sumStatsPatch_set2 = sortSumStatsPatch(idx);
sumStatsPatch_set2 = sumStatsPatch_set2(1:nPatches);

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
title('Single Patches. Simulation 5 vs Florence')
xlabel([ nPatches ' patches on simulation 5 set'])
ylabel([ nPatches ' patches on Florence''s set'])

%% Plot doublets on various sets of images
% clear; clc; dbstop if error;
% 
% home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\';
% simulation = 'simulation4';
% condition  = 'control_v2';
% combination_type = 'find_CPatches';
% perfUsed         = '_fbox_x_fbox';
% % perfUsed         = '';
% patches_type     = 'patchSet_3x2';
% 
% nImgsTraining = 1659;
% % nImgsTesting  = 1008;
% nImgsTesting  = 766;
% % nImgsTesting  = 923; % Florence's high contrast data.
% % nImgsTesting  = 1000;
% nPatches      = 25000;
% 
% nTPatches     = 1000;
% nCPatches     = 100;
% 
% scaleMin = 0;
% scaleMax = 60;
% 
% % Load the combMatrix
% load(fullfile(home,simulation,condition,'data',patches_type,'lfwSingle50000',...
%               'combinations',combination_type,'doublets',...
%               [int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches' perfUsed],...
%               'combMatrix_output.mat'));
% 
% % Transform performances into percentages
% combMatrix_output(:,4) = combMatrix_output(:,4)*100/nImgsTraining;
% combMatrix_output(:,5) = combMatrix_output(:,5)*100/nImgsTesting;
% 
% % Plot
% figure
% scatter(combMatrix_output(:,4),combMatrix_output(:,5),...
%         10,'MarkerEdgeColor','k',...
%               'MarkerFaceColor','y'...
%               )
% xlim([scaleMin scaleMax])
% ylim([scaleMin scaleMax])
% grid on
% hold on
% plot(scaleMin:scaleMax,scaleMin:scaleMax)
% hold off
% title('Doublet Generalization training vs Control Images')
% % xlabel('Face-box performance on Jacob''s training set')
% % ylabel('Face-box performance on Control annulus images')
% xlabel('Face-box performance on Jacob''s training set')
% ylabel('Face-box performance on Control set')
% 
% %% Plot doublet performance on Florence and Control side-by-side
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
