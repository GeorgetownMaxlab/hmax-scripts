function bestPatches = getBestPatches(topNPatch, numPatchSize, patchHome)
%OUTDATED
%produce the 'Hall of Fame' patches from topNPatch (see topAUC.m)
%
%topNPatch: output of topAUC.m
%patchHome: directory of where the patches are stored
%
%bestPatches: struct that contains the band, source img, size, location and patch

if(nargin < 3) patchHome = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-OCV/noResize2/'; end;

bestPatches.sizes = [2:2:(numPatchSize * 2); 2:2:(numPatchSize * 2); 4 * ones(1, numPatchSize); zeros(1, numPatchSize)];
for iSize = 1:numPatchSize
	bestPatches.bands{iSize} = [];
	bestPatches.imgs{iSize} = [];
	bestPatches.locations{iSize} = [];
	bestPatches.patches{iSize}{1} = [];
end
for iPatch = 1:length(topNPatch.AUC)
	patchSize = topNPatch.patchSize(iPatch);
	patches = load([patchHome 'patch' int2str(patchSize / 2) '.mat']); %loads patches here
	patches = patches.patches;
	
	patchNumber = topNPatch.patchNumber(iPatch);
	bestPatches.sizes(4, patchSize / 2) = bestPatches.sizes(4, patchSize / 2) + 1;
	bestPatches.bands{patchSize / 2} = horzcat(bestPatches.bands{patchSize / 2}, patches.bands(patchNumber));
	bestPatches.imgs{patchSize / 2} = horzcat(bestPatches.imgs{patchSize / 2}, patches.imgs(patchNumber));
	bestPatches.locations{patchSize / 2} = vertcat(bestPatches.locations{patchSize / 2}, patches.locations(patchNumber, :));
	bestPatches.patches{patchSize / 2}{1} = horzcat(bestPatches.patches{patchSize / 2}{1}, patches.patches{1}(:, patchNumber));
end
save([patchHome 'bestPatches.mat'], 'bestPatches');

end

