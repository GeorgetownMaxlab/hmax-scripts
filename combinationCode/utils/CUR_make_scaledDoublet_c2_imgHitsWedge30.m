function CUR_make_scaledDoublet_c2_imgHitsWedge30(loadLoc,saveLoc,nTPatches,nCPatches,pushValue)

% This script is called by CUR_findScaledDoublets_FaceBox.m and other scripts. It
% simply builds the scaled-doublet c2 and imgHits matrix and 
% saves them in the folder, so they can be used for later analysis. 

%% GLOBAL STUFF
% clear; clc;
dbstop if error;
runParameterComments = 'none';%input('Any comments about the run?\n'); %#ok<*NASGU>

% Load the singles matrices.
load(fullfile(loadLoc,'fixedLocalization','imgHitsWedge.mat'));
load(fullfile(loadLoc,'c2f.mat'));
nImgs = size(c2f,2);
imgHitsWedge = imgHitsWedge.wedgeDegree_30;

% Load the combMatrix of the scaled doublets.
load(fullfile(saveLoc,'combMatrix'))
% load([loadLoc '/scaling_FaceBox/' int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches/runParameters'],'pushValues')


%% START BUILDING THE NEW c2f and ImgHits MATRICES
nDoublets             = size(combMatrix,1);%nTPatches*nCPatches;
doubletC2             = zeros(nDoublets,nImgs);
doubletimgHitsWedge   = zeros(nDoublets,nImgs);
doubletChosenPatchIdx = zeros(nDoublets,nImgs); 

for iDoublet = 1:nDoublets
    if mod(iDoublet,5000) == 0
        iDoublet
    end
    idxTPatch = combMatrix(iDoublet,1);
    idxCPatch = combMatrix(iDoublet,2);
    SF        = combMatrix(iDoublet,3);

    newC2_Scaled = [c2f(idxTPatch,:); c2f(idxCPatch,:)];
    
        if SF < 1
            newC2_Scaled(2,:) = (newC2_Scaled(2,:) .* SF) - pushValue;
        else
            newC2_Scaled(2,:) = (newC2_Scaled(2,:) .* SF) + pushValue;
        end

            [newC2_Scaled_min(1,:),chosenPatchIdx(1,:)] = min(newC2_Scaled,[],1);
            doubletC2(iDoublet,:)                       = newC2_Scaled_min;
            doubletChosenPatchIdx(iDoublet,:)           = chosenPatchIdx;
            newimgHitsWedge                             = [imgHitsWedge(idxTPatch,:); ...
                                                           imgHitsWedge(idxCPatch,:)];

        for iImg = 1:nImgs
            doubletimgHitsWedge(iDoublet,iImg) = newimgHitsWedge(chosenPatchIdx(1,iImg),iImg);
        end

    newLoc(iDoublet,1) = nnz(doubletimgHitsWedge(iDoublet,:));
    
    % clear variables.
    chosenPatchIdx   = [];
    newC2_Scaled_min = [];
    newC2_Scaled     = [];

end

assert(isequal(newLoc,combMatrix(:,4))==1);
%% save C2 and imgHits
c2f = doubletC2;
doubletC2 = [];
imgHitsWedge = doubletimgHitsWedge;
doubletimgHitsWedge = [];
chosenPatchIdx = doubletChosenPatchIdx;
doubletChosenPatchIdx = [];
display('saving data...');
save(fullfile(saveLoc,'c2f'),'c2f','-v7.3');
save(fullfile(saveLoc,'imgHitsWedge'),'imgHitsWedge','-v7.3');
save(fullfile(saveLoc,'chosenPatchIdx'),'chosenPatchIdx','-v7.3');


