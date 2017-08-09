function topNPatch = fixTopAUC(topNPatchOld)
%Finds the patches that gives the top nPatch AUCs
%
%nPatchSize: Number of patch sizes you want to find the top AUCS from. If 3, then the code will take 
%	the top AUCs from the 3 smallest patch size. 
%nPatch: How many AUCs you want outputted. 
%path: location of where you patches and C2s are
%
%topNPatch: Struct that contains the FI, AUC, allAUC, patchSize, and patch number of top nPatch patches. The 
%	patch number corresponds to patch in ['patch' int2str(patchSize / 2) '.mat'] in the directory
%	located in 'path' as specified in the argument. The first row in allAUC is all the AUCs of the smallest
%	size with the next row containing all the AUCs of the next smallest size and so forth

topNPatch.FI = [];
topNPatch.AUC = [];
topNPatch.patchSize = [];
topNPatch.patchNumber = [];
topNPatch.allAUC = [];
topNPatch.allFI = [];
topNPatch.allIndex = [];

%fix the AUCs because the C2s are euclidean instead of gaussian and flip the vectors to reorder
topNPatchOld = fixAUC(topNPatchOld);
topNPatchOld.allAUC = fliplr(topNPatchOld.allAUC);
topNPatchOld.allFI = fliplr(topNPatchOld.allFI);
topNPatchOld.allIndex = fliplr(topNPatchOld.allIndex);

topNPatch.allAUC = topNPatchOld.allAUC;
topNPatch.allFI = topNPatchOld.allFI;
topNPatch.allIndex = topNPatchOld.allIndex;
nPatch = size(topNPatchOld.AUC, 2);

for iSize = 1:size(topNPatchOld.allAUC, 1)
	if(length(topNPatch.AUC) == 0)
		topNPatch.patchNumber = topNPatchOld.allIndex(iSize, 1:nPatch);
		topNPatch.patchSize = iSize * 2 * ones(1, nPatch); %assumes that the actual patch size is iSize * 2
		topNPatch.AUC = topNPatchOld.allAUC(iSize, 1:nPatch);
		topNPatch.FI = topNPatchOld.allFI(iSize, 1:nPatch);
	else
		indexAUC = topNPatchOld.allIndex(iSize, 1:nPatch);
		AUC = topNPatchOld.allAUC(iSize, 1:nPatch);
		FI = topNPatchOld.allFI(iSize, 1:nPatch);
		catAUC.AUC = horzcat(topNPatch.AUC, AUC);
		catAUC.loc = [zeros(1, nPatch) ones(1, nPatch)];
		catAUC.index = [1:nPatch 1:nPatch];
		[sortedAUC, index] = sort(catAUC.AUC, 2, 'descend');
		newPatchSize = [];
		newPatchNumber = [];
		newAUC = [];
		newFI = [];
		for n = 1:nPatch
			if(catAUC.loc(index(n)) == 0)
				newPatchSize(n) = topNPatch.patchSize(catAUC.index(index(n)));
				newPatchNumber(n) = topNPatch.patchNumber(catAUC.index(index(n)));
				newAUC(n) = topNPatch.AUC(catAUC.index(index(n)));
				newFI(n) = topNPatch.FI(catAUC.index(index(n)));
			else
				newPatchSize(n) = iSize * 2; %assumes that the actual patch size is iSize * 2
				newPatchNumber(n) = indexAUC(catAUC.index(index(n)));
				newAUC(n) = AUC(catAUC.index(index(n)));
				newFI(n) = FI(catAUC.index(index(n)));
			end
		end
		topNPatch.patchSize = newPatchSize;
		topNPatch.patchNumber = newPatchNumber;
		topNPatch.AUC = newAUC;
		topNPatch.FI = newFI;
	end
end
save('/home/bentrans/Documents/HMAX/feature-learning/HMAX-OCV/FixedSuperPatchAll/topNPatchAllFixed.mat', 'topNPatch');

end
