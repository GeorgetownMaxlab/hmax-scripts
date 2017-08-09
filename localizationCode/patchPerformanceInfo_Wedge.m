function patchPerformanceInfo_Wedge(...
    loadLoc,...
    saveLoc)

if (nargin < 1)
    loadLoc = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation2\set2\data\patchSet_3x1\lfwSingle50000\newCode_saveAngles3';
    saveLoc = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation2\set2\data\patchSet_3x1\lfwSingle50000\newCode_saveAngles3\sandbox';
end

if ~exist(saveLoc)
    mkdir(saveLoc)
end

load(fullfile(loadLoc,'imgHitsWedge.mat'));

for iAngle = 1:numel(imgHitsWedge.wedgeInDeg)
    
    eval(['iMap = imgHitsWedge.wedgeDegree_' num2str(imgHitsWedge.wedgeInDeg(iAngle)) ';']);
    
    [nPatches,nImgs] = size(iMap);
    
    sumStatsPatch = sum(iMap,2)/nImgs   *100;
    sumStatsImg   = sum(iMap,1)/nPatches*100;
    
    [sortSumStatsPatch, idx_best_patches] = sort(sumStatsPatch,'descend'); %#ok<*ASGLU>
    [sortSumStatsImg,   idx_best_imgs]    = sort(sumStatsImg  ,'descend');
    
    %% Save
    save(fullfile(saveLoc,['patchPerformanceInfo_Wedge_' num2str(imgHitsWedge.wedgeInDeg(iAngle)) '.mat']),...
        'sortSumStatsPatch','idx_best_patches','sortSumStatsImg','idx_best_imgs');
    
end
end