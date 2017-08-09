%%v1 car probleme d'ombre autour des visages quand deux fois le meme
%%visage, un probleme avec les ratios etc.

%% 11032014
%% Florence Campana

% Code to paste two elements among four positions

%% Florence Campana, 28022014
%% This script pastes 4 faces in the background (takes all the background in the folder ? to create images before the  expoeriment)
%% We want that the images subtend 18.12 * 24.16 degrees visual angle to match the size in the fMRI so that we know that the proportions height/width are kept
%% This should also enable me to give as an input the size of the face to paste as well as the eccentricity
function [fce,bg,pastedimage,coords1,coords2,X1,Y1,X2,Y2,tImage2]=CodePaste3StimsDefv11(tsize,tecc,tangle,params,bg,nfce,msknfce,fce,mskfce,itrial,ResScreen,ScreenSize)
EcartMean=[];Ecartstd=[];   meanrefmat=[];meanstdmat=[];pasted={};
Garde=[];
%% Inputs
    % condition: 'C1', 'C2', 'C3' or 'C4' according to the position where the face is pasted   
    % tangle the angle for the location where we put the face. In degrees. 
    % tecc the eccentricity in degrees, expressed relatively to the center
    % of the screen. 
    % tsize the size of the face in degrees.  
   
%% ++  it can be put into a script if it is adjusted for the path, to take the relevant image at each step. Images are created online rather than registered before the experiment 
%% WOULD STILL BE GOOD TO KNOW HOW LONG IT TAKES TO RUN THIS CODE IN ORDER TO HAVE STILL ACCURATE TIMINGS OVER AN EXPERIMENT
%     Params contains the fields sizScreen distScreen resScreen, for instance for the computer room (not a big deal since we will give in
%     DrawTexture the size in pixels)
%     params.sizScreen
%     params.distScreen
%     params.resScren

addpath ..

%% +++++++ PARAMS TO USE, OF THE SCANNER +++++++++++++++++++++++++++++++++++
    params.resScreen=ResScreen;
    params.sizScreen=ScreenSize./10;% in cms
    params.distScreen=60;
    
%     params.resScreen=[768 1024];
%      params.sizScreen=[30.3 37.8];
%      params.distScreen=60;
%% +++++++ PARAMS TO USE, OF THE SCANNER +++++++++++++++++++++++++++++++++++

%     params.resScreen=[768 1024];
%     params.sizScreen=[30.3 37.8];
%     params.distScreen=60;

tImage{1}=(fce);
tImage1=tImage{1};
if size(tImage1,3)==3
tImage1=rgb2gray(tImage1);
end


tImage{2}=imread(nfce);
tImage2=tImage{2};
if size(tImage2,3)==3
tImage2=rgb2gray(tImage2);
end



mskImage1=imread(mskfce);

msknfce=imread(msknfce);
if size(msknfce,3)==3
msknfce=rgb2gray(msknfce);
end


% tImage3{2}=imread(nfce2);
% tImage3=tImage3{2};
% if size(tImage3,3)==3
% tImage3=rgb2gray(tImage3);
% end
% msknfce2=imread(msknfce2);
% msknfce3=rgb2gray(msknfce2);
% 



bgImage=imread(bg);% bgImage the matrix with one value per pixel, corresponding to the RGB value (grey, so only one value per pixel rather than 3 in colored images)

%% Colors expressed between 0 and 1




%% !!! The central parameter ? size    
degperpix=2*((atan(params.sizScreen./(2*params.distScreen))).*(180/pi))./params.resScreen;% Number of degrees in one pixel 
% degInPx previously in the code was 1/degperpix(1) [supposedly the same in width and height]. But here, with a
% resolution of 768 * 1024, given the size of the screen, the pixels do not
% have a squared size. I might then change the parameters. For instance,
% give the resolution and the size of the scanner screen. This makes sense,
% it will be the aim, I just need to have the good proportion in degrees
% and for that, I need squared pixels at this stage I guess. Then, on each
% different monitors, I will give to DrawTexture the desired size in pixels
% to get 18.12 degs * 24.16, but at least I will be certain that the images
% themselves are ok.
degInPx1=1./degperpix(1);
degInPx2=1./degperpix(2);
%degInPx=1./degperpix; equivalent degInPx=1/(atand((params.sizScreen(1)/2)/params.distScreen)/(params.resScreen(1)/2));
%degInPx=tand(1)*params.distScreen*params.resScreen(1)/params.sizScreen(1);
ToResizeBg=[degInPx1*18.12 degInPx2*24.16];% 18.12 MUST BE THE FIRST SINCE THIS WILL BE THE INPUT OF IMRESIZE, WHICH TAKES NUMBER ROWS, NUMBER COLUMNS AS ARGUMENT. Aim:have a background of the size in degrees visual angle of that in the scanner (pilot done by Xiong). It seems important to me to display, but also since the size of the faces I measures (2.5 degrees visual angle) was for this size of background. So this is crucial to keep the ratio between the background and the image.
bgImage=imresize(bgImage,ToResizeBg);
% CAUTION, MADE BY ME
%params.sizeIm=params.resScreen;
%res = params.sizeIm;
res=size(bgImage);%% 
res = res([1 2]);
centerScreen=floor(res/2);% coordinates of the center of this image
[X1,Y1]=pol2cart(deg2rad(tangle(1)),tecc(1).*degInPx1(1));

 [X2,Y2]=pol2cart(deg2rad(tangle(2)),tecc(2).*degInPx1(1));
% [X3,Y3]=pol2cart(deg2rad(tangle(3)),tecc(3).*degInPx1(1));

%[X3,Y3]=pol2cart(deg2rad(tangle(3)),tecc(3)*degInPx1(1));
%[X4,Y4]=pol2cart(deg2rad(tangle(4)),tecc(4)*degInPx1(1));

%% CAUTION, HERE I CHANGED FROM MY OLD CODE centerScreen(2) then centerScreen(1) while I did the reverse, which was not in accordance with their code
posface1 =[centerScreen(1)-Y1 centerScreen(2)+X1];%the coordinates of the face (pxs) relatively to the center of the image. % !!!! lines expressed with y since in cartesian coordinates, lines correspond to the height, ie to Y. 
% posface1 =[centerScreen(1)-X1 centerScreen(2)+Y1];%the coordinates of the face (pxs) relatively to the center of the image. % !!!! lines expressed with y since in cartesian coordinates, lines correspond to the height, ie to Y. 

coords1=round(posface1);% coordinates of the position of face expressed as integers [Y X]
posface2 =[centerScreen(1)-Y2 centerScreen(2)+X2];%the coordinates of the face (pxs) relatively to the center of the image. % !!!! lines expressed with y since in cartesian coordinates, lines correspond to the height, ie to Y. 
coords2=round(posface2);% coordinates of the position of face expressed as integers [Y X]
   
% posface3 =[centerScreen(1)-Y3 centerScreen(2)+X3];%the coordinates of the face (pxs) relatively to the center of the image. % !!!! lines expressed with y since in cartesian coordinates, lines correspond to the height, ie to Y. 
% coords3=round(posface3);% coordinates of the position of face expressed as integers [Y X]
% 

Image1=double(tImage1)/255;
Image2=double(tImage2)/255;
background=double(bgImage)/255;
mask1=double(mskImage1)/255;
mask2=double(msknfce)/255;
% Image3=double(tImage3)/255;
%mask3=double(msknfce3)/255;



%% I will always paste the same
% tImage2=tImage{2};
% Image2=double(tImage2)/255;
% mask2=double(mskImage2)/255;
% 
% tImage3=tImage{3};
% Image3=double(tImage3)/255;
% mask3=double(mskImage3)/255;
% 
% tImage4=tImage{4};
% Image4=double(tImage4)/255;
% mask4=double(mskImage4)/255;
%% DONE BY FLORENCE TO HAVE A FACE THAT IS TSIZE * TSIZE RATHER THAN TSIZE IN ONLY ONE DIRECTION, IN ORDER TO MATCH THE STIMULI USED IN THE FMRI PILOT

%% 06042014, Comments about what was in the code CodePaste2StimsDef.m
% Ratio 1 * plus grande dimension du visage = taille voulue de l'image
ratio1=(degInPx1*tsize)/max(size(tImage{1}));% ratio = desired size of the target expressed divided by the longest dimension of the image (both are expressed in pixels).
% Mask1 est le mask1 mais resize a la taille de l'image1 (mais avant que l'image une ne soit resizee)
%% Commente le 06042014 mask1= imresize(mask1,[size(Image1,1) size(Image1,2)]);
% Ratio 2 * plus grande dimension de l'image 2 = taille voulue de l'image
ratio2=(degInPx1*tsize)/max(size(tImage2));% ratio = desired size of the target expressed divided by the longest dimension of the image (both are expressed in pixels).
%% Commente le 06042014 % Mask2 est le mask2 mais resize a la taille de l'image2 (mais avant que l'image une ne soit resizee)
%% mask2= imresize(mask2,[size(Image2,1) size(Image2,2)]);

%ratio3=(degInPx1*tsize)/max(size(tImage3));% ratio = desired size of the target expressed divided by the longest dimension of the image (both are expressed in pixels).

% Resize in one direction only 
ttoPaste1=imresize(Image1,ratio1);%% From Jacob, it resizes the image but keeps the length over width
MtoPaste1=imresize(mask1,ratio1); %% 06042014 Mask1 devrait avoir la taille de l'image1 donc on devrait pouvoir appliquer la correction par le meme ratio
ttoPasteSize1=size(ttoPaste1);% MtoPaste1 has the same size
   
ttoPaste2=imresize(Image2,[size(ttoPaste1,1) size(ttoPaste1,2)]);%% Pour avoir la meme taille d'image 1 et 2, car le ratio n'est pas forcement le meme donc multiplier par un certain facteur ne suffit pas
MtoPaste2=imresize(mask2,[size(ttoPaste1,1) size(ttoPaste1,2)]);% pour etre sur qu'on a la meme taille d'image 1 et 2 (sinon multiplier par un ratio ne permet pas d'avoir la meme taille)
ttoPasteSize2=size(ttoPaste2);% MtoPaste1 has the same size

% Commente le 06042014 MtoPaste2=imresize(mask2,[size(MtoPaste1,1) size(MtoPaste1,2)]);% pour etre sur qu'on a la meme taille d'image 1 et 2 (sinon multiplier par un ratio ne permet pas d'avoir la meme taille)

% ttoPaste3=imresize(Image3,[size(ttoPaste1,1) size(ttoPaste1,2)]);%% Pour avoir la meme taille d'image 1 et 2, car le ratio n'est pas forcement le meme donc multiplier par un certain facteur ne suffit pas
% MtoPaste3=imresize(mask3,[size(ttoPaste1,1) size(ttoPaste1,2)]);% pour etre sur qu'on a la meme taille d'image 1 et 2 (sinon multiplier par un ratio ne permet pas d'avoir la meme taille)
% ttoPasteSize3=size(ttoPaste3);


   
% Coordinates of the patch of background where the face will be pasted
TopbgCoords1=[max(1,coords1(1)-ceil((ttoPasteSize1(1)-1)/2)) ,... % coords1 is [lines cols] as well as ttoPasteSize1
        min(size(background,1), coords1(1)+floor((ttoPasteSize1(1)-1)/2)) ,...
        max(1, coords1(2)-ceil((ttoPasteSize1(2)-1)/2)) ,...
        min(size(background,2), coords1(2)+floor((ttoPasteSize1(2)-1)/2)) ];
bgCoords1=background(TopbgCoords1(1):TopbgCoords1(2),TopbgCoords1(3):TopbgCoords1(4));%% Value of the background color at each pixel where the face will be pasted in. TopbgCoords(1):TopbgCoords(2) corresponds to the pixels x1 to xn for a face (rectangle image), TopbgCoords(1):TopbgCoords(2)  whose position once pasted will be occupying from yi to yz and from yi to yz
  

TopbgCoords2=[max(1,coords2(1)-ceil((ttoPasteSize2(1)-1)/2)) ,... % coords1 is [lines cols] as well as ttoPasteSize1
        min(size(background,1), coords2(1)+floor((ttoPasteSize2(1)-1)/2)) ,...
        max(1, coords2(2)-ceil((ttoPasteSize2(2)-1)/2)) ,...
        min(size(background,2), coords2(2)+floor((ttoPasteSize2(2)-1)/2)) ];
bgcoords2=background(TopbgCoords2(1):TopbgCoords2(2),TopbgCoords2(3):TopbgCoords2(4));%% Value of the background color at each pixel where the face will be pasted in. TopbgCoords(1):TopbgCoords(2) corresponds to the pixels x1 to xn for a face (rectangle image), TopbgCoords(1):TopbgCoords(2)  whose position once pasted will be occupying from yi to yz and from yi to yz
 

% TopbgCoords3=[max(1,coords3(1)-ceil((ttoPasteSize3(1)-1)/2)) ,... % coords1 is [lines cols] as well as ttoPasteSize1
%         min(size(background,1), coords3(1)+floor((ttoPasteSize3(1)-1)/2)) ,...
%         max(1, coords3(2)-ceil((ttoPasteSize3(2)-1)/2)) ,...
%         min(size(background,2), coords3(2)+floor((ttoPasteSize3(2)-1)/2)) ];
% bgcoords3=background(TopbgCoords3(1):TopbgCoords3(2),TopbgCoords3(3):TopbgCoords3(4));%% Value of the background color at each pixel where the face will be pasted in. TopbgCoords(1):TopbgCoords(2) corresponds to the pixels x1 to xn for a face (rectangle image), TopbgCoords(1):TopbgCoords(2)  whose position once pasted will be occupying from yi to yz and from yi to yz
%  


%----------------------Luminance equalization-------------------------------
vignette21=stretch_histogram(ttoPaste1,bgCoords1);%% The face is returned while in the color range of the background (values below that of the patch and above take the min and max values of the patch respectively and there is a linear mapping between both).
vignette1=vignette21;

vignette22=stretch_histogram(ttoPaste2,bgcoords2);%% The face is returned while in the color range of the background (values below that of the patch and above take themin and max values of the patch respectively and there is a linear mapping between both).
vignette2=vignette22;

% vignette23=stretch_histogram(ttoPaste3,bgcoords3);%% The face is returned while in the color range of the background (values below that of the patch and above take themin and max values of the patch respectively and there is a linear mapping between both).
% vignette3=vignette23;


%vignette1=0.5*ttoPaste1+0.5*vignette21; Certainly to increase contrast but
%this is not very clean

%----------------------Other kind of transformation for the equalisation ? some relying on the SHINE toolbox -------------------------------
%StretchToBackThenEqualiseMeanLum   
%EqualiseHist
%EqualiseMeanLum
%EqMatlab
%StrechThenEqualiseHist
%vignette1=0.5*ttoPaste1+0.5*vignette21{1};
%vignette1=0.5*ttoPaste1+0.5*vignette21;
%S2tretchWholeThenPatch
%StretchPatch
%----------------------------------------------------------------------
 imgRes=background;
 for i=1:ttoPasteSize1(1)%% 1 to the size of the image with the face to be pasted in (X)
      for j=1:ttoPasteSize1(2)%% 1 to the size of the image with the face to be pasted in (Y)
            % Think that axis aren't the same!!!
            imgCoord1(1)=round(i-1+coords1(1)-floor(ttoPasteSize1(1)/2));%% !!! La encore, je ne comprends pas le -1, mais imgCoord(1) ce sont toutes les coordonnees en x du visage la ou il va etre colle
            imgCoord1(2)=round(j-1+coords1(2)-floor(ttoPasteSize1(2)/2));%% et toutes ses coordonnees en y(pouruoi ne pas prendre le TopbgCoords defini ci dessus (legerement different cependant avec des mins et max)
             if all(imgCoord1>=1) && all(imgCoord1<=size(background))
               % disp('true')
%                if nargin==13
%                 disp(indexCat)
%                end 
               %disp(fce)
               %disp(mskfce)
                

                indexmasktest234=256;
                imgRes(imgCoord1(1),imgCoord1(2)) = MtoPaste1(i,j)*vignette1(i,j) ...% (1-MtoPaste(i,j))*background(imgCoord(1),imgCoord(2)) where the mask is 0, it is the background ()*face+1*background=background), where the mask is 1 ie white it becomes the face ()+ the face=face))
                    + (1-MtoPaste1(i,j))*background(imgCoord1(1), imgCoord1(2));
             end
             
      end
 end
 
 for i=1:ttoPasteSize2(1)%% 1 to the size of the image with the face to be pasted in (X)
      for j=1:ttoPasteSize2(2)%% 1 to the size of the image with the face to be pasted in (Y)
             imgCoord2(1)=round(i-1+coords2(1)-floor(ttoPasteSize2(1)/2));%% !!! La encore, je ne comprends pas le -1, mais imgCoord(1) ce sont toutes les coordonnees en x du visage la ou il va etre colle
             imgCoord2(2)=round(j-1+coords2(2)-floor(ttoPasteSize2(2)/2));%% et toutes ses coordonnees en y(pouruoi ne pas prendre le TopbgCoords defini ci dessus (legerement different cependant avec des mins et max)
           
             if all(imgCoord2>=1) && all(imgCoord2<=size(background))
                %disp('true')
                indexmasktest234=256;
                imgRes(imgCoord2(1),imgCoord2(2))=MtoPaste2(i,j)*vignette2(i,j) ...% (1-MtoPaste(i,j))*background(imgCoord(1),imgCoord(2)) where the mask is 0, it is the background ()*face+1*background=background), where the mask is 1 ie white it becomes the face ()+ the face=face))
                    + (1-MtoPaste2(i,j))*background(imgCoord2(1),imgCoord2(2));
             end
             
             
             
        end
end
%     
%  for i=1:ttoPasteSize3(1)%% 1 to the size of the image with the face to be pasted in (X)
%       for j=1:ttoPasteSize3(2)%% 1 to the size of the image with the face to be pasted in (Y)
%              imgCoord3(1)=round(i-1+coords3(1)-floor(ttoPasteSize3(1)/2));%% !!! La encore, je ne comprends pas le -1, mais imgCoord(1) ce sont toutes les coordonnees en x du visage la ou il va etre colle
%              imgCoord3(2)=round(j-1+coords3(2)-floor(ttoPasteSize3(2)/2));%% et toutes ses coordonnees en y(pouruoi ne pas prendre le TopbgCoords defini ci dessus (legerement different cependant avec des mins et max)
%            
%              if all(imgCoord3>=1) && all(imgCoord3<=size(background))
%                 %disp('true')
%                 indexmasktest234=256;
%                 imgRes(imgCoord3(1),imgCoord3(2))=MtoPaste3(i,j)*vignette3(i,j) ...% (1-MtoPaste(i,j))*background(imgCoord(1),imgCoord(2)) where the mask is 0, it is the background ()*face+1*background=background), where the mask is 1 ie white it becomes the face ()+ the face=face))
%                     + (1-MtoPaste3(i,j))*background(imgCoord3(1),imgCoord3(2));
%              end
%              
%              
%              
%         end
% end
%     
%     
% %%%
%  pastedimage(:,:) = ceil(imgRes(:,:)*255);
%     pasted{itrial}=pastedimage;
%     NomImage=strcat(condition,'_',num2str(itrial));
%     saveimage(pastedimage,NomImage,'jpeg')
% %%%

    pastedimage(:,:) = ceil(imgRes(:,:)*255);
    pasted{itrial}=pastedimage;
   
end