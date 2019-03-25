function copyFaceQuadImages(imgLoc, saveLoc)

if(nargin < 1)
	imgLoc = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages/lfwSingle1-10k/facesLoc.mat';
	saveLoc = '/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages/';
end

load(imgLoc);
system(['rm -rf ' saveLoc 'faceQuadImages']);
system(['mkdir ' saveLoc 'faceQuadImages']);

for iQuad = 1:4
	system(['mkdir ' saveLoc 'faceQuadImages/quad' int2str(iQuad)]);
	for iImg = 1:length(facesLoc{iQuad})
		system(['cp ' facesLoc{iQuad}{iImg} ' ' saveLoc 'faceQuadImages/quad' int2str(iQuad) '/']);
	end
end

end
