% This script will paste Jacob's face images into Jacob's bg images.
% It will paste them in the same location, except if luminance equalization
% produces a ghost face.

clear; clc; dbstop if error;

humanaeLoc = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM';
home       = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation4';

load(fullfile(home,'crossValidInfo.mat'));

condition = 'testing'

if strcmp(condition,'training')
    bgPaths   = crossValidInfo.trainingBgs;
    facePaths = crossValidInfo.trainingFaces;
elseif strcmp(condition,'testing')
    bgPaths   = crossValidInfo.testingBgs;
    facePaths = crossValidInfo.testingFaces;
else
    error('Wrong condition');
end
maskPaths = lsDir(fullfile(humanaeLoc,'HumanaeFaces5Processed','Mask'),{'jpg'});
locPaths  = lsDir(fullfile(humanaeLoc,'HumanaeFaces5Processed','locations'),{'mat'});

resizeDims = 50*766/500; % Jacob's face images are about 766 pixels, but the face itself is about 500.
% To resize the image so that the face is 50 pixels, the image must be
% resized to 50*766/500 = 76.6.
resizeBg   = 600;
exampleBg = imread(bgPaths{1});
exampleBg = imresize(exampleBg,resizeBg/size(exampleBg,1));
bgDims = size(exampleBg);

% For each face, paste it in a randomly chosen bg.
bgForEachFace = repmat(1:length(bgPaths),1,20); % Generate a vector of indices for bgs.
randomizeBgs  = randperm(length(bgForEachFace)); % shuffle the vector.
bgForEachFace = bgForEachFace(randomizeBgs);     % shuffle the vector.
bgForEachFace = bgForEachFace(1:length(facePaths)); % shorten the vector to the number of face imgs.

parfor iFace = 1:length(facePaths);
    iFace
    [~,faceFileName,faceExt] = fileparts(facePaths{iFace});
    [~,bgFileName,bgExt]     = fileparts(bgPaths{bgForEachFace(iFace)});
    
    % Find idx of the mask corresponding to the face.
    idx_mask = find(ismember(maskPaths,...
        fullfile(humanaeLoc,'HumanaeFaces5Processed','Mask',[faceFileName '.jpg'])));
    % Find idx of the location file corresponding to the face.
    idx_loc  = find(ismember(locPaths,...
        fullfile(humanaeLoc,'HumanaeFaces5Processed','locations',[faceFileName '.jpg.mat'])));
    
    % Load bg, face, and mask, and facepositions
    bg      = grayImage(imread(bgPaths{bgForEachFace(iFace)}))/255;
    bg      = imresize(bg,resizeBg/size(bg,1)); % rescale the bg so its not too large. Simulations will run faster.
    faceImg = grayImage(imread(facePaths{iFace}))/255;
    maskImg = grayImage(imread(maskPaths{idx_mask}));
    facepoints = load(locPaths{idx_loc});
    facepoints = facepoints.facepoints;
    % imshow(uint8(bg));
    
    % Resize the face image and mask.
    faceImg = imresize(faceImg,resizeDims/size(faceImg,1));
    maskImg = imresize(maskImg,resizeDims/size(maskImg,1));
    assert(isequal(size(faceImg),size(maskImg)) == 1,'resized dimensions of face and mask don''t match');
    
%     % Choose the location to paste the face at.
%     pasteLocation(1) = randi([size(faceImg,1) size(bg,1) - size(faceImg,1)],1);
%     pasteLocation(2) = randi([size(faceImg,2) size(bg,2) - size(faceImg,2)],1);
%     
%     % Stretch histogram of face image so luminances match
%     bgPatch = bg(pasteLocation(1) - ceil (size(faceImg,1)/2):  ...
%                  pasteLocation(1) + floor(size(faceImg,1)/2)-1,...
%                  pasteLocation(2) - ceil (size(faceImg,2)/2):  ...
%                  pasteLocation(2) + floor(size(faceImg,2)/2)-1);
% 
%     faceImg_norm = stretch_histogram(faceImg,bgPatch);
% 
%     % Check that its not a ghost face
%     face_michelson = (max(faceImg_norm(:)) - min(faceImg_norm(:)))/...
%                      (max(faceImg_norm(:)) + min(faceImg_norm(:)));
    
    pasteLocation = [];
    face_michelson = 0;
    while face_michelson < 0.3 || isempty(pasteLocation)
        pasteLocation(1) = randi([size(faceImg,1) size(bg,1) - size(faceImg,1)],1);
        pasteLocation(2) = randi([size(faceImg,2) size(bg,2) - size(faceImg,2)],1);

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
    
    % create exptDesign file
    exptDesign(iFace).faceImg       = faceImg_norm;
    exptDesign(iFace).faceName      = faceFileName;
    exptDesign(iFace).bgName        = bgFileName;
    exptDesign(iFace).position      = pasteLocation;
    exptDesign(iFace).positionAngle = angle_deg;
    exptDesign(iFace).mask          = maskImg;
    exptDesign(iFace).imageDim      = bgDims;
    exptDesign(iFace).michelson     = face_michelson;
    
    imwrite(pastedBg,fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation4',condition,'images',...
        ['img' int2str(iFace) '__' faceFileName '__' bgFileName '.png']));
    
end

%% save necessary files
save(fullfile(home,condition,'exptDesign.mat'),'exptDesign');