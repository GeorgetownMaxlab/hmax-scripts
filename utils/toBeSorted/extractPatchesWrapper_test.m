function extractPatchesWrapper_test(patchSizes,nImages,saveLoc,pathToImages,maxSize,resize)

%   A wrapper function that takes in raw images, transforms them into C1
%   space, and extracts patches.
%   Images do not get resized.

% gaborSpecs: struct, holds information needed for creating S1 filters
% sourceImages: a cell array with paths to 


%% Define global variables
dbstop if error;
runParameterComments = input('Any comments about the run?\n');
runDateTime = datetime('now');

if (nargin < 5) resize = 0; maxSize = flintmax; end
if (nargin < 3) saveLoc = 'C:\Users\Levan\HMAX\patches\sandbox\HMAXfigure\'; end
if (nargin < 2) nImages = 10; end
if (nargin < 1) patchSizes = [2; 2; 4; 100]; end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

c1Scale = 1:2:18;
c1Space = 8:2:22;
gaborSpecs.orientations = [90 -45 0 45]; %filter orientations
gaborSpecs.receptiveFieldSizes = 7:2:39; %how big the filters are
gaborSpecs.div = 4:-.05:3.2; %frequency tuning of sinusoids

[fSize, filters, c1OL, numSimpleFilters] = init_gabor...
    (gaborSpecs.orientations,gaborSpecs.receptiveFieldSizes, gaborSpecs.div);

%% Generate/load image list.
if (nargin < 4) 
    pathToImages = 'C:\Users\Levan\HMAX\lfwImageDatabase\'; 
end

% Check if image list exists
if exist([saveLoc 'sourceImages.mat'],'file')
    fprintf('image list file already exists. Loading it... \n');    
    load([saveLoc 'sourceImages.mat']);
%     nImages = numel(sourceImages); % This gets inputted as an argument.
    sourceImages = sourceImages(1:nImages);
else
% Create the image list.
fprintf('image list file DOES NOT EXIST. Creating it... \n')
subFolders = lsDir(pathToImages,{'*'});
    sourceImages = {};
        for i = 1:length(subFolders)
           subFolderImages = lsDir(subFolders{i},{'jpg'});
           sourceImages = [sourceImages subFolderImages];
        end
    sourceImages = sourceImages(1:nImages);
    save([saveLoc 'sourceImages.mat'],'sourceImages');
    fprintf('Saved the image list file\n')
end
%% Process the image and create C1 representations. 

% Check if C1 file already exists.
if exist([saveLoc 'c1.mat'],'file')
    fprintf('C1 file already exists. Loading it... \n')
    load([saveLoc 'c1.mat'])
else

% Create C1 file
fprintf('C1 file DOES NOT EXIST. Creating it... \n')
if resize == 1
    for iImg = 1:nImages
        sourceImages{iImg} = double(resizeImage(grayImage(imread(sourceImages{iImg})),maxSize));
    end    
else
    for iImg = 1:nImages
        sourceImages{iImg} = double(grayImage(imread(sourceImages{iImg})));
    end
end
fprintf('creating c1... \n');
c1r = cell(1,numel(sourceImages));
s1r = cell(1,numel(sourceImages));

for iImg = 1:numel(sourceImages)
    fprintf('%d \n', iImg);
        img = sourceImages{iImg};
            [c1, s1] = C1(img, filters, fSize, c1Space, c1Scale, c1OL);
        c1r{iImg} = c1;
        s1r{iImg} = s1;
        s1 = []; % clearing because of memory usage. 
end

save([saveLoc 'c1.mat'],'c1r');
fprintf('Done saving C1 file. \n')
% c1r = {};
% s1r = {};
end
%% Extract patches from C1 space images

% Make sure the patches file doesn't already exist.

if exist([saveLoc 'patches.mat'],'file')
    fprintf('Patches file already exists!\n')
else
    fprintf('Started patch extraction. \n')
    [ps] = extractedPatches(c1r,patchSizes);
    save([saveLoc 'patches.mat'],'ps');
end

%% Save parameter space of the run
outputOfPWD = pwd;

save([saveLoc 'parameterSpace.mat'],...
    'runDateTime',...
    'outputOfPWD',...
    'runParameterComments',...
    'patchSizes',...
    'nImages',...
    'saveLoc',...
    'pathToImages',...
    'resize',...
    'maxSize'...
    );

end