function topNPatch = fixAUC(topNPatch)

newAllAUC = topNPatch.allAUC;
for r = 1:size(newAllAUC, 1)
	for c = 1:size(newAllAUC, 2)
%		if(newAllAUC(r, c) < 0.5)
			newAllAUC(r, c) = 1- newAllAUC(r, c);
%		end
	end
end

topNPatch.allAUC = newAllAUC;

end
