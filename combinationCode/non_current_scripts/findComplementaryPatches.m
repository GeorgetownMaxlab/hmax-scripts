% find complementary patches

%% GLOBAL STUFF
clear; clc;
% if (nargin < 1)
    loadFolder = 'trainingRuns/patchSetAdam/lfwSingle50000';
    saveFolder = 'trainingRuns/patchSetAdam/lfwSingle50000\sandbox';
    nPatches = 50000;
    idxPatchConsidered = 1;
    nCPatchesConsidered = 100;
% end


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

load([loadLoc 'imageDifficultyData_Wedge_50000_patches.mat'],'IndPatch','sortSumStatsPatch','IndImg','sortSumStatsImg');
load([loadLoc 'imgHitsWedge.mat']);
load([loadLoc 'c2f.mat']);

% Preprocessing
idxBestPatch = IndPatch(idxPatchConsidered);
bestPatchRow = imgHitsWedge(idxBestPatch,:);

idxHardImgs = find(bestPatchRow == 0);
idxEasyImgs = find(bestPatchRow == 1);

hardImgMap = imgHitsWedge(:,idxHardImgs);
easyImgMap = imgHitsWedge(:,idxEasyImgs);
nHardImgs = length(idxHardImgs);
nEasyImgs = length(idxEasyImgs);

%% Now find patches that do well on hard images.

for iPatch = 1:nPatches
    sumStatsPatchCompl(iPatch) = nnz(hardImgMap(iPatch,:));
end
[sortSumStatsPatchCompl,idxComplPatches] = sort(sumStatsPatchCompl,'descend');

    % Construct info about complementary patch.
    complInfo.idxPatches = idxComplPatches(1:nCPatchesConsidered); %find(sumStatsPatchCompl == (max(sumStatsPatchCompl)));
%     assert(length(complInfo.idxPatch) == 1,'Many best complementary patches exist');
    complInfo.nHardImgsHit = sortSumStatsPatchCompl(1:nCPatchesConsidered);
    for j = 1:nCPatchesConsidered
        complInfo.nAllImgsHit(j) = nnz(imgHitsWedge(complInfo.idxPatches(j),:));
        complInfo.nEasyImgsHit(j) = complInfo.nAllImgsHit(j) - complInfo.nHardImgsHit(j);
    end
        
% maxPossibleLoc = (complInfo.nHardImgsHit*100/480) + sortSumStatsPatch(idxPatchConsidered);

% Find indices of hard images that complementary patch misses.

% all images missed by the complementary patch.
% idxComplMiss = find(imgHitsWedge(complInfo.idxPatch,:) == 0); 
% assert(numel(idxComplMiss) == (480 - complInfo.nAllImgsHit)); % sanity check.
%     % indices of the hard images missed by complementary path. 
%     idxComplHard_MISS = intersect(idxHardImgs,idxComplMiss); 
%     assert(numel(idxComplHard_MISS) == nHardImgs - complInfo.nHardImgsHit); % sanity check.
%         % all images hit by complementary patch.
%         idxComplHit = setdiff(1:480,idxComplMiss); 
%         idxComplHard_HIT = intersect(idxHardImgs,idxComplHit); % all hard images hit by complementary patch.

%% Now determine the range of SF
for iCPatch = 1:nCPatchesConsidered
    
    idxiCPatch = complInfo.idxPatches(iCPatch);
    newC2 = [c2f(idxBestPatch,:); c2f(idxiCPatch,:)];
    newImgHitsWedge = [imgHitsWedge(idxBestPatch,:); imgHitsWedge(idxiCPatch,:)];

    % newC2_hardImgs = newC2(:,idxComplHard_HIT);

    % newC2_hardImgs(:,2) = [20;100];
    % newC2_hardImgs(:,10) = [100;200];

    % Subtract c-patch C2 values from b-patch C2 values. 
    sfArray = newC2(1,:) ./ newC2(2,:); 
    % sfArray(sfArray>1) = NaN; % make all negative numbers zero so later we can find min difference.

    [maxSF,idxMax] = max(sfArray) 
    [minSF,idxMin] = min(sfArray)
    SF_range = maxSF - minSF
    SF_incr  = round(SF_range/100,2)
    allSF = minSF:SF_incr:maxSF;
    fprintf([int2str(length(allSF)) ' scaling factors!!!!\n']);
    % % If no positive numbers, then c-patch gave lower C2 values on all hard imgs.
    % if isempty(sfArray(sfArray > 0)) 
    %     display('C-patch oucompetes b-patch on all hard images!!!')
    %     SF = 1 % scaling factor should be 1 so that nothing changes. 
    % elseif length(sfArray(sfArray > 0)) == 1 
    %     SF = sfArray;
    % else
    %    [maxSF,idxMax] = max(sfArray) 
    %    [minSF,idxMin] = min(sfArray)
    %    SF = minSF:0.05:maxSF
    % end

    % hold off
    % plot(newC2(1,:))
    % hold on
    % plot(newC2(2,:))
    %% Run through the SF range to find the optimal value.
    % We should start from maxSF to minSF. 

    for ii = 1:length(allSF)
%         ii
        iSF = allSF(ii);

        iiNewC2 = newC2;
        iiNewC2(2,:) = iiNewC2(2,:) .* iSF;

        [iiNewC2_min(1,:),chosenPatchIdx(1,:)] = min(iiNewC2,[],1);

        iiNewImgHitsWedge = zeros(1,size(iiNewC2,2));
        for iImg = 1:size(iiNewC2,2)
            iiNewImgHitsWedge(1,iImg) = newImgHitsWedge(chosenPatchIdx(1,iImg),iImg);
        end

        newLoc(ii) = nnz(iiNewImgHitsWedge);
    end

    [bestLoc(iCPatch),idxBestLoc(iCPatch)] = max(newLoc);
    bestSF(iCPatch) = allSF(idxBestLoc(iCPatch));


end
    
    
    
    
    
    
    
    
    
    
    






