function CUR_annulus_FaceBox_and_AngularDegree_Calculation(...
                    iPatchLoop,...
                    nPatchesPerLoop,...
                    patchSizes,...
                    loadLoc,...
                    condition,...
                    saveLoc,...
                    facesLoc,...
                    nImgsAnalyzed,...
                    dimsOrig,...
                    dimsResized,...
                    scalingFactors,...
                    runImgDiff,...
                    quadType)

% This script is adjusted to perform localization for any size of patches.
% It also supports starting the localization calculation from an arbitrary
% index of patches.

                
%% Define global variables and load files.

if (nargin < 12) quadType = 'f';
end
if (nargin < 11) runImgDiff = 1;
end
if (nargin < 8) nImgsAnalyzed = length(facesLoc{1});
end
if (nargin < 7) saveLoc = loadLoc;
end

dbstop if error;

idxPatchStart = (iPatchLoop-1)*nPatchesPerLoop+1;
idxPatchEnd   = (iPatchLoop)  *nPatchesPerLoop;

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end


rfSizes = 7:2:39;
c1Space = 8:2:22;
c1Scale = 1:2:18;

load(fullfile(condition,'exptDesign.mat'));
% load(fullfile(loadLoc,'exptDesign.mat')); % temporary edit, since we're using the high contrast data and exptDesign file is located in that subfolder.
load(fullfile(loadLoc, ['bestLocC2'   quadType])); %variable in workspace called 'bestLoc'
load(fullfile(loadLoc, ['bestBandsC2' quadType])); %variable in workspace called 'bestBands'

%% ADJUST THE BEST LOC VALUES BASED ON RESIZING DONE AT C2 CALCULATION
% The code below was taken out to the parent code CUR_genLoc.m

% % ySizeOrig and xSizeOrig are dimensions of images that were presented to
% % subjects during psychophysical experiments. All the face-location data
% % given by Florence is relative to these dimensions. 
% % load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\upright\data\patchSetAdam\lfwSingle50000\sandbox\dimensions.mat');
% % load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_2nd_cohort\upright\data\patchSetAdam\lfwSingle50000\sandbox\dimensions.mat');
% 
% % Predefine the variables
% dimsOrig       = zeros(length(facesLoc{1}),2);
% dimsResized    = zeros(length(facesLoc{1}),2);
% scalingFactors = zeros(1,length(facesLoc{1}));
% 
% for iImg = 1:nImgsAnalyzed %length(facesLoc{1})
% %     if mod(iImg,100) == 0
% %         display(['Calculating scaling factors. iImg = ' int2str(iImg)]);
% %     end
%     dimsOrig   (iImg,1:2) = size(imread(facesLoc{1}{iImg}));
%     % These are the dimensions of images pushed through HMAX.
%     dimsResized(iImg,1:2) = size(resizeImage(imread(facesLoc{1}{iImg}),maxSize));
% 
%     % Now obtain the scaling factor for bestLoc variables, so they can be
%     % transformed to be relative to dimensions of the images seen by subjects.
%     % Then they can be compared to face location values.
%     scalingFactors(iImg) = dimsOrig(iImg,1)/dimsResized(iImg,1);
%     assert(isequal(round(scalingFactors(iImg),2),round(dimsOrig(iImg,2)/dimsResized(iImg,2),2)),'somethings not right with image resizing');
% end
%% SEE IF C2 COMES FROM THE WEDGE OR FACE BOX.
if iscell(bestBands)
    bestBands = horzcat(bestBands{:});
    bestLoc   = horzcat(bestLoc{:});
end

imgHitsWedgePatchLoop   = zeros(nPatchesPerLoop,nImgsAnalyzed);
imgHitsFaceBoxPatchLoop = zeros(nPatchesPerLoop,nImgsAnalyzed);
angularDistPatchLoopRad = zeros(nPatchesPerLoop,nImgsAnalyzed);
angularDistPatchLoopDeg = zeros(nPatchesPerLoop,nImgsAnalyzed);


% tic;

% Get the img # in the facesLoc file.
% Typically facesLoc file should be sorted. So img # corresponds to its
% location in the facesLoc file. Check that this condition holds, then
% proceed.
% Sort the facesLoc file using natural sorting. The output indices
% should just be progression from 1 to the maximum number of images.

[~,idx_sorted_facesLoc] = sort_nat(facesLoc{1});
assert(isequal(idx_sorted_facesLoc',1:size(facesLoc{1},1)),'getting imaged indices for localization are messed up');
imgFacesLoc = idx_sorted_facesLoc;
% sanityCheckPatchLoop.imgFacesLoc = imgFacesLoc;

% Predefine by how much should the bestLoc values be shifted to get the top
% left and bottom right corners of the C1 area that contributed to the C2
% value. This will depend on the patchSize. 

patchRows = patchSizes(1,1);
patchCols = patchSizes(2,1);

rows_shift_topLeft     = floor((patchRows-1)/2); 
% Take the row value in bestLoc, shift it to the left by this amount.  You get the top left     row coordinate of the C1 area contributing to the C2 value.
rows_shift_bottomRight = patchRows -1 - rows_shift_topLeft;
% Take the row value in bestLoc, shift it to the right by this amount. You get the bottom right row coordinate of the C1 area contributing to the C2 value.


cols_shift_topLeft     = floor((patchCols-1)/2);
% Take the column value in bestLoc, shift it up by this amount.   You get the top left     column coordinate of the C1 area contributing to the C2 value.
cols_shift_bottomRight = patchCols -1 - cols_shift_topLeft;
% Take the column value in bestLoc, shift it down by this amount. You get the bottom right column coordinate of the C1 area contributing to the C2 value.


for iPatch = 1:nPatchesPerLoop 
%     fprintf('STARTING W CUSTOM PATCH!!')
%     if mod(iPatch,500) == 0
%         idxPatchStart+iPatch-1
%     end
    for iImg = 1:nImgsAnalyzed %size(bestBands,2) 
%         fprintf('STARTING W CUSTOM IMAGE!!')
        
        ySizeOrig    = dimsOrig   (iImg,1);
        xSizeOrig    = dimsOrig   (iImg,2);
        ySizeResized = dimsResized(iImg,1);
        xSizeResized = dimsResized(iImg,2);
        
        band = bestBands(idxPatchStart+iPatch-1, iImg);
        y1   = bestLoc  (idxPatchStart+iPatch-1, iImg, 1); % y1 is the ROW    coordinate of top-left corner.
        y1   = y1 - rows_shift_topLeft;   
        
        x1   = bestLoc(idxPatchStart+iPatch-1, iImg, 2); % x1 is the COLUMN coordinate of the top-left corner.
        x1   = x1 - cols_shift_topLeft;
        
        y2   = y1 + patchRows - 1;  % y2 is the ROW    coordinate of the bottom-right corner.
        x2   = x1 + patchCols - 1; % x2 is the COLUMN coordinate of the bottom-right corner.
        
        % Get pixel coordinates of the C1 representation
        [x1p, x2p, y1p, y2p] = patchDimensionsInPixelSpace(band, x1, x2, y1, y2, c1Scale, c1Space, rfSizes, double(xSizeResized), double(ySizeResized));
        assert((x1p <= x2p || y1p <= y2p), 'X or Y inversion occurred!!'); 
        % Define the area around the face location to record a hit.
        if ySizeOrig == 730 || ySizeOrig == 726
            radius = 50;
        elseif ySizeOrig == 1086
            radius = 74; %1086*50/730=74.38
        elseif ySizeOrig == 1094
            radius = 75; %1094*50/730=74.93
        elseif ySizeOrig == 600 % These are the dimensions from Jacob's image set.
            radius = 41; %600*50/730
        else
            error('Image size isn''t right')
        end
        
        faceBoxOrig = [exptDesign(imgFacesLoc(iImg)).position(2)-radius ...
                       exptDesign(imgFacesLoc(iImg)).position(2)+radius ...
                       exptDesign(imgFacesLoc(iImg)).position(1)-radius ...
                       exptDesign(imgFacesLoc(iImg)).position(1)+radius]; %[x1 x2 y1 y2]
                       % x1 is the leftmost coordinate of the box.
                       % x2 is the rightmost coordinate of the box.
                       % y1 is the topmost.
                       % y2 is the bottommost.
        % Rescale faceBox coordinates to be relative to resized
        % image dimensions, so patch pixel coordinates can be
        % compared to it.
        faceBoxResized = faceBoxOrig/scalingFactors(iImg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Draw images for visualizing everything.
% annulusImgToShow = facesLoc{1}{iImg};
% visualize = visualizeLocations(ySizeOrig,xSizeOrig,scalingFactors(iImg),faceBoxOrig,x1p,x2p,y1p,y2p,annulusImgToShow);
% sanityCheckPatchLoop.visualizePositions{iPatch,iImg} = visualize;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    if y2p > faceBoxResized(3) && y1p < faceBoxResized(4) && x1p < faceBoxResized(2) && x2p > faceBoxResized(1) 
       %if best match is within where the face is.
        imgHitsFaceBoxPatchLoop(iPatch,iImg) = 1;
%         imwrite(uint8(visualize),fullfile(saveLoc,['responseOverlays/hits/patch'   int2str(iPatch) '_face' int2str(iImg) '.png']));
    else
%         imwrite(uint8(visualize),fullfile(saveLoc,['responseOverlays/misses/patch' int2str(iPatch) '_face' int2str(iImg) '.png']));
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NOW CHECK THE WEDGE LOCALIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the center of the C2 location.
ctrCol = x1p + (x2p-x1p)/2;
ctrRow = y1p + (y2p-y1p)/2;
% Due to image resizing, adjust the ctrCol and ctrRow to be relative to the
% dimensions of the images presented to subjects.
ctrCol = ctrCol * scalingFactors(iImg);
ctrRow = ctrRow * scalingFactors(iImg);

% Trasform the center coordinates into cartesian ones
ctrCartX = ctrCol - xSizeOrig/2; % X coordinate
ctrCartY = ySizeOrig/2 - ctrRow; % Y coordinate

% Get the polar angle of the center of the C2 location.
[c2_loc_rad, ~] = cart2pol(ctrCartX,ctrCartY);

face_loc_deg = exptDesign(imgFacesLoc(iImg)).positionAngle;
face_loc_rad = deg2rad(face_loc_deg);

% Check in radians
dist_in_rad1 = abs(angleDiff(c2_loc_rad,face_loc_rad));
dist_in_deg1 = rad2deg(dist_in_rad1);

% The code below was commented out. Using criterionInDeg = 45 was wrong and
% I had kept it just in case. But with the random pasting location of the
% faces in Jacob's backgrounds, angle calculation was giving me error. We
% don't need angle distances for training the patches on Jacob's set of
% images. We only need the facebox performance.

% criterionInDeg = 45; % I left this in the old code, even though this is wrong. I just wanted to compare the correct results with what would have been with the incorrect one. 
% criterionInRad = deg2rad(criterionInDeg);
% 
% % Double check with another script
% dist_in_deg2 = angdiffdeg(rad2deg(c2_loc_rad),face_loc_deg);
% dist_in_rad2 = deg2rad(dist_in_deg2);
% 
% if dist_in_rad1 < criterionInRad
%     assert(dist_in_deg2 <= criterionInDeg,'The two ways of calculating the angles differ')
%     imgHitsWedgePatchLoop(iPatch,iImg) = 1;
% end
% if dist_in_deg2 <= criterionInDeg
%     assert(imgHitsWedgePatchLoop(iPatch,iImg) == 1,'The two ways of calculating the angles differ')
% end

angularDistPatchLoopRad(iPatch,iImg) = dist_in_rad1;
angularDistPatchLoopDeg(iPatch,iImg) = dist_in_deg1;

    end % iImg loop
end % iPatch loop

%% Save variables
save(fullfile(saveLoc,['angularDistRad_'   int2str(idxPatchStart) '-' int2str(idxPatchEnd) '_allImages']),'angularDistPatchLoopRad');
save(fullfile(saveLoc,['angularDistDeg_'   int2str(idxPatchStart) '-' int2str(idxPatchEnd) '_allImages']),'angularDistPatchLoopDeg');

% save(fullfile(saveLoc,['imgHitsWedgeOld_'  int2str(idxPatchStart) '-' int2str(idxPatchEnd) '_allImages']),'imgHitsWedgePatchLoop');
save(fullfile(saveLoc,['imgHitsFaceBox_'   int2str(idxPatchStart) '-' int2str(idxPatchEnd) '_allImages']),'imgHitsFaceBoxPatchLoop');
% save(fullfile(saveLoc,['sanityCheck_'    int2str(idxPatchStart) '-' int2str(idxPatchEnd) '_allImages']),   'sanityCheckPatchLoop');

%% call the image difficulty code?
% if runImgDiff == 1
%    display('making the image difficulty maps...\n');
%    CUR_imageDifficultyMapWedgeLocalization  ('SINGLES','f', saveFolder,0);
%    CUR_imageDifficultyMapFaceBoxLocalization('SINGLES','f', saveFolder,0);
% end


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
    
    % Make the center of the patch a white square.
    visualize(round(y1pOrig+((y2pOrig-y1pOrig)/2)-3):...
              round(y2pOrig-((y2pOrig-y1pOrig)/2)+3),...
              round(x1pOrig+((x2pOrig-x1pOrig)/2)-3):...
              round(x2pOrig-((x2pOrig-x1pOrig)/2)+3)) = 128;
    
    % Reduce the dimensions of visualize so it doesn't take much space.
    visualize = imresize(visualize,0.3);
          
    % If want to see the patch in whole image.
%     figure;
%     subplot(1,2,1)
%     imshow(uint8(visualize))
%     subplot(1,2,2)
%     imshow(uint8(imread(annulusImgToShow)));

%     % If want to see just the face box and compare to how HMAX saw it.
%     visualize = visualize(faceBoxOrig(3):faceBoxOrig(4),faceBoxOrig(1):faceBoxOrig(2));
%     figure
%     subplot(2,1,1)
%     imshow(uint8(visualize))
%     visualize = imresize(visualize,0.5); % Downsampled to save space.
%     
%     % Now visualize as HMAX saw it
%     visualizeHMAX = resizeImage(double(imread(annulusImgToShow)),1067);
%     faceBoxResized = round(faceBoxOrig/imgScalingFactor);
%     visualizeHMAX = visualizeHMAX(faceBoxResized(3):faceBoxResized(4),faceBoxResized(1):faceBoxResized(2));
%     subplot(2,1,2)
%     imshow(uint8(visualizeHMAX))

end
        
        