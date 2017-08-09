function [c2, c1, bestBands, bestLocations, s2] = genC2(gaborSpecs,imgNames,c1bands,linPatches,patchSpecs, ...
  USEMATLAB, maxSize, keepS2, RESIZE, nImgsPerWorker)
% c2 = genC2(gaborSpecs,imgNames,c1bands,linPatches,patchSpecs, ...
% USEMATLAB,maxSize)
% 
% give C2 responses for an image set
%
% gaborSpecs: struct, holds information needed for creating S1 filters
% imgNames: cell array, a list of filenames in the image set
% c1bands: struct, holds information about bands and scales in C1
% linPatches: cell array, the patches, before being reshaped
% patchSpecs:  4 x m array, 
% m = nPatchSizes and 4 rows = [rows; columns; depth; patchesPerSize]
% USEMATLAB: logical, if 1 use HMAX-MATLAB, otherwise use HMAX-CUDA
% COMBINATION: how many patches to combined. If 0, no combination takes place. If 2, will form all possible 
%					combination of pairs (see C2.m) creating (nPatches C 2) total patches
% BLUR: see C2.m
% keepS2: logical, if 1 adds the S2 matrices over all test images for each patch (TAKES A LOT OF MEMORY)
% c2: nPatches x nImgs array, C2 responses for an image set
	 if (nargin < 8) keepS2 = 0; end;
     if (nargin < 5) maxSize = flintmax; end;
     if (nargin < 4) USEMATLAB = 1; end;

    [filterSizes,linFilters,c1OL,~] = initGabor(gaborSpecs.orientations,...
       gaborSpecs.receptiveFieldSizes,gaborSpecs.div);

    % create square filters (S1)
    nFilters = length(filterSizes);
    for i = 1:nFilters
        iSize = filterSizes(i);
        filters{i} = reshape(linFilters(1:(iSize^2),i),iSize,iSize);
    end

    % flip patches and reshape into squares
    patchSizes = patchSpecs(1:3,:);
    nPatchSizes = size(patchSizes,2);
    iPatch = 1;
    for iSize = 1:nPatchSizes
        nOrientations = patchSizes(3,iSize);
        dimPatch = [patchSizes(1,iSize) patchSizes(2,iSize)];
        nElements = prod(dimPatch);
        for iLinearPatch = 1:size(linPatches{iSize},2)
            for iOrient = 1:nOrientations
                patchStart = 1+(iOrient-1)*nElements;
                patchStop = iOrient*nElements;
                patches{iPatch} = ...
                  reshape(linPatches{iSize}(patchStart:patchStop, ...
                  iLinearPatch),dimPatch);
                iPatch = iPatch+1;
            end
        end
    end
	 nPatches = length(patches) / 4; % whats up with this?? 4 is the number of orientations.
     
     parc2         = zeros(nImgsPerWorker*nPatches,ceil(length(imgNames)/nImgsPerWorker),'double');
	 pars2         = cell(1, ceil(length(imgNames) / nImgsPerWorker));
	 bestLocations = cell(1, ceil(length(imgNames) / nImgsPerWorker));
	 bestBands     = cell(1, ceil(length(imgNames) / nImgsPerWorker));

     parfor iImg = 1:ceil(length(imgNames)/nImgsPerWorker); 
%      fprintf('PARFOR IS OFF!!!\n');
        iStart = 1+(iImg-1)*nImgsPerWorker;
        iStop  = min(iStart+nImgsPerWorker-1,length(imgNames));
%         fprintf('%d: start: %d stop: %d\n',iImg,iStart, iStop);
        imgs = imgNames(iStart:iStop);
        if USEMATLAB
            [c, c11, bestBand, bestLoc, s2] = extractC2FromCell(...
                                   linFilters,filterSizes,...
                                   c1bands.c1Space,c1bands.c1Scale,c1OL,...
                                   linPatches,imgs,nPatchSizes,...
                                   patchSizes,nPatches,...
                                   0,[],0,0,keepS2,maxSize,RESIZE); %17
            d = [reshape(c,[],1); zeros((nImgsPerWorker-size(c,2))*nPatches,1)];
            parc2(:,iImg) = d;
				bestBands{iImg} = bestBand;
				bestLocations{iImg} = bestLoc;
				c1{iImg} = c11;
				if(keepS2)
					pars2{iImg} = s2; %takes a lot of memory
				end
				s2 = 0; %save memory
        else
            parc2(:,iImg) = hmaxCudaFun(filters,patches,imgs,nImgsPerWorker)';
        end % if USEMATLAB
     end % iImg loop
     
    c2 = [];
    for i = 1:size(parc2,2)
        c2 = [c2 reshape(parc2(:,i),[],nImgsPerWorker)];
    end
    c2 = c2(:,1:length(imgNames));
%	 compile the s2 matrices for the patches
	 s2 = {};
	 if(keepS2)
		count = 1;
		for i = 1:length(pars2)
			pars2
			for iImg = 1:length(pars2{i})
				for iPatch = 1:nPatches
					for iBand = 1:8
						s2{count}{iPatch}{iBand} = pars2{i}{iImg}{iPatch}{iBand};
					end
				end
				count = count + 1;
			end
		end
	 end
end

%% HMAX Cuda function
function c2 = hmaxCudaFun(filters,patches,imgs,maxImgs)
% c2 = hmaxCudaFun(filters,patches,imgs,maxImgs)
%
% helper function to allow parfor
%
% filters: cell array of double arrays, the S1 filters
% patches: cell array of double arrays, the S2 filters
% imgs: cell array of double arrays, the images
% maxImgs: double scalar, the maximum number of images processed at one time
%
% c2: double array, the C2 matrix
    c2 = zeros(length(patches)/4,maxImgs);
    for i = 1:ceil(length(patches)/2048);
        startIn = 1+2048*(i-1);
        stopIn = min(length(patches),2048*i);
        startOut = 1+512*(i-1);
        stopOut = min(length(patches)/4,512*i);
        c = hmaxcudanew(imgs,filters,patches(startIn:stopIn),0,1024)';
        c2(startOut:stopOut,1:length(imgs)) = c;
    end
    c2 = reshape(c2,[],1);
end
