function C2Image(patch, imgs, home, patchSize, c1Scale, c1Space, rfSizes)
%HMAX HAS CHANGED SUCH THAT THIS SCRIPT DOES NOT WORK
%DEBUGGING IN PROGRESS
%
%extracts the best match for the specified patch for the specified img
%
%patch: vector of the patch number; patch and imgs should have same length
%imgs: vector of the img that corresponds to patch; patch and imgs should have same length
%     (ex: extract best match from patch{1} imgs{1], patch{2} imgs{2} ... patch{n} imgs{n})
%home: location of where the patches, testingLoc, etc is located
%patchSize: size of the patch you want to analyze... only handles one size at a time currently
%           might be good to make this flexible int he future
%
%creates a folder called 'testFeatures' in the 'home' folder specified that contains all the 
%extraced best matches as well as a .mat file that gives the coordinates in pixel space and 
%img that it came from for testing and analytical purposes
%

if(nargin < 7); rfSizes = 7:2:39; end;
if(nargin < 6); c1Space = 8:2:22; end;
if(nargin < 5); c1Scale = 1:2:18; end;

testingLoc = load([home 'facesLoc.mat']);
testingLoc = testingLoc.facesLoc;
if(length(testingLoc) == 4)
	l = [length(testingLoc{1}) length(testingLoc{2}) length(testingLoc{3}) length(testingLoc{4})];
end
ext = 'jpg';

system(['rm -rf testFeatures']);
system(['mkdir testFeatures']);
%read and extract needed info and crop
for iImg = 1:length(imgs)
	imgIndex = imgs(iImg) - l(1) - l(2) - l(3);
	quad = 4;
	if(imgs(iImg) < (sum(l) - l(4)))
		quad = 3;
		imgIndex = imgs(iImg) - l(1) - l(2);
	end
	if(imgs(iImg) < (sum(l) - l(4) - l(3)))
		quad = 2;
		imgIndex = imgs(iImg) - l(1);
	end
	if(imgs(iImg) < l(1))
		quad = 1;
		imgIndex = imgs(iImg);
	end
	load([home 'bestLocC2f' int2str(quad)]); %creates the variable bestLoc
	load([home 'bestBandsC2f' int2str(quad)]); %creates the variable bestBands
	img = imread(testingLoc{quad}{imgIndex});
	imgList{iImg} = img;
	xSize = size(img, 2);
	ySize = size(img, 1);
	nImg = floor(imgIndex / 20) + 1;
	subImg = mod(imgIndex, 20);
	if(subImg == 0)
		subImg = 20;
	end
	y1 = bestLoc{nImg}(patch(iImg), subImg, 1) + 2;
	x1 = bestLoc{nImg}(patch(iImg), subImg, 2) + 2;
	y2 = y1 + patchSize - 1;
	x2 = x1 + patchSize - 1;
	[x1p, x2p, y1p, y2p] = patchDimensionsInPixelSpace(bestBands{nImg}(patch(iImg), subImg), x1, x2, y1, y2, c1Scale, c1Space, rfSizes, double(xSize), double(ySize));
	if(x1p > x2p) %cautionary measure, if this occurs, output for that particular patch and image is bad
		fprintf(['xinversion occured for image ' int2str(iImg) ' patch ' int2str(patch(iImg)) '\n']);
		temp = x1p;
		x1p = x2p;
		x2p = temp;
	end
	if(y1p > y2p) %cautionary measure, if this occurs, output for that particular patch and image is bad
		fprintf(['xinversion occured for image ' int2str(iImg) ' patch ' int2str(patch(iImg)) '\n']);
		temp = y1p;
		y1p = y2p;
		y2p = temp;
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
save('testFeaturesInfo', 'testFeaturesInfo');
system(['cp testFeaturesInfo.mat ' 'testFeatures']);
system('rm testFeaturesInfo.mat');
system(['rm -rf ' home 'testFeatures']);
system(['cp -r testFeatures ' home]);
system('rm -rf testFeatures');

end
