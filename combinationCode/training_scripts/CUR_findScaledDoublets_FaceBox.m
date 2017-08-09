function CUR_findScaledDoublets_FaceBox(nPatches,nTPatches,nCPatches)

% This script will take a number of top-patches, find "hard images" for
% EACH of those top patches, and then find complementary patches that do
% well on those hard images.

% The script then determines the best scaling factor to apply to the C2 values
% of each doublet consisting of one top-patch and one complementary-patch.

% The script then calls CUR_make_scaledDoublet_c2_imgHits.m code to find
% new localization accuracy for each of these doublets.

% NOTE: this script will use the FACE-BOX accuracy criterion to find best
% patches, not the WEDGE-criterion.

%% GLOBAL STUFF
% clear; clc;
dbstop if error;
runParameterComments = 'none';%input('Any comments about the run?\n'); %#ok<*NASGU>

loadFolder = 'simulation1/testing/data/patchSetAdam/lfwSingle50000';
if (nargin < 1)
    nPatches = 50000;
    nTPatches = 10;
    nCPatches = 10;
end
saveFolder = ['simulation1/testing/data/patchSetAdam/lfwSingle50000/scaling_FaceBox_switchSets/doublets/' int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches'];
% saveFolder = ['simulation1/sandbox'];

if ispc == 1
    loadLoc    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' loadFolder '\'];
    saveLoc    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' saveFolder '\'];
else    
    loadLoc    = ['/home/levan/HMAX/annulusExptFixedContrast/' loadFolder '/'];
    saveLoc    = ['/home/levan/HMAX/annulusExptFixedContrast/' saveFolder '/'];
end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end
% cd(loadLoc)
% load(['imageDifficultyData_FaceBox_' int2str(nPatches) '_patches'],'IndPatch','sortSumStatsPatch','IndImg','sortSumStatsImg');
load([loadLoc 'imageDifficultyData_FaceBox_' int2str(nPatches) '_Patches'],'IndPatch');
load([loadLoc 'imgHitsFaceBox.mat']);
load([loadLoc 'c2f.mat']);
nImgs = size(c2f,2);

%% START TP LOOP
tic;
combMatrix = zeros(nTPatches*nCPatches,4);
% imgHitsColored = zeros(nTPatches,nImgs,3); % This was our attempt to
% create a color map of t-patch, c-patch, and doublet hits. It got too
% complex.
for i = 1:nTPatches
    i

% Preprocessing
idxTopPatch = IndPatch(i);

idxHardImgs = find(imgHitsFaceBox(idxTopPatch,:) == 0); %#ok<*NODEF>
idxEasyImgs = find(imgHitsFaceBox(idxTopPatch,:) == 1);

hardImgMap = imgHitsFaceBox(:,idxHardImgs);
easyImgMap = imgHitsFaceBox(:,idxEasyImgs);
nHardImgs  = length(idxHardImgs);
nEasyImgs  = length(idxEasyImgs);

                                                                                                                                    % Some sanity checks.
                                                                                                                                    assert(nnz(hardImgMap(idxTopPatch,:)) == 0);
                                                                                                                                    assert(nHardImgs == nImgs - nEasyImgs);
                                                                                                                                    allSuccesses = nnz(imgHitsFaceBox(:));
                                                                                                                                    hardSuccesses = nnz(hardImgMap(:));
                                                                                                                                    easySuccesses = nnz(easyImgMap(:));
                                                                                                                                    assert(allSuccesses == hardSuccesses + easySuccesses);
%% make a colored imgHits map
% yellow_color = [255 255 0];
% blue_color   = [0   0 255];
% green_color  = [0   255 0];

% imgHitsColored(i,idxEasyImgs,:) = repmat(reshape(blue_color,[1,1,3]),1,length(idxEasyImgs));

%% Now find patches that do well on hard images.
sumStats_CPatch = zeros(1,nPatches); % preallocated
for iPatch = 1:nPatches
    sumStats_CPatch(iPatch) = nnz(hardImgMap(iPatch,:));
end
[sortSumStats_CPatch,idxCPatches] = sort(sumStats_CPatch,'descend');

% Construct info about complementary patches.
CPInfo.idxPatches   = idxCPatches(1:nCPatches);
CPInfo.nHardImgsHit = sortSumStats_CPatch(1:nCPatches);
for j = 1:nCPatches
    CPInfo.nAllImgsHit(j) = nnz(imgHitsFaceBox(CPInfo.idxPatches(j),:));
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
    newC2 = [c2f(idxTopPatch,:); c2f(idx_iCPatch,:)];
    newImgHitsFaceBox = [imgHitsFaceBox(idxTopPatch,:); imgHitsFaceBox(idx_iCPatch,:)];

    % Subtract c-patch C2 values from b-patch C2 values. 
    sfArray = newC2(1,:) ./ newC2(2,:); % DIVIDE TP C2 values by CP C2 values

    allSF = sort(sfArray);
    pushValue = 0.001;
    
    % sanity check that rounding errors don't mess us up.
    recreated_original_C2 = newC2(2,:) .* sfArray;
    diff_C2s = newC2(1,:) - recreated_original_C2;
    assert(pushValue > max(abs(diff_C2s)));
    % so if SF were calculated with some rounding errors, resulting in the
    % scaling multiplication that is not perfect, pushValue should
    % definitely be larger to over-cover any such error.
    
%                                                                                                                                      plotSFarrays(newC2,sfArray,allSF)
%                                                                                                                                      close;
%     fprintf([int2str(length(allSF)) ' scaling factors!!!!\n']);

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
            
            [newC2_Scaled_min(1,:),chosenPatchIdx(1,:)] = min(newC2_Scaled,[],1); %#ok<ASGLU>
            
%                                                                                                                                     hold on
%                                                                                                                                     plot(newC2_Scaled(1,:))
%                                                                                                                                     plot(newC2_Scaled(2,:))
%                                                                                                                                     plot(newC2_Scaled_min(1,:)+0.05)
%                                                                                                                                     legend('BP','CP','Minimum C2')
%                                                                                                                                     close;
            
            newImgHitsFaceBox_Scaled = zeros(1,nImgs);
            
                for iImg = 1:nImgs
%                     iImg
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
%                                                                                                                                      plot(bestLoc);
% combMatrixLoop = [repmat(idxTopPatch,nCPatches,1) CPInfo.idxPatches' bestSF' bestLoc'];
% combMatrix = [combMatrix; combMatrixLoop];
combMatrix(  ((i-1)*nCPatches+1):i*nCPatches,:) = [repmat(idxTopPatch,nCPatches,1) CPInfo.idxPatches' bestSF' bestLoc'];
key = [{'Top Patch'} {'Complementary Patch'} {'SF'} {'New Localization'}];
% combMatrixLoop = [];

% if mod(iCPatch,500) == 0
%     save([saveLoc 'combMatrix'],'combMatrix');
% end
iToc = toc
end % nTPaches loop

overallMaxLoc = max(combMatrix(:,4))/nImgs*100

%% SAVE VARIABLES

save([saveLoc 'combMatrix'],'combMatrix');
save([saveLoc 'key_to_combMatrix'],'key');
CUR_make_scaledDoublet_c2_imgHitsFaceBox(loadLoc,saveLoc,nTPatches,nCPatches,pushValue)
runTime = toc

runDateTime = datetime('now');
outputOfPWD = pwd;
scriptName  = mfilename('fullpath');
save([saveLoc 'runParameters.mat'],...
    'runDateTime',...
    'scriptName',...
    'outputOfPWD',...
    'runParameterComments',...
    'nPatches',...
    'nTPatches',...
    'nCPatches',...
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