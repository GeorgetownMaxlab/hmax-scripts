%% EVALUATE TRIPLET DATA

% This script will take the best triplets from the bestPatches.mat file,
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
nTriplets         = length(bestTriplets.idx_suriving_testing_faceBox_threshold);

% start script

for iTriplet = 1:nTriplets
    if mod(iTriplet,1000) == 0
        iTriplet
    end
    pushValue_patch2 = 0.001; %for patch #2
    pushValue_patch3 = 0.001; %for patch #3
    
    % Use the pushValue to make sure two C2 outputs aren't exactly the same
    if bestTriplets.patch2_scaling_factor(iTriplet) < 1
        pushValue_patch2 = -pushValue_patch2;
    end
    if bestTriplets.patch3_scaling_factor(iTriplet) < 1
        pushValue_patch3 = -pushValue_patch3;
    end
    
    newC2_Scaled_upright    = [c2f_upright_singles(bestTriplets.idx_suriving_testing_faceBox_threshold(iTriplet,1),:);...
                               c2f_upright_singles(bestTriplets.idx_suriving_testing_faceBox_threshold(iTriplet,2),:)...
                               .* bestTriplets.patch2_scaling_factor(iTriplet) + pushValue_patch2;...
                               c2f_upright_singles(bestTriplets.idx_suriving_testing_faceBox_threshold(iTriplet,3),:)...
                               .* bestTriplets.patch3_scaling_factor(iTriplet) + pushValue_patch3];
           
    newImgHitsWedge_upright = [imgHitsWedge_upright_singles(bestTriplets.idx_suriving_testing_faceBox_threshold(iTriplet,1),:); ...
                               imgHitsWedge_upright_singles(bestTriplets.idx_suriving_testing_faceBox_threshold(iTriplet,2),:);...
                               imgHitsWedge_upright_singles(bestTriplets.idx_suriving_testing_faceBox_threshold(iTriplet,3),:)];
    
    [newC2_min_Scaled_upright(1,:),chosenPatchIdx_upright(1,:)] = min(newC2_Scaled_upright,[],1);
    
    newImgHitsWedge_Scaled_upright = zeros(1,nImgs_upright); % preallocate
    for iImg = 1:nImgs_upright
        newImgHitsWedge_Scaled_upright(1,iImg) = newImgHitsWedge_upright(chosenPatchIdx_upright(1,iImg),iImg);
    end
    
    bestTriplets.triplets_upright(iTriplet,1) = nnz(newImgHitsWedge_Scaled_upright)*100/nImgs_upright;
    
    
    newC2_Scaled_upright = [];
    newImgHitsWedge_upright = [];
    chosenPatchIdx_upright = [];
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% INVERTED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    newC2_Scaled_inverted    = [c2f_inverted_singles(bestTriplets.idx_suriving_testing_faceBox_threshold(iTriplet,1),:);...
                                c2f_inverted_singles(bestTriplets.idx_suriving_testing_faceBox_threshold(iTriplet,2),:)...
                                    .* bestTriplets.patch2_scaling_factor(iTriplet) + pushValue_patch2;...
                                c2f_inverted_singles(bestTriplets.idx_suriving_testing_faceBox_threshold(iTriplet,3),:)...
                                    .* bestTriplets.patch3_scaling_factor(iTriplet) + pushValue_patch3];
           
    newImgHitsWedge_inverted = [imgHitsWedge_inverted_singles(bestTriplets.idx_suriving_testing_faceBox_threshold(iTriplet,1),:); ...
                                imgHitsWedge_inverted_singles(bestTriplets.idx_suriving_testing_faceBox_threshold(iTriplet,2),:);...
                                imgHitsWedge_inverted_singles(bestTriplets.idx_suriving_testing_faceBox_threshold(iTriplet,3),:)];
    
    [newC2_min_Scaled_inverted(1,:),chosenPatchIdx_inverted(1,:)] = min(newC2_Scaled_inverted,[],1);
    
    newImgHitsWedge_Scaled_inverted = zeros(1,nImgs_inverted); % preallocate
    for iImg = 1:nImgs_inverted
        newImgHitsWedge_Scaled_inverted(1,iImg) = newImgHitsWedge_inverted(chosenPatchIdx_inverted(1,iImg),iImg);
    end
    
    bestTriplets.triplets_inverted(iTriplet,1) = nnz(newImgHitsWedge_Scaled_inverted)*100/nImgs_inverted;
    
    
    newC2_Scaled_inverted = [];
    newImgHitsWedge_inverted = [];
    chosenPatchIdx_inverted = [];
end

%% now plot...
scaleMin = 10;
scaleMax = 60;
scatter(bestTriplets.triplets_inverted,bestTriplets.triplets_upright,...
        1,'MarkerEdgeColor','k',...
              'MarkerFaceColor','b'...
              )
xlabel('Inverted Localization')
ylabel('Upright Localization')
title(['Best ' int2str(length(bestTriplets.idx_suriving_testing_faceBox_threshold)) ' triplets, after crossvalidation'])
xlim([scaleMin scaleMax])
ylim([scaleMin scaleMax])
grid on
hold on
plot(scaleMin:scaleMax,scaleMin:scaleMax)
legend('Pathces','45 degree line')

%% save the bestPatches.mat file
% optional to overwrite the singles data
save(fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1',imgSet,'\data\patchSetAdam\lfwSingle50000\scaling_FaceBox_switchSets\bestPatches.mat'),'bestTriplets','-append');