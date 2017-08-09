function [hits, c1, bestBands, bestLoc] = C2ImageOCV(patch, imgs, home, patchSize, matlabPath)
%HMAX HAS CHANGED A BIT AND THIS IS NO LONGER IN USE
%still works, but other newer utilities like localization will not work
%extracts the best match for the specified patch for the specified img
%uses the MATLAB implementation to extract needed info. HMAX-MATLAB and HMAX-OCV
%have been tested to be within numerical precision (9e-11) at this moment. 
%
%patch: array of the patch number; patch and imgs should have same length
%imgs: array of the img that corresponds to patch; patch and imgs should have same length
%		(ex: extract best match from patch{1} imgs{1], patch{2} imgs{2} ... patch{n} imgs{n})
%home: location of where the patches, testingLoc, etc is located
%patchSize: size of the patch you want to analyze... only handles one size at a time currently
%				might be good to make this flexible int he future			
%matlabPath: path to where the matlab code is
%
%creates a folder called 'testFeatures' in the 'home' folder specified that contains all the 
%extraced best matches as well as a .mat file that gives the coordinates in pixel space and 
%img that it came from for testing and analytical purposes
%

if(nargin < 5)
	matlabPath = '/home/bentrans/Documents/HMAX/feature-learning/';
end

tic;
gaborSpecs.orientations = [90 -45 0 45];
gaborSpecs.receptiveFieldSizes = 7:2:39;
gaborSpecs.div = 4:-.05:3.2;
c1Scale = 1:2:18;
c1Space = 8:2:22;
c1Bands.c1Scale = c1Scale;
c1Bands.c1Space = c1Space;
loc{1} = [(206 - 32) (206 + 32) (365 - 114 - 43) (365 - 114 + 43)]; %[x1 x2 y1 y2]
loc{2} = [(255 - 32) (255 + 32) (365 - 114 - 43) (365 - 114 + 43)];
loc{3} = [(263 - 32) (263 + 32) (365 - 161 - 43) (365 - 161 + 43)];
loc{4} = [(198 - 32) (198 + 32) (365 - 161 - 43) (365 - 161 + 43)];

patches = load([home 'patch' int2str(patchSize / 2) '.mat']);
patches = patches.patches;
for iPatch = 1:length(patch)
	patchGroup{1}(:, iPatch) = patches.patches{1}(:, patch(iPatch));
end

testingLoc = load([home 'facesLoc.mat']);
testingLoc = testingLoc.facesLoc;
for iImg = 1:length(imgs)
	imgList{iImg} = testingLoc{imgs(iImg)};
end

addpath(matlabPath);
[fSize, filters, c1OL, numSimpleFilters] = initGabor(gaborSpecs.orientations, gaborSpecs.receptiveFieldSizes, gaborSpecs.div);
%call HMAX-MATLAB to do the C2 calculations which will give us the location and bands
for iImg = 1:length(patch)
	singlePatch{iImg}{1} = patchGroup{1}(:, iImg);
end
parfor iImg = 1:length(imgs)
	[C2, c11, bestBand, bestLocation] = genC2(gaborSpecs, {imgList{iImg}}, c1Bands, singlePatch{iImg}, patches.sizes, 1, 1500);
	bestBands{iImg} = bestBand{1};
	bestLoc{iImg} = bestLocation{1};
	c1{iImg} = c11;
end
rmpath(matlabPath);
ext = 'jpg';

system(['rm -rf testFeatures']);
system(['mkdir testFeatures']);
hits = 0;
%read and extract needed info and crop 
for iImg = 1:length(imgList)
	img = imread(imgList{iImg});
%	img = uint8(resizeImage(double(imread(imgList{iImg})), 1500));
	ySize = size(img, 1);
	xSize = size(img, 2);
%	if(ySize ~= 100) fprintf('y: %f \n', ySize); end;
%	if(xSize ~= 100) fprintf('x: %f \n', xSize); end;
	y1 = bestLoc{iImg}(1, 1);
	x1 = bestLoc{iImg}(1, 2);
	y2 = y1 + patchSize - 1;
	x2 = x1 + patchSize - 1;
	[x1p, x2p, y1p, y2p] = patchDimensionsInPixelSpace(bestBands{iImg}(1), x1, x2, y1, y2, c1Scale, c1Space, gaborSpecs.receptiveFieldSizes, double(xSize), double(ySize));
	if(x1p > x2p) %cautionary measure... if this occurs, output for that particular image and patch is bad
		fprintf(['xinversion occured for image ' num2str(iImg) ' patch ' num2str(patch(iImg)) '\n']);
		temp = x1p;
		x1p = x2p;
		x2p = temp;
	end
	if(y1p > y2p) %cautionary measure... if this occurs, output for that particular image and patch is bad
		fprintf(['yinversion occured for image ' num2str(iImg) ' patch ' num2str(patch(iImg)) '\n']);
		temp = y1p;
		y1p = y2p;
		y2p = temp;
	end
	quad = str2num(imgList{iImg}(length(imgList{iImg}) - 4));
	if(y2p > loc{quad}(3) && y1p < loc{quad}(4) && x1p < loc{quad}(2) && x2p > loc{quad}(1))
		hits = hits + 1;
	end

	coordinates{iImg} = [x1p, y1p, (x2p - x1p), (y2p - y1p)];
	croppedImg = imcrop(img, coordinates{iImg});
	imwrite(croppedImg, ['patch' int2str(iImg) '.' ext], ext);
	system(['cp patch' int2str(iImg) '.' ext ' ' 'testFeatures']);
	system(['rm patch' int2str(iImg) '.' ext]);
end

%store coordinates and imgList in struct saved in 'home' folder specified in args
testFeaturesInfo.coordinates = coordinates;
testFeaturesInfo.imgList = imgList;
testFeaturesInfo.bestBands = bestBands;
testFeaturesInfo.bestLoc = bestLoc;
save('testFeaturesInfo', 'testFeaturesInfo');
system(['cp testFeaturesInfo.mat ' 'testFeatures']);
system('rm testFeaturesInfo.mat');
system(['rm -rf ' home 'testFeatures']);
system(['cp -r testFeatures ' home]);
system('rm -rf testFeatures');
toc;
end
