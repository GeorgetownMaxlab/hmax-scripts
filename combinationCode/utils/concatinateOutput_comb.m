function concatinateOutput_comb(loadLoc,nTPatchesPerLoop,nTPatches,nCPatches)

% This function simply concatinates output files from combination script
% into one file. Its usually called by higher order scripts.

rangeStr = 1:nTPatchesPerLoop:nTPatches+nTPatchesPerLoop;

%% Predefine the matrices so its faster.

% Load the first file to get the number of imgs that were analized.
load(fullfile(loadLoc, ['combMatrix_' int2str(rangeStr(1)) '-' int2str(rangeStr(2)-1)]));
[nRows,nCols] = size(combMatrixPatchLoop);


combMatrix = zeros(nTPatches*nCPatches,nCols);
idx_for_combMatrix = 1;
%% Start loop
for iLoop = 1:length(rangeStr)-1
    display(['Concatenating loop ' int2str(iLoop)]);
    load(fullfile(loadLoc, ['combMatrix_' int2str(rangeStr(iLoop)) '-' int2str(rangeStr(iLoop+1)-1)]))

    combMatrix(idx_for_combMatrix:idx_for_combMatrix+nRows-1,:) = combMatrixPatchLoop;
    
    % Now delete the segmented variables to avoid clutter.
    delete(fullfile(loadLoc, ['combMatrix_' int2str(rangeStr(iLoop)) '-' int2str(rangeStr(iLoop+1)-1) '.mat']));
    idx_for_combMatrix = idx_for_combMatrix + nRows;
end

%% Save final variables
save(fullfile(loadLoc,'combMatrix'), 'combMatrix');

end