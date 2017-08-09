function newLocalizationTest(facesFileToLoad, nPatches, loadFolder, maxSize, RESIZE, ...
    saveFolder, quadType, patchSize)


%% Define global variables and load files.
if(nargin < 8) patchSize = 2
end
if(nargin < 7) quadType = 'f'
end
if(nargin < 6) saveFolder = loadFolder
end

startFace = input('starting image?\n')
endFace   = input('ending image?\n')

dbstop if error;

if ispc
   home = 'C:\Users\Levan\HMAX\annulusExpt\';
   loadLoc = ['C:\Users\Levan\HMAX\annulusExpt\'...
       loadFolder '\']
            load([loadLoc facesFileToLoad]); %variable in workspace called 'facesLoc']
            facesLoc = convertFacesLocAnnulus(facesLoc); %Convert the linux file paths to windows file paths.
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

if RESIZE == 1
    [ySize, xSize] = size(resizeImage(imread(facesLoc{1}{1}),maxSize));
else 
    [ySize, xSize] = size(imread(facesLoc{1}{1}));
end
rfSizes = 7:2:39;
c1Space = 8:2:22;
c1Scale = 1:2:18;

load([home 'exptDesign.mat']);
load([loadLoc 'bestLocC2' quadType startFace '-' endFace]); %variable in workspace called 'bestLoc'
load([loadLoc 'bestBandsC2' quadType startFace '-' endFace]); %variable in workspace called 'bestBands'

%% New code

bestBands = horzcat(bestBands{:});
bestLoc   = horzcat(bestLoc{:});

imgHitsWedge   = zeros(nPatches,size(bestBands,2));
imgHitsFaceBox = zeros(nPatches,size(bestBands,2));

for iPatch = 1:nPatches %fprintf('STARTING W CUSTOM PATCH!!')
    iPatch
    for iImg = 1:size(bestBands,2)
        
    % Get the img # in the facesLoc file.
        key = '_session'; %#ok<*NOPRT>
        key2 = '_image';
        idx = strfind(facesLoc{1}{iImg},key);
        idx2 = strfind(facesLoc{1}{iImg},key2);               
        subj = str2double(facesLoc{1}{iImg}(idx-1));
        ses  = str2double(facesLoc{1}{iImg}(idx+8));
        imgNum = facesLoc{1}{iImg}(idx2+6:end);
        imgNum(strfind(imgNum,'.jpeg'):end) = [];
        imgNum = str2double(imgNum);
        imgFacesLoc = 64*(5*(subj-2)+ses-1)+imgNum;
        sanityCheck.imgNum(iImg) = imgFacesLoc;
        
        

        band = bestBands(iPatch, iImg);
        y1 = bestLoc(iPatch, iImg, 1);
        x1 = bestLoc(iPatch, iImg, 2);
%         y1 = y1 + 2; %due to cropping of border; if not done, comment out these 2 lines
%         x1 = x1 + 2;
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
                
                % Define the area around the face location to record a hit.
                faceBox = [position{imgFacesLoc}(2)-50 ...
                          position{imgFacesLoc}(2)+50 ...
                          position{imgFacesLoc}(1)-50 ...
                          position{imgFacesLoc}(1)+50]; %[x1 x2 y1 y2]
                          % x1 is the rightmost coordinate of the box.
                          % x2 is the leftmost coordinate of the box.
                          % y1 is the topmost.
                          % y2 is the bottommost.
                
                if y2p > faceBox(3) && y1p < faceBox(4) && x1p < faceBox(2) && x2p > faceBox(1) 
                   %if best match is within where the face is.
                    imgHitsFaceBox(iPatch,iImg) = 1;
%                     fprintf('FACE BOX HIT!!!!\n')
                end

                
% Get the center of the face.
ctrCol = x1p + (x2p-x1p)/2;
ctrRow = y1p + (y2p-y1p)/2;
    % Trasform the center coordinates into cartesian ones
    ctrCartX = ctrCol - xSize/2; % X coordinate
    ctrCartY = ySize/2 - ctrRow; % Y coordinate                        
        [c2_loc_rad, RHO] = cart2pol(ctrCartX,ctrCartY);
        c2_loc_deg = radtodeg(c2_loc_rad);
        if c2_loc_deg < 0
            c2_loc_deg = 360 + c2_loc_deg;
        end
                        
        face_loc_deg = positionAngle(imgFacesLoc);
            sanityCheck.c2_loc_deg(iImg) = c2_loc_deg;
            sanityCheck.face_loc_deg(iImg) = face_loc_deg;

        if c2_loc_deg < face_loc_deg + 22.5 && c2_loc_deg > face_loc_deg - 22.5
            imgHitsWedge(iPatch,iImg) = 1;
%             fprintf('WEDGE HIT!!!!\n')

        end
    end % iImg loop
end % iPatch loop

%% Save variables
save([saveLoc 'imgHitsWedge' startFace '-' endFace],'imgHitsWedge');
save([saveLoc 'imgHitsFaceBox' startFace '-' endFace],'imgHitsFaceBox');
save([saveLoc 'sanityCheck' startFace '-' endFace],'sanityCheck');

end
        
        
        
        
        