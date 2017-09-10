function CUR_findScaledDoublets_FaceBox_par(...
        nPatchesAnalyzed,...
        iPatchLoop,...
        nTPatchesPerLoop,...
        nCPatches,...
        saveLoc,...
        loadLoc)

% This script is called by CUR_genDoublets_norep.m. The two scripts allow
% parallelization of finding doublets.
    
    
if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

idxTPatchStart = (iPatchLoop-1)*nTPatchesPerLoop+1;
idxTPatchEnd   = (iPatchLoop)  *nTPatchesPerLoop;

% display('Loading the c2 related files...')
load(fullfile(loadLoc,'fixedLocalization','patchPerformanceInfo_FaceBox.mat'));
load(fullfile(loadLoc,'fixedLocalization','imgHitsFaceBox.mat'));
load(fullfile(loadLoc,'c2f.mat'),'c2f');
display('Done loading c2 related files...')
% imgHitsFaceBox = imgHitsFaceBox.imgHits;
nImgs = size(c2f,2);


combMatrixPatchLoop = zeros(nTPatchesPerLoop*nCPatches,4);
idx_for_combMatrix = 1; % since iTPatch will depend on the iPatchLoop, whereas 
% combMatrix has to be populated from 1st till last patch
% this variable will start with 1, grow by 1 along with iTPatch, and will
% indicated where in the combMatrix the data from the iTPatch loop goes.

for iTPatch = idxTPatchStart:idxTPatchEnd
    idx_for_combMatrix
    
    % Preprocessing
    idxTopPatch = idx_best_patches(iTPatch);
    
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
    
    %% Now find patches that do well on hard images.
    sumStats_CPatch = zeros(1,nPatchesAnalyzed); % preallocated
    for iPatch = 1:nPatchesAnalyzed %for thresholding strategy, can we just turn this into "for iPatch = [idx_above_threshold_CPatches]"?
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
%             iCPatch
        idx_iCPatch = CPInfo.idxPatches(iCPatch);
        newC2 = [c2f(idxTopPatch,:); c2f(idx_iCPatch,:)];
        newimgHitsFaceBox = [imgHitsFaceBox(idxTopPatch,:); imgHitsFaceBox(idx_iCPatch,:)];
        
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
            
%             hold on
%             plot(newC2_Scaled(1,:))
%             plot(newC2_Scaled(2,:))
%             plot(newC2_Scaled_min(1,:)+0.05)
%             legend('BP','CP','Minimum C2')
%             close;
            
            newimgHitsFaceBox_Scaled = zeros(1,nImgs);
            
            for iImg = 1:nImgs
                %                     iImg
                newimgHitsFaceBox_Scaled(1,iImg) = newimgHitsFaceBox(chosenPatchIdx(1,iImg),iImg);
            end
            
            newLoc(ii) = nnz(newimgHitsFaceBox_Scaled);
            
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
        newimgHitsFaceBox = [];
        sfArray = [];
        allSF = [];
    end % iCPatch

    combMatrixPatchLoop(  ((idx_for_combMatrix-1)*nCPatches+1):idx_for_combMatrix*nCPatches,:) = ...
        [repmat(idxTopPatch,nCPatches,1) CPInfo.idxPatches' bestSF' bestLoc'];
    
    idx_for_combMatrix = idx_for_combMatrix + 1;
end % iTPaches loop

%% Save the variables

save(fullfile(saveLoc,['combMatrix_'   int2str(idxTPatchStart) '-' int2str(idxTPatchEnd)]),'combMatrixPatchLoop');


end

% function plotSFarrays(newC2,sfArray,newLoc)
% %     hold off
% subplot(2,2,1)
% plot(newC2(1,:));
% hold on
% plot(newC2(2,:));
% title('BP and CP C2 Values','FontSize',25)
% legend('BP','CP')
% axis([0 480 0 1])
% hold off
% 
% subplot(2,2,2)
% plot(sfArray)
% %     plot(allSF)
% axis([0 480 0 6])
% title('Scaling Factors Considered');
% 
% subplot(2,2,3)
% plot(newLoc)
% hold on
% title('Localization for Each SF');
% xlabel('SF values')
% axis([0 480 0 400])
% %     hold off
% end