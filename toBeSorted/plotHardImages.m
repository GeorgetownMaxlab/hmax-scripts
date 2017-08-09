% plotting difficult images as a montage.

%% Define global variables
clear; clc; close;
loadLoc = 'C:\Users\Levan\HMAX\annulusExpt\testingSetRuns\';

folderName = 'patchSet4\lfwDouble100\';
nPatches = 50;
nImagesShown = 480;

saveLoc = [loadLoc folderName];

load([loadLoc folderName 'imageDifficultyData_' ...
    num2str(nPatches) '_Patches'],'IndImg');
load([loadLoc folderName 'facesLoc.mat']);
facesLoc = convertFacesLocAnnulus(facesLoc);
facesLoc = horzcat(facesLoc{:});

%% 
IndImg = IndImg(1:nImagesShown);

% Pad the images with black outlines
for i = 1:length(facesLoc(IndImg))
    img = imread(facesLoc{IndImg(i)});
    a{i} = padarray(img,[1 1]);
end

% Now construct a giant image.
nCol = 10

for r = 0:(length(a)/nCol)-1
    montageImg{r+1} = horzcat(a{r*nCol+1:r*nCol+nCol})
end
montageImg = vertcat(montageImg{:});
% imshow(montageImg,'InitialMagnification',100);
imwrite(montageImg,...
       [saveLoc 'hard_Images_top_' num2str(nImagesShown) '_Montage.JPEG']) 