function combinePatchesTest(loadFolder, saveFolder, ...
                        COMBINATION, nPatches, quadType, nQuad)
% This function combines patches by finding the C2 across all bands of all
% scales of all patches being combined. For example, if two patches are
% combined, each with 8 scale bands, the code will find the minimum S2
% across all 16 scale bands and record the S2 value, bestBand, bestLoc, and
% which patch did the bestBand belong to. 

%% Define Global variables
dbstop if error;

if (nargin < 1)
    loadFolder = 'testingSetRuns\patchSet3\lfwSingle10000'
    saveFolder = 'testingSetRuns\patchSet3\sandbox\third'
    COMBINATION = 3
%     nPatches = 100;
    quadType = 'f';
    nQuad = 4;
end
runParameterComments = input('Any comments about the run?\n'); %#ok<*NASGU>
% customIdx            = input('Combining custom indices?\n');

if ispc == 1
    loadLoc    = ['C:\Users\Levan\HMAX\naturalFaceImages\' loadFolder '\']
    saveLoc    = ['C:\Users\Levan\HMAX\naturalFaceImages\' saveFolder '\']

else    
    loadLoc    = ['/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/' loadFolder '/']
    saveLoc    = ['/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages2/' saveFolder '/']
end
customIdx = 'yes';
nHardImgs = 41
load([saveLoc num2str(nHardImgs) '_Hard_Images_customCombMatrix.mat']);
combinationMatrix = customCombMatrix;
load([loadLoc 'facesLoc.mat']);

%% Start main code
for iQuad = 1:nQuad
    iQuad
    load([loadLoc 'c2'          quadType int2str(iQuad) '.mat'])
    load([loadLoc 'bestBandsC2' quadType int2str(iQuad) '.mat'])
    load([loadLoc 'bestLocC2'   quadType int2str(iQuad) '.mat'])
    nImgsPerQuad = length(facesLoc{iQuad});

        %% Get the new C2 matrix
%         combinationMatrix = combnk(1:nPatches,COMBINATION);
        
        % Do not combine within first 50 or within last 50 patches
%         for k = 1:size(combinationMatrix,1)
%            if isequal((combinationMatrix(k,:) <= 50),[1 1 1]) == 1 ...
%                    || isequal((combinationMatrix(k,:) >= 50),[1 1 1]) == 1
%                combinationMatrix(k,:) = NaN;
%            end
%         end
%         combinationMatrix = combinationMatrix(~any(isnan(combinationMatrix),2),:);
        
        
        nCombPatches      = length(combinationMatrix);
        c2Comb            = zeros(nCombPatches,nImgsPerQuad);
        chosenPatchIdx    = zeros(nCombPatches,nImgsPerQuad);

%%%%%%%%% THIS MUST BE UNCOMMENTED IF COMBINING CUSTOM INDECES%%%%%%
%             if strmatch(customIdx,'yes') == 1
%                 load([loadLoc 'customCombIdx']);
%                 if length(customCombIdx) ~= nPatches
%                     fprintf('customCombIdx and nPatches do not match');
%                 else
%                     c2f = c2f(customCombIdx,:);
%                     for w = 1:size(bestBands,2)
%                         bestBands{w} = bestBands{w}(customCombIdx,:);
%                         bestLoc{w}   = bestLoc{w}(customCombIdx,:,:);
%                     end
%                 end
%             end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
            % predefine bestBands and bestLoc for speed.
            bestBandsComb = cell(1,size(bestBands,2));
            bestLocComb   = cell(1,size(bestLoc,  2));
            for w = 1:size(bestBands,2)
                bestBandsComb{w} = zeros(nCombPatches,size(bestBands{w},2));
                bestLocComb{w}   = zeros(nCombPatches,size(bestLoc{w},2),2);
            end     
            % Start populating bestBands and bestLoc
                start = 0;
                for w = 1:size(bestBands,2)
                    for iCombPatch = 1:nCombPatches
                        if mod(iCombPatch,1000) == 0
                            iCombPatch
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
    'nHardImgs',...
    'combinationMatrix',...
    'outputOfPWD',...
    'runDateTime',...
    'runParameterComments',...
    'saveLoc',...
    'loadLoc'...
    );
save([saveLoc 'facesLoc.mat'],'facesLoc');

%% call the localization code
fprintf('Starting Localization code');
naturalLocalization('facesLoc.mat',nCombPatches,saveFolder);
end