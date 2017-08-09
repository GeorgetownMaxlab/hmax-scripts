function [outPs,c1r,sourceImgs] = findCorrectPatches(patches,oldImgList,patchSizes,filters,filterSizes,c1Scale,c1Space,c1OL)
%NOT WORKING!
% [outPs,c1r,sourceImgs] = findCorrectPatches(patches,oldImgList,patchSizes,filters,filterSizes,c1Scale,c1Space,c1OL)
%
% patches: cell array of double arrays, the patches, organized by size
% oldImgList: cell array of strings, the image files to search for the patches in "patches"
% patchSizes: [3, nSizes] array, the nRows, nColumns, nOrientations for each patch size
% filters, filterSizes, c1Scale, c1Space, c1OL: see C1.m
%
% outPs: cell array of struct arrays, the patches from "patches" and their best
%   matches from the images in "oldImgList". Each struct contains the patch, a
%   struct array of the possibly non-unique best matches, and the euclidean
%   distance between the patch and its best matches. The struct array of
%   matches gives the matching patch, its band, its location, its distance from
%   the target patch, and its source image.
% c1r: cell array, the C1 activations for the unique set of images in
%   "oldImgList", see C1.m
% sourceImgs: cell array of strings, the image files listed in the same order
%   as their C1 activations are given in "c1r"

    % find the unique list of images from which patches were taken
    sourceImgs = unique(oldImgList);

    % for each image, compute the C1 activations for those images
    params.filters = filters; % all these parameters are in gabor-and-c1.mat
    params.filterSizes = filterSizes;
    params.c1Scale = c1Scale;
    params.c1Space = c1Space;
    params.c1OL = c1OL;
    params.maxSize = bitmax; % ignore max size
    c1r = c1rFromCells(sourceImgs,params);
    
    % initialize output array
    for iSize = 1:length(patches) % for each patch size
        for iPatch = 1:size(patches{iSize},2) % for each original patch of iSize
            outPs{iSize}(iPatch) = struct('patch',patches{iSize}(:,iPatch),'matches',[],'minDist',inf);
        end
    end

    for iImg = 1:length(sourceImgs) % for each image
        for iSize = 1:size(patchSizes,2) % for each size
            fprintf('%d/%d : %d/%d\n',iImg,length(sourceImgs),iSize,length(patches));
            % extract all possible patches of that size from that image
            [ps,ls,bs] = extractAllPatches(c1r{iImg},patchSizes(1:3,iSize));
            tmpPs = outPs{iSize};
            parfor iPatch = 1:size(patches{iSize},2) % for each original patch of iSize
                tmpPs(iPatch) = findMatches(tmpPs(iPatch),ps,ls,bs,sourceImgs{iImg});
            end
            outPs{iSize} = tmpPs;
        end
    end
end

function newPatch = findMatches(patch,ps,ls,bs,sourceImg)
    % compute the euclidean distance between the patch and the all patches extracted from the image
    ds = pdist2(reshape(patch.patch,1,[]),ps,'euclidean');
    if min(ds) < patch.minDist
        patch.minDist = min(ds); % reset the minimum distance
        patch.matches = []; % reset the discovered best matches
    end

    % append all best matches as potential sources for that patch.
    newMins = find(ds == patch.minDist);
    tmpP = [];
    for iMin = 1:length(newMins)
        tmpP(iMin).patch = ps(newMins(iMin),:);
        tmpP(iMin).location = ls(newMins(iMin),:);
        tmpP(iMin).img  = sourceImg;
        tmpP(iMin).band = bs(newMins(iMin));
        tmpP(iMin).dist = ds(newMins(iMin));
    end
    patch.matches = [patch.matches tmpP];
    newPatch = patch;
end
