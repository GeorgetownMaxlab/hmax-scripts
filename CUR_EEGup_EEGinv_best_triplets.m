%% EVALUATE TRIPLET DATA

% Script has been double checked on 2017-01-22 by Levan Bokeria

% This script will take the best triplets from the bestPatches.mat file,
% and generate a C2  matrix for them on the upright and inverted images
% from the EEG part of the CRCNS experiment.

% Evaluating localization-performance of triplets is useless because all patches
% performed at 100%, since in EEG experiment background was blank.

clear; close all; clc;

%% setup and load stuff
load(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\',...
      'patchSetAdam\lfwSingle50000\scaling_faceBox\bestPatches.mat'])

% loadFolder_singles_upright  = 'eeg_up_inv\upright\data\patchSetAdam\lfwSingle50000';
% loadFolder_singles_inverted = 'eeg_up_inv\inverted\data\patchSetAdam\lfwSingle50000';

    loadLoc_singles_upright     = ['C:\Users\Levan\HMAX\eeg_up_inv\upright\data\patchSetAdam\lfwSingle50000\'];
    loadLoc_singles_inverted    = ['C:\Users\Levan\HMAX\eeg_up_inv\inverted\data\patchSetAdam\lfwSingle50000\'];

% Load upright data.
c2f_upright_singles = load([loadLoc_singles_upright 'c2f']);
c2f_upright_singles = c2f_upright_singles.c2f;
% imgHitsWedge_upright_singles = load([loadLoc_singles_upright 'imgHitsWedge']);
% imgHitsWedge_upright_singles = imgHitsWedge_upright_singles.imgHitsWedge;
nImgs_upright = size(c2f_upright_singles,2);

% Now load inverted data.
c2f_inverted_singles = load([loadLoc_singles_inverted 'c2f']);
c2f_inverted_singles = c2f_inverted_singles.c2f;
% imgHitsWedge_inverted_singles = load([loadLoc_singles_inverted 'imgHitsWedge']);
% imgHitsWedge_inverted_singles = imgHitsWedge_inverted_singles.imgHitsWedge;
nImgs_inverted = size(c2f_inverted_singles,2);



%% %%%%%%%%%%%%%% EVALUATE UPRIGHT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nTriplets         = length(bestTriplets.idx_crossValid);

% start script
newC2_min_Scaled_upright  = zeros(nTriplets,nImgs_upright);
newC2_min_Scaled_inverted = zeros(nTriplets,nImgs_inverted);
for iTriplet = 1:nTriplets
    if mod(iTriplet,1000) == 0
        iTriplet
    end
    pushValue_patch2 = 0.001; %for patch #2
    pushValue_patch3 = 0.001; %for patch #3
     
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% UPRIGHT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Use the pushValue to make sure two C2 outputs aren't exactly the same
    if bestTriplets.patch2_scaling_factor(iTriplet) < 1
        pushValue_patch2 = -pushValue_patch2;
    end
    if bestTriplets.patch3_scaling_factor(iTriplet) < 1
        pushValue_patch3 = -pushValue_patch3;
    end
    
    newC2_Scaled_upright    = [c2f_upright_singles(bestTriplets.idx_crossValid(iTriplet,1),:);...
                               c2f_upright_singles(bestTriplets.idx_crossValid(iTriplet,2),:)...
                               .* bestTriplets.patch2_scaling_factor(iTriplet) + pushValue_patch2;...
                               c2f_upright_singles(bestTriplets.idx_crossValid(iTriplet,3),:)...
                               .* bestTriplets.patch3_scaling_factor(iTriplet) + pushValue_patch3];
           
%     newImgHitsWedge_upright = [imgHitsWedge_upright_singles(bestTriplets.idx_crossValid(iTriplet,1),:); ...
%                                imgHitsWedge_upright_singles(bestTriplets.idx_crossValid(iTriplet,2),:);...
%                                imgHitsWedge_upright_singles(bestTriplets.idx_crossValid(iTriplet,3),:)];
    
    [newC2_min_Scaled_upright(iTriplet,:),chosenPatchIdx_upright(1,:)] = min(newC2_Scaled_upright,[],1);
    
%     newImgHitsWedge_Scaled_upright = zeros(1,nImgs_upright); % preallocate
%     for iImg = 1:nImgs_upright
%         newImgHitsWedge_Scaled_upright(1,iImg) = newImgHitsWedge_upright(chosenPatchIdx_upright(1,iImg),iImg);
%     end
%     
%     bestTriplets.triplets_upright(iTriplet,1) = nnz(newImgHitsWedge_Scaled_upright)*100/nImgs_upright;
    
    
    newC2_Scaled_upright = [];
%     newImgHitsWedge_upright = [];
    chosenPatchIdx_upright = [];
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% INVERTED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    newC2_Scaled_inverted    = [c2f_inverted_singles(bestTriplets.idx_crossValid(iTriplet,1),:);...
                                c2f_inverted_singles(bestTriplets.idx_crossValid(iTriplet,2),:)...
                                    .* bestTriplets.patch2_scaling_factor(iTriplet) + pushValue_patch2;...
                                c2f_inverted_singles(bestTriplets.idx_crossValid(iTriplet,3),:)...
                                    .* bestTriplets.patch3_scaling_factor(iTriplet) + pushValue_patch3];
           
%     newImgHitsWedge_inverted = [imgHitsWedge_inverted_singles(bestTriplets.idx_crossValid(iTriplet,1),:); ...
%                                 imgHitsWedge_inverted_singles(bestTriplets.idx_crossValid(iTriplet,2),:);...
%                                 imgHitsWedge_inverted_singles(bestTriplets.idx_crossValid(iTriplet,3),:)];
    
    [newC2_min_Scaled_inverted(iTriplet,:),chosenPatchIdx_inverted(1,:)] = min(newC2_Scaled_inverted,[],1);
    
%     newImgHitsWedge_Scaled_inverted = zeros(1,nImgs_inverted); % preallocate
%     for iImg = 1:nImgs_inverted
%         newImgHitsWedge_Scaled_inverted(1,iImg) = newImgHitsWedge_inverted(chosenPatchIdx_inverted(1,iImg),iImg);
%     end
    
%     bestTriplets.triplets_inverted(iTriplet,1) = nnz(newImgHitsWedge_Scaled_inverted)*100/nImgs_inverted;
    
    
    newC2_Scaled_inverted = [];
%     newImgHitsWedge_inverted = [];
    chosenPatchIdx_inverted = [];
end

%% now plot...
% scatter(bestTriplets.triplets_inverted,bestTriplets.triplets_upright,...
%         1,'MarkerEdgeColor','k',...
%               'MarkerFaceColor','b'...
%               )
% xlabel('Inverted Localization')
% ylabel('Upright Localization')
% title(['Best ' int2str(length(bestTriplets.idx_crossValid)) ' triplets, after crossvalidation'])
% xlim([15 50])
% ylim([15 50])
% grid on
% hold on
% plot(15:50,15:50)
% legend('Pathces','45 degree line')