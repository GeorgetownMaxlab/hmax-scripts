function [sourceImgs, nonSourceImgs] = sourceImageExtraction(outPs, sourceImgDirectory)
%creates a list of the images the patches came from after using
%	findCorrectPatches
%
%outPs: cell array of struct arrays, the patches from "patches" and their best
%	matches from the images in "oldImgList". Each struct contains the patch, a
%	struct array of the possibly non-unique best matches, and the euclidean
%	distance between the patch and its best matches. The struct array of
%	matches gives the matching patch, its band, its location, its distance from
%	the target patch, and its source image.
%sourceImgDirectory: directory of where the images come from
%
%sourceImgs: list of images that correspond to the patch that was extracted from it
%nonSourceImgs: list of images that were not used as the training set

if(nargin < 2); 
	sourceImgDirectory = '/home/bentrans/Documents/n09618957/'; end;

%get sourceImgs
outPs = outPs{1};
sourceImgs = {};
for n = 1:length(outPs)
	img = outPs(n).matches.img;
	if(sum(ismember(sourceImgs, img)) == 0) %if sourceImgs does not contain img
		sourceImgs = horzcat(sourceImgs, img);
	end
end

%get nonSourceImgs
allImgs = lsDir(sourceImgDirectory, {'JPEG'});
nonSourceImgs = {};
for n = 1:length(allImgs)
	if(sum(ismember(sourceImgs, allImgs{n})) == 0) %if sourceImgs does not contain allImgs{n}
		nonSourceImgs = horzcat(nonSourceImgs, {allImgs{n}});
	end
end

end
