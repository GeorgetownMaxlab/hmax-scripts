function annulusWedgeAndBoxLocalization_resizing_testing(nPatches, loadFolder, condition, ...
    runImgDiff, maxSize, facesFileToLoad, saveFolder, quadType, patchSize)

%% Define global variables and load files.

% if(nargin < 1)
%     nPatches = 500;
%     loadFolder = 'trainingRuns\patchSetAdam\lfwSingle500resized_masked';
%     maxSize = 579;
%     facesFileToLoad = 'facesLoc.mat';
%     saveFolder = 'trainingRuns\patchSetAdam\lfwSingle500resized_masked\sandbox\500';
% end

if(nargin < 9) patchSize = 2
end
if(nargin < 8) quadType = 'f'
end
if(nargin < 7) saveFolder = loadFolder
end
if(nargin < 6) facesFileToLoad = 'facesLoc.mat';
end
if(nargin < 5) maxSize = 579;
end
if(nargin < 4) runImgDiff = 1;
end

dbstop if error;

if ispc
    pcStatus = 1;
    home = ['C:/Users/Levan/HMAX/annulusExptFixedContrast/' condition '/'];
    loadLoc = ['C:/Users/Levan/HMAX/annulusExptFixedContrast/' loadFolder '/']
    load([loadLoc facesFileToLoad]); %variable in workspace called 'facesLoc']
    saveLoc = ['C:/Users/Levan/HMAX/annulusExptFixedContrast/' saveFolder '/']
else
    pcStatus = 0;
    home = ['/home/levan/HMAX/annulusExptFixedContrast/' condition '/'];
    loadLoc = ['/home/levan/HMAX/annulusExptFixedContrast/' loadFolder '/']
    load([loadLoc facesFileToLoad]) %variable in workspace called 'facesLoc'
    saveLoc = ['/home/levan/HMAX/annulusExptFixedContrast/' saveFolder '/']
end

% Check if faceLoc needs to be changed
facesLoc = convertFacesLocAnnulusFixedContrast(facesLoc,pcStatus); %Convert the linux file paths to windows file paths, and vice-versa if needed.

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

rfSizes = 7:2:39;
c1Space = 8:2:22;
c1Scale = 1:2:18;

load([home 'exptDesign.mat'],'position','positionAngle');
position = position;
positionAngle = positionAngle;
load([loadLoc 'bestLocC2' quadType]); %variable in workspace called 'bestLoc'
load([loadLoc 'bestBandsC2' quadType]); %variable in workspace called 'bestBands'


%% Save parameter space.
runDateTime = datetime('now');
outputOfPWD = pwd;
scriptName  = mfilename('fullpath');
runParameterComments = 'none'; %input('Any comments about run?\n');
save([saveLoc 'locParameters.mat'],...
    'runDateTime',...
    'outputOfPWD',...
    'runParameterComments',...
    'home',...
    'scriptName',...
    'facesFileToLoad',...
    'quadType',...
    'patchSize',...
    'saveLoc',...
    'loadLoc',...
    'maxSize'...
    );
%% ADJUST THE BEST LOC VALUES BASED ON RESIZING DONE AT C2 CALCULATION

% ySizeOrig and xSizeOrig are dimensions of images that were presented to
% subjects during psychophysical experiments. All the face-location data
% given by Florence is relative to these dimensions. 
% ySizeOrig = 730;
% xSizeOrig = 927;
[ySizeOrig,xSizeOrig] = size(imread(facesLoc{1}{1}));

% These are the dimensions of images pushed through HMAX.
[ySizeResized, xSizeResized] = size(resizeImage(imread(facesLoc{1}{1}),maxSize));

% Now obtain the scaling factor for bestLoc variables, so they can be
% transformed to be relative to dimensions of the images seen by subjects.
% Then they can be compared to face location values.
scalingFactor = ySizeOrig/ySizeResized;
assert(isequal(round(scalingFactor,3),round(xSizeOrig/xSizeResized,3)),'somethings not right with image resizing');

%% SEE IF C2 COMES FROM THE WEDGE OR FACE BOX.
if iscell(bestBands)
    bestBands = horzcat(bestBands{:});
    bestLoc   = horzcat(bestLoc{:});
end

imgHitsWedge   = zeros(nPatches,size(bestBands,2));
imgHitsFaceBox = zeros(nPatches,size(bestBands,2));

tic;

for iPatch = 1:nPatches %fprintf('STARTING W CUSTOM PATCH!!')
    if mod(iPatch,500) == 0
        iPatch
    end
    for iImg = 1:size(bestBands,2)
        
    % Get the img # in the facesLoc file.

    key = '/image';
    key2 = '_';
    idx  = strfind(facesLoc{1}{iImg},key);
    idx = idx(end);
    idx2 = strfind(facesLoc{1}{iImg},key2);
    imgFacesLoc = str2double(facesLoc{1}{iImg}((idx+length(key)):idx2-1))
    sanityCheck.imgNum(iPatch,iImg) = imgFacesLoc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The code below was for old runs to get the img#.
%     key = '_session'; %#ok<*NOPRT>
%     key2 = '_image';
%     idx = strfind(facesLoc{1}{iImg},key);
%     idx2 = strfind(facesLoc{1}{iImg},key2);               
%     subj = str2double(facesLoc{1}{iImg}(idx-1));
%     ses  = str2double(facesLoc{1}{iImg}(idx+8));
%     imgNum = facesLoc{1}{iImg}(idx2+6:end);
%     imgNum(strfind(imgNum,'.jpeg'):end) = [];
%     imgNum = str2double(imgNum);
%     imgFacesLoc = 64*(5*(subj-2)+ses-1)+imgNum;
%     sanityCheck.imgNum(iPatch,iImg) = imgFacesLoc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        band = bestBands(iPatch, iImg);
        y1 = bestLoc(iPatch, iImg, 1);
        x1 = bestLoc(iPatch, iImg, 2);
        y2 = y1 + patchSize - 1;
        x2 = x1 + patchSize - 1;    
            % Get pixel coordinates of the C1 rep. 
            [x1p, x2p, y1p, y2p] = patchDimensionsInPixelSpace(band, x1, x2, y1, y2, c1Scale, c1Space, rfSizes, double(xSizeResized), double(ySizeResized));
            assert((x1p <= x2p || y1p <= y2p), 'X or Y inversion occurred!!'); 
        % Define the area around the face location to record a hit.
        faceBoxOrig = [position{imgFacesLoc}(2)-50 ...
                  position{imgFacesLoc}(2)+50 ...
                  position{imgFacesLoc}(1)-50 ...
                  position{imgFacesLoc}(1)+50]; %[x1 x2 y1 y2]
                  % x1 is the leftmost coordinate of the box.
                  % x2 is the rightmost coordinate of the box.
                  % y1 is the topmost.
                  % y2 is the bottommost.
        % Rescale faceBox coordinates to be relative to resized
        % image dimensions, so patch pixel coordinates can be
        % compared to it.
        faceBoxResized = faceBoxOrig/scalingFactor;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Draw images for visualizing everything.
annulusImgToShow = facesLoc{1}{iImg};
visualize = visualizeLocations(ySizeOrig,xSizeOrig,scalingFactor,faceBoxOrig,x1p,x2p,y1p,y2p,annulusImgToShow);
mkdir([saveLoc 'sandbox']);
imwrite(uint8(visualize),[saveLoc 'sandbox/patch' int2str(iPatch) '_face' int2str(iImg) '.png']);

% sanityCheck.visualizePositions{iPatch,iImg} = visualize;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    if y2p > faceBoxResized(3) && y1p < faceBoxResized(4) && x1p < faceBoxResized(2) && x2p > faceBoxResized(1) 
       %if best match is within where the face is.
        imgHitsFaceBox(iPatch,iImg) = 1;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOW CHECK THE WEDGE LOCALIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the center of the C2 location.
ctrCol = x1p + (x2p-x1p)/2;
ctrRow = y1p + (y2p-y1p)/2;
% Due to image resizing, adjust the ctrCol and ctrRow to be relative to the
% dimensions of the images presented to subjects.
ctrCol = ctrCol * scalingFactor;
ctrRow = ctrRow * scalingFactor;

    % Trasform the center coordinates into cartesian ones
    ctrCartX = ctrCol - xSizeOrig/2; % X coordinate
    ctrCartY = ySizeOrig/2 - ctrRow; % Y coordinate   
    
        % Get the polar angle of the center of the C2 location.
        [c2_loc_rad, ~] = cart2pol(ctrCartX,ctrCartY);
        face_loc_deg = positionAngle(imgFacesLoc);
        face_loc_rad = deg2rad(face_loc_deg);
    %     % Sanity check that angles are calculated right.
    %         % cartesian positions of the face in original dimensions
    %         for iCheck = 1:length(position)
    %             cartPosition{i} = [position{i}(2)-ySizeOrig/2,xSizeOrig/2-position{i}(1)];
    %             sanityCheckRad = cart2pol(cartPosition{i});
    %         end
    %     % sanity check unfinished
    
    criterionInRad = deg2rad(45);    
    if abs(angleDiff(c2_loc_rad,face_loc_rad)) < criterionInRad
        imgHitsWedge(iPatch,iImg) = 1;
    end
    
sanityCheck.c2_loc_rad  (iPatch,iImg) = c2_loc_rad;
sanityCheck.face_loc_rad(iPatch,iImg) = face_loc_rad;

    end % iImg loop
end % iPatch loop

runTime = toc
% sanityCheck.imgNum = imgNum;
% sanityCheck.c2_loc_deg = c2_loc_deg;
% sanityCheck.face_loc_deg = face_loc_deg;

%% Save variables
save([saveLoc 'runTime'],'runTime');
save([saveLoc 'imgHitsWedge'],'imgHitsWedge');
save([saveLoc 'imgHitsFaceBox'],'imgHitsFaceBox');
save([saveLoc 'sanityCheck'],'sanityCheck');

%% call the image difficulty code?
if runImgDiff == 1
   display('making the image difficulty maps...\n');
   imageDifficultyMapWedgeLocalization('SINGLES','f', saveFolder,0);
end


end
        
        
function visualize = visualizeLocations(ySizeOrig,xSizeOrig,scalingFactor,faceBoxOrig,x1p,x2p,y1p,y2p,annulusImgToShow)
%     close;
    visualize = double(imread(annulusImgToShow)); %zeros(ySizeOrig,xSizeOrig);
    % Draw face box
%     visualize(faceBoxOrig(3):faceBoxOrig(4),faceBoxOrig(1):faceBoxOrig(2)) = 1;
    % Draw C2 location.
    x1pOrig = round(x1p*scalingFactor);
    x2pOrig = round(x2p*scalingFactor);
    y1pOrig = round(y1p*scalingFactor);
    y2pOrig = round(y2p*scalingFactor);
    visualize(y1pOrig:y2pOrig,x1pOrig:x2pOrig) = 0;
%     subplot(1,2,1)
%     imshow(uint8(visualize))
%     subplot(1,2,2)
%     imshow(uint8(imread(annulusImgToShow)));
%     visualize = imresize(visualize,0.05); % Downsampled to save space.
    visualize = visualize(faceBoxOrig(3):faceBoxOrig(4),faceBoxOrig(1):faceBoxOrig(2));
%     imshow(uint8(visualize))
end
        
        