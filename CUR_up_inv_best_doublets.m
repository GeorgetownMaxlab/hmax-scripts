%% EVALUATE DOUBLET DATA

% This script will take the best doublets from the bestPatches.mat file,
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

    loadLoc_singles_upright     = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles_upright '\'];
    loadLoc_singles_inverted    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles_inverted '\'];

c2f_upright_singles          = load([loadLoc_singles_upright 'c2f']);
imgHitsWedge_upright_singles = load([loadLoc_singles_upright 'imgHitsWedge']);
c2f_upright_singles          = c2f_upright_singles.c2f;
imgHitsWedge_upright_singles = imgHitsWedge_upright_singles.imgHitsWedge;

% Now load inverted data.
c2f_inverted_singles          = load([loadLoc_singles_inverted 'c2f']);
imgHitsWedge_inverted_singles = load([loadLoc_singles_inverted 'imgHitsWedge']);
c2f_inverted_singles          = c2f_inverted_singles.c2f;
imgHitsWedge_inverted_singles = imgHitsWedge_inverted_singles.imgHitsWedge;

nImgs_upright  = size(c2f_upright_singles, 2);
nImgs_inverted = size(c2f_inverted_singles,2);

%% %%%%%%%%%%%%%% EVALUATE UPRIGHT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nDoublets         = length(bestDoublets.idx_suriving_testing_faceBox_threshold);

% start script

for iDoublet = 1:nDoublets
    if mod(iDoublet,100) == 0
        iDoublet
    end
    pushValue = 0.001;
 
    % Use the pushValue to make sure two C2 outputs aren't exactly the same
    if bestDoublets.patch2_scaling_factor(iDoublet) < 1
        pushValue = -pushValue;
    end
    
    newC2_Scaled_upright    = [c2f_upright_singles(bestDoublets.idx_suriving_testing_faceBox_threshold(iDoublet,1),:);...
                               c2f_upright_singles(bestDoublets.idx_suriving_testing_faceBox_threshold(iDoublet,2),:)...
                               .* bestDoublets.patch2_scaling_factor(iDoublet) + pushValue]; 
           
    newImgHitsWedge_upright = [imgHitsWedge_upright_singles(bestDoublets.idx_suriving_testing_faceBox_threshold(iDoublet,1),:); ...
                               imgHitsWedge_upright_singles(bestDoublets.idx_suriving_testing_faceBox_threshold(iDoublet,2),:)];
    
    [newC2_min_Scaled_upright(1,:),chosenPatchIdx_upright(1,:)] = min(newC2_Scaled_upright,[],1);
%     hist(chosenPatchIdx_upright)
    newImgHitsWedge_Scaled_upright = zeros(1,nImgs_upright); % preallocate
    for iImg = 1:nImgs_upright
        newImgHitsWedge_Scaled_upright(1,iImg) = newImgHitsWedge_upright(chosenPatchIdx_upright(1,iImg),iImg);
    end
    
    bestDoublets.doublets_upright(iDoublet,1) = nnz(newImgHitsWedge_Scaled_upright)*100/nImgs_upright;
    
    
    newC2_Scaled_upright = [];
    newImgHitsWedge_upright = [];
    chosenPatchIdx_upright = [];
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% INVERTED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    newC2_Scaled_inverted    = [c2f_inverted_singles(bestDoublets.idx_suriving_testing_faceBox_threshold(iDoublet,1),:);...
                                c2f_inverted_singles(bestDoublets.idx_suriving_testing_faceBox_threshold(iDoublet,2),:)...
                                .* bestDoublets.patch2_scaling_factor(iDoublet) + pushValue]; 
           
    newImgHitsWedge_inverted = [imgHitsWedge_inverted_singles(bestDoublets.idx_suriving_testing_faceBox_threshold(iDoublet,1),:); ...
                                imgHitsWedge_inverted_singles(bestDoublets.idx_suriving_testing_faceBox_threshold(iDoublet,2),:)];
    
    [newC2_min_Scaled_inverted(1,:),chosenPatchIdx_inverted(1,:)] = min(newC2_Scaled_inverted,[],1);
    
    newImgHitsWedge_Scaled_inverted = zeros(1,nImgs_inverted); % preallocate
    for iImg = 1:nImgs_inverted
        newImgHitsWedge_Scaled_inverted(1,iImg) = newImgHitsWedge_inverted(chosenPatchIdx_inverted(1,iImg),iImg);
    end
    
    bestDoublets.doublets_inverted(iDoublet,1) = nnz(newImgHitsWedge_Scaled_inverted)*100/nImgs_inverted;
    
    newC2_Scaled_inverted = [];
    newImgHitsWedge_inverted = [];
    chosenPatchIdx_inverted = []; 
end

%% now plot...
close;
scaleMin = 10;
scaleMax = 60;
scatter(bestDoublets.doublets_inverted,bestDoublets.doublets_upright,...
        20,'MarkerEdgeColor','k',...
              'MarkerFaceColor','b'...
              )
xlabel('Inverted Localization')
ylabel('Upright Localization')
title(['Best ' int2str(length(bestDoublets.idx_suriving_testing_faceBox_threshold)) ' doublets, after crossvalidation'])
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
hold on
plot(scaleMin:scaleMax,scaleMin:scaleMax)
legend('Pathces','45 degree line')

%% save the bestPatches.mat file
% optional to overwrite the singles data
save(fullfile(home,imgSet,'data\patchSetAdam\lfwSingle50000',scaling_condition,'bestPatches.mat'),'bestDoublets','-append');