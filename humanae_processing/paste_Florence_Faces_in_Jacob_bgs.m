% This is an adaptation of pasteHumanaeFaces.m
% This script will use Florence's faces and Jacob's bgs to paste the faces
% in the bgs. This was used to evaluate HMAX on such images and see if
% performance would be comparable to Florence's faces pasted in Florence's
% backgrounds. 

% Used for simulation4

clear; clc; dbstop if error; close all;

home    = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation4';
faceLoc = 'C:\Users\levan\HMAX\annulusExptFixedContrast\face_images_from_Florence';
condition = 'control_v3';


bgPaths   = lsDir(fullfile(home,'control_v2','annulizedImages_730x927'),{'png'});
bgPaths   = horzcat(bgPaths,bgPaths); % make it twice as large, so each bg repeats twice.
facePaths = lsDir(fullfile(faceLoc,'used_in_psych_cropped'),{'png'});
maskPaths = lsDir(fullfile(faceLoc,'MaskToKeep_cropped'),{'jpg'});

nImgsGenerated = length(bgPaths);
maxSizeFace    = 81;
annulusRadius  = 284; % pixels

% For each bg, choose a face randomly to paste it in it.
faceForEachBg  = repmat(1:length(facePaths),1,20); % Generate a vector of indices for bgs.
randomizeFaces = randperm(length(faceForEachBg)); % shuffle the vector.
faceForEachBg  = faceForEachBg(randomizeFaces);     % shuffle the vector.
faceForEachBg  = faceForEachBg(1:nImgsGenerated); % shorten the vector to the number of face imgs.

% Define the circle along which to paste the face.
exampleBg = imread(bgPaths{1});
bgDims    = size(exampleBg);
theta = 0 : 0.01: 2*pi;
xCenter = size(exampleBg,2)/2;
yCenter = size(exampleBg,1)/2;
xValues = round(annulusRadius * cos(theta) + xCenter);
yValues = round(yCenter - annulusRadius * sin(theta));

% plot(xValues,yValues);
imgCounter = 1;
sanity = [];

for iImg = 1:nImgsGenerated
    iImg
    [~,faceFileName,faceExt] = fileparts(facePaths{faceForEachBg(iImg)});
    [~,bgFileName,bgExt]     = fileparts(bgPaths{iImg});
    
    % Find idx of the mask corresponding to the face.
%     idx_mask = find(ismember(maskPaths,...
%         fullfile(humanaeLoc,'HumanaeFaces5Processed','Mask',[faceFileName '.jpg'])));
%     
    % Load bg, face, and mask, and facepositions
%     bg      = grayImage(imread(bgPaths{faceForEachBg(iImg)}))/255;
%     bg      = imresize(bg,resizeBg/size(bg,1)); % rescale the bg so its not too large. Simulations will run faster.
%     faceImg = grayImage(imread(facePaths{iImg}))/255;
%     maskImg = grayImage(imread(maskPaths{idx_mask}));

    bg      = grayImage(imread(bgPaths{iImg}))/255;
    faceImg = grayImage(imread(facePaths{faceForEachBg(iImg)}))/255;
    maskImg = grayImage(imread(fullfile(faceLoc,'MaskToKeep_cropped',[faceFileName '.png'])));
    
    faceImg = resizeImage(faceImg,maxSizeFace);
    maskImg = resizeImage(maskImg,maxSizeFace);
    assert(isequal(size(faceImg),size(maskImg)) == 1,'resized dimensions of face and mask don''t match');    
   
    % Choose location to paste the face in.
    permLocs = randperm(length(xValues)); % generate random indices for choosing xValues and yValues for pasting the face.
    for iLoc = 1:length(permLocs)
        pasteLocation = [yValues(permLocs(iLoc)) xValues(permLocs(iLoc)) ];
    
        bgPatch = bg(pasteLocation(1) - ceil (size(faceImg,1)/2):  ...
                     pasteLocation(1) + floor(size(faceImg,1)/2)-1,...
                     pasteLocation(2) - ceil (size(faceImg,2)/2):  ...
                     pasteLocation(2) + floor(size(faceImg,2)/2)-1);
        
        faceImg_norm = stretch_histogram(faceImg,bgPatch);
        
        face_michelson = (max(faceImg_norm(:)) - min(faceImg_norm(:)))/...
                         (max(faceImg_norm(:)) + min(faceImg_norm(:)));
        if face_michelson > 0.05
            break
        end
    end
    
    % If some location gave a good contrast value paste the face. Otherwise
    % go to the next background.
    if face_michelson > 0.05
    
        % Get the polar angle of the location where face will be pasted.
        cartX = pasteLocation(2) - xCenter;
        cartY = yCenter - pasteLocation(1);
        [THETA,RHO] = cart2pol(cartX,cartY);
        angle_deg = rad2deg(THETA);
        THETA(THETA < 0) = THETA(THETA < 0) + 2*pi; % just to have them all positive.
        if angle_deg <= 0
            angle_deg = 360 + angle_deg;
        end
        
        % Sanity check
        assert(isequal(size(faceImg),size(bgPatch)),'bgPatch and faceImg sizes don''t match');
%         sanity(1:2,imgCounter) = [THETA; theta(permLocs(iLoc))];
        assert(isequal(round(THETA,2),round(theta(permLocs(iLoc)),2)),'The angle location for pasting is messed up');
        
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
%             figure
%             imshow(pastedBg);
        
        % create exptDesign file
        exptDesign(imgCounter).faceImg       = faceImg_norm;
        exptDesign(imgCounter).faceName      = faceFileName;
        exptDesign(imgCounter).bgName        = bgFileName;
        exptDesign(imgCounter).position      = pasteLocation;
        exptDesign(imgCounter).positionAngle = angle_deg;
        exptDesign(imgCounter).mask          = maskImg;
        exptDesign(imgCounter).imageDim      = bgDims;
        exptDesign(imgCounter).michelson     = face_michelson;
%         
%             imwrite(pastedBg,fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation4',condition,'images',...
%                 ['img' int2str(imgCounter) '__' faceFileName '__' bgFileName '.png']));
        
        imgCounter = imgCounter + 1;
    else % if contrast is good loop.
        badBg{1} = bgPaths{iImg};
    end
end

%% save necessary files
save(fullfile(home,condition,'exptDesign.mat'),'exptDesign');