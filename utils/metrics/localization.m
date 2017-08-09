function hits = localization(type, patchSize, nPatches, home, nQuad)
%
%type: face, configural, house, scrambled, etc.
%patchSize: the size of the patch
%nPtaches: the number of patches we are finding the localization for
%home: location of where 'bestLoc.mat' and 'bestBands.mat' are located (see classSpecificMAT.m' series for more info
%nQuad: number of quadrants (if not applicable, put 1)
%
%hits: total number of best matches that are within coordinates
%
if(nargin < 5) nQuad = 4;
if(nargin < 4) home = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/lfwBlur/'; end;

load([home 'facesLoc']); %variable in workspace called 'facesLoc'
[ySize, xSize] = size(imread(facesLoc{1}{1}));
rfSizes = 7:2:39;
c1Space = 8:2:22;
c1Scale = 1:2:18;
%uncropped borders
loc{1} = [(206 - 32) (206 + 32) (365 - 114 - 43) (365 - 114 + 43)]; %[x1 x2 y1 y2]
loc{2} = [(255 - 32) (255 + 32) (365 - 114 - 43) (365 - 114 + 43)];
loc{3} = [(263 - 32) (263 + 32) (365 - 161 - 43) (365 - 161 + 43)];
loc{4} = [(198 - 32) (198 + 32) (365 - 161 - 43) (365 - 161 + 43)];
%coordinates below used to make up for improperly labled coordinates during a very specific run!
bandSize{1} = [92 116];
bandSize{2} = [73 93];
bandSize{3} = [61 78];
bandSize{4} = [53 67];
bandSize{5} = [46 58];
bandSize{6} = [41 52];
bandSize{7} = [37 47];
bandSize{8} = [34 43];
%cropped borders (unsure of coordinates)
%loc{1} = [153 240 181 288];
%loc{2} = [201 288 189 296];
%loc{3} = [213 296 137 244];
%loc{4} = [149 228 133 240];
%load([home 'hits']);
%[~, index] = sort2(hits{5}, 1:19600, 2, 'descend');
index = 1:nPatches;

for iQuad = 1:nQuad
	load([home 'bestLocC2' type int2str(iQuad)]); %variable in workspace called 'bestLoc'
	load([home 'bestBandsC2' type int2str(iQuad)]); %variable in workspace called 'bestBands'
	hits{iQuad} = zeros(1, nPatches);
	imgHits{iQuad} = cell(1, length(bestLoc));
	for n = 1:length(bestLoc)
		n
		temp = zeros(1, nPatches); %used because to recorde the number of hits due to parfar causing problems
		imgHits{iQuad}{n} = zeros(1, 20);
		tempImgHits = cell(1, nPatches);
		parfor i = 1:nPatches	
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
					[x1p x2p] = swap(x1p, x2p);
				end
				if(y1p > y2p) %SHOULD NOT HAPPEN! SIGNALS THAT THERE IS SOMETHING WRONG
					fprintf(['yinversion occured for image ' int2str(iImg) ' patch ' int2str(iImg) '\n']);
					[y1p y2p] = swap(y1p, y2p);
				end
			
				quad = str2num(facesLoc{iQuad}{iImg + ((n - 1) * 20)}(length(facesLoc{iQuad}{iImg + ((n - 1) * 20)}) - 4));
	
				if(y2p > loc{quad}(3) && y1p < loc{quad}(4) && x1p < loc{quad}(2) && x2p > loc{quad}(1)) %if best match is within where the face is
					temp(i) = temp(i) + 1; %used because of the parfor
%					tempImgHits{i}(iImg) = 1;
				end
			end
		end
		hits{iQuad} = hits{iQuad} + temp; %compile the number %of hit
%		for iPatch = 1:nPatches
%			for iImg = 1:length(tempImgHits{iPatch})
%				imgHits{iQuad}{n}(iImg) = imgHits{iQuad}{n}(iImg) + tempImgHits{iPatch}(iImg);
%			end
%		end
	end
	save([home 'hits'], 'hits');
%	save([home 'imgHits' int2str(nPatches)], 'imgHits');
end

hits{5} = zeros(1, nPatches);
for iPatch = 1:nPatches
	hits{5}(iPatch) = hits{1}(iPatch) + hits{2}(iPatch) + hits{3}(iPatch) + hits{4}(iPatch);
end
save([home 'hits'], 'hits');
%save([home 'imgHits' int2str(nPatches)], 'imgHits');

end


