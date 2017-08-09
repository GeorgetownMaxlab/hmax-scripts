function CUR_patchImageExtraction(patchesFolder, saveFolder, patchIndices, patchName, imgResize, c1Scale, c1Space, rfSizes, ext)
%patchDimensionsInPixelSpace and associated functions created by Josh Rule
%converts the top nPatches from C1 to pixel coordinates and saves the patches
%in a new folder named topPatches. Copy this folder to a different location to keep records. 
%
%patchIndices: patchIndices of the patch so that the information from it can be extracted
%patchName: name of the patch file
%patchLoc: cell array containing the locations of patches you want extracted (ex: the array from trainingLoc.mat)
%home: location of where your patch data is 
%imgResize: the size of what the training images were resized to (or the original size if not resized)
%c1Scale c1Space, rfSize: see C1.m
%ext: extension you want the cropped image to be saved as
%
%topPatchesInfo.coordinates: the coordinates of the patch image in its original state
%topPatchesInfo.imgList: list of where the original image can be found

%% Define global variables
if(nargin < 9)  ext = 'bmp'; end;
if(nargin < 8)  rfSizes = 7:2:39; end;
if(nargin < 7)  c1Space = 8:2:22; end;
if(nargin < 6)  c1Scale = 1:2:18; end;
if(nargin < 5)  imgResize = 78; end;
if(nargin < 4)  patchName = 'patches.mat'; end;

saveLoc = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\' saveFolder '\'];

if ~exist(saveLoc)
    mkdir(saveLoc)
end

load(['C:\Users\Levan\HMAX\patches\' patchesFolder '\sourceImages.mat']);
    sourceImages = convertSourceImages(sourceImages);

% Load the patches.
patches = load(['C:\Users\Levan\HMAX\patches\' patchesFolder '\' patchName]); 
patches = patches.ps;

% Indicate patch indices if not provided
if (nargin < 3)
    patchIndices = input('What patches do you want to look at?\n');
end

%% finds coordinates of patch in pixel space in [xmin, ymin, width, height] format
coordinates = cell(1,length(patchIndices)); % predefine for speed
parfor iPatch = 1:length(patchIndices)
    iPatch
	img = uint8(resizeImage(double(imread(sourceImages{patches.imgs(patchIndices(iPatch))})), imgResize));
	xSize = size(img, 2);
	ySize = size(img, 1);
	loc = patches.locations(patchIndices(iPatch), :);
	y1 = loc(1);
	y2 = y1 + patches.sizes(1) - 1; %if this errors, change patches.size(1, i) to just patches.size(1)
	x1 = loc(2);
	x2 = x1 + patches.sizes(1) - 1; %same as above
	[x1p, x2p, y1p, y2p]  = patchDimensionsInPixelSpace(patches.bands(patchIndices(iPatch)), x1, x2, y1, y2,...
                            c1Scale, c1Space, rfSizes, double(xSize), double(ySize));
	coordinates{iPatch} = [x1p, y1p, (x2p - x1p), (y2p - y1p)]; %[xmin, ymin, width, height]
end

%% crops the image to create an image of the patch in pixel space
%creates a folder named topPatches as a temporary storage area for the patches
imgs = {};

mkdir(saveLoc)

for iPatch = 1:length(coordinates)
	img = sourceImages{patches.imgs(patchIndices(iPatch))};
	imgs{iPatch} = img;
	img = uint8(resizeImage(double(imread(img)), imgResize));
	croppedImg = imcrop(img, coordinates{iPatch});
	imwrite(croppedImg, [saveLoc '\patch' int2str(iPatch) '_Original_Idx_' int2str(patchIndices(iPatch)) '.' ext], ext);

end

%% saves the coordinates and location of img that corresponds to the patch in topFIPatchesInfo
topPatchesInfo.coordiantes = coordinates;
topPatchesInfo.imgList = imgs;
save([saveLoc 'topPatchesInfo'], 'topPatchesInfo');
end
