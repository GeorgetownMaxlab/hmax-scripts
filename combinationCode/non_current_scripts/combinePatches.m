function combinePatches(loadFolder, saveFolder, ...
                        COMBINATION, nPatches, quadType, nQuad)
% This function combines patches by finding the C2 across all bands of all
% scales of all patches being combined. For example, if two patches are
% combined, each with 8 scale bands, the code will find the minimum S2
% across all 16 scale bands and record the S2 value, bestBand, bestLoc, and
% which patch did the bestBand belong to.

%VARIABLES:

% COMBINATION: a double. 2 or 3. Determines whether combining doublets or
               % triplests.
% nPatches: number of patches that will be used to form every possible
            % combination of doublets or triplets. 
% nQuad: number of quadrants into which the original images were broken up.

%% Define Global variables
dbstop if error;

if (nargin < 5)
    quadType = 'f';
    nQuad = 4;
end
runParameterComments = input('Any comments about the run?\n'); %#ok<*NASGU>

if ispc == 1
    loadLoc    = ['C:\Users\Levan\HMAX\naturalFaceImages\' loadFolder '\']
    saveLoc    = ['C:\Users\Levan\HMAX\naturalFaceImages\' saveFolder '\']

else    
    loadLoc    = ['/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/' loadFolder '/']
    saveLoc    = ['/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/' saveFolder '/']
end

load([loadLoc 'facesLoc.mat']);

%% Start main code
for iQuad = 1:nQuad
    iQuad
    load([loadLoc 'c2'          quadType int2str(iQuad) '.mat'])
    load([loadLoc 'bestBandsC2' quadType int2str(iQuad) '.mat'])
    load([loadLoc 'bestLocC2'   quadType int2str(iQuad) '.mat'])
    nImgsPerQuad = length(facesLoc{iQuad});

        %% Get the new C2 matrix
        combinationMatrix = combnk(1:nPatches,COMBINATION);
        nCombPatches      = length(combinationMatrix);
        c2Comb            = zeros(nCombPatches,nImgsPerQuad);
        chosenPatchIdx    = zeros(nCombPatches,nImgsPerQuad);
        
        if     COMBINATION == 2 
            for i = 1:nCombPatches
                C = [c2f(combinationMatrix(i,1),:); c2f(combinationMatrix(i,2),:)];
                    [c2Comb(i,:),chosenPatchIdx(i,:)] = min(C,[],1);
                C = [];
            end
        elseif COMBINATION == 3
            for i = 1:nCombPatches
                C = [c2f(combinationMatrix(i,1),:); c2f(combinationMatrix(i,2),:); c2f(combinationMatrix(i,3),:)];
                    [c2Comb(i,:),chosenPatchIdx(i,:)] = min(C,[],1);
                C = [];
            end
        else
            fprintf('COMBINATION variable not appropriate')
        end
            %% Get the bestBands and bestLoc matrices
            %predefine bestBands and bestLoc for speed.
            bestBandsComb = cell(1,size(bestBands,2));
            bestLocComb   = cell(1,size(bestLoc,  2));
            for w = 1:size(bestBands,2)
                bestBandsComb{w} = zeros(nCombPatches,size(bestBands{w},2));
                bestLocComb{w}   = zeros(nCombPatches,size(bestLoc{w},2),2);
            end     
            %Start populating bestBands and bestLoc
                start = 0;
                for w = 1:size(bestBands,2)
                    for iCombPatch = 1:nCombPatches
                        if mod(iCombPatch,1000) == 0
%                             iCombPatch
                        end
                        for j = 1:size(bestBands{w},2)
                            bestBandsComb{w}(iCombPatch,j) = bestBands{w}...
                                (combinationMatrix(iCombPatch,chosenPatchIdx(iCombPatch,start+j)),...
                                 j);
                            bestLocComb{w}(iCombPatch,j,:) = bestLoc{w}...
                                (combinationMatrix(iCombPatch,chosenPatchIdx(iCombPatch,start+j)),...
                                 j,:);
                %             start + j
                %             I(i,start+j)
                %             combinationMatrix(i,:)
                        end
                    end
                    start = start + j;
                    
                    if isempty(find(bestBandsComb{w}(:) == 0)) == 0 || ...
                       isempty(find(bestLocComb{w}(:)   == 0)) == 0
                            fprintf('Preallocation messed it up!!!\n')
                            k
                    end
                end
            c2f       = c2Comb;
            bestBands = bestBandsComb;
            bestLoc   = bestLocComb;

    %% Sart saving variables
    save([saveLoc 'c2'          quadType int2str(iQuad) '.mat'],'c2f');
    save([saveLoc 'bestBandsC2' quadType int2str(iQuad) '.mat'],'bestBands');
    save([saveLoc 'bestLocC2'   quadType int2str(iQuad) '.mat'],'bestLoc');
    save([saveLoc 'chosenPatchIdx'       int2str(iQuad) '.mat'],'chosenPatchIdx');
    c2f = []; c2fComb = []; bestBands = {}; bestBandsComb = {};
    bestLoc = {}; bestLocComb = {};
end

%% Save variables outside of the for loop.
runDateTime = datetime('now');
outputOfPWD = pwd;
save([saveLoc 'combinationParameterSpace.mat'],...
    'quadType',...
    'nQuad',...
    'COMBINATION',...
    'combinationMatrix',...
    'outputOfPWD',...
    'runDateTime',...
    'runParameterComments',...
    'nPatches',...
    'saveLoc',...
    'loadLoc'...
    );
save([saveLoc 'facesLoc.mat'],'facesLoc');

end