function facesLoc = convertFacesLocAnnulus(facesLoc)
%% replace linux file paths with windows.
% clear; clc;
% load('facesLocTraining.mat')

for i = 1:length(facesLoc{1})
    
%    facesLoc{1}{i} = strrep(facesLoc{1}{i},'/home/levan/HMAX/annulusExpt/Images_Faces_Backgrounds/background_with_faces_without_annulus_no_luminance_normalization_tsize=2.34/',...
%        'C:\Users\Levan\HMAX\annulusExpt\Images_Faces_Backgrounds\background_with_faces_without_annulus_no_luminance_normalization_tsize=2.34\');
 
     facesLoc{1}{i} = strrep(facesLoc{1}{i},'/home/levan/HMAX/annulusExpt/images2/',...
         'C:\Users\Levan\HMAX\annulusExpt\images2\');
    
end

% save('facesLocWin.mat','facesLoc');
end