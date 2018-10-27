%% Get faces from ExptDesign
clear; clc; dbstop if error;

home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation6\training';

if ~exist(fullfile(home,'face_images'))
    mkdir(fullfile(home,'face_images'));
end

load(fullfile(home,'exptDesign.mat'));

faceNames = {exptDesign(:).faceName}';
[faceNames_unique,ia,ic] = unique(faceNames);

for iImg = 1:length(ia)
    imwrite(exptDesign(ia(iImg)).faceImg,fullfile(home,'face_images',[faceNames_unique{iImg} '.png']));
end

%% Create Florence_bgs_indexed
clear; clc; dbstop if error;

home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\bgs_used_in_psych';

saveLoc = fullfile(home,'Florence_bgs_indexed_resized');
origBgLoc = 'C:\Users\levan\HMAX\annulusExptFixedContrast\bgs_used_in_psych\AllBackgrounds';

bgPaths = sort_nat(lsDir(fullfile(home,'Florence_bgs_annulized_indexed'),{'png'}))';

[~,bgNames,ext]  = cellfun(@fileparts,bgPaths , 'UniformOutput',false);

for iBg = 1:length(bgNames)
    key = '__';
    C = strsplit(bgNames{iBg},key);
    origNames{iBg,1} = [C{2}  '.jpg'];
    
    iBgImg = imresize(imread(fullfile(origBgLoc,origNames{iBg})),[730,927]);
    imwrite(iBgImg,fullfile(saveLoc,[int2str(iBg) '__' C{2} '.png']));
    
end

%% Find Florences bgs and matching annulized bgs with their original names.
clear; clc; dbstop if error;

home = 'C:\Users\levan\Desktop\bgs_used_in_psych';
% saveLoc = fullfile(home,'AllBackgrounds_resized_annulized');
% Now, go 1 by 1 through Florence's bg images and find the matching ones
% from our images.
florence_bgs = lsDir(fullfile(home,'FlorenceBackgrounds_annulized'),{'png'});
all_bgs = lsDir(fullfile(home,'AllBackgrounds_resized_annulized'),{'png'});

florence_bgs = sort_nat(florence_bgs);

diff_mat = [];

for iFlo = 11 %:length(florence_bgs)
    iFlo
    iFloImg = imread(florence_bgs{iFlo});
    
    for iBg = 1:length(all_bgs)
        iBgImg = imread(all_bgs{iBg});
        
        diff_mat(iFlo,iBg) = sum(iFloImg(:)) - sum(iBgImg(:));
        
    end
    
    % Find closest
%     [minValue,matchingIdx] = min(abs(diff_mat(iFlo,:)));
    [sorted,idxs] = sort(abs(diff_mat(iFlo,:)),'ascend');
    figure
    subplot(2,3,1)
    imshow(florence_bgs{iFlo});
    title(int2str(iFlo));
    
    subplot(2,3,2)
    imshow(all_bgs{idxs(1)});
    title(int2str(idxs(1)));
    
    subplot(2,3,3)
    imshow(all_bgs{idxs(2)});
    title(int2str(idxs(2)));
    
    subplot(2,3,4)
    imshow(all_bgs{idxs(3)});
    title(int2str(idxs(3)));
    
    subplot(2,3,5)    
    imshow(all_bgs{idxs(4)});
    title(int2str(idxs(4)));
    
    subplot(2,3,6)
    imshow(all_bgs{idxs(5)});
    title(int2str(idxs(5)));
    
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
end
%%
clear; clc; close all;

home = 'C:\Users\levan\Desktop\bgs_used_in_psych';
florence_bgs = lsDir(fullfile(home,'FlorenceBackgrounds_annulized'),{'png'})';
all_bgs = lsDir(fullfile(home,'AllBackgrounds_resized_annulized'),{'png'});

corrIdxs = [2,78,3,5,6,7,12,35,41,42,49,50,3,14,16,23,25,31,33,40,45,47,55,48,56,57,58,60,61,65,67,68,80,62,83,84,89,91,92,93,95,100,63,72,73,74,75]';

[S,INDEX] = sort_nat(florence_bgs);
corrIdxs_resorted = corrIdxs(INDEX);

for iBg = 1:length(corrIdxs_resorted)
    iBgImg = imread(all_bgs{corrIdxs_resorted(iBg)});
    [path,name,ext] = fileparts(all_bgs{corrIdxs_resorted(iBg)});
    
%     imwrite(iBgImg,fullfile(home,'test',[int2str(iBg) '__' name '.png']));
    
    figure
    subplot(1,2,1)
    imshow(S{iBg});
    
    subplot(1,2,2)
    imshow(iBgImg);
end
    
    

%% Annulize bgs
clear; clc; dbstop if error;

home = 'C:\Users\levan\Desktop\bgs_used_in_psych';
saveLoc = fullfile(home,'AllBackgrounds_resized_annulized');

if ~exist(saveLoc)
    mkdir(saveLoc)
end

all_bgs = lsDir(fullfile(home,'AllBackgrounds'),{'jpg'});

targetDims = [730,927];

% Make the annulus
rows    = targetDims(1);
columns = targetDims(2);
% Create an image
[columnsInImage,rowsInImage] = meshgrid(1:columns, 1:rows);
% Next create the inner and outer circles in the center of the image.
centerX = round(columns/2);
centerY = round(rows/2);
innerRad = 231;
outerRad = 332;

outerCircle = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= outerRad.^2;
innerCircle = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 > innerRad.^2;

annulus = outerCircle .* innerCircle; % This defines annulus, with 1 in annulus idxs and 0 elsewhere.

% Start anulizing images.

for iBg = 1:length(all_bgs)
    [path,filename,ext] = fileparts(all_bgs{iBg});
    iBgImg = imresize(double(imread(all_bgs{iBg})),targetDims);
%     imshow(uint8(iBgImg));
    iBgImg(~annulus) = 128;

    imwrite(uint8(iBgImg),fullfile(saveLoc,[filename '.png']));
end   
    

%% Defining indices of the mask.
% This script will load a manually created annulus mask and get the indices
% of the mask.
% This is used to take Florence's bgs, black out the annulus, and use the
% rest of the image to paste faces in.
clear; clc; dbstop if error;

% Load one of the images
exampleImg = imread('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\images\imageIdx1_faceName37_bgName12.png');
[rows,columns] = size(exampleImg);

% Create an image
[columnsInImage,rowsInImage] = meshgrid(1:columns, 1:rows);
% Next create the inner and outer circles in the center of the image.
centerX = round(columns/2);
centerY = round(rows/2);

innerRad = 225;
outerRad = 340;

outerCircle = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= outerRad.^2;
innerCircle = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 > innerRad.^2;

annulus = outerCircle .* innerCircle; % This defines annulus, with 1 in annulus idxs and 0 elsewhere.
% Reverse the annulus
annulus_rev = ~annulus;

% subplot(1,2,1);
% imshow(annulus);
% subplot(1,2,2);
% imshow(annulus_rev);

% Now start loading the bg images and overlay the mask.



%% Creating circles in images
% From https://nl.mathworks.com/matlabcentral/answers/53340-how-to-make-circular-black-frame-in-image


clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
fontSize = 20;
% Read in a standard MATLAB color demo image.
folder = fullfile(matlabroot, '\toolbox\images\imdemos');
baseFileName = 'peppers.png';
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
if ~exist(fullFileName, 'file')
	% Didn't find it there.  Check the search path for it.
	fullFileName = baseFileName; % No path this time.
	if ~exist(fullFileName, 'file')
		% Still didn't find it.  Alert user.
		errorMessage = sprintf('Error: %s does not exist.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
rgbImage = imread(fullFileName);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Display the original image.
subplot(2, 2, 1);
imshow(rgbImage);
title('Original Color Image', 'FontSize', fontSize);
[rows columns numberOfColorChannels] = size(rgbImage);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Create a logical image of a circle with specified
% diameter, center, and image size.
% First create the image.
[columnsInImage rowsInImage] = meshgrid(1:columns, 1:rows);
% Next create the circle in the center of the image.
centerX = columns/2;
centerY = rows/2;
radius = min([rows columns]) / 2;
outerCircle = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= radius.^2;
innerCircle = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 > (radius-40).^2;
% circlePixels is a 2D "logical" array.
% Now, display it.
subplot(2, 2, 2);
imshow(outerCircle, []);
colormap([0 0 0; 1 1 1]);
title('Binary image of a circle', 'FontSize', fontSize);
% Mask the image.
maskedRgbImage = bsxfun(@times, rgbImage, cast(outerCircle, class(rgbImage)));

% Now, display it.
subplot(2, 2, 3);
imshow(maskedRgbImage);
title('Image Masked by the Circle', 'FontSize', fontSize);
% Mask the image the other way.
maskedRgbImage = bsxfun(@times, rgbImage, cast(~outerCircle, class(rgbImage)));

% Now, display it.
subplot(2, 2, 4);
imshow(maskedRgbImage);
title('Image Masked by the Circle', 'FontSize', fontSize);

%% Check if best patches on Florence's set were part of the doublets for simulaiton5 training
clear; clc; dbstop if error;

% Load Florence's performances. 
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\data\patchSet_3x2\lfwSingle50000\fixedLocalization\patchPerformanceInfo_FaceBox.mat');

% Load doublets trained on simulation5.
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation5\training\data\patchSet_3x2\lfwSingle50000\combinations\find_CPatches\doublets\2000TPatches2000CPatches\combMatrix.mat');

% Check if top N patches on Florence's set are part of indices for
% doublest.
topN_florence = idx_best_patches(1:1000);

common_florence_topPatches = intersect(topN_florence,combMatrix(:,1));
common_florence_compPatches = intersect(topN_florence,combMatrix(:,2));

% Plot all patches that were part of TP or CP, by their performanceo on
% Florence's set. 
    % Resort Florence's patches by their idx 1 to end.
    [sorted_indices,idx] = sort(idx_best_patches,'ascend');
    sumStatsPatch_resorted = sortSumStatsPatch(idx);
    
    % Plot
    TP_values = sumStatsPatch_resorted(combMatrix(:,1));
    CP_values = sumStatsPatch_resorted(combMatrix(:,2));
    
    hist(TP_values)
    figure
    hist(CP_values)

%% Looped sequence of script to run doublet combination on training then testing automatically.
clear; clc; dbstop if error;

nPatches = 50000;
% nTPatchesAll = [100, 1000,200, 1000,2000,2000];
% nCPatchesAll = [1000,100, 1000,200, 2000,3000]; 

nTPatchesAll = [10,20];
nCPatchesAll = [20,10];

for iRun = 1:length(nTPatchesAll)
    iRun
    % Create doublets using various combination of TPatches and CPatches.
    CUR_genDoublets_norep(nPatches,nTPatchesAll(iRun),...
                          ceil(nTPatchesAll(iRun)/32),...
                          nCPathcesAll(iRun));
    display(['done with making doublets for run' int2str(iRun)]);
    
    % Now test these with FACE-BOX criterion.
    CUR_runScaledDoublet_FaceBox(nTPatchesAll(iRun),nCPathcesAll(iRun));
    display(['done with testing doublets with FB for run' int2str(iRun)]);

    % Now test these with WEDGE criterion.
    CUR_runScaledDoublet_wedge30(nTPatchesAll(iRun),nCPathcesAll(iRun));
    display(['done with testing doublets with wedge for run' int2str(iRun)]);    
end   
%% sequence of script to run doublet combination on training then testing automatically.
clear; clc; dbstop if error;

nTPatches1 = 1000;
nCPathces1 = 3000;

nTPatches2 = 2000;
nCPatches2 = 3000;

nTPatches3 = 2000;
nCPatches3 = 2000;

% Create doublets using various combination of TPatches and CPatches.
CUR_genDoublets_norep(50000,nTPatches1,40,nCPathces1);
% CUR_genDoublets_norep(50000,nTPatches2,80,nCPatches2);
% CUR_genDoublets_norep(50000,nTPatches3,80,nCPatches3);
display('done with making doublets');

% Now test these with FACE-BOX criterion.
CUR_runScaledDoublet_FaceBox(nTPatches1,nCPathces1);
% CUR_runScaledDoublet_FaceBox(nTPatches2,nCPatches2);
% CUR_runScaledDoublet_FaceBox(nTPatches3,nCPatches3);
display('done with testing doublets with face-box criterion');

% Now test these with WEDGE criterion.
CUR_runScaledDoublet_wedge30(nTPatches1,nCPathces1);
% CUR_runScaledDoublet_wedge30(nTPatches2,nCPatches2);
% CUR_runScaledDoublet_wedge30(nTPatches3,nCPatches3);
display('done with testing doublets with wedge criterion');


%% Resort facesLoc.mat and c2, bestLoc, bestBands files...
% clear; clc; dbstop if error;
% 
% if ispc
%     fileLoc = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation5\training\data\patchSet_3x2\lfwSingle50000';
% else
%     fileLoc = '/home/levan/HMAX/annulusExptFixedContrast/simulation5/training/data/patchSet_3x2/lfwSingle50000';
% end
%     
% load(fullfile(fileLoc,'facesLoc.mat'));
% load(fullfile(fileLoc,'c2f.mat'));
% load(fullfile(fileLoc,'bestLocC2f.mat'));
% load(fullfile(fileLoc,'bestBandsC2f.mat'));
% 
% [sortedFacesLoc,idx_sort] = sort_nat(facesLoc{1});
% 
% c2f         = c2f(:,idx_sort);
% bestBands   = bestBands(:,idx_sort);
% bestLoc     = bestLoc(:,idx_sort,:);
% facesLoc{1} = sortedFacesLoc;
% 
% save(fullfile(fileLoc,'facesLoc.mat'),'facesLoc');
% save(fullfile(fileLoc,'c2f.mat'),'c2f');
% save(fullfile(fileLoc,'bestLocC2f.mat'),'bestLoc');
% save(fullfile(fileLoc,'bestBandsC2f.mat'),'bestBands');

%% Edit out those images from Florence's set that have too low Michelson contrast
% clear; clc; close all;
% dbstop if error;
% 
% home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\data\patchSet_3x2\lfwSingle50000';
% saveFolder = 'high_contrast_data';
% 
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\exptDesign.mat')
% 
% % Get michelson values
% for iImg = 1:length(exptDesign)
%     face_michelson(iImg) = (max(exptDesign(iImg).faceImg(:)) - min(exptDesign(iImg).faceImg(:)))/...
%                            (max(exptDesign(iImg).faceImg(:)) + min(exptDesign(iImg).faceImg(:)));
% end
% 
% idx_low = find(face_michelson < 0.3);
% idx_high = setdiff(1:length(face_michelson),idx_low);
% 
% % Start editing out the data.
% load(fullfile(home,'facesLoc.mat'));
% facesLoc{1} = facesLoc{1}(idx_high);
% 
% load(fullfile(home,'c2f.mat'));
% c2f = c2f(:,idx_high);
% 
% load(fullfile(home,'bestBandsC2f.mat'));
% bestBands = bestBands(:,idx_high);
% 
% load(fullfile(home,'bestLocC2f.mat'));
% bestLoc = bestLoc(:,idx_high,:);
% 
% exptDesign = exptDesign(idx_high);
% % Save data to a new folder
% 
% save(fullfile(home,saveFolder,'c2f.mat'),'c2f');
% save(fullfile(home,saveFolder,'bestBandsC2f.mat'),'bestBands');
% save(fullfile(home,saveFolder,'bestLocC2f.mat'),'bestLoc');
% save(fullfile(home,saveFolder,'facesLoc.mat'),'facesLoc');
% save(fullfile(home,saveFolder,'exptDesign.mat'),'exptDesign');
% 
% 
