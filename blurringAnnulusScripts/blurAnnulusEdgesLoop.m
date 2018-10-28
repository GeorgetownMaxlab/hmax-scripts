% Script to iteratively blur annulus edges for many images.
% Also allows blurring of various width.
% This function calls the blurAnnulusEdges.m function.

%% Global stuff
clear; clc;

allWidths = [5]; % a value of 5 will give you a blur of width 2*5=10 pixels. you can make this a vector of several values, and it will loop through and generate blurs of various widths.

for iLoop = 1:length(allWidths)
d = allWidths(iLoop);
d

% loadFolder = 'normalized\images';
% saveFolder = ['normalized\images_blurEdges_' int2str(2*d) 'px'];
% 
% if ispc == 1
%     loadLoc    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\s10\' loadFolder '\']
%     saveLoc    = ['C:\Users\Levan\HMAX\annulusExptFixedContrast\s10\' saveFolder '\']
% else    
%     loadLoc    = ['/home/levan/HMAX/annulusExptFixedContrast/s10/' loadFolder '/']
%     saveLoc    = ['/home/levan/HMAX/annulusExptFixedContrast/s10/' saveFolder '/']
% end

loadFolder = 'BackgroundsMay2016';
saveFolder = ['BackgroundsMay2016\images_blurEdges_' int2str(2*d) 'px'];

if ispc == 1
    loadLoc    = ['C:\Users\levan\HMAX\annulusExptFixedContrast\backgroundsToBeUsed\' loadFolder '\']
    saveLoc    = ['C:\Users\levan\HMAX\annulusExptFixedContrast\backgroundsToBeUsed\' saveFolder '\']
else    
    loadLoc    = ['/home/levan/HMAX/annulusExptFixedContrast/s10/' loadFolder '/']
    saveLoc    = ['/home/levan/HMAX/annulusExptFixedContrast/s10/' saveFolder '/']
end


if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

imgPaths = lsDir(loadLoc,{'png'});

%% Load all images and blur them

parfor iImg = 1:length(imgPaths)
%         if mod(iImg,50) == 0
%             iImg
%         end
        imgIn = double(imread(imgPaths{iImg}));
        imgOut = blurAnnulusEdges(imgIn,d);
        imgIn = [];
%         imshow(uint8(imgOut));

        % save the images.
        saveName = strrep(imgPaths{iImg},loadFolder,saveFolder);
        imwrite(uint8(imgOut),saveName,'png');
end

end
