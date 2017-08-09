function topNPatch = fixPatchNumber(topNPatch, pSize)

index = 1;
newPatchNumber = [];
for n = 1:length(topNPatch.patchNumber)
	newPatchNumber(n) = topNPatch.patchNumber(n);
	if(newPatchNumber(n) == 0)
		newPatchNumber(n) = topNPatch.allIndex(pSize, index);
		index = index + 1;
	end
end
topNPatch.patchNumber = newPatchNumber;

end
