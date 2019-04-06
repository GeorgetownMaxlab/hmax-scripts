%% EVALUATE DOUBLET DATA

% Script has been double checked on 2017-01-22 by Levan Bokeria

% This script will take the best doublets from the bestPatches.mat file,
% and generate a C2  matrix for them on the upright and inverted images
% from the EEG part of the CRCNS experiment.

% Evaluating the localization-performance of doublets is useless because all patches
% performed at 100%, since in EEG experiment background was blank.

clear; close all; clc;

%% setup and load stuff
load(['C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\',...
      'patchSetAdam\lfwSingle50000\scaling_faceBox\bestPatches.mat'],...
      'bestDoublets','preference_analysis')

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
nDoublets         = length(bestDoublets.idx_crossValid);

% start script
newC2_min_Scaled_upright  = zeros(nDoublets,nImgs_upright);
newC2_min_Scaled_inverted = zeros(nDoublets,nImgs_inverted);

for iDoublet = 1:nDoublets
    if mod(iDoublet,100) == 0
        iDoublet
    end
    pushValue = 0.001;
 
    % Use the pushValue to make sure two C2 outputs aren't exactly the same
    if bestDoublets.patch2_scaling_factor(iDoublet) < 1
        pushValue = -pushValue;
    end
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% UPRIGHT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    newC2_Scaled_upright    = [c2f_upright_singles(bestDoublets.idx_crossValid(iDoublet,1),:);...
                               c2f_upright_singles(bestDoublets.idx_crossValid(iDoublet,2),:)...
                               .* bestDoublets.patch2_scaling_factor(iDoublet) + pushValue]; 
           
%     newImgHitsWedge_upright = [imgHitsWedge_upright_singles(bestDoublets.idx_crossValid(iDoublet,1),:); ...
%                                imgHitsWedge_upright_singles(bestDoublets.idx_crossValid(iDoublet,2),:)];
    
    [newC2_min_Scaled_upright(iDoublet,:),chosenPatchIdx_upright(1,:)] = min(newC2_Scaled_upright,[],1);
    
%     newImgHitsWedge_Scaled_upright = zeros(1,nImgs_upright); % preallocate
%     for iImg = 1:nImgs_upright
%         newImgHitsWedge_Scaled_upright(1,iImg) = newImgHitsWedge_upright(chosenPatchIdx_upright(1,iImg),iImg);
%     end
    
%     bestDoublets.doublets_upright(iDoublet,1) = nnz(newImgHitsWedge_Scaled_upright)*100/nImgs_upright;
    
    
    newC2_Scaled_upright = [];
%     newImgHitsWedge_upright = [];
    chosenPatchIdx_upright = [];
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% INVERTED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    newC2_Scaled_inverted    = [c2f_inverted_singles(bestDoublets.idx_crossValid(iDoublet,1),:);...
                                c2f_inverted_singles(bestDoublets.idx_crossValid(iDoublet,2),:)...
                                .* bestDoublets.patch2_scaling_factor(iDoublet) + pushValue]; 
           
%     newImgHitsWedge_inverted = [imgHitsWedge_inverted_singles(bestDoublets.idx_crossValid(iDoublet,1),:); ...
%                                 imgHitsWedge_inverted_singles(bestDoublets.idx_crossValid(iDoublet,2),:)];
    
    [newC2_min_Scaled_inverted(iDoublet,:),chosenPatchIdx_inverted(1,:)] = min(newC2_Scaled_inverted,[],1);
    
%     newImgHitsWedge_Scaled_inverted = zeros(1,nImgs_inverted); % preallocate
%     for iImg = 1:nImgs_inverted
%         newImgHitsWedge_Scaled_inverted(1,iImg) = newImgHitsWedge_inverted(chosenPatchIdx_inverted(1,iImg),iImg);
%     end
%     
%     bestDoublets.doublets_inverted(iDoublet,1) = nnz(newImgHitsWedge_Scaled_inverted)*100/nImgs_inverted;
    
    newC2_Scaled_inverted = [];
%     newImgHitsWedge_inverted = [];
    chosenPatchIdx_inverted = []; 
end

%% now plot...
% close;
% scatter(bestDoublets.doublets_inverted,bestDoublets.doublets_upright,...
%         5,'MarkerEdgeColor','k',...
%               'MarkerFaceColor','b'...
%               )
% xlabel('Inverted Localization')
% ylabel('Upright Localization')
% title(['Best ' int2str(length(bestDoublets.idx_crossValid)) ' doublets, after crossvalidation'])
% xlim([20 50])
% ylim([20 50])
% grid on
% hold on
% plot(20:50,20:50)
% legend('Pathces','45 degree line')