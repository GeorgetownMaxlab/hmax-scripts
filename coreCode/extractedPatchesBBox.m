function ps = extractedPatchesBBox(c1r,patchSizes,maxOverlap,corrThreshold)
% [patches,bands,imgs,sizes,locations] = extractedPatchesBBox(c1r,patchSizes)
%
% extract patches of C1 activations at random locations WITHIN A PREDEFINED REGION
% for use as S2 features.
%
% c1r: a cell array of c1 responses, each c1r{i} is a separate image and NaNs
%   are considered "cropped" or "punched-out" areas of the image. See 'C1.m' in
% 'hmax' for details.
% patchSizes: a 4 x nPatchSizes array of patch sizes. Each column should hold
%   [nRows; nCols; nOrientations; nPatches]
% maxOverlap: a scalar, determines maximum spatial overlap allowed.
% corrThreshold: a scalar, determines max correlation allowed between patches
%
% ps: struct array, the patches and their bands, imgs, sizes, and locations
    if (nargin < 4) corrThreshold = 1; end; %0.8; end;
    if (nargin < 3) maxOverlap = 1; end; %0.4; end;
    if (nargin < 2) patchSizes = [2; 2; 4;10000]; end; %last value is TOTAL number of patches, not per image %[2:2:8;2:2:8;4*ones(1,4);100*ones(1,4)]; end;
    nImgs = length(c1r);
    nPatchSizes = size(patchSizes,2);
    ps.bands = [];
    ps.imgs = [];
    ps.sizes = [];
    ps.locations = [];
    
    %fprintf('number of patches being extracted = \n') patchSizes(4,1) %so that I know how many patches are being extracted (comment by levan)

    for iSize = nPatchSizes:-1:1
        ps.patches{iSize} = [];
		  fprintf('%d: ',iSize);
        for iPatch = 1:patchSizes(4,iSize)
            if mod(iPatch,100) == 0, fprintf('%d \n',iPatch); end;
            huntingPatch = 1;
            while huntingPatch
                chosenImg = randi(nImgs);
                b = c1r{chosenImg};
                randBand = randi(length(b));
                
                
                [bandRows bandCols ~] = size(b{randBand});
                eyeRegHeight = bandRows*(70/250);
                eyeRegWidth  = bandRows*(150/250);
                
                cutTop    = bandRows*(60/250);
                cutBottom = bandRows*(120/250);
                cutLeft   = bandRows*(40/250);
                cutRight  = bandRows*(60/250);
                
                r1 = floor(cutTop + rand*eyeRegHeight-patchSizes(1,iSize))+1;
                c1 = floor(cutLeft + rand*eyeRegWidth-patchSizes(2,iSize))+1;
                r2 = r1+patchSizes(1,iSize)-1;
                c2 = c1+patchSizes(2,iSize)-1;
                if r1>cutTop && ...
                   c1>cutLeft && ...
                   r2 <= bandRows-cutBottom && ...
                   c2 <= bandCols-cutRight
               
                    newPatch = b{randBand}(r1:r2,c1:c2,:);
                    huntingPatch = ~testPatch(ps.patches{iSize},newPatch,...
                      ps.locations,[r1 c1],ps.imgs,chosenImg, ...
                      patchSizes(:,iSize),maxOverlap,corrThreshold);
                    idx = sum(patchSizes(4,1:iSize-1))+iPatch;
                    ps.bands(idx) = randBand;
                    ps.imgs(idx) = chosenImg;
                    %ps.sizes(idx,:) = patchSizes(1:3, iSize); %patchSizes(1:3,iSize);
                    ps.locations(idx,:) = [r1 c1];
                    ps.patches{iSize}(:,iPatch) = reshape(newPatch,[],1);
                end
            end
        end
	 fprintf('\n');
    end
	 ps.sizes = patchSizes; 
end

%% 
function patchIsValid = testPatch(patches,patch,locations,location,imgs, ...
  img,patchSize,maxOverlap,corrThreshold)
% patchIsValid = testPatch(patches,patch,locations,location,imgs, ...
%   img,patchSize,maxOverlap,corrThreshold)
%
% ensure a candidate patch passes several tests
%
% patches: double array, previously chosen patches
% patch: double array, candidate patch
% locations: double array, [nChosen 2] array of previously chosen locations
% location: double array, [1 2] matrix of the candidate location
% imgs: cell array of strings, filenames from which  previously chosen patches
%   were extracted
% img: string, the filename of the candidate patch's image
% patchSize: double array, 4 vector of the number of rows, columns,
%   orientations, and total number of patches for the current patch size
% maxOverlap: double scalar, the max allowable overlap, ranges from 0 to 1
% corrThreshold: double scalar, the max allowable correlation between two
%   patches, ranges from 0 to 1
%
% patchIsValid: logical, 1 if the patch passes all tests, 0 otherwise
    avoidsCrop = isempty(find(isnan(patch(:))));
    interesting = mean(patch(:)) >= 10^-2;
    lowCorrelation = ~isempty(patches) && ...
      max(corr(patches,patch(:))) < corrThreshold;
    if isempty(locations) || (sum(imgs == img) == 0)
      lowOverlap = true;
    else
      boxes = [locations(:,2) locations(:,1) locations(:,2)+patchSize(2)-1 ...
        locations(:,1)+patchSize(1)-1];
      box = [location(2) location(1) location(2)+patchSize(2)-1  ...
        location(1)+patchSize(1)-1];
      lowOverlap = max(computeOverlap(boxes(imgs == img,:),box,'pascal')) < ...
        maxOverlap;
   end
    patchIsValid = avoidsCrop && interesting && lowCorrelation && lowOverlap;
end
