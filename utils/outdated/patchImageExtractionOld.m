function patchImageExtraction(imgList, patches, AUCFI, nPatches, c1Scale, c1Space, rfSizes, xSize, home)
%patchDimensionsInPixelSpace and associated functions created by Josh Rule
%converts the top nPatches FI patches from C1 to pixel coordinates and saves the patches
%in a new folder named topPatches. Copy this folder to a different location to keep records. 
%
%imgList: Images used to create the patches 
%patches: 1x1 struct that contains the bands, index of img from imgList patch came from,
%			 sizes, locations (x1 x2 y1 y2), and patch info.
%AUCFI: list of all the AUC or FI values of each patch
%nPatches: how many patches you want (ex: nPatches = 10 gives the top 10 FI patches)
%xSize: width of original image the patch was extracted from
%home: location of where your patch data is 
%
%topPatchesInfo.coordinates: the coordinates of the patch image in its RESIZED state (not original)
%topPatchesInfo.imgList: list of where the original image can be found

if(nargin < 9) home = '/home/bentrans/Documents/HMAX/feature-learning/'; end;
if(nargin < 8) xSize = 240; end;
if(nargin < 7) rfSizes = 7:2:39; end;
if(nargin < 6) c1Space = 8:2:22; end;
if(nargin < 5) c1Scale = 1:2:18; end;
if(nargin < 4) nPatches = 10; end;


%finds the indices of the top nPatches FI
%[topFI, iTopFI] = sort(FI, 2);
%topFI = topFI(length(topFI) - nPatches + 1:length(topFI));
%iTopFI = iTopFI(length(iTopFI) - nPatches + 1:length(iTopFI));
topVal = AUCFI;
iTopVal = 1:length(topVal);

%finds coordinates of patch in pixel space in [xmin, ymin, width, height] format
coordinates = {};
for i = 1:length(iTopVal)
	loc = patches.locations(iTopVal(i), :);
	%x1 = loc(1);
	%x2 = loc(2);
	%y1 = loc(3);
	%y2 = loc(4);
	y1 = loc(1);
	y2 = y1 + patches.sizes(1, i) - 1; %if this errors, change patches.size(1, i) to just patches.size(1)
	x1 = loc(2);
	x2 = x1 + patches.sizes(1, i) - 1; %same as above
	[x1p, x2p, y1p, y2p]  = patchDimensionsInPixelSpace( patches.bands(iTopVal(i)), x1, x2, y1, y2, c1Scale, c1Space, rfSizes, double(xSize), double(xSize));
	coordinates{i} = [x1p, y1p, (x2p - x1p), (y2p - y1p)]; %[xmin, ymin, width, height]
end

%crops the image to create an image of the patch in pixel space
%creates a folder named topFIPatches as a temporary storage area for the patches
imgs = {};
%system(['cd ' home]);
system(['rm -rf ' home 'topPatches']);
system(['mkdir ' home 'topPatches']);
for i = 1:length(coordinates)
	img = imgList{patches.imgs(iTopVal(i))};
	[path, name, ext] = fileparts(img);
	img = ['/home/bentrans/Documents/n09618957/' name ext]; %remove in future use
	imgs{i} = img;
	img = imread(img);
	img = uint8(resizeImage(img, xSize));
	croppedImg = imcrop(img, coordinates{i});
	imwrite(croppedImg, ['patch' int2str(i) ext], ext(2:length(ext)));
	system(['cp patch' int2str(i) ext ' ' home 'topPatches']);
	system(['rm patch' int2str(i) ext]);
end

%saves the coordinates and location of img that corresponds to the patch in topFIPatchesInfo
topPatchesInfo.coordiantes = coordinates;
topPatchesInfo.imgList = imgs;
save('topPatchesInfo', 'topPatchesInfo');
system(['cp topPatchesInfo.mat ' home 'topPatches']);
system('rm topPatchesInfo.mat');

end
