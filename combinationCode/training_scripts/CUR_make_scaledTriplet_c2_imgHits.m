function CUR_make_scaledTriplet_c2_imgHits(loadLoc,saveLoc,nTPatchesLoad,nCPatchesLoad,pushValue)

% This script is called by CUR_findScaledTriplets.m and other scripts. It
% simply builds the scaled-triplet c2 and imgHits matrix and 
% saves them in the folder, so they can be used for later analysis. 

%% GLOBAL STUFF
% clear; clc;
dbstop if error;
runParameterComments = 'none';%input('Any comments about the run?\n'); %#ok<*NASGU>

if (nargin < 1)
    loadFolder_singles = 'simulation1/training/data/patchSetAdam/lfwSingle50000';
    nTPatchesLoad = 10;
    nCPatchesLoad = 10;
    pushValue = 0.001;
    saveFolder = [loadFolder_singles '/scaling/triplets/' int2str(nTPatchesLoad) 'TPatches' int2str(nCPatchesLoad) 'CPatches'];

    if ispc == 1
        loadLoc    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder_singles '\'];
        saveLoc    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' saveFolder '\'];
    else    
        loadLoc    = ['/home/levan/HMAX/annulusExptFixedContrast/' loadFolder_singles '/'];
        saveLoc    = ['/home/levan/HMAX/annulusExptFixedContrast/' saveFolder '/'];
    end

    if ~exist(saveLoc,'dir')
        mkdir(saveLoc)
    end
end

% Load the singles matrices.
singlesC2f = load([loadLoc 'c2f.mat']);
singlesC2f = singlesC2f.c2f;
singlesImgHitsWedge = load([loadLoc 'imgHitsWedge.mat']);
singlesImgHitsWedge = singlesImgHitsWedge.imgHitsWedge;

nImgs = size(singlesC2f,2);

% Load the combMatrix of the scaled triplet.
% load([loadLoc 'scaling/triplets/' int2str(nTPatchesLoad) 'TPatches' int2str(nCPatchesLoad) 'CPatches/combMatrix.mat'])
load([saveLoc '/combMatrix.mat']);

%% START BUILDING THE NEW c2f and ImgHits MATRICES
nTriplets             = size(combMatrix,1);
tripletC2             = zeros(nTriplets,nImgs);
tripletImgHitsWedge   = zeros(nTriplets,nImgs);
tripletChosenPatchIdx = zeros(nTriplets,nImgs); 

for iTriplet = 1:nTriplets
    if mod(iTriplet,5000) == 0
        iTriplet
    end
    idxDoublet1 = combMatrix(iTriplet,1);
    idxDoublet2 = combMatrix(iTriplet,2);
    idxCPatch   = combMatrix(iTriplet,3);
    SF_Doublet  = combMatrix(iTriplet,4);
    SF_Triplet  = combMatrix(iTriplet,5);

    newC2_Scaled = [singlesC2f(idxDoublet1,:); singlesC2f(idxDoublet2,:); singlesC2f(idxCPatch,:)];
        
        % Scale the doublet
        if SF_Doublet < 1
            newC2_Scaled(2,:) = (newC2_Scaled(2,:) .* SF_Doublet) - pushValue;
        else
            newC2_Scaled(2,:) = (newC2_Scaled(2,:) .* SF_Doublet) + pushValue;
        end
        % Scale the triplet
        if SF_Triplet < 1
            newC2_Scaled(3,:) = (newC2_Scaled(3,:) .* SF_Triplet) - pushValue;
        else
            newC2_Scaled(3,:) = (newC2_Scaled(3,:) .* SF_Triplet) + pushValue;
        end
        
        
            [newC2_Scaled_min(1,:),chosenPatchIdx(1,:)] = min(newC2_Scaled,[],1);
            tripletC2(iTriplet,:)                       = newC2_Scaled_min;
            tripletChosenPatchIdx(iTriplet,:)           = chosenPatchIdx;
            newImgHitsWedge                             = [singlesImgHitsWedge(idxDoublet1,:); ...
                                                           singlesImgHitsWedge(idxDoublet2,:); ...
                                                           singlesImgHitsWedge(idxCPatch,  :)];

        for iImg = 1:nImgs
            tripletImgHitsWedge(iTriplet,iImg) = newImgHitsWedge(chosenPatchIdx(1,iImg),iImg);
        end

    newLoc(iTriplet,1) = nnz(tripletImgHitsWedge(iTriplet,:));
    
    % clear variables.
    chosenPatchIdx   = [];
    newC2_Scaled_min = [];
    newC2_Scaled     = [];

end

assert(isequal(newLoc,combMatrix(:,7))==1);
%% save C2 and imgHits
c2f                   = tripletC2;
imgHitsWedge          = tripletImgHitsWedge;
tripletC2             = [];
tripletImgHitsWedge   = [];
chosenPatchIdx        = tripletChosenPatchIdx;
tripletChosenPatchIdx = [];
display('saving data...');
save([saveLoc 'c2f'],'c2f');
save([saveLoc 'imgHitsWedge'],'imgHitsWedge');
save([saveLoc 'chosenPatchIdx'],'chosenPatchIdx');


