function CUR_annulus_Wedge_Calculation(...
                    loadLoc,...
                    saveLoc,...
                    wedgeInDeg)

% This script is adjusted to perform localization for any size of patches.

                
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
        