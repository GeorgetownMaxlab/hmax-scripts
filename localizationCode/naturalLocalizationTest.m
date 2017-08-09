function hits = naturalLocalizationTest(facesFileToLoad, nPatches, loadFolder, ...
    saveFolder, quadType, nQuad, patchSize)
%
%type: face, configural, house, scrambled, etc.
%patchSize: the size of the patch
%nPtaches: the number of patches we are finding the localization for
%home: location of where 'bestLoc.mat' and 'bestBands.mat' are located (see classSpecificMAT.m' series for more info
%nQuad: number of quadrants (if not applicable, put 1)
%
%hits: total number of best matches that are within coordinates
%
if(nargin < 7) patchSize = 2
end
if(nargin < 6) nQuad = 4
end
if(nargin < 5) quadType = 'f'
end
if(nargin < 4) saveFolder = loadFolder
end

if ispc
   loadLoc = ['C:\Users\Levan\HMAX\naturalFaceImages\'...
       loadFolder '\']
            load([loadLoc facesFileToLoad]); %variable in workspace called 'facesLoc']
            facesLoc = convertFacesLoc(facesLoc); %Convert the linux file paths to windows file paths.
   saveLoc = ['C:\Users\Levan\HMAX\naturalFaceImages\'...
       saveFolder '\']
else
    loadLoc = ['/home/levan/HMAX/naturalFaceImages/'...
       loadFolder '/']
    load([loadLoc facesFileToLoad]); %variable in workspace called 'facesLoc'
    saveLoc = ['/home/levan/HMAX/naturalFaceImages/'...
        saveFolder '/']
end

[ySize, xSize] = size(imread(facesLoc{1}{1}));
rfSizes = 7:2:39;
c1Space = 8:2:22;
c1Scale = 1:2:18;
%uncropped borders
loc{1} = [(190) (190 + 104) (384 - 75 - 100)  (384 - 75)]; %[x1 x2 y1 y2]
loc{2} = [(215) (215 + 104) (384 - 75 - 100)  (384 - 75)];
loc{3} = [(248) (248 + 104) (384 - 125 - 100) (384 - 125)];
loc{4} = [(157) (157 + 104) (384 - 125 - 100) (365 - 125)];
%load([home 'hits']);
%[~, index] = sort2(hits{5}, 1:19600, 2, 'descend');

index = 1:nPatches;

for iQuad = 1:nQuad
	load([loadLoc 'bestLocC2' quadType int2str(iQuad)]); %variable in workspace called 'bestLoc'
	load([loadLoc 'bestBandsC2' quadType int2str(iQuad)]); %variable in workspace called 'bestBands'
	hits{iQuad} = zeros(1, nPatches);
	%imgHits{iQuad} = cell(1, length(bestLoc));
	for n = 1:length(bestLoc)
		n
		temp = zeros(1, nPatches); %used because to record the number of hits due to parfar causing problems
	%	imgHits{iQuad}{n} = zeros(1, 20);
	%	tempImgHits = cell(1, nPatches);
		for i = 1:nPatches	
			iPatch = index(i);
			for iImg = 1:size(bestLoc{n}(iPatch, :, :), 2)
				band = bestBands{n}(iPatch, iImg);
			%	t = bandSize{band} %temporary variable for reason stated below
				y1 = bestLoc{n}(iPatch, iImg, 1);
				x1 = bestLoc{n}(iPatch, iImg, 2);
				%safety net if a quadrant is one pixel bigger than the others
			%	if(y1 - 1 == t(1))
			%		t(1) = t(1) + 1;
			%	end
			%	if(x1 - 1 == t(2))
			%		t(2) = t(2) + 1;
			%	end	
			%	singleIndex = sub2ind([t(1) - 14, t(2)], y1, x1);
			%	[y1 x1] = ind2sub([t(1) - 7, t(2) - 7], singleIndex);
				y1 = y1 + 2; %due to cropping of border; if not done, comment out these 2 lines
				x1 = x1 + 2;
				y2 = y1 + patchSize - 1;
				x2 = x1 + patchSize - 1;
				[x1p, x2p, y1p, y2p] = patchDimensionsInPixelSpace(band, x1, x2, y1, y2, c1Scale, c1Space, rfSizes, double(xSize), double(ySize));
				if(x1p > x2p) %SHOULD NOT HAPPEN! SIGNALS THAT THERE IS SOMETHING WRONG
					fprintf(['xinversion occured for image ' int2str(iImg) ' patch ' int2str(iImg) '\n']);
					[x1p, x2p] = swap(x1p, x2p);
				end
				if(y1p > y2p) %SHOULD NOT HAPPEN! SIGNALS THAT THERE IS SOMETHING WRONG
					fprintf(['yinversion occured for image ' int2str(iImg) ' patch ' int2str(iImg) '\n']);
					[y1p, y2p] = swap(y1p, y2p);
				end
			
				quad = str2num(facesLoc{iQuad}{iImg + ((n - 1) * 20)}(length(facesLoc{iQuad}{iImg + ((n - 1) * 20)}) - 4));
				
				imgHits{iQuad}{n}{i}{iImg} = 0;
				if(y2p > loc{quad}(3) && y1p < loc{quad}(4) && x1p < loc{quad}(2) && x2p > loc{quad}(1)) %if best match is within where the face is
					temp(i) = temp(i) + 1; %used because of the parfor
%					tempImgHits{i}(iImg) = 1;
					imgHits{iQuad}{n}{i}{iImg} = 1;
				end
			end
        end; %nPatches loop
		hits{iQuad} = hits{iQuad} + temp; %compile the number %of hit
%		for iPatch = 1:nPatches
%			for iImg = 1:length(tempImgHits{iPatch})
%				imgHits{iQuad}{n}(iImg) = imgHits{iQuad}{n}(iImg) + tempImgHits{iPatch}(iImg);
%			end
%		end
	end
	save([saveLoc 'hits'], 'hits');
	save([saveLoc 'imgHits' int2str(nPatches)], 'imgHits');
end; %iQuad loop.

hits{5} = zeros(1, nPatches);
for iPatch = 1:nPatches
	hits{5}(iPatch) = hits{1}(iPatch) + hits{2}(iPatch) + hits{3}(iPatch) + hits{4}(iPatch);
end
save([saveLoc 'hits'], 'hits');
save([saveLoc 'imgHits' int2str(nPatches)], 'imgHits');

concatinateImgHits(quadType,nPatches,loadLoc);

end