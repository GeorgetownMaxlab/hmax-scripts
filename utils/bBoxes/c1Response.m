function [face, background] = c1Response(patch, index, home, patchSize, matlabHome)

if(nargin < 5)
	matlabHome = '/home/bentrans/Documents/HMAX/feature-learning/';
end
if(nargin < 4) patchSize = 2; end;

addpath(matlabHome);

annotation = load('annotation');
annotation = annotation.annotation;
patches = load([home 'patch' int2str(patchSize / 2) '.mat']);
patches = patches.patches;
trainingLoc = load([home 'trainingLoc.mat']);
trainingLoc = trainingLoc.trainingLoc;
gaborSpecs.orientations = [90 -45 0 45];
gaborSpecs.receptiveFieldSizes = 7:2:39;
gaborSpecs.div = 4:-.05:3.2;
c1Scale = 1:2:18;
c1Space = 8:2:22;
c1Bands.c1Scale = c1Scale;
c1Bands.c1Space = c1Space;

for iPatch = 1:length(patch)
	for i = 1:length(index)
		testingLoc{i} = trainingLoc(index(i));
	end
	singlePatch{1} = patches.patches{1}(:, patch(iPatch));
	[~, c1, bestBands, ~] = genC2(gaborSpecs, testingLoc, c1Bands, singlePatch, patches.sizes, 1, 0);
	
	x1 = annotation{patches.imgs(patch(iPatch)}.x1;
	x2 = annotation{patches.imgs(patch(iPatch)}.x2;
	y1 = annotation{patches.imgs(patch(iPatch)}.y1;
	y2 = annotation{patches.imgs(patch(iPatch)}.y2;
	[x1x1, x1x2, y1y1, y1y2] = pixelToC1(x1, y1, patches.bands(patch(iPatch)), c1Scale, c1Space, gaborSpecs.receptiveFieldSizes);
	[x2x1, x2x2, y2y1, y2y2] = pixelToC1(x2, y2, patches.bands(patch(iPatch)), c1Scale, c1Space, gaborSpecs.receptiveFieldSizes);

	x1c = min(x1x1, x2x1);
	x2c = max(x1x2, x2x2);
	y1c = min(y1y1, y2y1);
	y2c = max(y1y2, y2y2);

	totalNResponses = size(c1{patch(iPatch)}{band}, 1) * size(c1{patch(iPatch)}{band}, 2); %total number of responses
	totalNFaceResponses = 0; %total number of face responses to be determined for loop below
	faceResponses = 0; %sum of the face responses
	backgroundResponses = 0; %sum of the background responses

	for y = 5:size(c1{patch(iPatch)}{band}, 1) - 5%row
		for x = 5:size(c1{patch(iPatch)}{band}, 2) - 5%column
			if(x < x2c && x > x1c && y < y2c && y > y1c) %if within the boundary of the face
				totalNFaceResponses = totalNFaceResponses + 1; 
				faceResponses = faceResponses + c1{patch(iPatch)}{band}(y, x);
			else
				backgroundResponses = backgroundResponses + c1{patch(iPatch)}{band}(y, x);
			end
		end
	end
	face{iPatch} = faceResponses / totalNFaceResponses;
	background{iPatch} = backgroundResponses / (totalNResponses - totalNFaceResponses);
																																																		
end

rmpath(matlabHome);

end
