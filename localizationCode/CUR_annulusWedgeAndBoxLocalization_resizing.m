function CUR_annulusWedgeAndBoxLocalization_resizing(...
                    nPatches, patchSize, loadFolder, condition, ...
                    runImgDiff, maxSize, facesFileToLoad, ...
                    saveFolder, quadType)

%% Define global variables and load files.

if(nargin < 1)
    nPatches = 1;
    loadFolder = 'annulusExptFixedContrast/simulation1\part2Inverted_2nd_cohort\upright\data\patchSetAdam\lfwSingle50000';
    condition = 'annulusExptFixedContrast/simulation1\part2Inverted_2nd_cohort\upright';
    saveFolder = [loadFolder '/sandbox'];
end

if(nargin < 9) quadType = 'f'
end
if(nargin < 8) saveFolder = loadFolder
end
if(nargin < 7) facesFileToLoad = 'facesLoc.mat';
end
if(nargin < 6) maxSize = 579;
end
if(nargin < 5) runImgDiff = 1;
end

dbstop if error;

if ispc
    pcStatus = 1;
    home    = fullfile('C:/Users/Levan/HMAX/',condition); % location for exptDesign file
    loadLoc = fullfile('C:/Users/Levan/HMAX/',loadFolder) %#ok<*NOPRT>
    load(fullfile(loadLoc,facesFileToLoad)); %variable in workspace called 'facesLoc']
    saveLoc = fullfile('C:/Users/Levan/HMAX/',saveFolder)
else
    pcStatus = 0;
    home    = fullfile('/home/levan/HMAX/',condition); % location for exptDesign file
    loadLoc = fullfile('/home/levan/HMAX/',loadFolder)
    load(fullfile(loadLoc,facesFileToLoad) %variable in workspace called 'facesLoc'
    saveLoc = fullfile('/home/levan/HMAX/',saveFolder)
end

% Check if faceLoc needs to be changed
facesLoc = convertFacesLocAnnulusFixedContrast(facesLoc,pcStatus); %Convert the linux file paths to windows file paths, and vice-versa if needed.

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end
mkdir(fullfile(saveLoc,'responseOverlays/hits'));
mkdir(fullfile(saveLoc,'responseOverlays/misses'));

rfSizes = 7:2:39;
c1Space = 8:2:22;
c1Scale = 1:2:18;

load(fullfile(home, 'exptDesign.mat'),'position','positionAngle');
load(fullfile(loadLoc, ['bestLocC2'   quadType])); %variable in workspace called 'bestLoc'
load(fullfile(loadLoc, ['bestBandsC2' quadType])); %variable in workspace called 'bestBands'


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
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\upright\data\patchSetAdam\lfwSingle50000\sandbox\dimensions.mat');
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_2nd_cohort\upright\data\patchSetAdam\lfwSingle50000\sandbox\dimensions.mat');

for iImg = 1:length(facesLoc{1})
    display(['Calculating scaling factors. Img = ' int2str(iImg)]);
    dimsOrig   (iImg,1:2) = size(imread(facesLoc{1}{iImg}));
    % These are the dimensions of images pushed through HMAX.
    dimsResized(iImg,1:2) = size(resizeImage(imread(facesLoc{1}{iImg}),maxSize));

    % Now obtain the scaling factor for bestLoc variables, so they can be
    % transformed to be relative to dimensions of the images seen by subjects.
    % Then they can be compared to face location values.
    scalingFactor(iImg) = dimsOrig(iImg,1)/dimsResized(iImg,1);
    assert(isequal(round(scalingFactor(iImg),2),round(dimsOrig(iImg,2)/dimsResized(iImg,2),2)),'somethings not right with image resizing');
end
%% SEE IF C2 COMES FROM THE WEDGE OR FACE BOX.
if iscell(bestBands)
    bestBands = horzcat(bestBands{:});
    bestLoc   = horzcat(bestLoc{:});
end

imgHitsWedge   = zeros(nPatches,size(bestBands,2));
imgHitsFaceBox = zeros(nPatches,size(bestBands,2));

tic;

% Get the img # in the facesLoc file.
% Typically facesLoc file should be sorted. So img # corresponds to its
% location in the facesLoc file. Check that this condition holds, then
% proceed.
% Sort the facesLoc file using natural sorting. The output indices
% should just be progression from 1 to the maximum number of images.
[~,idx_sorted_facesLoc] = sort_nat(facesLoc{1});
assert(isequal(idx_sorted_facesLoc,1:size(facesLoc{1},2)),'getting imaged indices for localization are messed up');
imgFacesLoc = idx_sorted_facesLoc;
sanityCheck.imgFacesLoc = imgFacesLoc;


for iPatch = 1:nPatches %fprintf('STARTING W CUSTOM PATCH!!')
    if mod(iPatch,500) == 0
        iPatch
    end
    for iImg = 1:size(bestBands,2) 
%         fprintf('STARTING W CUSTOM IMAGE!!')
        
        ySizeOrig    = dimsOrig   (iImg,1);
        xSizeOrig    = dimsOrig   (iImg,2);
        ySizeResized = dimsResized(iImg,1);
        xSizeResized = dimsResized(iImg,2);
        
        band = bestBands(iPatch, iImg);
        y1   = bestLoc(iPatch, iImg, 1);
        x1   = bestLoc(iPatch, iImg, 2);
        y2   = y1 + patchSize - 1;
        x2   = x1 + patchSize - 1;    
        % Get pixel coordinates of the C1 representation
        [x1p, x2p, y1p, y2p] = patchDimensionsInPixelSpace(band, x1, x2, y1, y2, c1Scale, c1Space, rfSizes, double(xSizeResized), double(ySizeResized));
        assert((x1p <= x2p || y1p <= y2p), 'X or Y inversion occurred!!'); 
        % Define the area around the face location to record a hit.
        if ySizeOrig == 730
            radius = 50;
        elseif ySizeOrig == 1086
            radius = 74; %1086*50/730=74.38
        elseif ySizeOrig == 1094
            radius = 75; %1094*50/730=74.93
        else
            error('Image size isn''t right')
        end
        
        faceBoxOrig = [position{imgFacesLoc(iImg)}(2)-radius ...
                       position{imgFacesLoc(iImg)}(2)+radius ...
                       position{imgFacesLoc(iImg)}(1)-radius ...
                       position{imgFacesLoc(iImg)}(1)+radius]; %[x1 x2 y1 y2]
                       % x1 is the leftmost coordinate of the box.
                       % x2 is the rightmost coordinate of the box.
                       % y1 is the topmost.
                       % y2 is the bottommost.
        % Rescale faceBox coordinates to be relative to resized
        % image dimensions, so patch pixel coordinates can be
        % compared to it.
        faceBoxResized = faceBoxOrig/scalingFactor(iImg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Draw images for visualizing everything.
% annulusImgToShow = facesLoc{1}{iImg};
% visualize = visualizeLocations(ySizeOrig,xSizeOrig,scalingFactor(iImg),faceBoxOrig,x1p,x2p,y1p,y2p,annulusImgToShow);
% sanityCheck.visualizePositions{iPatch,iImg} = visualize;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    if y2p > faceBoxResized(3) && y1p < faceBoxResized(4) && x1p < faceBoxResized(2) && x2p > faceBoxResized(1) 
       %if best match is within where the face is.
        imgHitsFaceBox(iPatch,iImg) = 1;
%         imwrite(uint8(visualize),[saveLoc 'responseOverlays/hits/patch'   int2str(iPatch) '_face' int2str(iImg) '.png']);
    else
%         imwrite(uint8(visualize),[saveLoc 'responseOverlays/misses/patch' int2str(iPatch) '_face' int2str(iImg) '.png']);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NOW CHECK THE WEDGE LOCALIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the center of the C2 location.
ctrCol = x1p + (x2p-x1p)/2;
ctrRow = y1p + (y2p-y1p)/2;
% Due to image resizing, adjust the ctrCol and ctrRow to be relative to the
% dimensions of the images presented to subjects.
ctrCol = ctrCol * scalingFactor(iImg);
ctrRow = ctrRow * scalingFactor(iImg);

    % Trasform the center coordinates into cartesian ones
    ctrCartX = ctrCol - xSizeOrig/2; % X coordinate
    ctrCartY = ySizeOrig/2 - ctrRow; % Y coordinate   
    
        % Get the polar angle of the center of the C2 location.
        [c2_loc_rad, ~] = cart2pol(ctrCartX,ctrCartY);
        face_loc_deg = positionAngle(imgFacesLoc(iImg));
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
save(fullfile(saveLoc,'runTime'),       'runTime');
save(fullfile(saveLoc,'imgHitsWedge'),  'imgHitsWedge');
save(fullfile(saveLoc,'imgHitsFaceBox'),'imgHitsFaceBox');
save(fullfile(saveLoc,'sanityCheck'),   'sanityCheck');

%% call the image difficulty code?
if runImgDiff == 1
   display('making the image difficulty maps...\n');
   CUR_imageDifficultyMapWedgeLocalization  ('SINGLES','f', saveFolder,0);
   CUR_imageDifficultyMapFaceBoxLocalization('SINGLES','f', saveFolder,0);
end


end
        
        
function visualize = visualizeLocations(ySizeOrig,xSizeOrig,imgScalingFactor,faceBoxOrig,x1p,x2p,y1p,y2p,annulusImgToShow)
%     close;
    visualize = double(imread(annulusImgToShow)); %zeros(ySizeOrig,xSizeOrig);
    % Draw face box
%     visualize(faceBoxOrig(3):faceBoxOrig(4),faceBoxOrig(1):faceBoxOrig(2)) = 1;
    % Draw C2 location.
    x1pOrig = round(x1p*imgScalingFactor);
    x2pOrig = round(x2p*imgScalingFactor);
    y1pOrig = round(y1p*imgScalingFactor);
    y2pOrig = round(y2p*imgScalingFactor);
    visualize(y1pOrig:y2pOrig,x1pOrig:x2pOrig) = 0;
%     subplot(1,2,1)
%     imshow(uint8(visualize))
%     subplot(1,2,2)
%     imshow(uint8(imread(annulusImgToShow)));

    visualize = visualize(faceBoxOrig(3):faceBoxOrig(4),faceBoxOrig(1):faceBoxOrig(2));
    figure
    subplot(2,1,1)
    imshow(uint8(visualize))
    visualize = imresize(visualize,0.5); % Downsampled to save space.

    
    % Now visualize as HMAX saw it
    visualizeHMAX = resizeImage(double(imread(annulusImgToShow)),579);
    faceBoxResized = round(faceBoxOrig/imgScalingFactor);
    visualizeHMAX = visualizeHMAX(faceBoxResized(3):faceBoxResized(4),faceBoxResized(1):faceBoxResized(2));
    
    subplot(2,1,2)
    imshow(uint8(visualizeHMAX))

end
        
        