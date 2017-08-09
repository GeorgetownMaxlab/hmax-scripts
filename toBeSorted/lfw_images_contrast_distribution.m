% get natural contrast variation
clear; clc; close;
% images = lsDir('C:\Users\levan\HMAX\lfwcrop_grey\facesPNG',{'png'});
load('C:\Users\levan\HMAX\lfwcrop_grey\filePaths.mat')


parfor iImg = 1:length(images)
   iImg
   img = double(imread(images{iImg}));
   mean_image(iImg) = mean(img(:));
   max_image(iImg)  = max (img(:));
   min_image(iImg)  = min (img(:));   
   
   michelson_values(iImg) = (max_image(iImg) - min_image(iImg))/...
                           (max_image(iImg) + min_image(iImg));
                       
end