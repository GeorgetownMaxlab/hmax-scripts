function quadInfo = cropQuadrants(numSubj, numSes, numTrials, psychHome)
%crop the psychophysics images into quadrants using annotations given by Florence Campana 

if(nargin < 4) psychHome = '~/Documents/Psychophysics/'; end;
if(nargin < 3) numTrials = 72;
if(nargin < 2) numSes = 15; end;
if(nargin < 1) numSubj = 8; end;

outFile = [psychHome 'quadImages/'];
system(['rm -rf ' outFile]);
system(['mkdir ' outFile]);

system(['mkdir ' psychHome '0']); %faces
system(['mkdir ' psychHome '1']); %upright faces
system(['mkdir ' psychHome '2']); %scrambled
system(['mkdir ' psychHome '3']); %houses
system(['mkdir ' psychHome '4']); %inverted faces
system(['mkdir ' psychHome '5']); %configural faces
system(['mkdir ' psychHome '6']); %empty
ext = 'BMP';
count = 1;

for iSubj = 1:numSubj
	for iSes = 1:numSes
		for iTrial = 1:numTrials
			sourceImg = [psychHome 'Images/Suj' int2str(iSubj) '/' int2str(iSubj) '_ses' ...
							 int2str(iSes) '_trial' int2str(iTrial) '.bmp']; 
			img = imread(sourceImg);
			[height, width] = size(img);
			width = width / 2;
			height = height / 2;
			quad1 = imcrop(img, [0, 0, width, height]);
			quad2 = imcrop(img, [width, 0, width, height]);
			quad3 = imcrop(img, [0, height, width, height]);
			quad4 = imcrop(img, [width, height, width, height]);
			quad1File =  [outFile 'Subj_' int2str(iSubj) '_Trial_' ...
								int2str(iTrial + ((iSes - 1) * 72)) 'quad1.bmp'];
			quad2File =  [outFile 'Subj_' int2str(iSubj) '_Trial_' ...
								int2str(iTrial + ((iSes - 1) * 72)) 'quad2.bmp'];
			quad3File =  [outFile 'Subj_' int2str(iSubj) '_Trial_' ...
								int2str(iTrial + ((iSes - 1) * 72)) 'quad3.bmp'];
			quad4File =  [outFile 'Subj_' int2str(iSubj) '_Trial_' ...
								int2str(iTrial + ((iSes - 1) * 72)) 'quad4.bmp'];
			imwrite(quad1, quad1File, ext);
			imwrite(quad2, quad2File, ext);
			imwrite(quad3, quad3File, ext);
			imwrite(quad4, quad4File, ext);
			quadInfo.quadPictures.loc{count, 1} = quad1File;
			quadInfo.quadPictures.loc{count, 2} = quad2File;
			quadInfo.quadPictures.loc{count, 3} = quad3File;
			quadInfo.quadPictures.loc{count, 4} = quad4File;
			quadInfo.quadPictures.Subj{count} = iSubj;
			quadInfo.quadPictures.Ses{count} = iSes;
			quadInfo.quadPictures.Trial{count} = iTrial;
			count = count + 1;	
		end
	end
end
fprintf('done chopping images \n');
for n = 1:count - 1
	subj = int2str(quadInfo.quadPictures.Subj{n});
	ses = int2str(quadInfo.quadPictures.Ses{n});
	trial = quadInfo.quadPictures.Trial{n};
	posArray = load([psychHome 'info_pos/' subj '_ses' ses '.mat']);
	dInfo = load([psychHome 'info_distr/distr_' subj '_ses' ses '.mat']);
	dQuad = posArray.c_distr(trial);
	dType = dInfo.distr(trial);
	fQuad = posArray.c_fce(trial);
	quad = [1 2 3 4];
	
	if(~isnan(dQuad))
		if(isnan(dType))	
			system(['cp ' quadInfo.quadPictures.loc{n, dQuad} ' ' psychHome '1/']); %originally 0
		else
			system(['cp ' quadInfo.quadPictures.loc{n, dQuad} ' ' psychHome int2str(dType) '/']);
		end
	end
	quad = quad(quad~=dQuad); %no distractor
	system(['cp ' quadInfo.quadPictures.loc{n, fQuad} ' ' psychHome '0/']);
	quad = quad(quad~=fQuad); %no distractor(from previous line) and no face
	for iQuad = 1:length(quad) 
		system(['cp ' quadInfo.quadPictures.loc{n, quad(iQuad)} ' ' psychHome '6/']);
	end
end
system(['mv ' psychHome '0 ' psychHome 'faces']);
system(['mv ' psychHome '1 ' psychHome 'uprightFaces']);
system(['mv ' psychHome '2 ' psychHome 'scrambledFaces']);
system(['mv ' psychHome '3 ' psychHome 'houses']);
system(['mv ' psychHome '4 ' psychHome 'invertedFaces']);
system(['mv ' psychHome '5 ' psychHome 'configuralFaces']);
system(['mv ' psychHome '6 ' psychHome 'empty']);

end
