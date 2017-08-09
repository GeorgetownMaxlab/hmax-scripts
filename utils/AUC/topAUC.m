function topNPatch = topAUC(nPatchSize, nPatch, path) 
%FOR FASTER AUC CALUCATION SEE JAKE'S CODE FOR AUC CALUCALTION (Levan should have it)
%Outdated! For the sorting an array with an array dependent on it, (sort an array but have the index of the array match
%the new sorted array) use sort2 to clean things up if this does come back into use
%
%Finds the patches that gives the top nPatch AUCs
%
%nPatchSize: Number of patch sizes you want to find the top AUCS from. If 3, then the code will take 
%	the top AUCs from the 3 smallest patch size. 
%nPatch: How many AUCs you want outputted. 
%path: location of where patches and C2s are
%
%topNPatch: Struct that contains the FI, AUC, allAUC, patchSize, and patch number of top nPatch patches. The 
%	patch number corresponds to patch in ['patch' int2str(patchSize / 2) '.mat'] in the directory
%	located in 'path' as specified in the argument. The first row in allAUC is all the AUCs of the smallest
%	size with the next row containing all the AUCs of the next smallest size and so forth

if(nargin < 3)
	path = '~/Documents/HMAX/feature-learning/HMAX-OCV/noResize2/';
end
addpath(path);

topNPatch.FI = [];
topNPatch.AUC = [];
topNPatch.patchSize = [];
topNPatch.patchNumber = [];
topNPatch.allAUC = [];
topNPatch.allFI = [];
topNPatch.allIndex = [];

for iSize = 1:nPatchSize
	c2t = load(['c2t' int2str(iSize) '.mat']);
	c2t = c2t.c2t;
	c2d = load(['c2d' int2str(iSize) '.mat']);
	c2d = c2d.c2d;
	fi = fisher(c2t', c2d');

	[FI, indexFI] = sort(fi, 2, 'ascend');
	AUC = [];
	fprintf(['starting AUC calculations for size ' int2str(iSize) '...']);
	parfor iFI = 1:length(FI)	
			labels = [ones(1, length(c2t(1, :))) zeros(1, length(c2d(1, :)))];
			scores = [c2t(indexFI(iFI), :) c2d(indexFI(iFI), :)];	
			[x, y, T, auc] = perfcurve(labels, scores, 0); %care for posclass; c2s are euclidean distances
			AUC(iFI) = auc;
	end
	fprintf('Done making AUC calculations');
	[AUC, ind] = sort(AUC, 2, 'ascend');
	topNPatch.allAUC = vertcat(topNPatch.allAUC, AUC);
	AUC = AUC(1:nPatch);
	indexAUC = [];
	for i = 1:length(ind)
		indexAUC(i) = indexFI(ind(i));
	end
	for i = 1: length(indexAUC)
		topNPatch.allFI(iSize, i) = fi(indexAUC(i));
	end
	topNPatch.allIndex = vertcat(topNPatch.allIndex, indexAUC);
	indexAUC = indexAUC(1:nPatch);
	if(length(topNPatch.AUC) == 0)
		%if nothing exists yet and this is the first one, nocomparison needed
		topNPatch.patchNumber = indexAUC;
		topNPatch.patchSize = iSize * 2 * ones(1, nPatch); %assumes that the actual patch size is iSize * 2
		topNPatch.AUC = AUC;
		topNPatch.FI = FI(1:nPatch);
	else
		%concatenates everything and keeps track of where it came from
		catAUC.AUC = horzcat(topNPatch.AUC, AUC);
		catAUC.loc = [zeros(1, nPatch) ones(1, nPatch)];
		catAUC.index = [1:nPatch 1:nPatch];
		[sortedAUC, index] = sort(catAUC.AUC, 2, 'ascend');
		newPatchSize = [];
		newPatchNumber = [];
		newAUC = [];
		newFI = [];
		for n = 1:nPatch
			%loops through the new top nPatch AUC giving patches and store its correlated data
			if(catAUC.loc(index(n)) == 0)
				%if it already existed in topNPatch before, find it and store it in the new 
				newPatchSize(n) = topNPatch.patchSize(catAUC.index(index(n)));
				newPatchNumber(n) = topNPatch.patchNumber(catAUC.index(index(n)));
				newAUC(n) = topNPatch.AUC(catAUC.index(index(n)));
				newFI(n) = topNPatch.FI(catAUC.index(index(n)));
			else
				% if does not already exist in topNPatch (came from current patch size), take data and store into new
				newPatchSize(n) = iSize * 2; %assumes that the actual patch size is iSize * 2
				newPatchNumber(n) = indexAUC(catAUC.index(index(n)));
				newAUC(n) = AUC(catAUC.index(index(n)));
				newFI(n) = fisher(c2t(newPatchNumber(n),:)', c2d(newPatchNumber(n),:)');
			end
		end
		topNPatch.patchSize = newPatchSize;
		topNPatch.patchNumber = newPatchNumber;
		topNPatch.AUC = newAUC;
		topNPatch.FI = newFI;
	end
end
save([path 'topNPatchAll.mat'], 'topNPatch');
rmpath(path);

end
