%% Create crossValidInfo file for simulation5
% Use the crossValidInfo file for simulation4, to determine which bgs to
% use. 
clear; clc; dbstop if error;

home = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed';

load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation4\crossValidInfo.mat');
crossValidInfo = rmfield(crossValidInfo,{'trainingFaces','testingFaces','testingBgs'});

maskLoc = fullfile(home,'new_gimp_masks_final');
maskLoc_males   = lsDir(fullfile(maskLoc,'male'),  {'png'})';
maskLoc_females = lsDir(fullfile(maskLoc,'female'),{'png'})';
maskLoc = [maskLoc_males(1:50);maskLoc_females(1:50)];

[~,faceNames,~]  = cellfun(@fileparts,maskLoc, 'UniformOutput',false);
facesLoc = fullfile(home,'faces',faceNames);
for iFace = 1:length(facesLoc)
    facesLoc{iFace} = [facesLoc{iFace} '.jpg'];
    assert(exist(facesLoc{iFace}) == 2);
end

crossValidInfo.trainingBgs   = crossValidInfo.trainingBgs';
crossValidInfo.trainingFaces = facesLoc;
%% Get rid of index numbers for masks and faces.
% % So original masks I created were created from face images that had a
% % number appended at the beginning. This script removes that number, and
% % also sorts the face masks into male and female folders.
% clear; clc; dbstop if error;
% 
% home = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed';
% 
% gender = 'female';
% faceLocFilt  = fullfile(home,'mask_originals_filt',gender);
% maskLoc      = fullfile(home,'new_gimp_masks');
% saveLoc_mask = fullfile(home,'new_gimp_masks_final',gender);
% 
% if ~exist(saveLoc_mask)
%     mkdir(saveLoc_mask)
% end
% 
% sourcefaceNamePaths = lsDir(faceLocFilt,{'png'})';
% gimpMaskNamePaths   = lsDir(maskLoc,{'png'})';
% 
% [~,sourcefaceNames,ext]  = cellfun(@fileparts,sourcefaceNamePaths , 'UniformOutput',false);
% 
% % Copy the mask to the new location, separated by gender. Also remove the index before the mask.
% for iFile = 1:length(sourcefaceNames)
%     key = '_';
%     idx_start = strfind(sourcefaceNames{iFile},key);
%     idx_start = idx_start(1)+1;
%     copyName = sourcefaceNames{iFile}(idx_start:end); % removes the numbers in the beginning of the file.
%     copyfile([fullfile(maskLoc,sourcefaceNames{iFile}) '.png'],[fullfile(saveLoc_mask,copyName) '.png']);
% end
    
%% Flexible block for copying various humanae faces and masks with appended number in the beginning.
% This makes it easier to load in gimp for mask creation. And to keep track
% of progress.
% clear; clc; dbstop if error;
% 
% gimp_maskLoc = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\new_gimp_masks';
% saveLoc  = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\mask_originals_filt';
% source_faces = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\mask_originals';
% orig_facesLoc = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\faces';
% 
% if ~exist(saveLoc)
%     mkdir(saveLoc)
% end
% 
% sourcefaceNamePaths = lsDir(source_faces,{'png'})';
% maskNamePaths = lsDir(gimp_maskLoc,{'png'})';
% 
% [~,sourcefaceNames,~]  = cellfun(@fileparts,sourcefaceNamePaths , 'UniformOutput',false);
% [~,maskNames,~]        = cellfun(@fileparts,maskNamePaths, 'UniformOutput',false);
% 
% % % Create the paths to the faces and masks in their original folders. 
% % orig_facePaths  = cellfun(@(S) fullfile(orig_facesLoc, S), faceNames, 'Uniform', 0); % This is genius!!
% % orig_maskPaths  = cellfun(@(S) fullfile(orig_maskLoc, S),  faceNames, 'Uniform', 0); % This is genius!!
% 
% 
% % % Make sure all these images exist in the original folder.
% % all_files = vertcat(orig_facePaths,orig_maskPaths);
% % status = cellfun(@exist, all_files); % Do these files exist? Should be output "2" for all.
% % assert(isempty(find(status < 2)),'Failed to locate the face file');
% 
% % Start copying files over.
% 
%     % Make sure folder is empty
% %     saveLocFiles = lsDir(saveLoc,{''})';
% %     cellfun(@delete,saveLocFiles);
% % 
% %     for iFile = 1:length(faceNames)    
% %         copyfile(faceNamePaths{iFile},fullfile(saveLoc,[int2str(iFile) '_' faceNames{iFile} '.png']));
% % %         copyfile(faceNamePaths{iFile},fullfile(saveLoc,[int2str(iFile*2)   '_' faceNames{iFile}]));
% %     end
% 
% % Copy those faces whose masks have been created
% for iFace = 1:length(maskNames)
%    copyfile(fullfile(source_faces,[maskNames{iFace} '.png']),saveLoc);
%     
%     
%     
% end

%% Copy the images and their masks to a new folder, to make loading into Inkscape easier
% % Goal is to load the pic and mask in Inkscape, remove shoulders and neck,
% % and save the mask. This script just copies the face pics and masks
% % side-by-side, so I can manually drop them in Inkscape.
% clear; clc; dbstop if error;
% 
% facesFolder = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\blank_background\re_organized';
% saveFolder  = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\to_load_in_inkscape';
% orig_facesLoc = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\faces';
% orig_maskLoc = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\Mask';
% 
% condition = 'small_halo';
% gender    = 'male';
% 
% facesLoc = fullfile(facesFolder,condition,gender);
% saveLoc  = fullfile(saveFolder,condition,gender);
% 
% if ~exist(saveLoc)
%     mkdir(saveLoc)
% end
% 
% faceNamePaths = lsDir(facesLoc,{'png'})';
% 
% [~,faceNames,~]  = cellfun(@fileparts,faceNamePaths, 'UniformOutput',false);
% 
% % Create the paths to the faces and masks in their original folders. 
% orig_facePaths  = cellfun(@(S) fullfile(orig_facesLoc, S), faceNames, 'Uniform', 0); % This is genius!!
% orig_maskPaths  = cellfun(@(S) fullfile(orig_maskLoc, S),  faceNames, 'Uniform', 0); % This is genius!!
% 
% 
% % Make sure all these images exist in the original folder.
% all_files = vertcat(orig_facePaths,orig_maskPaths);
% status = cellfun(@exist, all_files); % Do these files exist? Should be output "2" for all.
% assert(isempty(find(status < 2)),'Failed to locate the face file');
% 
% % Start copying files over.
% 
%     % Make sure folder is empty
%     saveLocFiles = lsDir(saveLoc,{'jpg'})';
%     cellfun(@delete,saveLocFiles);
% 
%     for iFile = 1:length(faceNames)    
%         copyfile(orig_facePaths{iFile},fullfile(saveLoc,[int2str(iFile*2-1) '_' faceNames{iFile}]));
%         copyfile(orig_maskPaths{iFile},fullfile(saveLoc,[int2str(iFile*2)   '_' faceNames{iFile}]));
%     end
% 
% 

%% Create crossValidInfo file for simulation5.
% % This will combine male and female faces from no-halo and small-halo
% % folders, and split them into training/testing batches.
% clear; clc; dbstop if error;
% 
% % Use the same bg split as in simulation 4
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation4\crossValidInfo.mat')
% crossValidInfo.trainingFaces = [];
% crossValidInfo.testingFaces  = [];
% 
% home = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM';
% loc_blank_faces = fullfile(home,'HumanaeFaces5Processed','blank_background','re_organized');
% loc_orig_faces  = fullfile(home,'HumanaeFaces5Processed','faces');
% 
% % Get all the no-halo paths
% none_m_paths = lsDir(fullfile(loc_blank_faces,'none_at_all','male'),{'png'})';
% none_f_paths = lsDir(fullfile(loc_blank_faces,'none_at_all','female'),{'png'})';
% 
% % Get all the small-halo paths
% small_m_paths = lsDir(fullfile(loc_blank_faces,'small_halo','male'),{'png'})';
% small_f_paths = lsDir(fullfile(loc_blank_faces,'small_halo','female'),{'png'})';
% 
% % Isolate the names of the face images
% [~,none_m_face_names,~]  = cellfun(@fileparts,none_m_paths, 'UniformOutput',false); % in this case, face_name is appended with ".jpg".
% [~,none_f_face_names,~]  = cellfun(@fileparts,none_f_paths, 'UniformOutput',false); % in this case, face_name is appended with ".jpg".
% [~,small_m_face_names,~] = cellfun(@fileparts,small_m_paths,'UniformOutput',false); % in this case, face_name is appended with ".jpg".
% [~,small_f_face_names,~] = cellfun(@fileparts,small_f_paths,'UniformOutput',false); % in this case, face_name is appended with ".jpg".
% 
% % Concatinate names of face images with the location path to the original folder.
% orig_none_m_face_names  = cellfun(@(S) fullfile(loc_orig_faces, S), none_m_face_names, 'Uniform', 0); % This is genius!!
% orig_none_f_face_names  = cellfun(@(S) fullfile(loc_orig_faces, S), none_f_face_names, 'Uniform', 0);
% orig_small_m_face_names = cellfun(@(S) fullfile(loc_orig_faces, S), small_m_face_names, 'Uniform', 0);
% orig_small_f_face_names = cellfun(@(S) fullfile(loc_orig_faces, S), small_f_face_names, 'Uniform', 0);
% 
% % Make sure all these images exist in the original folder.
% all_files = vertcat(orig_none_m_face_names,orig_none_f_face_names,orig_small_m_face_names,orig_small_f_face_names);
% status = cellfun(@exist, all_files); % Do these files exist? Should be output "2" for all.
% assert(isempty(find(status < 2)),'Failed to locate the face file');
% 
%     % Shuffle the order of faces and split males and females in half. First
%     % halves will be fore training images and second half would be for
%     % testing halves.
% 
% 
% 
% 



%% Paste Florence's faces on an empty background so we can see how much of a halo they have
% clear; clc;
% dbstop if error;
% 
% home = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM';
% bgPaths   = lsDir(fullfile(home,'Backgrounds'),{'jpg'});
% facePaths = lsDir(fullfile(home,'HumanaeFaces5Processed','faces_used_by_florence'),{'jpg'});
% maskPaths = lsDir(fullfile(home,'HumanaeFaces5Processed','Mask'),{'jpg'});
% locPaths  = lsDir(fullfile(home,'HumanaeFaces5Processed','locations'),{'mat'});
% 
% maskPixelThreshold = 200;
% if ~exist(fullfile('C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\blank_background_florence',...
%         [int2str(maskPixelThreshold) '_maskThreshold']))
%     mkdir(fullfile('C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\blank_background_florence',...
%         [int2str(maskPixelThreshold) '_maskThreshold']));
% end
% 
% for iImg = 1:length(facePaths);
%     if mod(iImg,500) == 0
%         iImg
%     end
%     
% %     faceFileName = facePaths{iImg}(length(fullfile(home,'HumanaeFaces5Processed','faces_used_by_florence'))+2:end);
%     [~,faceFileName,ext] = fileparts(facePaths{iImg});
%     faceFileName = [faceFileName ext];
%     
%     % Find idx of the mask corresponding to the face.
%     idx_mask = find(ismember(maskPaths,...
%         fullfile(home,'HumanaeFaces5Processed','Mask',faceFileName)));
%     % Find idx of the location file corresponding to the face.
% %     idx_loc  = find(ismember(locPaths,...
% %         [fullfile(home,'HumanaeFaces5Processed','locations',faceFileName),'.mat']));
% 
% 
% 
%     % Load bg, face, and mask, and facepositions
%     faceImg = grayImage(imread(facePaths{iImg}))/255;
%     maskImg = grayImage(imread(maskPaths{idx_mask}));
% %     facepoints = load(locPaths{idx_loc});
% %     facepoints = facepoints.facepoints;
% 
%     bg = zeros(size(faceImg));
%     pasteLocation = [10,10];
%     pastedBg = bg;
%     for iCol = 1:size(faceImg,2)
%         %         iCol
%         for iRow = 1:size(faceImg,1)
%             if maskImg(iRow,iCol) > maskPixelThreshold
%                 % taking the ceil of the faceImg dimension might be a
%                 % problem, but should lead to an error of utmost 1 pixel
%                 % not being pasted in.
%                 pastedBg(pasteLocation(1) + iRow,...
%                     pasteLocation(2) + iCol) = ...
%                     faceImg(iRow,iCol);
%             end
%         end
%     end
% %     imshow(pastedBg);
%     imwrite(pastedBg,fullfile('C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\blank_background_florence',...
%         [int2str(maskPixelThreshold) '_maskThreshold'],[faceFileName '.png']));
% 
% end

%% Add position angle variable to exptDesign files.
% clear; clc; dbstop if error;
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation4\training\exptDesign.mat')



%% Reduce contrast of Jacob's bg images.
% 
% clear; clc; close all;
% dbstop if error;
% 
% if ispc
%     home = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM';
% else
%     home = '/home/levan/HMAX/HumanaeFaces20170707_JGM';
% end
% 
% % Get the range of stretchlim values of Florences images
% floPath = 'C:\Users\levan\HMAX\annulusExptFixedContrast\AllBackgrounds';
% floImgs = lsDir(floPath,{'jpg'});
% allValues = zeros(length(floImgs),2);
% 
% for iImg = 1:length(floImgs)
%    img = imread(floImgs{iImg});
%    allValues(iImg,:) = stretchlim(img);
% 
% end
% 
% meanValues = mean(allValues,1);
% stdValues  = std(allValues);
% 
% 
% 
% % Start adjusting Jacob's images.
% % For each of Jacob's image, randomly choose an image from Florence's
% % folder, and use the stretchlim values of that image for contrast
% % normalization.
% bgPath = fullfile(home,'Backgrounds_not_used_by_florence');
% bgImgs = lsDir(bgPath,{'jpg'});
% 
% % refImg = imread('C:\Users\levan\HMAX\annulusExptFixedContrast\AllBackgrounds\bgBazaar001.jpg');
% 
% parfor iImg = 1:length(bgImgs)
%     idxRefImg = randi(100,1);
%     bgImg = imread(bgImgs{iImg});
%     
% %     bgImgAdj = stretch_histogram(bgImg,refImg);
%     bgImgAdj = imadjust(bgImg,stretchlim(bgImg),allValues(idxRefImg,:));
%     
% %     subplot(1,2,1)
% %     imshow(bgImg);
% %     subplot(1,2,2)
% %     imshow(bgImgAdj);
%     [pathstr,name,ext] = fileparts(bgImgs{iImg});
%     imwrite(bgImgAdj,fullfile(home,'Backgrounds_not_used_by_florence_unique_normalized',[name '.png']));
% end

%% Take only the unique images from Jacob's database.
% clear; clc; close all; dbstop if error;
% if ispc
%     home = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM';
% else
%     home = '/home/levan/HMAX/HumanaeFaces20170707_JGM';
% end
% 
% bgPath = fullfile(home,'Backgrounds_not_used_by_florence');
% filtPath = fullfile(home,'filtered_backgrounds');
% 
% 
% saveLoc = fullfile(home,'Backgrounds_not_used_by_florence_unique');
% if ~exist(saveLoc)
%     mkdir(saveLoc)
% end
% 
% bgImgs   = lsDir(bgPath,{'jpg'});
% filtImgs = lsDir(filtPath,{'png'});
% 
% 
% filtNames = dir(fullfile(home,'filtered_backgrounds'));
% filtNames = struct2cell(filtNames);
% filtNames = filtNames(1,3:end);
% 
% key = '_';
% imgNumbers = [];
% 
% for iFilt = 1:length(filtImgs)
%     idx_key = strfind(filtNames{iFilt},key);
%     imgNumber = filtNames{iFilt}(1:idx_key-1);
%     imgNumber = str2double(imgNumber);
%     imgNumbers(iFilt) = imgNumber;
% 
% end
% imgNumbers = imgNumbers + 1;
% imgNumbers = sort(imgNumbers);
% 
% % Now take only these imgNumber images from Jacob's original folder.
% 
% uniqueBgs = bgImgs(imgNumbers);
% 
% for iFlo = 1:length(uniqueBgs)
%     [pathstr,name,ext] = fileparts(uniqueBgs{iFlo});
%     copyfile(uniqueBgs{iFlo},fullfile(saveLoc,[name '.png']));
% end
%% Remove duplicate bgs from Jacob's database.

% clear; clc; close all; dbstop if error;
% if ispc
%     home = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM';
% else
%     home = '/home/levan/HMAX/HumanaeFaces20170707_JGM';
% end
% 
% bgPath = fullfile(home,'Backgrounds_not_used_by_florence');
% 
% saveLoc = fullfile(home,'duplicates_separated');
% if ~exist(saveLoc)
%     mkdir(saveLoc)
% end
% 
% bgImgs = lsDir(bgPath,{'jpg'});
% 
% load(fullfile(home,'duplicates','leastError.mat'));
% 
% idx_duplicates = [];
% 
% for iImg = 1:size(leastError,1)
% %     if ~ismember(iImg,idx_duplicates)
%         idx_duplicates = [idx_duplicates find(leastError(iImg,:) < 4000 &...
%                           leastError(iImg,:) > 0)];
% %     end
% end
% 
% % Now cut out those that have a duplicate. 
% idx_duplicates = idx_duplicates - 1;
% 
% key = '_';
% 
% cd(fullfile(home,'duplicates'));
% dup_names = dir(fullfile(home,'duplicates'));
% dup_names = struct2cell(dup_names);
% dup_names = dup_names(1,3:end);
% 
% 
% 
% parfor iBg = 1:length(dup_names)
%     idx_key = strfind(dup_names{iBg},key);
%     img_number = dup_names{iBg}(1:idx_key-1);
%     img_number = str2double(img_number);
%     
%     if ismember(img_number,idx_duplicates)
%         copyfile(dup_names{iBg},fullfile(home,'duplicates_separated'));
%         delete(dup_names{iBg});
%     end
% end


%% Find duplicate background images in Jacob's database.

% Code will take each image, and find closest 3 images. 

% clear; clc;
% 
% dbstop if error;
% 
% if ispc
%     home = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM';
% else
%     home = '/home/levan/HMAX/HumanaeFaces20170707_JGM';
% end
% % florencePath = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\Backgrounds_from_florence_not_in_jacobs_folder';
% % leftoverPath = 'C:\Users\levan\HMAX\annulusExptFixedContrast\AllBackgrounds';
% bgPath = fullfile(home,'Backgrounds_not_used_by_florence');
% floPath = fullfile(home,'Backgrounds_used_by_florence');
% 
% saveLoc = fullfile(home,'last_filt_step');
% if ~exist(saveLoc)
%     mkdir(saveLoc)
% end
% 
% floImgs = lsDir(floPath,{'jpg'});
% bgImgs = lsDir(bgPath,{'jpg'});
% 
% resScale = 0.15;
% 
% leastError = zeros(length(floImgs),length(bgImgs));
% 
% for iFlo = 1:length(floImgs)
%     iFlo
% 
%     iImgOrig = imread(floImgs{iFlo});
% 
%     parfor iComp = 1:length(bgImgs)
% %         iComp
%         iImgComp = imread(bgImgs{iComp});
%         
%         assert(isequal(size(iImgOrig),size(iImgComp)),'Image sizes differ');
%         
% %         diffImg = iImgOrig - iImgComp;
%         leastError(iFlo,iComp) = immse(iImgOrig,iImgComp);
%     end
%     
%     [sortedError, Idx] = sort(leastError(iFlo,:),'ascend');
%     
%     imwrite(imresize(iImgOrig,resScale),fullfile(saveLoc,[int2str(iFlo-1) '_0.png'])); 
%     for iWrite = 1:4
%         imwrite(imresize(imread(bgImgs{Idx(iWrite)}),resScale),...
%                 fullfile(saveLoc,[int2str(iFlo-1) '_' int2str(iWrite) '.png']))
%     end
% end
% 
% save(fullfile(saveLoc,'leastError'),'leastError');

%% Find the left out background images in Jacob's database.
% clear; clc;
% 
% dbstop if error;
% 
% home = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM';
% florencePath = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\Backgrounds_from_florence_not_in_jacobs_folder';
% % leftoverPath = 'C:\Users\levan\HMAX\annulusExptFixedContrast\AllBackgrounds';
% jacobPath = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\Backgrounds_not_used_by_florence';
% 
% 
% florenceImgs = lsDir(florencePath,{'jpg'});
% jacobsImgs   = lsDir(jacobPath,{'jpg'});
% 
% for iFlorence = 1:length(florenceImgs)
%     iFlorence
%     saveLoc = fullfile(home,'differences',int2str(iFlorence));
%     if ~exist(saveLoc)
%         mkdir(saveLoc)
%     end
% 
%     parfor iJacob = 1:length(jacobsImgs)
%         iJImg = imread(jacobsImgs{iJacob});
%         iFImg = imread(florenceImgs{iFlorence});
%         iFImg = imresize(iFImg,size(iJImg));
% 
%         diffImg = iFImg - iJImg;
%         leastError(iJacob) = immse(iFImg,iJImg);
%     end
%     
%     [sortedError, Idx] = sort(leastError,'ascend');
%     
%     for iWrite = 1:10
%         imwrite(imread(jacobsImgs{Idx(iWrite)}),fullfile(saveLoc,[int2str(iWrite) '_image.png']))
%     end
% end


%% Exclude background images common between Florence's and Jake's databases.
% clear; clc;
% 
% dbstop if error;
% 
% home = 'C:\Users\levan\HMAX';
% 
% pathJacob    = fullfile(home,'HumanaeFaces20170707_JGM','Backgrounds');
% pathFlorence = fullfile(home,'annulusExptFixedContrast','AllBackgrounds');
% 
% cd(pathFlorence);
% bgNamesFlorence = dir('*.jpg');
% bgNamesFlorence = struct2cell(bgNamesFlorence);
% bgNamesFlorence = bgNamesFlorence(1,:)';
% 
% cd(pathJacob);
% bgNamesJacob = dir('*.jpg');
% bgNamesJacob = struct2cell(bgNamesJacob);
% bgNamesJacob = bgNamesJacob(1,:)';
% 
% for ibg = 1:length(bgNamesFlorence)
%     idx{ibg} = find(ismember(bgNamesJacob,bgNamesFlorence{ibg}));
%     
%     if isempty(idx{ibg});
%         copyfile(fullfile(pathFlorence,bgNamesFlorence{ibg}),...
%                  fullfile(home,'HumanaeFaces20170707_JGM','Backgrounds_from_florence_not_in_jacobs_folder'));
%     else
%         copyfile(fullfile(pathJacob,bgNamesJacob{idx{ibg}}),...
%                  fullfile(home,'HumanaeFaces20170707_JGM','Backgrounds_used_by_florence'));
%         delete(fullfile(pathJacob,bgNamesJacob{idx{ibg}}));
%     end
% end

%% Paste faces on empty background so we can choose the ones without a halo effect.
% clear; clc;
% dbstop if error;
% 
% home = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM';
% bgPaths   = lsDir(fullfile(home,'Backgrounds'),{'jpg'});
% facePaths = lsDir(fullfile(home,'HumanaeFaces5Processed','faces'),{'jpg'});
% maskPaths = lsDir(fullfile(home,'HumanaeFaces5Processed','Mask'),{'jpg'});
% locPaths  = lsDir(fullfile(home,'HumanaeFaces5Processed','locations'),{'mat'});
% 
% maskPixelThreshold = 200;
% if ~exist(fullfile('C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\sandbox',...
%         [int2str(maskPixelThreshold) '_maskThreshold']))
%     mkdir(fullfile('C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\sandbox',...
%         [int2str(maskPixelThreshold) '_maskThreshold']));
% end
% 
% for iImg = 1:length(facePaths);
%     if mod(iImg,500) == 0
%         iImg
%     end
% 
%     faceFileName = facePaths{iImg}(length(fullfile(home,'HumanaeFaces5Processed','faces'))+2:end);
% 
%     % TEMP
%     if strcmp(faceFileName,'tumblr_n2hztpDnEB1rvapjbo1_500.jpg') == 1
%         input('Face found')
%     end
%     
%     % Find idx of the mask corresponding to the face.
%     idx_mask = find(ismember(maskPaths,...
%         fullfile(home,'HumanaeFaces5Processed','Mask',faceFileName)));
%     % Find idx of the location file corresponding to the face.
%     idx_loc  = find(ismember(locPaths,...
%         [fullfile(home,'HumanaeFaces5Processed','locations',faceFileName),'.mat']));
% 
% 
% 
%     % Load bg, face, and mask, and facepositions
%     faceImg = grayImage(imread(facePaths{iImg}))/255;
%     maskImg = grayImage(imread(maskPaths{idx_mask}));
%     facepoints = load(locPaths{idx_loc});
%     facepoints = facepoints.facepoints;
% 
%     bg = zeros(size(faceImg));
%     pasteLocation = [10,10];
%     pastedBg = bg;
%     for iCol = 1:size(faceImg,2)
%         %         iCol
%         for iRow = 1:size(faceImg,1)
%             if maskImg(iRow,iCol) > maskPixelThreshold
%                 % taking the ceil of the faceImg dimension might be a
%                 % problem, but should lead to an error of utmost 1 pixel
%                 % not being pasted in.
%                 pastedBg(pasteLocation(1) + iRow,...
%                     pasteLocation(2) + iCol) = ...
%                     faceImg(iRow,iCol);
%             end
%         end
%     end
% %     imshow(pastedBg);
%     imwrite(pastedBg,fullfile('C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\sandbox',...
%         [int2str(maskPixelThreshold) '_maskThreshold'],[faceFileName '.png']));
% 
% end
%% Try pasting a face
% clear; clc;
%
% home = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM';
% bgPaths   = lsDir(fullfile(home,'Backgrounds'),{'jpg'});
% facePaths = lsDir(fullfile(home,'HumanaeFaces5Processed','faces'),{'jpg'});
% maskPaths = lsDir(fullfile(home,'HumanaeFaces5Processed','Mask'),{'jpg'});
% locPaths  = lsDir(fullfile(home,'HumanaeFaces5Processed','locations'),{'mat'});
%
% ResizeDims = 100;
% bgDims = size(imread(bgPaths{1}));
%
% pasteLocation = bgDims/2 - 200;
%
% finalImgCount = 1;
%
% for iImg = 1:30;
%     iImg
%     bgsToUse = randperm(length(bgPaths),10);
%
%     % Start the loop over bg images
%     for iBg = bgsToUse %length(bgPaths)
%         pasteLocation = bgDims/2 - 200;
%
%
%         faceFileName = facePaths{iImg}(length(fullfile(home,'HumanaeFaces5Processed','faces'))+2:end);
%         bgFileName   = bgPaths  {iBg}(length(fullfile(home,'Backgrounds'))+2:end);
%
%
%
%         % Find idx of the mask corresponding to the face.
%         idx_mask = find(ismember(maskPaths,...
%             fullfile(home,'HumanaeFaces5Processed','Mask',faceFileName)));
%         % Find idx of the location file corresponding to the face.
%         idx_loc  = find(ismember(locPaths,...
%             [fullfile(home,'HumanaeFaces5Processed','locations',faceFileName),'.mat']));
%
%
%
%         % Load bg, face, and mask, and facepositions
%         bg      = grayImage(imread(bgPaths{iBg}))/255;
%         faceImg = grayImage(imread(facePaths{iImg}))/255;
%         maskImg = grayImage(imread(maskPaths{idx_mask}));
%         facepoints = load(locPaths{idx_loc});
%         facepoints = facepoints.facepoints;
%         % imshow(uint8(bg));
%         % Resize the face image and mask.
%         faceImg = imresize(faceImg,ResizeDims/size(faceImg,1));
%         maskImg = imresize(maskImg,ResizeDims/size(maskImg,1));
%         assert(isequal(size(faceImg),size(maskImg)) == 1,'resized dimensions of face and mask don''t match');
%
%         % Stretch histogram of face image so luminances match
%         bgPatch = bg(pasteLocation(1) - ceil (size(faceImg,1)/2):...
%             pasteLocation(1) + floor(size(faceImg,1)/2)-1,...
%             pasteLocation(2) - ceil (size(faceImg,2)/2):...
%             pasteLocation(2) + floor(size(faceImg,2)/2)-1);
%
%         % Check that its not a ghost face
%         bg_michelson = (max(bgPatch(:)) - min(bgPatch(:)))/(max(bgPatch(:)) + min(bgPatch(:)));
%
%         low_contrast_count = 1;
%         while bg_michelson < 0.3
%             %         low_contrast_count
%             pasteLocation = pasteLocation + 200;
%             % Stretch histogram of face image so luminances match
%             bgPatch = bg(pasteLocation(1) - ceil (size(faceImg,1)/2):...
%                 pasteLocation(1) + floor(size(faceImg,1)/2)-1,...
%                 pasteLocation(2) - ceil (size(faceImg,2)/2):...
%                 pasteLocation(2) + floor(size(faceImg,2)/2)-1);
%
%             bg_michelson = (max(bgPatch(:)) - min(bgPatch(:)))/(max(bgPatch(:)) + min(bgPatch(:)));
%
%             low_contrast_count = low_contrast_count + 1;
%         end
%
%
%         assert(isequal(size(faceImg),size(bgPatch)),'bgPatch and faceImg sizes don''t match');
%         faceImg_norm = stretch_histogram(faceImg,bgPatch);
%
%         % imshow(faceImg);
%         % figure
%         % imshow(faceImg_norm);
%
%         pastedBg = bg;
%         for iCol = 1:size(faceImg,2)
%             %         iCol
%             for iRow = 1:size(faceImg,1)
%                 if maskImg(iRow,iCol) > 50
%                     % taking the ceil of the faceImg dimension might be a
%                     % problem, but should lead to an error of utmost 1 pixel
%                     % not being pasted in.
%                     pastedBg(pasteLocation(1) - ceil(size(faceImg,1)/2) + iRow,...
%                         pasteLocation(2) - ceil(size(faceImg,1)/2) + iCol) = ...
%                         faceImg_norm(iRow,iCol);
%                 end
%             end
%         end
%         %     figure
%         %     imshow(pastedBg);
%
%         % create exptDesign file
%         exptDesign(iBg).faceImg   = faceImg_norm;
%         exptDesign(iBg).faceName  = faceFileName;
%         exptDesign(iBg).bgName    = bgFileName;
%         exptDesign(iBg).position  = pasteLocation;
%         exptDesign(iBg).mask      = maskImg;
%         exptDesign(iBg).imageDim  = bgDims;
%         exptDesign(iBg).michelson = bg_michelson;
%
%         imwrite(pastedBg,fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation4\training\images',...
%             ['img' int2str(finalImgCount) '__' faceFileName '__' bgFileName '.png']));
%
%         finalImgCount = finalImgCount + 1;
%
%     end
% end
%% Delete common face files
% clear; clc;
% dbstop if error;
%
% psych_faces_loc = 'C:\Users\levan\HMAX\annulusExptFixedContrast\face_images_from_Florence\used_in_psych';
% humanae_loc     = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\faces';
%
% psych_file_paths = lsDir(psych_faces_loc,{'jpg'});
% humanae_paths    = lsDir(humanae_loc,{'jpg'});
%
%
% newString = psych_file_paths{1}(86:end);
%
% for iFace = 1:length(psych_file_paths)
%     psych_file_paths{iFace} = psych_file_paths{iFace}(86:end);
% end
%
% for iFace = 1:length(humanae_paths)
%     humanae_paths_new{iFace} = humanae_paths{iFace}(75:end);
% end
%
% % Now search for common files and delete
% idx_img = [];
% for iFace = 1:length(psych_file_paths)
%    idx_img = find(ismember(humanae_paths_new,psych_file_paths(iFace)));
%    if ~isempty(idx_img)
%        copyfile(humanae_paths{idx_img},'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed\used_by_florence\')
%        delete(humanae_paths{idx_img});
%    end
% end

%% Determine centre of the faces.
% clear; clc; %close all;
%
% dbstop if error;
%
% home = 'C:\Users\levan\HMAX\HumanaeFaces20170707_JGM\HumanaeFaces5Processed';
%
% facePaths = lsDir(fullfile(home,'faces'),{'jpg'})';
%
% for iImg = 1:length(facePaths)
%     if mod(iImg,500) == 0
%         iImg
%     end
%     image = grayImage(imread(facePaths{iImg}));
%
%     facepoints = load(fullfile(home,'locations',...
%         [facePaths{iImg}(length(fullfile(home,'faces'))+2:end),'.mat']));
%     facepoints = facepoints.facepoints;
%
%     % Just mark the points maked by Jacob.
%     %     rectWidth = 10;
%
%     %     image(round(facePoints.headtop(2)-rectWidth):round(facePoints.headtop(2)+rectWidth),...
%     %         round(facePoints.headtop(1)-rectWidth):round(facePoints.headtop(1)+rectWidth)) = 0;
%     %     image(round(facePoints.chin(2)-rectWidth):round(facePoints.chin(2)+rectWidth),...
%     %         round(facePoints.chin(1)-rectWidth):round(facePoints.chin(1)+rectWidth)) = 0;
%     %     image(round(facePoints.lefteye(2)-rectWidth):round(facePoints.lefteye(2)+rectWidth),...
%     %         round(facePoints.lefteye(1)-rectWidth):round(facePoints.lefteye(1)+rectWidth)) = 0;
%     %     image(round(facePoints.righteye(2)-rectWidth):round(facePoints.righteye(2)+rectWidth),...
%     %         round(facePoints.righteye(1)-rectWidth):round(facePoints.righteye(1)+rectWidth)) = 0;
%     %     image(round(facePoints.subnasale(2)-rectWidth):round(facePoints.subnasale(2)+rectWidth),...
%     %         round(facePoints.subnasale(1)-rectWidth):round(facePoints.subnasale(1)+rectWidth)) = 0;
%     %     image(round(facePoints.mouth(2)-rectWidth):round(facePoints.mouth(2)+rectWidth),...
%     %         round(facePoints.mouth(1)-rectWidth):round(facePoints.mouth(1)+rectWidth)) = 0;
%     %     image(round(facePoints.foreheadtop(2)-rectWidth):round(facePoints.foreheadtop(2)+rectWidth),...
%     %         round(facePoints.foreheadtop(1)-rectWidth):round(facePoints.foreheadtop(1)+rectWidth)) = 0;
%
%     xMiddle = (facepoints.righteye(1) - facepoints.lefteye(1))/2;
%     xCenter = facepoints.lefteye(1) + xMiddle;
%
%     yMiddle = (facepoints.chin(2) - facepoints.foreheadtop(2))/2;
%     yCenter = facepoints.foreheadtop(2) + yMiddle;
%
%     facepoints.faceCenter = [xCenter,yCenter];
%
%     image(round(facepoints.faceCenter(2)-10):round(facepoints.faceCenter(2)+10),...
%           round(facepoints.faceCenter(1)-10):round(facepoints.faceCenter(1)+10)) = 0;
%
% %     imagesc(image);
%
%
%     % Save the new location file including face centers.
%
%     save(fullfile(home,'locations1',[facePaths{iImg}(length(fullfile(home,'faces'))+2:end),'.mat']),'facepoints');
% end