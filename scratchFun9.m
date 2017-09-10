%% get the up/inv images from EEG data
% clear; clc; close all;
% dbstop if error;
% 
% loadLoc = 'C:\Users\levan\HMAX\eeg_up_inv\raw_data';
% load('C:\Users\levan\HMAX\eeg_up_inv\face_orientation.mat')
% dataFiles = sort_nat(lsDir(loadLoc,{'mat'}));
% masterSet = [];
% 
% for i = 1:length(dataFiles)
%     i
%     load(dataFiles{i});
%     A = squeeze(struct2cell(trialOutput.trials));
%     A = A([1,5,6],:);
%     masterSet = [masterSet A];
%    
% end
% 
% % masterSet = [masterSet; num2cell(orientation(1:500))];
% masterSet = [masterSet; num2cell(orientation)];
% 
% % now, take out the 1 degree located data.
% masterSet(:,cell2mat(masterSet(1,:)) == 1) = [];
% 
% % separate the data into upright and inverted images
% upright  = masterSet(:,cell2mat(masterSet(4,:)) == 1);
% inverted = masterSet(:,cell2mat(masterSet(4,:)) == 2);
% 
% masterSet = [];
% 
% % now find unique face images, and keep only those.
% [~,ia,~] = unique(upright(3,:));
% upright = upright(:,ia);
% 
% [~,ia,~] = unique(inverted(3,:));
% inverted = inverted(:,ia);

%% extract images and save them, append face image names
% clear; clc; close all; 
% condition = 'upright'; % upright has to be manually changed to inverted below.
% load(['C:\Users\levan\HMAX\eeg_up_inv\' condition '\data_' condition '.mat'])
% 
% saveFolder = ['C:\Users\levan\HMAX\eeg_up_inv\' condition '\images\'];
% 
% if ~exist(saveFolder)
%     mkdir(saveFolder)
% end
% 
% for iImg = 1:length(upright)
%     
%     imwrite(uint8(upright{2,iImg}),...
%     [saveFolder condition '_image' int2str(iImg) ...
%     '_faceName_' upright{3,iImg}(1:end-4) '.png']);
% 
%     facesLoc{1}{iImg} = ...
%     [saveFolder condition '_image' int2str(iImg) ...
%     '_faceName_' upright{3,iImg}(1:end-4) '.png'];
% 
% end
% 
% save(['C:\Users\levan\HMAX\eeg_up_inv\' condition '\facesLoc_' condition '.mat']);

%% create exptDesign file for eeg images, just so localization works.

%% Extract pixel representations of all patches involved in best singles, doublets, and triplets.
% clear; clc;
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatches.mat')
% 
% unique_patch_idx = unique([bestSingles.idx_crossValid'; bestDoublets.idx_crossValid(:); bestTriplets.idx_crossValid(:)]);
% 
% CUR_patchImageExtraction('patchSetAdam',...
%                          'simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox',...
%                          unique_patch_idx);
%% extract pixel representations of best up-singles that pass tests
% clear; clc;
% dbstop if error;
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatches.mat')
% idx_original_s = bestSingles.idx_crossValid (preference_analysis.s_idx_up_sign_thresh);
% idx_original_d = bestDoublets.idx_crossValid(preference_analysis.d_idx_up_sign_thresh,:)';
% % idx_original_d = idx_original_d(:,1:500);
% idx_original_t = bestTriplets.idx_crossValid(preference_analysis.t_idx_up_sign_thresh,:)';
% idx_original_t = idx_original_t(:,1:500);
% CUR_patchImageExtraction('patchSetAdam',...
%                          'simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatchesInPixels\up_pref_singles_patchesInPixels',...
%                          idx_original_s); 
% CUR_patchImageExtraction('patchSetAdam',...
%                          'simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatchesInPixels\up_pref_doublets_patchesInPixels',...
%                          idx_original_d(:)); 
% CUR_patchImageExtraction('patchSetAdam',...
%                          'simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatchesInPixels\up_pref_triplets_patchesInPixels',...
%                          idx_original_t(:));   
% %% extract pixel representations of best inv-singles that pass tests
% clear; clc;
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatches.mat')
% idx_original_s = bestSingles.idx_crossValid (preference_analysis.s_idx_inv_sign_thresh);
% idx_original_d = bestDoublets.idx_crossValid(preference_analysis.d_idx_inv_sign_thresh,:)';
% idx_original_t = bestTriplets.idx_crossValid(preference_analysis.t_idx_inv_sign_thresh,:)';
% idx_original_t = idx_original_t(:,1:5000);
% CUR_patchImageExtraction('patchSetAdam',...
%                          'simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatchesInPixels\inv_pref_singles_patchesInPixels',...
%                          idx_original_s); 
% CUR_patchImageExtraction('patchSetAdam',...
%                          'simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatchesInPixels\inv_pref_doublets_patchesInPixels',...
%                          idx_original_d(:)); 
% CUR_patchImageExtraction('patchSetAdam',...
%                          'simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatchesInPixels\inv_pref_triplets_patchesInPixels',...
%                          idx_original_t(:));
% %% extract pixel representations of best neutral-singles that pass tests
% clear; clc;
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatches.mat')
% idx_original_s = bestSingles.idx_crossValid (preference_analysis.s_idx_neutral_thresh);
% idx_original_d = bestDoublets.idx_crossValid(preference_analysis.d_idx_neutral_thresh,:)';
% idx_original_t = bestTriplets.idx_crossValid(preference_analysis.t_idx_neutral_thresh,:)';
% idx_original_t = idx_original_t(:,1:500);
% CUR_patchImageExtraction('patchSetAdam',...
%                          'simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatchesInPixels\neutral_singles_patchesInPixels',...
%                          idx_original_s); 
% CUR_patchImageExtraction('patchSetAdam',...
%                          'simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatchesInPixels\neutral_doublets_patchesInPixels',...
%                          idx_original_d(:)); 
% CUR_patchImageExtraction('patchSetAdam',...
%                          'simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatchesInPixels\neutral_triplets_patchesInPixels',...
%                          idx_original_t(:));


%% SINGLES: plot the best patches, with patches showing up/inv preferences overlaid.
% clear; clc; close all;
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatches.mat')
% 
% % Plot lines for average subject performance on UPRIGHT
% scalePlot = 65;
% upHumanMean = 58.88;
% upHumanSEM  = 0.04; % 4% SEM
% 
% upHumanMeanplot = ones(1,scalePlot)*upHumanMean;
% upHumanSEMplot = upHumanMeanplot*upHumanSEM;
% boundedline(1:scalePlot,upHumanMeanplot,upHumanSEMplot,'-g');
% hold on;
% 
% % Plot lines for average subject performance on INVERTED
% upHumanMean = 55.1;
% upHumanSEM  = 0.04; % 4% SEM
% 
% upHumanMeanplot = ones(1,scalePlot)*upHumanMean;
% upHumanSEMplot = upHumanMeanplot*upHumanSEM;
% boundedline(upHumanMeanplot,1:scalePlot,upHumanSEMplot,'-b','orientation', 'horiz');
% hold on;
% 
% % Plot all in blue. Blue will represent neutral patches because up and inv
% % prefering ones will be plotted on top of all patches.
% scatter(bestSingles.singles_inverted,bestSingles.singles_upright,...
%         20,'MarkerEdgeColor','k',...
%               'MarkerFaceColor','b'...
%               )
% xlabel('Inverted Localization')
% ylabel('Upright Localization')
% title({['Best ' int2str(length(bestSingles.idx_crossValid)) ' singles, after crossvalidation'];'Data is Unthresholded'})
% xlim([15 scalePlot])
% ylim([15 scalePlot])
% grid on
% hold on
% 
% % plot upright preferers in green
% scatter(bestSingles.singles_inverted(preference_analysis.s_idx_up_sign),...
%         bestSingles.singles_upright (preference_analysis.s_idx_up_sign),...
%         20,'MarkerEdgeColor','k',...
%            'MarkerFaceColor','g'...
%         );
% % plot inverted preferers in red
% scatter(bestSingles.singles_inverted(preference_analysis.s_idx_inv_sign),...
%         bestSingles.singles_upright (preference_analysis.s_idx_inv_sign),...
%         20,'MarkerEdgeColor','k',...
%            'MarkerFaceColor','r'...
%         );
% % % plot neutrals in blue
% % scatter(bestSingles.singles_inverted(preference_analysis.s_idx_neutral),...
% %         bestSingles.singles_upright (preference_analysis.s_idx_neutral),...
% %         20,'MarkerEdgeColor','k',...
% %            'MarkerFaceColor','y'...
% %         );
% 
% plot(15:50,15:50,'k')
% legend('Human Upright SEM','Human Upright','Human Inverted SEM','Human on Inverted',...
%        [int2str(length(preference_analysis.s_idx_neutral))  ' Neutral Patches'],...
%        [int2str(length(preference_analysis.s_idx_up_sign))  ' Upright Preferers'],...
%        [int2str(length(preference_analysis.s_idx_inv_sign)) ' Inverted Preferers'],...
%        '45 degree line');                

%% DOUBLETS plot the best patches, with patches showing up/inv preferences overlaid.
clear; clc;
figure
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation4\testing\data\patchSet_3x2\lfwSingle50000\scaling_FaceBox\bestPatches.mat')

% Plot lines for average subject performance on UPRIGHT
scalePlot = 65;
upHumanMean = 58.88;
upHumanSEM  = 0.04; % 4% SEM

upHumanMeanplot = ones(1,scalePlot)*upHumanMean;
upHumanSEMplot = upHumanMeanplot*upHumanSEM;
boundedline(1:scalePlot,upHumanMeanplot,upHumanSEMplot,'-g');
hold on;

% Plot lines for average subject performance on INVERTED
upHumanMean = 55.1;
upHumanSEM  = 0.04; % 4% SEM

upHumanMeanplot = ones(1,scalePlot)*upHumanMean;
upHumanSEMplot = upHumanMeanplot*upHumanSEM;
boundedline(upHumanMeanplot,1:scalePlot,upHumanSEMplot,'-b','orientation', 'horiz');
hold on;

% Plot all in blue. Blue will represent neutral patches because up and inv
% prefering ones will be plotted on top of all patches.
scatter(bestDoublets.doublets_inverted,bestDoublets.doublets_upright,...
        20,'MarkerEdgeColor','k',...
           'MarkerFaceColor','b'...
        )
xlabel('Inverted Localization')
ylabel('Upright Localization')
title({['Best ' int2str(length(bestDoublets.idx_crossValid)) ' doublets, after crossvalidation'];'Data is Unthresholded'})
xlim([15 scalePlot])
ylim([15 scalePlot])
grid on
hold on

% plot upright preferers in green
scatter(bestDoublets.doublets_inverted(preference_analysis.d_idx_up_sign),...
        bestDoublets.doublets_upright (preference_analysis.d_idx_up_sign),...
        20,'MarkerEdgeColor','k',...
           'MarkerFaceColor','g'...
        );
% plot inverted preferers in red
scatter(bestDoublets.doublets_inverted(preference_analysis.d_idx_inv_sign),...
        bestDoublets.doublets_upright (preference_analysis.d_idx_inv_sign),...
        20,'MarkerEdgeColor','k',...
           'MarkerFaceColor','r'...
        );
% % plot neutrals in blue
% scatter(bestDoublets.doublets_inverted(preference_analysis.d_idx_neutral),...
%         bestDoublets.doublets_upright (preference_analysis.d_idx_neutral),...
%         20,'MarkerEdgeColor','k',...
%            'MarkerFaceColor','y'...
%         );

plot(15:50,15:50,'k')
legend('Human Upright SEM','Human Upright','Human Inverted SEM','Human on Inverted',...
       [int2str(length(preference_analysis.d_idx_neutral))  ' Neutral Patches'],...
       [int2str(length(preference_analysis.d_idx_up_sign))  ' Upright Preferers'],...
       [int2str(length(preference_analysis.d_idx_inv_sign)) ' Inverted Preferers'],...
       '45 degree line'); 
% 
%% TRIPLETS plot the best patches, with patches showing up/inv preferences overlaid.
% clear; clc;
% figure
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatches.mat')
% 
% % Plot lines for average subject performance on UPRIGHT
% scalePlot = 65;
% upHumanMean = 58.88;
% upHumanSEM  = 0.04; % 4% SEM
% 
% upHumanMeanplot = ones(1,scalePlot)*upHumanMean;
% upHumanSEMplot = upHumanMeanplot*upHumanSEM;
% boundedline(1:scalePlot,upHumanMeanplot,upHumanSEMplot,'-g');
% hold on;
% 
% % Plot lines for average subject performance on INVERTED
% upHumanMean = 55.1;
% upHumanSEM  = 0.04; % 4% SEM
% 
% upHumanMeanplot = ones(1,scalePlot)*upHumanMean;
% upHumanSEMplot = upHumanMeanplot*upHumanSEM;
% boundedline(upHumanMeanplot,1:scalePlot,upHumanSEMplot,'-b','orientation', 'horiz');
% hold on;
% 
% % Plot all in blue. Blue will represent neutral patches because up and inv
% % prefering ones will be plotted on top of all patches.
% scatter(bestTriplets.triplets_inverted,bestTriplets.triplets_upright,...
%         20,'MarkerEdgeColor','k',...
%            'MarkerFaceColor','b'...
%         )
% xlabel('Inverted Localization')
% ylabel('Upright Localization')
% title({['Best ' int2str(length(bestTriplets.idx_crossValid)) ' triplets, after crossvalidation'];'Data is Unthresholded'})
% xlim([15 scalePlot])
% ylim([15 scalePlot])
% grid on
% hold on
% 
% % plot upright preferers in green
% scatter(bestTriplets.triplets_inverted(preference_analysis.t_idx_up_sign),...
%         bestTriplets.triplets_upright (preference_analysis.t_idx_up_sign),...
%         20,'MarkerEdgeColor','k',...
%            'MarkerFaceColor','g'...
%         );
% % plot inverted preferers in red
% scatter(bestTriplets.triplets_inverted(preference_analysis.t_idx_inv_sign),...
%         bestTriplets.triplets_upright (preference_analysis.t_idx_inv_sign),...
%         20,'MarkerEdgeColor','k',...
%            'MarkerFaceColor','r'...
%         );
% % % plot neutrals in blue
% % scatter(bestTriplets.triplets_inverted(preference_analysis.t_idx_neutral),...
% %         bestTriplets.triplets_upright (preference_analysis.t_idx_neutral),...
% %         20,'MarkerEdgeColor','k',...
% %            'MarkerFaceColor','y'...
% %         );
% 
% plot(15:50,15:50,'k')
% legend('Human Upright SEM','Human Upright','Human Inverted SEM','Human on Inverted',...
%        [int2str(length(preference_analysis.d_idx_neutral))  ' Neutral Patches'],...
%        [int2str(length(preference_analysis.d_idx_up_sign))  ' Upright Preferers'],...
%        [int2str(length(preference_analysis.d_idx_inv_sign)) ' Inverted Preferers'],...
%        '45 degree line');


    
    
    




