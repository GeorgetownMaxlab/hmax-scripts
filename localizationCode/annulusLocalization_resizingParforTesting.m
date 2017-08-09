function annulusLocalization_resizingParforTesting(facesFileToLoad, nPatches, loadFolder, ...
    maxSize, saveFolder, quadType, patchSize)


%% Define global variables and load files.
if(nargin < 7) patchSize = 2
end
if(nargin < 6) quadType = 'f'
end
if(nargin < 5) saveFolder = loadFolder
end

% startFace = input('starting image?\n')
% endFace   = input('ending image?\n')

dbstop if error;

if ispc
   home = 'C:\Users\Levan\HMAX\annulusExpt\';
   loadLoc = ['C:\Users\Levan\HMAX\annulusExpt\'...
       loadFolder '\']
            load([loadLoc facesFileToLoad]); %variable in workspace called 'facesLoc']
            facesLoc = convertFacesLocAnnulus(facesLoc); %Convert the linux file paths to windows file paths.
   saveLoc = ['C:\Users\Levan\HMAX\annulusExpt\'...
       saveFolder '\']
else
   home = '/home/levan/HMAX/annulusExpt/';
    loadLoc = ['/home/levan/HMAX/annulusExpt/'...
       loadFolder '/']
    load([loadLoc facesFileToLoad]) %variable in workspace called 'facesLoc'
    saveLoc = ['/home/levan/HMAX/annulusExpt/'...
        saveFolder '/']
end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end


rfSizes = 7:2:39;
c1Space = 8:2:22;
c1Scale = 1:2:18;

load([home 'exptDesign.mat']);
load([loadLoc 'bestLocC2' quadType]); %variable in workspace called 'bestLoc'
load([loadLoc 'bestBandsC2' quadType]); %variable in workspace called 'bestBands'

%% Adjust bestLoc values based on resizing done at C2 calculation.

% ySizeOrig and xSizeOrig are dimensions of images that were presented to
% subjects during psychophysics experiments. All the face-location data
% given by Florence is relative to these dimensions. 
ySizeOrig = 730;
xSizeOrig = 927;

% These are the dimensions of the S2 cells relative to which the bestLoc
% variables are defined.
[ySize, xSize] = size(resizeImage(imread(facesLoc{1}{1}),maxSize));

% Now obtain the scaling factor for bestLoc variables, so they can be
% transformed to be relative to dimensions of the images seen by subjects.
% Then they can be compared to face location values.
scalingFactor = ySizeOrig/ySize;

%% New code

bestBands = horzcat(bestBands{:});
bestLoc   = horzcat(bestLoc{:});

imgHitsWedge   = zeros(nPatches,size(bestBands,2));
imgHitsFaceBox = zeros(nPatches,size(bestBands,2));
tic;
% for iPatch = 1:nPatches %fprintf('STARTING W CUSTOM PATCH!!')
%     iPatch
for iImg = 1:size(bestBands,2)

% Get the img # in the facesLoc file.
    key = '_session'; %#ok<*NOPRT>
    key2 = '_image';
    idx = strfind(facesLoc{1}{iImg},key);
    idx2 = strfind(facesLoc{1}{iImg},key2);               
    subj = str2double(facesLoc{1}{iImg}(idx-1));
    ses  = str2double(facesLoc{1}{iImg}(idx+8));
    imgNum = facesLoc{1}{iImg}(idx2+6:end);
    imgNum(strfind(imgNum,'.jpeg'):end) = [];
    imgNum = str2double(imgNum);
    imgFacesLoc = 64*(5*(subj-2)+ses-1)+imgNum;
    sanityCheck.imgNum(iImg) = imgFacesLoc;
    face_loc_deg = positionAngle(imgFacesLoc);

end % iImg loop
toc
% sanityCheck.imgNum = imgNum;
% sanityCheck.c2_loc_deg = c2_loc_deg;
% sanityCheck.face_loc_deg = face_loc_deg;

%% Save variables
save([saveLoc 'imgHitsWedge'],'imgHitsWedge');
save([saveLoc 'imgHitsFaceBox'],'imgHitsFaceBox');
save([saveLoc 'sanityCheck'],'sanityCheck');

end
        
        
        
        
        