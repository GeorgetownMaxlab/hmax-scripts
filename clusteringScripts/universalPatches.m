function [pOut,labels] = universalPatches(pIn,k)
% [pOut,labels] = universalPatches(pIn,k)
%
% generate kmeans clustering centroids to use as "universal" patches
%
% note: uses Laurent Sober's kmeans++ implementation from MATLAB File Exchange:
% http://www.mathworks.com/matlabcentral/fileexchange/28804-k-means++
% (Available via BSD License)
%
% pIn: cell array of patch matrices, the patch arrays over which to run kmeans
% k: scalar, the number of patches per size, the number of clusters to make
%
% pOut: cell array of patch matrices, the universal patches (centroids)
% labels: cell array, the centroids to which each patch from pIn was assigned
    [labels,pOut] = cellfun(@(x) kmeansPlusPlus(x,k),pIn,'UniformOutput',0);
end
