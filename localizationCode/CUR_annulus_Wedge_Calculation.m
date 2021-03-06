function CUR_annulus_Wedge_Calculation(...
                    loadLoc,...
                    saveLoc,...
                    wedgeInDeg)

% This script is called by CUR_genLoc.m. 
% It will create imgHitsWedge maps for various sizes of wedges. Depending
% on how wide of a wedge you consider, a patch will either have "hit" the
% face in a given image, or "missed" it. So for each wedge size, you get a
% separate imgHitsWedge map, showing 1 or 0 for every cell entry,
% indicating whether there was a "hit" or a "miss".
                
%% Define global variables and load files.

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

load(fullfile(loadLoc,'angularDistRad'))

[nPatches,nImgs] = size(angularDistRad);

%% Generate multiple distance maps for different wedge criteria
close all;
wedgeInRad = deg2rad(wedgeInDeg);

for iAngle = 1:numel(wedgeInRad)
    
    criterionDistancesRad   = ones(nPatches,nImgs)*...
                              (wedgeInRad(iAngle))/2; % Divide the wedge in 2 because face is centered in the middle. 
    eval(['imgHitsWedge.wedgeDegree_' int2str(wedgeInDeg(iAngle)) ' = criterionDistancesRad > angularDistRad;']);
%     figure
%     eval(['imagesc(imgHitsWedgeNew.wedgeDegree_' int2str(wedgeInDeg(iAngle)) ')'])
end
imgHitsWedge.wedgeInDeg = wedgeInDeg;

%% Save the imgHitsWedge

save(fullfile(saveLoc,'imgHitsWedge.mat'),'imgHitsWedge');

end        
        