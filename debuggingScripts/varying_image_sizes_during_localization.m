%% image resizing problems

% localization script used to only look at the first image size to
% determine the scaling factor, which is a problem because some image sets
% contained images of more than one size. So in this script I've been
% tracking down the problem.

%% Understanding why cohort2 localization was different from rerunning all subjects localization.
% % both FB and wedge imgHits files are different.
% clear; clc; close all;
% % compare facesLoc.mat files
% coh2_facesLoc = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_2nd_cohort\inverted\data\patchSetAdam\lfwSingle50000\facesLoc.mat');
% all_facesLoc  = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\inverted\data\patchSetAdam\lfwSingle50000\facesLoc.mat');
% 
% coh2_facesLoc = convertFacesLocAnnulusFixedContrast(coh2_facesLoc.facesLoc,ispc)
% all_facesLoc  = convertFacesLocAnnulusFixedContrast(all_facesLoc.facesLoc,ispc)
% 
% coh2_facesLoc = coh2_facesLoc{1}';
% all_facesLoc  = all_facesLoc{1}';
% all_facesLoc_2nd_half = all_facesLoc(400:end); % image names seem to match.
% 
% for iCell = 1:length(all_facesLoc_2nd_half)
%     
%    sanityCheck(iCell) = strcmp(coh2_facesLoc{iCell}(end-20:end),all_facesLoc_2nd_half{iCell}(end-20:end));
%    
% end
% assert(isempty(find(sanityCheck == 0)));
% % actually load the images and compare. 
% 
% for iCell = 1:length(all_facesLoc_2nd_half)
%     if mod(iCell,100) == 0
%         iCell
%     end
%     img1 = imread(coh2_facesLoc{iCell});
%     img2 = imread(all_facesLoc_2nd_half{iCell});
%     sanityCheck_imgs(iCell) = isequal(img1,img2);
%     
% end
% 
% % code below compares whether the facesLoc in the parent folder matches the one that is saved as a copy during localization code.
% % inverted_facesLoc_parent = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\inverted\facesLoc.mat');
% % inverted_facesLoc_data_folder =  load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\inverted\data\patchSetAdam\lfwSingle50000\facesLoc.mat');
% % inverted_facesLoc_parent.facesLoc = convertFacesLocAnnulusFixedContrast(inverted_facesLoc_parent.facesLoc,ispc);
% % inverted_facesLoc_data_folder.facesLoc = convertFacesLocAnnulusFixedContrast(inverted_facesLoc_data_folder.facesLoc,ispc);
% % 
% % inverted_facesLoc_parent = inverted_facesLoc_parent.facesLoc{1}';
% % inverted_facesLoc_data_folder = inverted_facesLoc_data_folder.facesLoc{1}';
% % isequal(inverted_facesLoc_parent,inverted_facesLoc_data_folder)

%% Compare the reran localization
% clear; clc; close all;
% 
% coh1Wedge = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\inverted\data\patchSetAdam\lfwSingle50000\imgHitsWedge.mat');
% coh1FB    = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Invertedt\inverted\data\patchSetAdam\lfwSingle50000\imgHitsFaceBox.mat');
% all_subj_Wedge_rerun = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\inverted\data\patchSetAdam\lfwSingle50000\imgHitsWedge.mat');
% all_subj_FB_rerun    = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\inverted\data\patchSetAdam\lfwSingle50000\imgHitsFaceBox.mat');
% 
% % Now load the reran data:
% check_FB    = load('C:\Users\levan\HMAX\sandbox\all_subj\imgHitsFaceBox.mat');
% check_wedge = load('C:\Users\levan\HMAX\sandbox\all_subj\imgHitsWedge.mat');
% 
% % isequal(coh1Wedge.imgHitsWedge,all_subj_Wedge_rerun.imgHitsWedge(:,1:399))
% % isequal(coh1Wedge.imgHitsWedge(1:1000,:),check_wedge.imgHitsWedge)
% isequal(all_subj_Wedge_rerun.imgHitsWedge(1:1000,:),check_wedge.imgHitsWedge)
% isequal(all_subj_FB_rerun.imgHitsFaceBox(1:1000,:),check_FB.imgHitsFaceBox)

%% Why even locally rerunning doesnt match cohort 2 data?
% clear; 
% coh2_loc_FB = load('C:\Users\levan\HMAX\sandbox\coh2\imgHitsFaceBox.mat');
% allS_loc_FB = load('C:\Users\levan\HMAX\sandbox\all_subj\imgHitsFaceBox.mat');
% 
% allS_loc_FB.imgHitsFaceBox = allS_loc_FB.imgHitsFaceBox(:,400:800);
% 
% DIFF = allS_loc_FB.imgHitsFaceBox - coh2_loc_FB.imgHitsFaceBox;
% 
% [r,c] = find(DIFF ~= 0);

%% check sizes of images.
% clear; clc;
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_2nd_cohort\inverted\exptDesign.mat')
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\inverted\facesLoc.mat')
% 
% 
% for iCell = 1:length(facesLoc{1})
% 
%     sizes(iCell,1:2) = size(imread(facesLoc{1}{iCell}));
% end
% 
% 
% clear; close all;
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted\upright\facesLoc.mat')
% idx1 = 1;
% idx2 = 344;
% maxSize = 579;
% 
% img1 = imread(facesLoc{1}{idx1});
% img2 = imread(facesLoc{1}{idx2});
% 
% img1res = resizeImage(img1,maxSize);
% img2res = resizeImage(img2,maxSize);
% 
% imshow(uint8(img1res))
% figure
% imshow(uint8(img2res))

%% visualize differences in size of faces after resizing
% clear; clc; close all;
% maxSize = 579;
% 
% % training. Originals are 730x927 pixels
% exptDesign_Training = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\exptDesign.mat');
% facesLoc_Training = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\facesLoc.mat');
% facesLoc_Training = facesLoc_Training.facesLoc;
% 
% faceName = exptDesign_Training.faceName(1);
% imgOrig_training = imread(facesLoc_Training{1}{1});
% imgResi_training = resizeImage(imgOrig_training,maxSize);

%% 02/20/2017 We have fixed the localization code and rerun the analysis.
clear; clc; close all;
% Coh1 first 120 images should be the same between old and new data.

condition = 'part2Inverted_all_subj/upright';
nImgsSame = 120;

oldFB = load(fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\', condition,'\data\patchSetAdam\lfwSingle50000\localization_wrong\imgHitsFaceBox.mat'));
newFB = load(fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\', condition,'\data\patchSetAdam\lfwSingle50000\imgHitsFaceBox.mat'));

isequal(oldFB.imgHitsFaceBox,newFB.imgHitsFaceBox) % isn't equal
isequal(oldFB.imgHitsFaceBox(:,1:nImgsSame),newFB.imgHitsFaceBox(:,1:nImgsSame)) % they are equal!

oldWedge = load(fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\', condition,'\data\patchSetAdam\lfwSingle50000\localization_wrong\imgHitsWedge.mat'));
newWedge = load(fullfile('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\', condition,'\data\patchSetAdam\lfwSingle50000\imgHitsWedge.mat'));

isequal(oldWedge.imgHitsWedge,newWedge.imgHitsWedge) % isn't equal
isequal(oldWedge.imgHitsWedge(:,1:nImgsSame),newWedge.imgHitsWedge(:,1:nImgsSame)) % they are equal!
% Result: for cohort1, first 120 images results are the same. For cohort2,
% first 240 was expected to be the same but isn't. Then I realized, we
% actually changed how the faceBox area is defined, its now relative to the
% original size whereas previously it was hard coded as 100x100 pixel area.
% So even though image dimensions match, the faceBox results won't. Wedge
% results do actually match though!



