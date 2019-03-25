% Simulation 7 script

% This script will paste do the following:
% - Take Florence's original bgs used in experiment.
% - Black out the annulus in those images.
% - Paste 116 well-segmented faces from Jabob's face set into these bgs,
% making sure they're pasted outside of the annulus locations.
% - Blur the blacked out annulus edges.

% Jacobs faces will be resized to be 78 pixels in height, being pasted in
% the 730x927 bg images. This will match exactly the psych experiment. The
% final pasted images should be resized to maxSize 579 as was done for
% analyzing the psych experiment images.
clear; clc; dbstop if error;

simulation = 'simulation7';
bgLoc      = 'C:\Users\levan\HMAX\annulusExptFixedContrast\bgs_used_in_psych\Florence_bgs_indexed_resized';
humanaeLoc = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM';
home       = fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\',simulation);
facesLoc   = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\faces';

condition = 'training';

% Clear the images folder
delete([fullfile(home,condition,'images') '\*']);

% maskPaths = lsDir(fullfile(humanaeLoc,'HumanaeFaces5Processed','Mask'),{'jpg'});
maskPaths = lsDir(fullfile(humanaeLoc,'HumanaeFaces5Processed','new_gimp_masks_final','both_genders'),{'png'});
locPaths  = lsDir(fullfile(humanaeLoc,'HumanaeFaces5Processed','locations'),{'mat'});

bgPaths = sort_nat(lsDir(bgLoc,{'png'})');

targetFaceSize = 78; % So actual face height will be 78 pixels. See below for explanations.

% resizeBg   = 600;
exampleBg = imread(bgPaths{1});
% exampleBg = imresize(exampleBg,resizeBg/size(exampleBg,1));
bgDims = size(exampleBg);

% Make the paths to face images from the paths to mask images
[~,faceNames,ext]  = cellfun(@fileparts,maskPaths , 'UniformOutput',false);
facePaths = cellfun(@(S) fullfile(facesLoc, S), faceNames, 'Uniform', 0);
faceNames = faceNames';
facePaths = facePaths';

nImgsToGenerate = 1000;

facePaths = repmat(facePaths(:),10,1);
facePaths = facePaths(1:nImgsToGenerate);

bgPaths   = repmat(bgPaths(:),30,1);
bgPaths   = bgPaths(1:nImgsToGenerate);
% randomize the bgs now
randomizeBgs = randperm(nImgsToGenerate);
bgPaths = bgPaths(randomizeBgs);

%% Create the coordinates of the annulus
% Make the annulus
rows    = bgDims(1);
columns = bgDims(2);
% Create an image
[columnsInImage,rowsInImage] = meshgrid(1:columns, 1:rows);
% Next create the inner and outer circles in the center of the image.
centerX = round(columns/2);
centerY = round(rows/2);

blurDiameter = 10;
maxFaceImgSize = 120;
avoidOverlap = sqrt(2*((maxFaceImgSize/2)^2));

% Create a safety annulus, used to avoid overlap between face and annulus
innerRad = 232 - blurDiameter/2 - avoidOverlap; % 232 matches the blurAnnulusEdges.m script values
outerRad = 333 + blurDiameter/2 + avoidOverlap; % 333 matches the blurAnnulusEdges.m script values
outerCircle = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= outerRad.^2;
innerCircle = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 > innerRad.^2;
annulus_safety = outerCircle .* innerCircle; % This defines annulus, with 1 in annulus idxs and 0 elsewhere.
annulus_safety = ~annulus_safety; % This reverses annulus.
% imshow(annulus);
annulusIdxs = find(annulus_safety(:) == 1);

% Create the actual annulus that will be multiplied with the image.
innerRad = 232;
outerRad = 333;
outerCircle = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= outerRad.^2;
innerCircle = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 > innerRad.^2;
annulus = outerCircle .* innerCircle; % This defines annulus, with 1 in annulus idxs and 0 elsewhere.
annulus = ~annulus; % This reverses annulus.

%% Start main loop
parfor iFace = 1:length(facePaths);
%     display('Parfor is off!!!!');
    iFace
    [~,faceFileName,faceExt] = fileparts(facePaths{iFace});
    [~,bgFileName,bgExt]     = fileparts(bgPaths{iFace});
    
    % Find idx of the mask corresponding to the face.
    idx_mask = find(ismember(maskPaths,...
        fullfile(humanaeLoc,'HumanaeFaces5Processed','new_gimp_masks_final','both_genders',[faceFileName '.png'])));
    % Find idx of the location file corresponding to the face.
    idx_loc  = find(ismember(locPaths,...
        fullfile(humanaeLoc,'HumanaeFaces5Processed','locations',[faceFileName '.jpg.mat'])));
    
    % Load bg, face, and mask, and facepositions
    bg      = grayImage(imread(bgPaths{iFace}))/255;
%     bg      = imresize(bg,resizeBg/size(bg,1)); % rescale the bg so its not too large. Simulations will run faster.
    faceImg = grayImage(imread([facePaths{iFace} '.jpg']))/255;
    maskImg = grayImage(imread(maskPaths{idx_mask}));
    facepoints = load(locPaths{idx_loc});
    facepoints = facepoints.facepoints;
    % imshow(uint8(bg));
    
    % Calculate resizeDims variable based on actual size of the face as
    % measured by Jacob with his facepoints variables. This takes the
    % headtop coordinate vs the chin coordinate to get the height of the
    % face.
    faceHeight = facepoints.chin(2) - facepoints.headtop(2);
    % To resize the actual face to 80 pixels, how much should you resize
    % the whole image? 
    % imageSize       -> faceHeight
    % targetImageSize -> targetFaceSize
    % So targetImageSize = imageSize*targetFaceSize/faceHeight
    targetImageSize = targetFaceSize * size(faceImg,1) / faceHeight;
    
    % Resize the face image and mask.
%     imtool close all
%     imtool(faceImg);
    faceImg = imresize(faceImg,[targetImageSize NaN]);
%     imtool(faceImg);
    maskImg = imresize(maskImg,[targetImageSize NaN]);
%     imtool(maskImg);
    assert(isequal(size(faceImg),size(maskImg)) == 1,'resized dimensions of face and mask don''t match');
    
    % Choose the location to paste the face at.
    pasteLocation = [];
    face_michelson = 0;
    overlappingCoords = 1; % becomes zero when none of the faces coordinates will overlap with annulus coordinate.
    while face_michelson < 0.3 || isempty(pasteLocation) || overlappingCoords
        pasteLocation(1) = randi([size(faceImg,1) size(bg,1) - size(faceImg,1)],1);
        pasteLocation(2) = randi([size(faceImg,2) size(bg,2) - size(faceImg,2)],1);

        % Make sure face doesn't overlap with the annulus. 
        overlappingCoords = ~annulus_safety(pasteLocation(1),pasteLocation(2));
        
        bgPatch = bg(pasteLocation(1) - ceil (size(faceImg,1)/2):  ...
                     pasteLocation(1) + floor(size(faceImg,1)/2)-1,...
                     pasteLocation(2) - ceil (size(faceImg,2)/2):  ...
                     pasteLocation(2) + floor(size(faceImg,2)/2)-1);        

        faceImg_norm = stretch_histogram(faceImg,bgPatch);
        
        face_michelson = (max(faceImg_norm(:)) - min(faceImg_norm(:)))/...
                         (max(faceImg_norm(:)) + min(faceImg_norm(:)));
    end
    
    % Get the polar angle of the location where face will be pasted.
    cartX = pasteLocation(2) - size(bg,2)/2;
    cartY = size(bg,1)/2 - pasteLocation(1);
    [THETA,RHO] = cart2pol(cartX,cartY);
    angle_deg = rad2deg(THETA);
    if angle_deg <= 0
        angle_deg = 360 + angle_deg;
    end
    
    % Sanity check
    assert(isequal(size(faceImg),size(bgPatch)),'bgPatch and faceImg sizes don''t match');
    
    %     imshow(faceImg);
    %     figure
    %     imshow(faceImg_norm);
    
    pastedBg = bg;
    for iCol = 1:size(faceImg,2)
        %         iCol
        for iRow = 1:size(faceImg,1)
            if maskImg(iRow,iCol) > 50
                % taking the ceil of the faceImg dimension might be a
                % problem, but should lead to an error of utmost 1 pixel
                % not being pasted in.
                pastedBg(pasteLocation(1) - ceil(size(faceImg,1)/2) + iRow,...
                         pasteLocation(2) - ceil(size(faceImg,2)/2) + iCol) = ...
                         faceImg_norm(iRow,iCol);
            end
        end
    end
    %     figure
    %     imshow(pastedBg);
    
    % Annulize the image
    pastedBg_annulized = pastedBg .* annulus;
    idx_annulus = find(annulus(:) == 0);
    pastedBg_annulized(idx_annulus) = 128/255; % makes the annulus gray
    
%     pastedBg_annulized_safety = pastedBg .* annulus_safety;
%     imshow(pastedBg_annulized);
%     figure
%     imshow(pastedBg_annulized_safety);

    % Blur the edges of the annulus
    pastedBg_annulized_blurred = blurAnnulusEdges(pastedBg_annulized,blurDiameter/2);
%     close all
%     imshow(pastedBg_annulized);
%     figure
%     imshow(pastedBg_annulized_blurred);
    
    % create exptDesign file
    exptDesign(iFace).faceImg       = faceImg_norm;
    exptDesign(iFace).faceName      = faceFileName;
    exptDesign(iFace).bgName        = bgFileName;
    exptDesign(iFace).position      = pasteLocation;
    exptDesign(iFace).positionAngle = angle_deg;
    exptDesign(iFace).mask          = maskImg;
    exptDesign(iFace).imageDim      = bgDims;
    exptDesign(iFace).michelson     = face_michelson;
    exptDesign(iFace).annulusMask   = annulus;
    
    imwrite(pastedBg_annulized_blurred,fullfile(home,condition,'images',...
        ['img' int2str(iFace) '__' faceFileName '__' bgFileName '.png']));
    
end

%% save necessary files
save(fullfile(home,condition,'exptDesign.mat'),'exptDesign');