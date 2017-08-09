function [c2,c1,bestBands,bestLocations,s2Layer,s1] = extractC2FromCellMask(filters,filterSizes,c1Space,c1Scale,c1OL,linearPatches,imgs,...
    nPatchSizes,patchSizes,nPatches,ALLS2C1PRUNE,c1,ORIENTATIONS2C1PRUNE,IGNOREPARTIALS,keepS2,maxSize,RESIZE,idxPixel)
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
%		COMBINATION: number of patches being combined
%		
%		nPatches: total number of patch combinations; if 0, no combining of patches.
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
    nPatchSizes = size(patchSizes,2); % make sure this var is correct.
    nPatchesPerSize = size(linearPatches{1},2);
    nPatches = nPatchSizes*nPatchesPerSize;
	
    if (nargin < 15) IGNOREBORDERS = 0; end;
    if (nargin < 14) IGNOREPARTIALS = 0; end;
    if (nargin < 13) ORIENTATIONS2C1PRUNE = 0; end;
    if (nargin < 12 || isempty(c1)) c1 = cell(1,nImgs); end;
    if (nargin < 11) ALLS2C1PRUNE = 0; end;
    if (nargin < 10) nPatches = 0; end;
    
    c2 = zeros(nPatches,nImgs);
    s2 = cell(1,nImgs);
	s2Layer = cell(1, nImgs);
    s1 = cell(1,nImgs);
    bestBands = zeros(nPatches,nImgs);
    bestLocations = zeros(nPatches,nImgs,2);
    
    for iImg = 1:nImgs        
        % Masking code
        img = double(grayImage(uint8(double(imread(imgs{iImg})))));
        img(idxPixel) = 128;

        if RESIZE == 1
		  img = double(resizeImage(img,maxSize));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for iPatchSize = 1:nPatchSizes
%             iPatchSize
            patchIndices = (nPatchesPerSize*(iPatchSize-1)+1):(nPatchesPerSize*iPatchSize);
            if isempty(c1{iImg}),  %compute C1 & S1
                [c2(patchIndices,iImg),s2{iImg}{iPatchSize},c1{iImg},s1{iImg},bestBands(patchIndices,iImg),bestLocations(patchIndices,iImg,:)] =...
                C2(img,filters,filterSizes,c1Space,c1Scale,c1OL,linearPatches{iPatchSize},patchSizes(:,iPatchSize)',[],...
                IGNOREPARTIALS,ALLS2C1PRUNE,ORIENTATIONS2C1PRUNE); %12
					 if(keepS2)
					 %Add the S2 matrices together for each image on a patch (small runs only, takes too much memory)
						 for iPatches = 1:nPatches
							for iBand = 1:8
								s2Layer{iImg}{iPatches}{iBand} = s2{iImg}{iPatchSize}{iPatches}{iBand}; %keeps every S2... VERY SMALL RUNS ONLY!
							end
						 end
                end
                s2{iImg}{iPatchSize} = 0; % takes too much memory
                s1{iImg} = 0; % takes too much memory
            else
                [c2(patchIndices,iImg),s2{iImg}{iPatchSize},~,~,bestBands(patchIndices,iImg),bestLocations(patchIndices,iImg,:)] =...
                C2(img,filters,filterSizes,c1Space,c1Scale,c1OL,linearPatches{iPatchSize},patchSizes(:,iPatchSize)',c1{iImg},...
                IGNOREPARTIALS,ALLS2C1PRUNE,ORIENTATIONS2C1PRUNE);
					 if(keepS2)
					 %same as above 
						 for iPatches = 1:nPatches
							for iBand = 1:8
								s2Layer{iImg}{iPatches}{iBand} = s2{iImg}{iPatchSize}{iPatches}{iBand};
							end
						 end
					 end
                s2{iImg}{iPatchSize} = 0; % takes too much memory
                s1{iImg} = 0; % takes too much memory
            end
        end
    end
end
