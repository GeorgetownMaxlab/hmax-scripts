function concatinateOutput_loc(loadLoc,nPatchesPerLoop,nPatchesAnalyzed)

rangeStr = 1:nPatchesPerLoop:nPatchesAnalyzed+nPatchesPerLoop;

%% Predefine the matrices so its faster.

% Load the first file to get the number of imgs that were analized.
load(fullfile(loadLoc, ['angularDistRad_' int2str(rangeStr(1)) '-' int2str(rangeStr(2)-1) '_allImages.mat']))
nImgs = size(angularDistPatchLoopRad,2);

imgHitsFaceBox = zeros(nPatchesAnalyzed,nImgs);
% imgHitsWedge   = zeros(nPatchesAnalyzed,nImgs);
angularDistRad = zeros(nPatchesAnalyzed,nImgs);
angularDistDeg = zeros(nPatchesAnalyzed,nImgs);
% sanityCheck    = [];
% runTime        = [];

%% Start loop
for iLoop = 1:length(rangeStr)-1
    display(['Concatenating loop ' int2str(iLoop)]);
    load(fullfile(loadLoc, ['angularDistRad_' int2str(rangeStr(iLoop)) '-' int2str(rangeStr(iLoop+1)-1) '_allImages.mat']))
    load(fullfile(loadLoc, ['angularDistDeg_' int2str(rangeStr(iLoop)) '-' int2str(rangeStr(iLoop+1)-1) '_allImages.mat']))
    
    load(fullfile(loadLoc, ['imgHitsFaceBox_' int2str(rangeStr(iLoop)) '-' int2str(rangeStr(iLoop+1)-1) '_allImages.mat']))
%     load(fullfile(loadLoc, ['imgHitsWedgeOld_'   int2str(rangeStr(iLoop)) '-' int2str(rangeStr(iLoop+1)-1) '_allImages.mat']))
    %     load(fullfile(loadLoc, ['sanityCheck_'    int2str(rangeStr(iLoop)) '-' int2str(rangeStr(iLoop+1)-1) '_allImages.mat']))
    %     load(fullfile(loadLoc, ['runTime_'        int2str(rangeStr(i)) '-' int2str(rangeStr(i+1)-1) '_allImages.mat']))
    
    
    % % If not cell type.
    %     imgHitsFaceBox = [imgHitsFaceBox; imgHitsFaceBoxPatchLoop];
    %     imgHitsWedge   = [imgHitsWedge;   imgHitsWedgePatchLoop];
    %     angularDistRad = [angularDistRad; angularDistPatchLoopRad];
    %     angularDistDeg = [angularDistDeg; angularDistPatchLoopDeg];
    imgHitsFaceBox(rangeStr(iLoop):(rangeStr(iLoop+1)-1),:) = imgHitsFaceBoxPatchLoop;
%     imgHitsWedge  (rangeStr(iLoop):(rangeStr(iLoop+1)-1),:) = imgHitsWedgePatchLoop;
    angularDistRad(rangeStr(iLoop):(rangeStr(iLoop+1)-1),:) = angularDistPatchLoopRad;
    angularDistDeg(rangeStr(iLoop):(rangeStr(iLoop+1)-1),:) = angularDistPatchLoopDeg;
    
    %     save(fullfile(loadLoc,'c2f')         , 'c2f');
    
    % Now delete the segmented variables to avoid clutter.
    delete(fullfile(loadLoc, ['imgHitsFaceBox_' int2str(rangeStr(iLoop)) '-' int2str(rangeStr(iLoop+1)-1) '_allImages.mat']),...
        fullfile(loadLoc, ['angularDistRad_'   int2str(rangeStr(iLoop)) '-' int2str(rangeStr(iLoop+1)-1) '_allImages.mat']),...
        fullfile(loadLoc, ['angularDistDeg_'   int2str(rangeStr(iLoop)) '-' int2str(rangeStr(iLoop+1)-1) '_allImages.mat']));
end

%% Save final variables
save(fullfile(loadLoc,'imgHitsFaceBox'), 'imgHitsFaceBox');
% save(fullfile(loadLoc,'imgHitsWedgeOld'),'imgHitsWedge');
save(fullfile(loadLoc,'angularDistRad'), 'angularDistRad');
% save(fullfile(loadLoc,'angularDistDeg'), 'angularDistDeg');


end