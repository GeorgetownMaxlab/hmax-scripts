function [c2,c1,bestBands,bestLocations,s2Layer,s1] = extractC2FromCell(filters,filterSizes,c1Space,c1Scale,c1OL,linearPatches,imgs,nPatchSizes,patchSizes,nCOMBINATION,ALLS2C1PRUNE,c1,ORIENTATIONS2C1PRUNE,IGNOREPARTIALS,IGNOREBORDERS,BLUR,keepS2,maxSize)
% [c2,c1,bestBands,bestLocations,s2,s1] = extractC2FromCell(filters,filterSizes,c1Space,c1Scale,c1OL,linearPatches,imgs,nPatchSizes,patchSizes,ALLS2C1PRUNE,c1,ORIENTATIONS2C1PRUNE,IGNOREPARTIALS)
%
% For each image in 'imgs', extract all responses.
%
% args:
%
%     imgs: a cell array of matrices, each representing an image
%
%     filters,filterSizes: see initGabor.m
%
%     c1Space,c1Scale,c1OL: see C1.m
%
%     linearPatches: a cell array with 1 cell/patchSize, each cell holds an
%         patchSizeX * patchSizeY * nOrientations x nPatchesPerSize matrix
%
%     nPatchSizes: size(patchSizes,2) - kept only for backward compatibility
%
%     patchSizes: a 3 x nPatchSizes array of patch sizes 
%     Each column should hold [nRows; nCols; nOrients]
%
%     c1: a precomputed set of C1 responses, as output by C1.m
%
%     IGNOREPARTIALS: see C2.m
%
%		IGNOREBORDERS: see C2.m
%
%     ALLS2C1PRUNE,ORIENTATIONS2C1PRUNE: see windowedPatchDistance.m
%		
%		nCOMBINATION: total number of patch combinations; if 0, no combining of patches.
%
%		BLUR: see C2.m
%
%		keepS2:see genC2.m
%
% returns: 
%
%     c2: a nPatches x nImgs array holding C2 activations
%
%     s2,c1,s1: cell arrays holding the particular s2, c1, or s1 response for
%     each image, see C2.m, C1.m
%
%     bestBands: a nPatches x nImgs array, the band whence came the maximal
%     response for each patch and image
%
%     bestLocations: a nPatches x nImgs x 2 array, the (x,y) pair whence came
%     the maximal response for each patch and image

    nImgs = length(imgs);
    nPatchSizes = size(patchSizes,2);
    nPatchesPerSize = size(linearPatches{1},2);
    nPatches = nPatchSizes*nPatchesPerSize;
	
	 if (nargin < 16) BLUR = 0; end;
	 if (nargin < 15) IGNOREBORDERS = 0; end;
    if (nargin < 14) IGNOREPARTIALS = 0; end;
    if (nargin < 13) ORIENTATIONS2C1PRUNE = 0; end;
    if (nargin < 12 || isempty(c1)) c1 = cell(1,nImgs); end;
    if (nargin < 11) ALLS2C1PRUNE = 0; end;
	 if (nargin < 10) nCOMBINATION = 0; end;
    c2 = zeros(nPatches,nImgs);
    s2 = cell(1,nImgs);
%	s2Layer = cell(1, nPatches);
	s2Layer = cell(1, nImgs);
	b = 0;
    s1 = cell(1,nImgs);
    bestBands = zeros(nPatches,nImgs);
    bestLocations = zeros(nPatches,nImgs,2);
	 COMBINATION = 0;
    for iImg = 1:nImgs
% 		  img = double(resizeImage(grayImage(imread(imgs{iImg})),maxSize));
        img = double(grayImage(uint8(double(imread(imgs{iImg})))));
        for iPatch = 1:nPatchSizes
            patchIndices = (nPatchesPerSize*(iPatch-1)+1):(nPatchesPerSize*iPatch);
				if(nCOMBINATION > 0)
					patchIndices = 1:nCOMBINATION;
					COMBINATION = 1;
				end
            if isempty(c1{iImg}),  %compute C1 & S1
                [c2(patchIndices,iImg),s2{iImg}{iPatch},c1{iImg},s1{iImg},bestBands(patchIndices,iImg),bestLocations(patchIndices,iImg,:)] =...
                C2(img,filters,filterSizes,c1Space,c1Scale,c1OL,linearPatches{iPatch},patchSizes(:,iPatch)',[],IGNOREBORDERS,COMBINATION,BLUR,IGNOREPARTIALS,ALLS2C1PRUNE,ORIENTATIONS2C1PRUNE);
					 if(keepS2)
					 %Add the S2 matrices together for each image on a patch (small runs only, takes too much memory)
						 for iPatches = 1:nPatches
							for iBand = 1:8
%								if(b == 0) %if s2Layer{iPatches}{iBand} doesn't exist yet
%									s2Layer{iPatches}{iBand} = s2{iImg}{iPatch}{iPatches}{iBand};
%								else %if s2Layer{iPatches}{iBand} does exist
									%the 2 if statements below takes care of size incompatibility has some of the quadrants are off by one pixel
									%be careful if the differences are bigger
%									if(size(s2Layer{iPatches}{iBand}, 1) + 1 == size(s2{iImg}{iPatch}{iPatches}{iBand}, 1)) %if s2Layer is one size bigger than s2 
%										s2Layer{iPatches}{iBand}(size(s2{iImg}{iPatch}{iPatches}{iBand}, 1), :) = 0;
%									end
%									if(size(s2{iImg}{iPatch}{iPatches}{iBand}, 1) + 1 == size(s2Layer{iPatches}{iBand}, 1)) %if s2 is one size bigger than s2Layer
%										s2{iImg}{iPatch}{iPatches}{iBand}(size(s2Layer{iPatches}{iBand}, 1), :) = 0;
%									end
%									s2Layer{iPatches}{iBand} = s2Layer{iPatches}{iBand} + s2{iImg}{iPatch}{iPatches}{iBand};
%								end
								s2Layer{iImg}{iPatches}{iBand} = s2{iImg}{iPatch}{iPatches}{iBand};
							end
						 end
                end
					 s2{iImg}{iPatch} = 0; % takes too much memory
                s1{iImg} = 0; % takes too much memory
            else
                [c2(patchIndices,iImg),s2{iImg}{iPatch},~,~,bestBands(patchIndices,iImg),bestLocations(patchIndices,iImg,:)] =...
                C2(img,filters,filterSizes,c1Space,c1Scale,c1OL,linearPatches{iPatch},patchSizes(:,iPatch)',c1{iImg},IGNOREBORDERS,COMBINATION,IGNOREPARTIALS,ALLS2C1PRUNE,ORIENTATIONS2C1PRUNE);
					 if(keepS2)
					 %same as above 
						 for iPatches = 1:nPatches
							for iBand = 1:8
%								if(b == 0) %if s2Layer{iPatches}{iBand} doesn't exist yet
%									s2Layer{iPatches}{iBand} = s2{iImg}{iPatch}{iPatches}{iBand};
%								else %if s2Layer{iPatches}{iBand} does exist
%									if(size(s2Layer{iPatches}{iBand}, 1) + 1 == size(s2{iImg}{iPatch}{iPatches}{iBand}, 1))
%										s2Layer{iPatches}{iBand}(size(s2{iImg}{iPatch}{iPatches}{iBand}, 1), :) = 0;
%									end
%									if(size(s2{iImg}{iPatch}{iPatches}{iBand}, 1) + 1 == size(s2Layer{iPatches}{iBand}, 1))
%										s2{iImg}{iPatch}{iPatches}{iBand}(size(s2Layer{iPatches}{iBand}, 1), :) = 0;
%									end
%									s2Layer{iPatches}{iBand} = s2Layer{iPatches}{iBand} + s2{iImg}{iPatch}{iPatches}{iBand};
%								end
								s2Layer{iImg}{iPatches}{iBand} = s2{iImg}{iPatch}{iPatches}{iBand};
							end
						 end
					 end
                s2{iImg}{iPatch} = 0; % takes too much memory
            end
        end
		  b = 1;
    end
end
