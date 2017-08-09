function cropQuadrants = cropQuadrants(imgPath, ext)
%crop images into quadrants

if(nargin < 1) 
	imgPath = '~/Documents/Psychophysics/naturalFaceImages/'; 
	ext = 'jpeg';
end

addpath('~/Documents/HMAX/feature-learning/utils/');
outFile = [imgPath 'quadImages/'];
system(['rm -rf ' outFile]);
system(['mkdir ' outFile]);

imgs = lsDir(imgPath, {ext});
saveExt = 'BMP';

for iImg = 1:length(imgs)
	imgLoc = imgs{iImg};
	img = imread(imgLoc);
	[~, imgName, ~] = fileparts(imgLoc);
	[height, width] = size(img);
	width = width / 2;
	height = height / 2;
	quad1 = imcrop(img, [0, 0, width, height]);
	quad2 = imcrop(img, [width, 0, width, height]);
	quad3 = imcrop(img, [0, height, width, height]);
	quad4 = imcrop(img, [width, height, width, height]);
	quad1File =  [outFile imgName(1:length(imgName) - (length(ext) + 1)) '_quad1.' saveExt];
	quad2File =  [outFile imgName(1:length(imgName) - (length(ext) + 1)) '_quad2.' saveExt];
	quad3File =  [outFile imgName(1:length(imgName) - (length(ext) + 1)) '_quad3.' saveExt];
	quad4File =  [outFile imgName(1:length(imgName) - (length(ext) + 1)) '_quad4.' saveExt];
	imwrite(quad1, quad1File, ext);
	imwrite(quad2, quad2File, ext);
	imwrite(quad3, quad3File, ext);
	imwrite(quad4, quad4File, ext);
	quadInfo.quadPictures.loc{iImg, 1} = quad1File;
	quadInfo.quadPictures.loc{iImg, 2} = quad2File;
	quadInfo.quadPictures.loc{iImg, 3} = quad3File;
	quadInfo.quadPictures.loc{iImg, 4} = quad4File;
end
fprintf('done chopping images \n');

rmpath('~/Documents/HMAX/feature-learning/utils/');

end
