% Create mask for the backgrounds
%% 7 september 2015
%% White annulus on black image-- between radius 6degs/8degs


% % 1-- Black image, 600*800pxs (size backgrounds)
% Mat_black = zeros([730,927]);
% 
% % 2-- Cooords of circle between radius 6 and 8 degrees visual angle
% % (1degree = 33 pxs, before redimensioning of the background to 1 deg, 40
% % pxs)
% pix_cerc = [];% coordinates x,y of the annulus relatively to the center of the screen
% index_x = 1;
% index_y = 1;
% res = ([730 927]);% number of lines number of columns of the background once resized to 18.12 * 24.16 degrees visual angle
% centerScreen=floor(res/2);% coordinates of the center of this image
% 
% for i_angle = 0:0.1:360
%     for i_ecc = 5.8*40:8.33*40%5.8*33:8.3*33 %198:1:264% 6 to 8 degrees visual angle in pixels% 5.8, sinon avec 6 des images debordent un peu
%       [A,B] = pol2cart(deg2rad(i_angle),i_ecc);%33 since here, one degree 33 pxs
%       pix_cerc(index_x,1) = A;
%       pix_cerc(index_x,2) = B;
%       index_x = index_x+1;
%       
%     end
% end
% pix_cerc=round(pix_cerc);
% % 3--Adjust the coordinates relatively to the center of the screen by
% % shifting everything
% pix_cerc_reref = [];
% pix_cerc_reref(:,1) = [730/2-pix_cerc(:,2)];%the coordinates of the face (pxs) relatively to the center of the image. % !!!! lines expressed with y since in cartesian coordinates, lines correspond to the height, ie to Y. 
% pix_cerc_reref(:,2) = [927/2+pix_cerc(:,1)];
% coords_annulus=round(pix_cerc_reref);% coordinates
% 
% %% Besoin d'utiliser unique ?
% for index_i=1:size(coords_annulus,1)
%     Mat_black(coords_annulus(index_i,1),coords_annulus(index_i,2)) = 255;
% end
% 
% 
% %imshow(Mat_black);
% %% All the possible coordinates in the image
% MatAll = [];
% indexall = 1;
% for index_x = 1:730
%     index_x
%     for index_y = 1:927
%    MatAll(indexall,:) = [index_x,index_y];
%    indexall = indexall + 1;
%     end
%     
% end
% save C:\Users\levan\HMAX\annulusExptFixedContrast\creatingAnnulizedImages\allVars.mat
load('C:\Users\levan\HMAX\annulusExptFixedContrast\creatingAnnulizedImages\allVars.mat')

%% Mask each background through this annulus and save the results in a folder with the backgrounds used in this experiment
indeximage=1;    
[nomDir, NomFichierMat] = LookForFiles('C:\Users\levan\HMAX\annulusExptFixedContrast\backgroundsToBeUsed/');% liste tous les
    NomFichier_bg = sort(NomFichierMat);
    Mat_black = double(Mat_black)./255;
    for i_bg = 1:length(NomFichier_bg)
        nomf = strcat('C:\Users\levan\HMAX\annulusExptFixedContrast\backgroundsToBeUsed/',NomFichier_bg{i_bg});
        eval(['imread ' nomf]);
        bgtomask = ans;
        bgtomask = imresize(bgtomask,[730,927]);%% added in MAy2016, I dont know how it was working before, but here, since the backgrounds are 600*800 it is not suited to the annulus made for images of 730 * 927 which is the
        % size of the images displayed on the screen to avoid any resizing
        % that would change the shape of the annulus
        bgtomask = double(bgtomask)./255;
        new_im = Mat_black .* bgtomask;
        %% Replace pixels black and not in the annulus, so not of the background by gray color
        To_replace = setdiff(MatAll,coords_annulus,'rows');
        for index_i=1:size(To_replace,1)
            new_im(To_replace(index_i,1),To_replace(index_i,2)) = 128/255;
        end

     
        nomtosave = strcat('BackgroundsMay2016/',num2str(indeximage),'.png');
        saveimage(new_im,nomtosave);
        indeximage=indeximage+1;
    end

    
     
    
    
    