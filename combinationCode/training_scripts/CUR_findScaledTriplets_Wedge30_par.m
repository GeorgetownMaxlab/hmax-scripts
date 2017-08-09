function CUR_findScaledTriplets_Wedge30_par(...
                iPatchLoop,...
                nTPatchesPerLoop,...
                nCPatches,...
                saveLoc,...
                loadLoc,...
                singlesLoc,...
                nDoublets,...
                doubletCombMatrix)

load(fullfile(loadLoc,['imageDifficultyData_Wedge_' int2str(nDoublets) '_Patches']),'IndPatch');            
load(fullfile(loadLoc,'imgHitsWedge.mat'));
load(fullfile(loadLoc,'c2f.mat'));
nImgs = size(c2f,2);

% load the single patch data
singlesimgHitsWedge = load(fullfile(singlesLoc,'imgHitsWedge.mat'));
singlesimgHitsWedge = singlesimgHitsWedge.imgHitsWedge;
singlesimgHitsWedge = singlesimgHitsWedge.wedgeDegree_30;
singlesC2f = load(fullfile(singlesLoc,'c2f.mat'));
singlesC2f = singlesC2f.c2f;
nSingles = size(singlesC2f,1);

%% START TP LOOP

idxTPatchStart = (iPatchLoop-1)*nTPatchesPerLoop+1;
idxTPatchEnd   = (iPatchLoop)  *nTPatchesPerLoop;

combMatrixPatchLoop = zeros(nTPatchesPerLoop*nCPatches,7);
idx_for_combMatrix = 1;

for iTPatch = idxTPatchStart:idxTPatchEnd
%     iTPatch

% PREPROCESSING
idxTopDoublet = IndPatch(iTPatch); %remember this is the index within the doublet data.
% So its not the index of the original patch.

idxHardImgs = find(imgHitsWedge(idxTopDoublet,:) == 0);
idxEasyImgs = find(imgHitsWedge(idxTopDoublet,:) == 1);

% these should be defined from the SINGLES map!!!
hardImgMap = singlesimgHitsWedge(:,idxHardImgs);
easyImgMap = singlesimgHitsWedge(:,idxEasyImgs);
nHardImgs = length(idxHardImgs);
nEasyImgs = length(idxEasyImgs);

% Some sanity checks.
assert(nHardImgs == nImgs - nEasyImgs);
allSuccesses = nnz(singlesimgHitsWedge(:));
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
    CPInfo.nAllImgsHit(j) = nnz(singlesimgHitsWedge(CPInfo.idxPatches(j),:));
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
    newimgHitsWedge = [imgHitsWedge(idxTopDoublet,:); singlesimgHitsWedge(idx_iCPatch,:)];

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
            
%             hold on
%             plot(newC2_Scaled(1,:))
%             plot(newC2_Scaled(2,:))
%             plot(newC2_Scaled_min(1,:)+0.05)
%             legend('BP','CP','Scaled CP')
%             close;
            
            newimgHitsWedge_Scaled = zeros(1,nImgs);
            
                for iImg = 1:nImgs
                    newimgHitsWedge_Scaled(1,iImg) = newimgHitsWedge(chosenPatchIdx(1,iImg),iImg);
                end

            newLoc(ii) = nnz(newimgHitsWedge_Scaled);
            
            % clear variables
            newC2_Scaled = [];
            chosenPatchIdx = [];
        end % SF LOOP
%         plotSFarrays(newC2,sfArray,newLoc)
%         close;


        [bestLoc(iCPatch),idxBestLoc(iCPatch)] = max(newLoc);
        bestSF(iCPatch) = sfArray(idxBestLoc(iCPatch));
        
        % clear variables
        newC2 = [];
        newimgHitsWedge = [];
        sfArray = [];
        allSF = [];
end

%create an output matrix
combMatrixPatchLoop(  ((idx_for_combMatrix-1)*nCPatches+1):idx_for_combMatrix*nCPatches,:) = ...    
    [repmat(doubletCombMatrix(idxTopDoublet,1:2),nCPatches,1) ...
    CPInfo.idxPatches' ...
    repmat(doubletCombMatrix(idxTopDoublet,3)  ,nCPatches,1) ...
    bestSF' ...
    repmat(doubletCombMatrix(idxTopDoublet,4)  ,nCPatches,1) ...
    bestLoc'];

               idx_for_combMatrix = idx_for_combMatrix + 1;
clearvars CPInfo;

% if mod(iCPatch,500) == 0
%     save(fullfile(saveLoc,'combMatrix'),'combMatrix');
% end
% iToc = toc
end % nTPaches loop

% overallMaxLoc = max(combMatrix(:,7))/nImgs*100

%% SAVE VARIABLES

save(fullfile(saveLoc,['combMatrix_'   int2str(idxTPatchStart) '-' int2str(idxTPatchEnd)]),'combMatrixPatchLoop');


end

% function plotSFarrays(newC2,sfArray,newLoc)
% %     hold off
%     subplot(2,2,1)
%     plot(newC2(1,:));
%     hold on
%     plot(newC2(2,:));
%     title('BP and CP C2 Values','FontSize',25)
%     legend('BP','CP')
%     axis([0 480 0 1])
%     hold off
%     
%     subplot(2,2,2)
%     plot(sfArray)
% %     plot(allSF)
%     axis([0 480 0 6])
%     title('Scaling Factors Considered');
%     
%     subplot(2,2,3)
%     plot(newLoc)
%     hold on
%     title('Localization for Each SF');
%     xlabel('SF values')
%     axis([0 480 0 400])
% %     hold off
% end