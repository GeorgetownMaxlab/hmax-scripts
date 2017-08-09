%% Plot the cross-validation results for doublets.
% clear; clc; close;
% lineWidth = 1;
% set(groot,'defaultLineLineWidth',lineWidth)
% 
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling\doublets\1000TPatches1000CPatches\combMatrix_output.mat')
% 
% nTrainingImgs = 744;
% nTestingImgs  = 720;
% 
% PER = [combMatrix_output(:,4)/nTrainingImgs*100 ...
%        combMatrix_output(:,5)/nTestingImgs*100];
% 
% % resort based on testing set localization
% [~,ind] = sort(PER(:,2),'descend');
% PER = PER(ind,:);
%    
% nPlotted = 1000000;   
% 
% plot(PER(1:nPlotted,2));
% hold on
% plot(PER(1:nPlotted,1));
% title(['TOP ' int2str(nPlotted) ' doublets sorted based on testing set']);
% legend('Testing','Training');
% 
% ylabel('Percentage Hit')


%% Plot the cross-validation results for TRIPLETS.
% clear; clc; close;
% lineWidth = 1;
% set(groot,'defaultLineLineWidth',lineWidth)
% 
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling\doublets\1000TPatches1000CPatches\triplets/combined_100TPatches1000CPatches_and_1000TPatches100CPatches/combMatrix_output.mat')
% 
% nTrainingImgs = 744;
% nTestingImgs  = 720;
% 
% PER = [combMatrix_output(:,7)/nTrainingImgs*100 ...
%        combMatrix_output(:,8)/nTestingImgs*100];
% 
% % resort based on testing set localization
% [~,ind] = sort(PER(:,2),'descend');
% PER = PER(ind,:);
%    
% nPlotted = 1000;   
% 
% plot(PER(1:nPlotted,1),'r');
% hold on
% plot(PER(1:nPlotted,2),'b');
% title(['Top ' int2str(nPlotted) ' triplet sorted based on testing set']);
% legend('Training','Testing');
% 
% ylabel('Percentage Hit')

%% Combine the different runs of triplet patches on the testing set.
% clear; clc; close;
% loadLoc1 = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling\doublets\1000TPatches1000CPatches\triplets\100TPatches1000CPatches/';
% loadLoc2 = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling\doublets\1000TPatches1000CPatches\triplets\1000TPatches100CPatches/';
% 
% combMatrix_output1 = load([loadLoc1 'combMatrix_output']);
% combMatrix_output1 = combMatrix_output1.combMatrix_output;
% combMatrix_output2 = load([loadLoc2 'combMatrix_output']);
% combMatrix_output2 = combMatrix_output2.combMatrix_output;
% 
% % Find the common patches from the two runs.
% [common_triplets,ia,ib] = intersect(combMatrix_output1,combMatrix_output2,'rows');
% 
% % Find indices of the unique patches within each combMatrix
% ind_of_unique_triplets1 = setdiff(1:length(combMatrix_output1),ia);
% ind_of_unique_triplets2 = setdiff(1:length(combMatrix_output2),ib);
% 
% combined_combMatrix = [combMatrix_output1(ind_of_unique_triplets1,:);...
%                        combMatrix_output2(ind_of_unique_triplets2,:);...
%                        common_triplets];
%  

%% plot inverted vs. upright comparison
% close all; clc; clear;
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\upright\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat')
% idxUP  = IndPatch;
% perfUP = sortSumStatsPatch;
% 
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\inverted\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat')
% 
% perfInv = sortSumStatsPatch;
% perfInv_unsorted = sumStatsPatch;
% perfInv_sortedByUpright = perfInv_unsorted(idxUP);

%% start figure
% figure
% scatter(perfUP,perfInv_sortedByUpright,'k','.')
% title('Scatterplot')
% xlabel('UPRIGHT localization')
% ylabel('INVERTED localization')
% hold on
% plot(10:40,10:40,'r','LineWidth',1);
% legend('Patches','45 degree line')
% 
% figure
% 
% plot(perfInv_sortedByUpright)
% hold on
% plot(perfUP,'LineWidth',2)
% title('Overlay of localizations')
% xlabel('Patches')
% ylabel('Localization')
% legend('Inverted','Upright');
% 
% figure
% 
% plot(perfInv(1:500),'LineWidth',1)
% hold on
% plot(perfUP(1:500),'LineWidth',1)
% title('Top 500 Patches on Upright and top 500 patches on Inverted')
% xlabel('Patches');
% ylabel('Localization')
% legend('Top 500 patches on INVERTED set','Top 500 patches on UPRIGHT set');



%% Use the bestPatches data structure to evaluate the upright/inverted dataset
% clear; close all; clc;
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_faceBox\bestPatches.mat')
% 
% % EVALUTE SINGLES DATA
% 
% % load performance of all 50,000 patches on upright and inverted images
% all_singles_upright_loc = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\upright\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat',...
%     'sumStatsPatch');
% all_singles_upright_loc = all_singles_upright_loc.sumStatsPatch;
% 
% all_singles_inverted_loc = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\inverted\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat',...
%     'sumStatsPatch');
% all_singles_inverted_loc = all_singles_inverted_loc.sumStatsPatch;
% 
% % look at only best singles' peformance on upright and inverted
% best_singles_on_upright_loc  = all_singles_upright_loc(bestSingles.idx_crossValid);
% best_singles_on_inverted_loc = all_singles_inverted_loc(bestSingles.idx_crossValid);
% 
% % plot(best_singles_on_upright_loc)
% % hold on
% % plot(best_singles_on_inverted_loc)
% % figure
% % scatter(best_singles_on_upright_loc,best_singles_on_inverted_loc)




% %% EVALUATE TRIPLET DATA
% 
% clear; close all; clc;
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_faceBox\bestPatches.mat')
% % 
% %     nTPatches = 1000;
% %     nCPatches = 1000;
% 
% %%%%%%%%%%%%%%%% EVALUATE UPRIGHT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% type_localization = 'scaling_FaceBox'; %input('Either ''scaling_FaceBox'' or ''scaling_wedge''\n'); % this is also appended to save dir.
% 
% loadFolder_singles_upright  = 'simulation1/part2Inverted/upright/data/patchSetAdam/lfwSingle50000';
% loadFolder_singles_inverted = 'simulation1/part2Inverted/inverted/data/patchSetAdam/lfwSingle50000';
% 
% saveFolder = ['simulation1/part2Inverted/upright/data/patchSetAdam/lfwSingle50000/'...
%               type_localization '/doublets/']; % BOTH UPRIGHT AND INVERTED GET SAVED HERE!!!!
% 
% % if ispc == 1
%     loadLoc_singles_upright     = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles_upright '\'];
%     loadLoc_singles_inverted    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles_inverted '\'];
% 
%     saveLoc_upright            = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' saveFolder '\'];
% %     combMatrixLoc_doublets = ['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1/training/data\patchSetAdam\lfwSingle50000\'...
% %                           type_localization '\doublets/' int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches\'];
% % else    
% %     loadLoc_singles_upright    = ['/home/levan/HMAX/annulusExptFixedContrast/' loadFolder_singles_upright '/'];
% %     saveLoc_upright            = ['/home/levan/HMAX/annulusExptFixedContrast/' saveFolder '/'];
% %     combMatrixLoc_doublets = ['/home/levan/HMAX/annulusExptFixedContrast/simulation1/training/data/patchSetAdam/lfwSingle50000/'...
% %                           type_localization '/doublets/' int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches/'];
% % end
% 
% if ~exist(saveLoc_upright,'dir')
%     mkdir(saveLoc_upright)
% end
% 
% c2f_upright_singles = load([loadLoc_singles_upright 'c2f']);
% c2f_upright_singles = c2f_upright_singles.c2f;
% imgHitsWedge_upright_singles = load([loadLoc_singles_upright 'imgHitsWedge']);
% imgHitsWedge_upright_singles = imgHitsWedge_upright_singles.imgHitsWedge;
% nImgs_upright = size(c2f_upright_singles,2);
% 
% % Now load inverted data.
% c2f_inverted_singles = load([loadLoc_singles_inverted 'c2f']);
% c2f_inverted_singles = c2f_inverted_singles.c2f;
% imgHitsWedge_inverted_singles = load([loadLoc_singles_inverted 'imgHitsWedge']);
% imgHitsWedge_inverted_singles = imgHitsWedge_inverted_singles.imgHitsWedge;
% nImgs_inverted = size(c2f_inverted_singles,2);
% 
% 
% 
% % Main script
% nTriplets         = length(bestTriplets.idx_crossValid);
% % combMatrix_output = zeros(nDoublets,5);
% 
% % sort bestTriplets
% [~,ind] = sort(bestTriplets.triplet_testing_crossValid_wedge_performance,'descend');
% bestTriplets.triplet_testing_crossValid_wedge_performance = bestTriplets.triplet_testing_crossValid_wedge_performance(ind);
% bestTriplets.triplet_training_crossValid_facebox_performance = bestTriplets.triplet_training_crossValid_facebox_performance(ind);
% bestTriplets.idx_crossValid = bestTriplets.idx_crossValid(ind,:);
% bestTriplets.patch2_scaling_factor = bestTriplets.patch2_scaling_factor(ind);
% bestTriplets.patch3_scaling_factor = bestTriplets.patch3_scaling_factor(ind);
% 
% % start script
% 
% for iTriplet = 1:nTriplets
%     if mod(iTriplet,100) == 0
%         iTriplet
%     end
%     pushValue_patch2 = 0.001; %for patch #2
%     pushValue_patch3 = 0.001; %for patch #3
%     
%     % Use the pushValue to make sure two C2 outputs aren't exactly the same
%     if bestTriplets.patch2_scaling_factor(iTriplet) < 1
%         pushValue_patch2 = -pushValue_patch2;
%     end
%     if bestTriplets.patch3_scaling_factor(iTriplet) < 1
%         pushValue_patch3 = -pushValue_patch3;
%     end
%     
%     newC2_Scaled_upright    = [c2f_upright_singles(bestTriplets.idx_crossValid(iTriplet,1),:);...
%                                c2f_upright_singles(bestTriplets.idx_crossValid(iTriplet,2),:)...
%                                .* bestTriplets.patch2_scaling_factor(iTriplet) + pushValue_patch2;...
%                                c2f_upright_singles(bestTriplets.idx_crossValid(iTriplet,3),:)...
%                                .* bestTriplets.patch3_scaling_factor(iTriplet) + pushValue_patch3];
%            
%     newImgHitsWedge_upright = [imgHitsWedge_upright_singles(bestTriplets.idx_crossValid(iTriplet,1),:); ...
%                                imgHitsWedge_upright_singles(bestTriplets.idx_crossValid(iTriplet,2),:);...
%                                imgHitsWedge_upright_singles(bestTriplets.idx_crossValid(iTriplet,3),:)];
%     
%     [newC2_min_Scaled_upright(1,:),chosenPatchIdx_upright(1,:)] = min(newC2_Scaled_upright,[],1);
%     
%     newImgHitsWedge_Scaled_upright = zeros(1,nImgs_upright); % preallocate
%     for iImg = 1:nImgs_upright
%         newImgHitsWedge_Scaled_upright(1,iImg) = newImgHitsWedge_upright(chosenPatchIdx_upright(1,iImg),iImg);
%     end
%     
%     bestTriplets.triplets_upright(iTriplet) = nnz(newImgHitsWedge_Scaled_upright)*100/nImgs_upright;
%     
%     
%     newC2_Scaled_upright = [];
%     newImgHitsWedge_upright = [];
%     chosenPatchIdx_upright = [];
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%% INVERTED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     newC2_Scaled_inverted    = [c2f_inverted_singles(bestTriplets.idx_crossValid(iTriplet,1),:);...
%                                 c2f_inverted_singles(bestTriplets.idx_crossValid(iTriplet,2),:)...
%                                 .* bestTriplets.patch2_scaling_factor(iTriplet) + pushValue]; 
%            
%     newImgHitsWedge_inverted = [imgHitsWedge_inverted_singles(bestTriplets.idx_crossValid(iTriplet,1),:); ...
%                                 imgHitsWedge_inverted_singles(bestTriplets.idx_crossValid(iTriplet,1),:)];
%     
%     [newC2_min_Scaled_inverted(1,:),chosenPatchIdx_inverted(1,:)] = min(newC2_Scaled_inverted,[],1);
%     
%     newImgHitsWedge_Scaled_inverted = zeros(1,nImgs_inverted); % preallocate
%     for iImg = 1:nImgs_inverted
%         newImgHitsWedge_Scaled_inverted(1,iImg) = newImgHitsWedge_inverted(chosenPatchIdx_inverted(1,iImg),iImg);
%     end
%     
%     bestTriplets.triplets_inverted(iTriplet) = nnz(newImgHitsWedge_Scaled_inverted)*100/nImgs_inverted;
%     
%     newC2_Scaled_inverted = [];
%     newImgHitsWedge_inverted = [];
%     chosenPatchIdx_inverted = []; 
% end
% 
% %% now plot...
% scatter(bestTriplets.triplets_inverted,bestTriplets.triplets_upright,...
%         20,'MarkerEdgeColor','k',...
%               'MarkerFaceColor','b'...
%               )
% xlabel('Inverted Localization')
% ylabel('Upright Localization')
% title(['Best ' int2str(nTriplets) ' triplets, after crossvalidation'])
% xlim([15 45])
% ylim([15 45])
% grid on

%% combine imgHits maps from 2 cohorts
% clear; clc; close;
% 
% loadFolder_singles_upright_coh1  = 'simulation1/part2Inverted/upright/data/patchSetAdam/lfwSingle50000';
% loadFolder_singles_inverted_coh1 = 'simulation1/part2Inverted/inverted/data/patchSetAdam/lfwSingle50000';
% 
%     loadLoc_singles_upright_coh1     = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles_upright_coh1  '\'];
%     loadLoc_singles_inverted_coh1    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles_inverted_coh1 '\'];
% 
% loadFolder_singles_upright_coh2  = 'simulation1/part2Inverted_2nd_cohort/upright/data/patchSetAdam/lfwSingle50000';
% loadFolder_singles_inverted_coh2 = 'simulation1/part2Inverted_2nd_cohort/inverted/data/patchSetAdam/lfwSingle50000';
% 
%     loadLoc_singles_upright_coh2     = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles_upright_coh2  '\'];
%     loadLoc_singles_inverted_coh2    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles_inverted_coh2 '\'];
% 
% % COMBINE INVERTED DATA
% coh1_imgHitsWedge_inv = load([loadLoc_singles_inverted_coh1 'imgHitsWedge.mat']);
% coh1_imgHitsWedge_inv = coh1_imgHitsWedge_inv.imgHitsWedge;
% coh2_imgHitsWedge_inv = load([loadLoc_singles_inverted_coh2 'imgHitsWedge.mat']);
% coh2_imgHitsWedge_inv = coh2_imgHitsWedge_inv.imgHitsWedge;
% 
% imgHitsWedge = [coh1_imgHitsWedge_inv coh2_imgHitsWedge_inv];
% save('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\inverted\imgHitsWedge.mat','imgHitsWedge');
% 
% clear imgHitsWedge coh1_imgHitsWedge_inv coh2_imgHitsWedge_inv
% 
% % COMBINE UPRIGHT DATA
% coh1_imgHitsWedge_up = load([loadLoc_singles_upright_coh1 'imgHitsWedge.mat']);
% coh1_imgHitsWedge_up = coh1_imgHitsWedge_up.imgHitsWedge;
% coh2_imgHitsWedge_up = load([loadLoc_singles_upright_coh2 'imgHitsWedge.mat']);
% coh2_imgHitsWedge_up = coh2_imgHitsWedge_up.imgHitsWedge;
% 
% imgHitsWedge = [coh1_imgHitsWedge_up coh2_imgHitsWedge_up];
% save('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\imgHitsWedge.mat','imgHitsWedge');

%% combine C2 files from 2 cohorts
clear; clc; close;

loadFolder_singles_upright_coh1  = 'simulation1/part2Inverted/upright/data/patchSetAdam/lfwSingle50000';
loadFolder_singles_inverted_coh1 = 'simulation1/part2Inverted/inverted/data/patchSetAdam/lfwSingle50000';

    loadLoc_singles_upright_coh1     = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles_upright_coh1  '\'];
    loadLoc_singles_inverted_coh1    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles_inverted_coh1 '\'];

loadFolder_singles_upright_coh2  = 'simulation1/part2Inverted_2nd_cohort/upright/data/patchSetAdam/lfwSingle50000';
loadFolder_singles_inverted_coh2 = 'simulation1/part2Inverted_2nd_cohort/inverted/data/patchSetAdam/lfwSingle50000';

    loadLoc_singles_upright_coh2     = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles_upright_coh2  '\'];
    loadLoc_singles_inverted_coh2    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles_inverted_coh2 '\'];

% COMBINE INVERTED DATA
coh1_c2f_inv = load([loadLoc_singles_inverted_coh1 'c2f.mat']);
coh1_c2f_inv = coh1_c2f_inv.c2f;
coh2_c2f_inv = load([loadLoc_singles_inverted_coh2 'c2f.mat']);
coh2_c2f_inv = coh2_c2f_inv.c2f;

c2f = [coh1_c2f_inv coh2_c2f_inv];
save('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\inverted\c2f.mat','c2f');

clear c2f coh1_c2f_inv coh2_c2f_inv

% COMBINE UPRIGHT DATA
coh1_c2f_up = load([loadLoc_singles_upright_coh1 'c2f.mat']);
coh1_c2f_up = coh1_c2f_up.c2f;
coh2_c2f_up = load([loadLoc_singles_upright_coh2 'c2f.mat']);
coh2_c2f_up = coh2_c2f_up.c2f;

c2f = [coh1_c2f_up coh2_c2f_up];
save('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\c2f.mat','c2f');













