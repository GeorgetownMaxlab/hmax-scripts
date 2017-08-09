function CUR_combinePatchesAnnulus(loadFolder, saveFolder, ...
                        COMBINATION, nPatchesAnalyzed, localize, quadType)
% This function combines patches by finding the C2 across all bands of all
% scales of all patches being combined. For example, if two patches are
% combined, each with 8 scale bands, the code will find the minimum S2
% across all 16 scale bands and record the S2 value, bestBand, bestLoc, and
% which patch did the bestBand belong to.

% This script does not implement any scaling between patches.

%VARIABLES:

% COMBINATION: a double. 2 or 3. Determines whether combining doublets or
               % triplests.
% nPatches: number of patches that will be used to form every possible
            % combination of doublets or triplets. 
% nQuad: number of quadrants into which the original images were broken up.

%% Define Global variables
tic;
dbstop if error;

if (nargin < 6)
    quadType = 'f';
end

if (nargin < 1)
    loadFolder = 'trainingRuns/patchSetAdam/lfwSingle50000';
    saveFolder = 'trainingRuns/patchSetAdam/lfwSingle50000\sandbox';
    COMBINATION = 2;
    nPatchesAnalyzed = 50;
    localize = 1;
end


runParameterComments = 'none';%input('Any comments about the run?\n'); %#ok<*NASGU>

if ispc == 1
    loadLoc    = ['C:\Users\Levan\HMAX\annulusExpt\' loadFolder '\']
    saveLoc    = ['C:\Users\Levan\HMAX\annulusExpt\' saveFolder '\']
else    
    loadLoc    = ['/home/levan/HMAX/annulusExpt/' loadFolder '/']
    saveLoc    = ['/home/levan/HMAX/annulusExpt/' saveFolder '/']
end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

load([loadLoc 'facesLoc.mat']);

%% Start main code
    load([loadLoc 'c2'          quadType 'Sorted.mat'])
    load([loadLoc 'bestBandsC2' quadType 'Sorted.mat'])
    load([loadLoc 'bestLocC2'   quadType 'Sorted.mat'])
    nImgs = length(facesLoc{1});


    %% Get the new C2 matrix
    combinationMatrix = combnk(1:nPatchesAnalyzed,COMBINATION);
%         load([loadLoc 'customCombInfo.mat']);
%         combinationMatrix = customCombMatrix;
    nCombPatches      = size(combinationMatrix,1);
    c2Comb            = zeros(nCombPatches,nImgs);
    chosenPatchIdx    = zeros(nCombPatches,nImgs);
    bestBandsComb = zeros(nCombPatches,nImgs);
    bestLocComb   = zeros(nCombPatches,nImgs,2);

    if     COMBINATION == 2 
        for iPatch = 1:nCombPatches
            if mod(iPatch,1000) == 0
                iPatch
            end
            C = [c2f(combinationMatrix(iPatch,1),:); c2f(combinationMatrix(iPatch,2),:)];
                [c2Comb(iPatch,:),chosenPatchIdx(iPatch,:)] = min(C,[],1);
            C = [];            
            
            for iImg = 1:nImgs
                bestBandsComb(iPatch,iImg)   = bestBands(chosenPatchIdx(iPatch,iImg),iImg);
                bestLocComb  (iPatch,iImg,:) = bestLoc(chosenPatchIdx(iPatch,iImg),iImg,:);
            end
            
        end
    elseif COMBINATION == 3
        for iPatch = 1:nCombPatches
            if mod(iPatch,1000) == 0
                iPatch
            end
            C = [c2f(combinationMatrix(iPatch,1),:); c2f(combinationMatrix(iPatch,2),:); c2f(combinationMatrix(iPatch,3),:)];
                [c2Comb(iPatch,:),chosenPatchIdx(iPatch,:)] = min(C,[],1);
            C = [];
            
            
            for iImg = 1:nImgs
                bestBandsComb(iPatch,iImg)   = bestBands(chosenPatchIdx(iPatch,iImg),iImg);
                bestLocComb  (iPatch,iImg,:) = bestLoc(chosenPatchIdx(iPatch,iImg),iImg,:);
            end
        end
    else
        fprintf('COMBINATION variable not appropriate')
    end
    
        %% IF BB and BL are CELLED
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %predefine bestBands and bestLoc for speed.
%         bestBandsComb = cell(1,size(bestBands,2));
%         bestLocComb   = cell(1,size(bestLoc,  2));
%         for w = 1:size(bestBands,2)
%             bestBandsComb{w} = zeros(nCombPatches,size(bestBands{w},2));
%             bestLocComb{w}   = zeros(nCombPatches,size(bestLoc{w},2),2);
%         end     
%         %Start populating bestBands and bestLoc
%             start = 0;
%             for w = 1:size(bestBands,2)
%                 for iCombPatch = 1:nCombPatches
%                     if mod(iCombPatch,1000) == 0
%                         iCombPatch
%                     end
%                     for j = 1:size(bestBands{w},2)
%                         bestBandsComb{w}(iCombPatch,j) = bestBands{w}...
%                             (combinationMatrix(iCombPatch,chosenPatchIdx(iCombPatch,start+j)),...
%                              j);
%                         bestLocComb{w}(iCombPatch,j,:) = bestLoc{w}...
%                             (combinationMatrix(iCombPatch,chosenPatchIdx(iCombPatch,start+j)),...
%                              j,:);
%             %             start + j
%             %             I(i,start+j)
%             %             combinationMatrix(i,:)
%                     end
%                 end
%                 start = start + j;
% 
%                 if isempty(find(bestBandsComb{w}(:) == 0)) == 0 || ...
%                    isempty(find(bestLocComb{w}(:)   == 0)) == 0
%                         fprintf('Preallocation messed it up!!!\n')
%                         k
%                 end
%             end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
c2f       = c2Comb;
bestBands = bestBandsComb;
bestLoc   = bestLocComb;

    %% Sart saving variables
    save([saveLoc 'c2'          quadType '.mat'],'c2f');
    save([saveLoc 'bestBandsC2' quadType '.mat'],'bestBands');
    save([saveLoc 'bestLocC2'   quadType '.mat'],'bestLoc');
    save([saveLoc 'chosenPatchIdx'       '.mat'],'chosenPatchIdx');
    c2f = []; c2fComb = []; bestBands = {}; bestBandsComb = {};
    bestLoc = {}; bestLocComb = {};

%% Save parameter space.
runDateTime = datetime('now');
outputOfPWD = pwd;
scriptName  = mfilename('fullpath');
save([saveLoc 'combinationParameterSpace.mat'],...
    'scriptName',...
    'quadType',...
    'COMBINATION',...
    'combinationMatrix',...
    'outputOfPWD',...
    'runDateTime',...
    'runParameterComments',...
    'nPatchesAnalyzed',...
    'saveLoc',...
    'loadLoc'...
    );
save([saveLoc 'facesLoc.mat'],'facesLoc');

%% Run localization code?

if localize == 1
    display('running localization now...\n')
    annulusWedgeAndBoxLocalization_resizingCUR(nCombPatches,saveFolder)
end

toc
end