function topNPatch = topAUCByFI(nPatchSize, nPatch, path)
%FOR FASTER AUC CALCULATIONS SEE JAKE'S CODE FOR AUC CALCULATION (Levan should have it or check basecamp)
%Finds the patches that gives the top nPatch AUCs based on FI
%
%nPatchSize: Number of patch sizes you want to find the top AUCS from. If 3, then the code will take 
%	the top AUCs from the 3 smallest patch size. 
%nPatch: How many AUCs you want outputted. 
%path: location of where you patches and C2s are
%
%topNPatch: Struct that contains the FI, AUC, patchSize, and patch number of top nPatch patches. The 
%	patch number corresponds to patch in ['patch' int2str(patchSize / 2) '.mat'] in the directory
%	located in 'path' as specified in the argument. 

if(nargin < 3)
	path = '~/Documents/HMAX/feature-learning/';
end
addpath(path);

topNPatch.FI = [];
topNPatch.AUC = [];
topNPatch.patchSize = [];
topNPatch.patchNumber = [];

for iSize = 1:nPatchSize
	c2t = load(['c2t' int2str(iSize) '.mat']);
	c2t = c2t.c2t;
	c2d = load(['c2d' int2str(iSize) '.mat']);
	c2d = c2d.c2d;
	fi = fisher(c2t', c2d');

	[FI, indexFI] = sort(fi, 2, 'ascend');
	FI = FI(length(FI) - nPatch + 1:length(FI));
	indexFI = indexFI(length(indexFI) - nPatch + 1:length(indexFI));

	if(length(topNPatch.FI) == 0)
		topNPatch.FI = FI;
		topNPatch.patchNumber = indexFI;
		topNPatch.patchSize = iSize * 2 * ones(1, nPatch); %assumes that the actual patch size is iSize * 2
		for iAUC = 1:nPatch
			labels = [ones(1, length(c2t(1, :))) zeros(1, length(c2d(1, :)))];
			scores = [c2t(topNPatch.patchNumber(iAUC), :) c2d(topNPatch.patchNumber(iAUC), :)];	
			[x, y, T, auc] = perfcurve(labels, scores, '0'); % might need to switch the 'posclass' value. 
			topNPatch.AUC(iAUC) = auc;
		end
	else	
		catFI.FI = horzcat(topNPatch.FI, FI);
		catFI.loc = [zeros(1, nPatch) ones(1, nPatch)];
		catFI.index = [1:nPatch 1:nPatch];
		[sortedFI, index] = sort(catFI.FI, 2, 'ascend');
		topNPatch.FI = sortedFI(length(sortedFI) - nPatch +1:length(sortedFI));
		index = index(length(index) - nPatch + 1:length(index));
		newPatchSize = [];
		newPatchNumber = [];
		newAUC = [];
		for n = 1:nPatch
			if(catFI.loc(index(n)) == 0)
				newPatchSize(n) = topNPatch.patchSize(catFI.index(index(n)));
				newPatchNumber(n) = topNPatch.patchNumber(catFI.index(index(n)));
				newAUC(n) = topNPatch.AUC(catFI.index(index(n)));
			else
				newPatchSize(n) = iSize * 2; %assumes that the actual patch size is iSize * 2
				newPatchNumber(n) = indexFI(catFI.index(index(n)));
				labels = [ones(1, length(c2t(1, :))) zeros(1, length(c2d(1, :)))];
				scores = [c2t(newPatchNumber(n), :) c2d(newPatchNumber(n), :)];	
				[x, y, T, auc] = perfcurve(labels, scores, '0'); % might need to switch the 'posclass' value. 
				newAUC(n) = auc;
			end
		end
		topNPatch.patchSize = newPatchSize;
		topNPatch.patchNumber = newPatchNumber;
		topNPatch.AUC = newAUC;
	end
end 
rmpath(path);

end
