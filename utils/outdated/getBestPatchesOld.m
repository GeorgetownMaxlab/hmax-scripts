function bestPatches = getBestPatchesOld(topNPatch, patchHome)
%produce the 'Hall of Fame' patches from topNPatch (see topAUC.m)
%
%topNPatch: output of topAUC.m
%patchHome: directory of where the patches are stored
%
%bestPatches: struct that contains the band, source img, size, location and patch

if(nargin < 2) patchHome = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/SuperPatch/'; end;

for iPatch = 1:length(topNPatch.AUC)
	patchSize = topNPatch.patchSize(iPatch);
	patches = load([patchHome 'patch' int2str(patchSize / 2) '.mat']);
	patches = patches.patches;
	
	patchNumber = topNPatch.patchNumber(iPatch);
	bestPatches.bands(iPatch) = patches.bands(patchNumber);
	bestPatches.imgs(iPatch) = patches.imgs(patchNumber);
	bestPatches.sizes(:, iPatch) = patches.sizes(:, 1);
	bestPatches.locations(iPatch, :) = patches.locations(patchNumber, :);
	bestPatches.patches{iPatch}{1} = patches.patches{1}(:, patchNumber);
end
save(['bestPatchesOld'], 'bestPatches');

end

