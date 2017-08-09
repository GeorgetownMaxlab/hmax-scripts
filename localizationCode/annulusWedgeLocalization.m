function hits = annulusWedgeLocalization(facesFileToLoad, nPatches, loadFolder, ...
    saveFolder, quadType, patchSize)
%
%type: face, configural, house, scrambled, etc.
%patchSize: the size of the patch
%nPtaches: the number of patches we are finding the localization for
%home: location of where 'bestLoc.mat' and 'bestBands.mat' are located (see classSpecificMAT.m' series for more info
%nQuad: number of quadrants (if not applicable, put 1)
%
%hits: total number of best matches that are within coordinates
%
if(nargin < 6) patchSize = 2
end
if(nargin < 5) quadType = 'f'
end
if(nargin < 4) saveFolder = loadFolder
end

dbstop if error;

if ispc
   home = 'C:\Users\Levan\HMAX\annulusExpt\';
   loadLoc = ['C:\Users\Levan\HMAX\annulusExpt\'...
       loadFolder '\']
            load([loadLoc facesFileToLoad]); %variable in workspace called 'facesLoc']
%             facesLoc = convertFacesLoc(facesLoc); %Convert the linux file paths to windows file paths.
   saveLoc = ['C:\Users\Levan\HMAX\annulusExpt\'...
       saveFolder '\']
else
   home = '/home/levan/HMAX/annulusExpt/';
    loadLoc = ['/home/levan/HMAX/annulusExpt/'...
       loadFolder '/']
    load([loadLoc facesFileToLoad]) %variable in workspace called 'facesLoc'
    saveLoc = ['/home/levan/HMAX/annulusExpt/'...
        saveFolder '/']
end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

load([home 'exptDesign.mat']);

[ySize, xSize] = size(imread(facesLoc{1}{1}));
rfSizes = 7:2:39;
c1Space = 8:2:22;
c1Scale = 1:2:18;
%uncropped borders
% loc{1} = [(190) (190 + 104) (384 - 75 - 100)  (384 - 75)]; %[x1 x2 y1 y2]
% loc{2} = [(215) (215 + 104) (384 - 75 - 100)  (384 - 75)];
% loc{3} = [(248) (248 + 104) (384 - 125 - 100) (384 - 125)];
% loc{4} = [(157) (157 + 104) (384 - 125 - 100) (365 - 125)];

index = 1:nPatches;
load([loadLoc 'bestLocC2' quadType '1']); %variable in workspace called 'bestLoc'
load([loadLoc 'bestBandsC2' quadType '1']); %variable in workspace called 'bestBands'
hits{1} = zeros(1, nPatches);

k = 1; % for sanityCheck. See below.

for n = 1:length(bestLoc)
    n
    temp = zeros(1, nPatches); %used to record the number of hits due to parfor causing problems
%     tempFaceBox = zeros(1, nPatches);
        for i = 1:nPatches	
            iPatch = index(i);
            imgPerCell = size(bestLoc{n}(iPatch, :, :), 2);
                for iImg = 1:imgPerCell
                    
                    % Which image does each cell of facesLoc contain?
                    key = '_session'; %#ok<*NOPRT>
                    key2 = '_image';
                    idx = strfind(facesLoc{1}{imgPerCell*(n-1)+iImg},key);
                    idx2 = strfind(facesLoc{1}{imgPerCell*(n-1)+iImg},key2);               
                        subj = str2double(facesLoc{1}{imgPerCell*(n-1)+iImg}(idx-1));
                        ses  = str2double(facesLoc{1}{imgPerCell*(n-1)+iImg}(idx+8));
                        imgNum = facesLoc{1}{imgPerCell*(n-1)+iImg}(idx2+6:end);
                        imgNum(strfind(imgNum,'.jpeg'):end) = [];
                        imgNum = str2double(imgNum);
                        imgFacesLoc = 64*(5*(subj-2)+ses-1)+imgNum;

                    sanityCheck(imgFacesLoc) = imgFacesLoc; k = k + 1;
                    
%                     loc{1} = [position{imgFacesLoc}(2)-50 ...
%                               position{imgFacesLoc}(2)+50 ...
%                               position{imgFacesLoc}(1)-50 ...
%                               position{imgFacesLoc}(1)+50]; %[x1 x2 y1 y2]
                              % x1 is the rightmost coordinate of the box.
                              % x2 is the leftmost coordinate of the box.
                              % y1 is the topmost.
                              % y2 is the bottommost.
                    band = bestBands{n}(iPatch, iImg);
                    y1 = bestLoc{n}(iPatch, iImg, 1);
                    x1 = bestLoc{n}(iPatch, iImg, 2);
                    y1 = y1 + 2; %due to cropping of border; if not done, comment out these 2 lines
                    x1 = x1 + 2;
                    y2 = y1 + patchSize - 1;
                    x2 = x1 + patchSize - 1;
                    
                    % Get pixel coordinates of the C1 rep. 
                    [x1p, x2p, y1p, y2p] = patchDimensionsInPixelSpace(band, x1, x2, y1, y2, c1Scale, c1Space, rfSizes, double(xSize), double(ySize));
                        if(x1p > x2p) %SHOULD NOT HAPPEN! SIGNALS THAT THERE IS SOMETHING WRONG
                            fprintf(['xinversion occured for image ' int2str(iImg) ' patch ' int2str(iImg) '\n']);
                            [x1p, x2p] = swap(x1p, x2p);
                        end
                        if(y1p > y2p) %SHOULD NOT HAPPEN! SIGNALS THAT THERE IS SOMETHING WRONG
                            fprintf(['yinversion occured for image ' int2str(iImg) ' patch ' int2str(iImg) '\n']);
                            [y1p, y2p] = swap(y1p, y2p);
                        end
                    
                    % Get the center of the face.
                    ctrRow = x1p + (x2p-x1p)/2;
                    ctrCol = y1p + (y2p-y1p)/2;
                        % Trasform the center coordinates into cartesian ones
                        ctrCartX = ctrCol - xSize/2; % X coordinate
                        ctrCartY = ySize/2 - ctrRow; % Y coordinate
                        
                        [THETA_rad, RHO] = cart2pol(ctrCartX,ctrCartY);
                        THETA_deg = radtodeg(THETA_rad);
                        if THETA_deg < 0
                            THETA_deg = 360 + THETA_deg;
                        end
                        
                        faceAngle = positionAngle(imgFacesLoc);
 
                    imgHits{1}{n}{i}{iImg} = 0;                        
                        if THETA_deg < faceAngle + 22.5 && THETA_deg > faceAngle - 22.5
                            temp(i) = temp(i) + 1; %used because of the parfor
                            imgHits{1}{n}{i}{iImg} = 1;
                        end
                end % imgPerCell loop. 
        end % nPatches loop
        hits{1} = hits{1} + temp; %compile the number %of hit
end
save([saveLoc 'hitsWedge'], 'hits');
save([saveLoc 'sanityCheckWedge'], 'sanityCheck');

imgHits = concatinateImgHitsAnnulus(imgHits,quadType,nPatches,loadLoc,saveLoc);
save([saveLoc 'imgHitsMapWedge' quadType], 'imgHits');


end