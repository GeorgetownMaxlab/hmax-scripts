function [face, background] = c1ResponsePsych(patch, band, home)
%returns the average responses to the face and background a patch has on a set of images in a given band
%
%patch:      the indices of the first layer of s2f that represents the patches
%band:       the scale band you wish to get the responses to
%home:       location of s2f
%
%face:       average responses to the face region
%background: average responses to the background

gaborSpecs.orientations = [90 -45 0 45];
gaborSpecs.receptiveFieldSizes = 7:2:39;
gaborSpecs.div = 4:-.05:3.2;
c1Scale = 1:2:18;
c1Space = 8:2:22;
%coordinates of the face in the psychophysics images (differs depending on the quadrant)
loc{1} = [206 (206 + 65) (365 - 114 - 87) (365 - 114)]; %[x1 x2 y1 y2]
loc{2} = [255 (255 + 65) (365 - 114 - 87) (365 - 114)];
loc{3} = [263 (263 + 65) (365 - 161 - 87) (365 - 161)];
loc{4} = [198 (198 + 65) (365 - 161 - 87) (365 - 161)];

for iQuad = 1:4
	s2f{iQuad} = load([home 's2f' num2str(iQuad)]);
	s2f{iQuad} = s2f{iQuad}.s2f;
end

parfor iPatch = 1:length(patch)
	for iQuad = 1:4
		x1 = loc{iQuad}(1);
		x2 = loc{iQuad}(2);
		y1 = loc{iQuad}(3);
		y2 = loc{iQuad}(4);

		[x1x1, x1x2, y1y1, y1y2] = pixelToC1(x1, y1, band, c1Scale, c1Space, gaborSpecs.receptiveFieldSizes);
		[x2x1, x2x2, y2y1, y2y2] = pixelToC1(x2, y2, band, c1Scale, c1Space, gaborSpecs.receptiveFieldSizes);

		x1c = min(x1x1, x2x1);
		x2c = max(x1x2, x2x2);
		y1c = min(y1y1, y2y1);
		y2c = max(y1y2, y2y2);

		totalNResponses = size(s2f{iQuad}{patch(iPatch)}{band}, 1) * size(s2f{iQuad}{patch(iPatch)}{band}, 2); %total number of responses
		totalNFaceResponses = 0; %total number of face responses to be determined for loop below
		faceResponses = 0; %sum of the face responses
		backgroundResponses = 0; %sum of the background responses

		for y = 5:size(s2f{iQuad}{patch(iPatch)}{band}, 1) - 5%row
			for x = 5:size(s2f{iQuad}{patch(iPatch)}{band}, 2) - 5%column
				if(x < x2c && x > x1c && y < y2c && y > y1c) %if within the boundary of the face
					totalNFaceResponses = totalNFaceResponses + 1;
					faceResponses = faceResponses + s2f{iQuad}{patch(iPatch)}{band}(y, x);
				else
					backgroundResponses = backgroundResponses + s2f{iQuad}{patch(iPatch)}{band}(y, x);
				end
			end
		end

		face{iPatch}{iQuad} = faceResponses / totalNFaceResponses;
		background{iPatch}{iQuad} = backgroundResponses / (totalNResponses - totalNFaceResponses);

	end
end

end
