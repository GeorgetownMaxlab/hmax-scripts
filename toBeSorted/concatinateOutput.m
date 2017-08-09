function concatinateOutput(loadLoc,nPatchesPerLoop,nPatchesAnalyzed)

if (nargin < 1)
    loadLoc = 'C:\Users\levan\HMAX/annulusExptFixedContrast/simulation3/part1upright/data/patchSet_3x1/lfwSingle50000';
    nPatchesPerLoop  = 6250;
    nPatchesAnalyzed = 50000;
end

rangeStr = 1:nPatchesPerLoop:nPatchesAnalyzed+nPatchesPerLoop;

bestBands = [];
bestLoc   = [];
c2f       = [];

for i = 1:length(rangeStr)-1
    load(fullfile(loadLoc, ['bestBands_patches' int2str(rangeStr(i)) '-' int2str(rangeStr(i+1)-1) 'allImages.mat']))
    load(fullfile(loadLoc, ['bestLoc_patches'   int2str(rangeStr(i)) '-' int2str(rangeStr(i+1)-1) 'allImages.mat']))
    load(fullfile(loadLoc, ['c2f_patches'       int2str(rangeStr(i)) '-' int2str(rangeStr(i+1)-1) 'allImages.mat']))

% IF bestBands and bestLoc are cell type
%     if i == 1
%         nCells = length(bestBandsPatchLoop);
%         bestBands = cell(1,nCells);
%         bestLoc   = cell(1,nCells);
%         c2f       = [];
%     end
%     
%     for iCell = 1:nCells
%         bestBands{iCell} = [bestBands{iCell}; bestBandsPatchLoop{iCell}];
%         bestLoc{iCell} =   [bestLoc{iCell};   bestLocPatchLoop{iCell}];                
%     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If not cell type.
    bestBands = [bestBands; bestBandsPatchLoop];
    bestLoc   = [bestLoc;   bestLocPatchLoop];
    c2f = [c2f; c2fPatchLoop];
    
    % keep saving the variables as they grow
    save(fullfile(loadLoc,'bestBandsC2f'), 'bestBands');
    save(fullfile(loadLoc,'bestLocC2f')  , 'bestLoc');
    save(fullfile(loadLoc,'c2f')         , 'c2f');
    
    % Now delete the segmented variables to avoid clutter.
    delete(fullfile(loadLoc, ['bestBands_patches' int2str(rangeStr(i)) '-' int2str(rangeStr(i+1)-1) 'allImages.mat']),...
           fullfile(loadLoc, ['bestLoc_patches'   int2str(rangeStr(i)) '-' int2str(rangeStr(i+1)-1) 'allImages.mat']),...
           fullfile(loadLoc, ['c2f_patches'       int2str(rangeStr(i)) '-' int2str(rangeStr(i+1)-1) 'allImages.mat']));
end


        
end