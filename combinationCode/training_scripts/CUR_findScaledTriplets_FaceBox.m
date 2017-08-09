function CUR_findScaledTriplets_FaceBox(nTPatchesLoad,nCPatchesLoad,nTPatches,nCPatches)

% This script will take a number of previously found best doublets, find 
% "hard images" for EACH of those top doublets, and then find complementary
% patches that do well on those hard images.

% The script then determines the best scaling factor to apply to the C2 values
% of each triplet consisting of one top-doublet and one complementary-patch.

% The script then calls CUR_make_scaledDoublet_c2_imgHits.m code to find
% new localization accuracy for each of these doublets.

% NOTE: this script will use the FACE-BOX accuracy criterion to find best
% patches, not the WEDGE criterion.

%% GLOBAL STUFF
% clear; clc;
dbstop if error;
runParameterComments = 'none';%input('Any comments about the run?\n'); %#ok<*NASGU>

if (nargin < 1)
    nTPatchesLoad = 10;
    nCPatchesLoad = 10;
    nTPatches = 10;
    nCPatches = 10;
end
nDoublets = nTPatchesLoad*nCPatchesLoad;
nTriplets = nTPatches*nCPatches;
loadFolder = ['simulation1/testing/data/patchSetAdam/lfwSingle50000/scaling_FaceBox_switchSets/doublets/' int2str(nTPatchesLoad) 'TPatches' int2str(nCPatchesLoad) 'CPatches'];
saveFolder = ['simulation1/testing/data/patchSetAdam/lfwSingle50000/scaling_FaceBox_switchSets/doublets/' ...
              int2str(nTPatchesLoad)         'TPatches' int2str(nCPatchesLoad) 'CPatches/' ...
              'triplets/' int2str(nTPatches) 'TPatches' int2str(nCPatches)     'CPatches'];

if ispc == 1
    loadLoc    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder '\'];
    saveLoc    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' saveFolder '\'];
    singlesLoc = 'C:\Users\Levan\HMAX\annulusExptFixedContrast\simulation1/testing/data/patchSetAdam/lfwSingle50000/';
else    
    loadLoc    = ['/home/levan/HMAX/annulusExptFixedContrast/' loadFolder '/'];
    saveLoc    = ['/home/levan/HMAX/annulusExptFixedContrast/' saveFolder '/'];
    singlesLoc = '/home/levan/HMAX/annulusExptFixedContrast/simulation1/testing/data/patchSetAdam/lfwSingle50000/';
end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

% load the doublet data
load([loadLoc 'combMatrix']);
doubletCombMatrix = combMatrix; % redefine because new combMatrix is created for triplets.
combMatrix = [];
    if exist([loadLoc 'imageDifficultyData_FaceBox_' int2str(nDoublets) '_Patches.mat']) == 0
       CUR_imageDifficultyMapFaceBoxLocalization('DOUBLETS','f',loadFolder,0);
    end
load([loadLoc 'imageDifficultyData_FaceBox_' int2str(nDoublets) '_Patches'],'IndPatch');
load([loadLoc 'imgHitsFaceBox.mat']);
load([loadLoc 'c2f.mat']);
nImgs = size(c2f,2);

% load the single patch data
singlesImgHitsFaceBox = load([singlesLoc 'imgHitsFaceBox.mat']);
singlesImgHitsFaceBox = singlesImgHitsFaceBox.imgHitsFaceBox;
singlesC2f = load([singlesLoc 'c2f.mat']);
singlesC2f = singlesC2f.c2f;
nSingles = size(singlesC2f,1);

%% START TP LOOP
tic;
% iToc = 0;
combMatrix = zeros(nTriplets,7);
key = [{'Patch1 index'} {'Patch2 index'} {'Patch3 index'} {'Patch2 SF'} {'Patch3 SF'} {'Doublet Localization'} {'Triplet Localization'}];
for i = 1:nTPatches
    i
%     iTic = tic;

% PREPROCESSING
idxTopDoublet = IndPatch(i); %remember this is the index within the doublet data.
% So its not the index of the original patch.

idxHardImgs = find(imgHitsFaceBox(idxTopDoublet,:) == 0);
idxEasyImgs = find(imgHitsFaceBox(idxTopDoublet,:) == 1);

% these should be defined from the SINGLES map!!!
hardImgMap = singlesImgHitsFaceBox(:,idxHardImgs);
easyImgMap = singlesImgHitsFaceBox(:,idxEasyImgs);
nHardImgs = length(idxHardImgs);
nEasyImgs = length(idxEasyImgs);

                                                                                                                                    % Some sanity checks.
                                                                                                                                    assert(nHardImgs == nImgs - nEasyImgs);
                                                                                                                                    allSuccesses = nnz(singlesImgHitsFaceBox(:));
                                                                                                                                    hardSuccesses = nnz(hardImgMap(:));
                                                                                                                                    easySuccesses = nnz(easyImgMap(:));
                                                                                                                                    assert(allSuccesses == hardSuccesses + easySuccesses);
                                                                                                                                    clearvars easyImgMap

%% Now find patches that do well on hard images.
sumStats_CPatch = zeros(1,nSingles); % preallocated
for iPatch = 1:nSingles
    sumStats_CPatch(iPatch) = nnz(hardImgMap(iPatch,:));
end
[sortSumStats_CPatch,idxCPatches] = sort(sumStats_CPatch,'descend');

% Construct info about complementary patches.
CPInfo.idxPatches = idxCPatches(1:nCPatches);
CPInfo.nHardImgsHit = sortSumStats_CPatch(1:nCPatches);
for j = 1:nCPatches
    CPInfo.nAllImgsHit(j) = nnz(singlesImgHitsFaceBox(CPInfo.idxPatches(j),:));
    CPInfo.nEasyImgsHit(j) = CPInfo.nAllImgsHit(j) - CPInfo.nHardImgsHit(j);
end
assert(isequal(CPInfo.nAllImgsHit,CPInfo.nHardImgsHit + CPInfo.nEasyImgsHit)==1);

%% Now determine the range of SF
bestLoc    = zeros(1,nCPatches); % preallocate
idxBestLoc = zeros(1,nCPatches); % preallocate
bestSF     = zeros(1,nCPatches); % preallocate

for iCPatch = 1:nCPatches
%     iCPatch
    idx_iCPatch = CPInfo.idxPatches(iCPatch);
    newC2 = [c2f(idxTopDoublet,:); singlesC2f(idx_iCPatch,:)];
    newImgHitsFaceBox = [imgHitsFaceBox(idxTopDoublet,:); singlesImgHitsFaceBox(idx_iCPatch,:)];

    % Subtract c-patch C2 values from b-patch C2 values. 
    sfArray = newC2(1,:) ./ newC2(2,:); % DIVIDE TP C2 values by CP C2 values

    allSF = sort(sfArray);
    pushValue = 0.001;
        % Run through the SF range to find the optimal value.
        newLoc = zeros(1,length(sfArray)); % preallocate
        for ii = 1:length(sfArray)
%             ii
            iSF = sfArray(ii);
            newC2_Scaled = newC2;
            if iSF < 1
                newC2_Scaled(2,:) = (newC2_Scaled(2,:) .* iSF) - pushValue;
            else
                newC2_Scaled(2,:) = (newC2_Scaled(2,:) .* iSF) + pushValue;                
            end
            
            [newC2_Scaled_min(1,:),chosenPatchIdx(1,:)] = min(newC2_Scaled,[],1);
            
%                                                                                                                                     hold on
%                                                                                                                                     plot(newC2_Scaled(1,:))
%                                                                                                                                     plot(newC2_Scaled(2,:))
%                                                                                                                                     plot(newC2_Scaled_min(1,:)+0.05)
%                                                                                                                                     legend('BP','CP','Scaled CP')
%                                                                                                                                     close;
            
            newImgHitsFaceBox_Scaled = zeros(1,nImgs);
            
                for iImg = 1:nImgs
                    newImgHitsFaceBox_Scaled(1,iImg) = newImgHitsFaceBox(chosenPatchIdx(1,iImg),iImg);
                end

            newLoc(ii) = nnz(newImgHitsFaceBox_Scaled);
            
            % clear variables
            newC2_Scaled = [];
            chosenPatchIdx = [];
        end % SF LOOP
%                                                                                                                                      plotSFarrays(newC2,sfArray,newLoc)
%                                                                                                                                        close;


        [bestLoc(iCPatch),idxBestLoc(iCPatch)] = max(newLoc);
        bestSF(iCPatch) = sfArray(idxBestLoc(iCPatch));
        
        % clear variables
        newC2 = [];
        newImgHitsFaceBox = [];
        sfArray = [];
        allSF = [];
end

%create an output matrix
combMatrix(  ((i-1)*nCPatches+1):i*nCPatches,:) = [repmat(doubletCombMatrix(idxTopDoublet,1:2),nCPatches,1) ...
                                                   CPInfo.idxPatches' ... 
                                                   repmat(doubletCombMatrix(idxTopDoublet,3)  ,nCPatches,1) ...
                                                   bestSF' ...
                                                   repmat(doubletCombMatrix(idxTopDoublet,4)  ,nCPatches,1) ...                                                          
                                                   bestLoc'];
clearvars CPInfo;

if mod(iCPatch,500) == 0
    save([saveLoc 'combMatrix'],'combMatrix');
end
iToc = toc
end % nTPaches loop

overallMaxLoc = max(combMatrix(:,7))/nImgs*100

%% SAVE VARIABLES

save([saveLoc 'combMatrix'],'combMatrix');
save([saveLoc 'key_to_combMatrix'],'key');
CUR_make_scaledTriplet_c2_imgHitsFaceBox(singlesLoc,saveLoc,nTPatches,nCPatches,pushValue)
runTime = toc

runDateTime = datetime('now');
outputOfPWD = pwd;
scriptName  = mfilename('fullpath');
save([saveLoc 'runParameters.mat'],...
    'runDateTime',...
    'scriptName',...
    'outputOfPWD',...
    'runParameterComments',...
    'nTPatches',...
    'nCPatches',...
    'nTPatchesLoad',...
    'nCPatchesLoad',...
    'saveLoc',...
    'loadLoc',...
    'runTime',...
    'pushValue'...
    );

end

function plotSFarrays(newC2,sfArray,newLoc)
%     hold off
    subplot(2,2,1)
    plot(newC2(1,:));
    hold on
    plot(newC2(2,:));
    title('BP and CP C2 Values','FontSize',25)
    legend('BP','CP')
    axis([0 480 0 1])
    hold off
    
    subplot(2,2,2)
    plot(sfArray)
%     plot(allSF)
    axis([0 480 0 6])
    title('Scaling Factors Considered');
    
    subplot(2,2,3)
    plot(newLoc)
    hold on
    title('Localization for Each SF');
    xlabel('SF values')
    axis([0 480 0 400])
%     hold off
end