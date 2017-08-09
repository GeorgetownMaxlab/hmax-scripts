% Generate the inner and outer circle coordinates of the annulus images.

%% White annulus outlines on black image
clear; clc;
dbstop if error;
% 1-- Black image, 600*800pxs (size backgrounds)
Mat_black = zeros([600,800]);

% 2-- Cooords of circle between radius 6 and 8 degrees visual angle
% (1degree = 33 pxs, before redimensioning of the background to 1 deg, 40
% pxs)
pix_cerc = [];% coordinates x,y of the annulus relatively to the center of the screen
index_x = 1;
index_y = 1;
res = ([600 800]);% number of lines number of columns of the background once resized to 18.12 * 24.16 degrees visual angle
centerScreen=floor(res/2);% coordinates of the center of this image

for i_angle = 0:0.1:360
%     i_angle
    width = 5.8*33:8.3*33; % width of the original annulus.
    for i_ecc = width(end)% so its a single pixel circle. %5.8*33:8.3*33 %198:1:264% 6 to 8 degrees visual angle in pixels% 5.8, sinon avec 6 des images debordent un peu
      [A,B] = pol2cart(deg2rad(i_angle),i_ecc);%33 since here, one degree 33 pxs
      pix_cerc(index_x,1) = A;
      pix_cerc(index_x,2) = B;
      index_x = index_x+1;
      
    end
end
pix_cerc=round(pix_cerc);
% 3--Adjust the coordinates relatively to the center of the screen by
% shifting everything
pix_cerc_reref = [];
pix_cerc_reref(:,1) = [300-pix_cerc(:,2)];%the coordinates of the face (pxs) relatively to the center of the image. % !!!! lines expressed with y since in cartesian coordinates, lines correspond to the height, ie to Y. 
pix_cerc_reref(:,2) = [400+pix_cerc(:,1)];
coords_annulus=round(pix_cerc_reref);% coordinates

%% Besoin d'utiliser unique ?
for index_i=1:size(coords_annulus,1)
    Mat_black(coords_annulus(index_i,1),coords_annulus(index_i,2)) = 1;
end
imshow(Mat_black);

%% save the inner outline

save('C:\Users\Levan\HMAX\scripts\utils\annulusFlorence\outerOutline.mat',...
    'coords_annulus','Mat_black');