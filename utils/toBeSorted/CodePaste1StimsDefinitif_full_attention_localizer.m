%% 11032014
%% Florence Campana

% Code to paste two elements among four positions

%% Florence Campana, 28022014
%% This script pastes 4 faces in the background (takes all the background in the folder ? to create images before the  expoeriment)
%% We want that the images subtend 18.12 * 24.16 degrees visual angle to match the size in the fMRI so that we know that the proportions height/width are kept
%% This should also enable me to give as an input the size of the face to paste as well as the eccentricity
function [fce,bg,pastedimage,coords1,X1,Y1,vignette1]=CodePaste1StimsDefinitif_full_attention_localizer(tsize,tecc,tangle,params,bg,fce,mskfce,itrial,ResScreen,ScreenSize)
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

%% +++++++ PARAMS TO USE, OF THE SCANNER +++++++++++++++++++++++++++++++++++
    params.resScreen=ResScreen;
    params.sizScreen=ScreenSize./10;%in cms
    params.distScreen=105;
    
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


mskImage1=imread(mskfce);




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
res = res([1 2]);% number of lines number of columns of the background once resized to 18.12 * 24.16 degrees visual angle
centerScreen=floor(res/2);% coordinates of the center of this image
[X1,Y1]=pol2cart(deg2rad(tangle),tecc.*degInPx1(1));
%[X3,Y3]=pol2cart(deg2rad(tangle(3)),tecc(3)*degInPx1(1));
%[X4,Y4]=pol2cart(deg2rad(tangle(4)),tecc(4)*degInPx1(1));

%% CAUTION, HERE I CHANGED FROM MY OLD CODE centerScreen(2) then centerScreen(1) while I did the reverse, which was not in accordance with their code
 posface1 =[centerScreen(1)-Y1 centerScreen(2)+X1];%the coordinates of the face (pxs) relatively to the center of the image. % !!!! lines expressed with y since in cartesian coordinates, lines correspond to the height, ie to Y. 

coords1=round(posface1);% coordinates of the position of face expressed as integers [Y X]

Image1=double(tImage1)/255;
background=double(bgImage)/255;
mask1=double(mskImage1)/255;



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
%%ratio1=(degInPx1*tsize)/max(size(tImage{1}));% ratio = desired size of the target expressed divided by the longest dimension of the image (both are expressed in pixels).r

%% 01 avril, the pictures of the natural faces have a big void around them
%% THerefore, if we entered a desired size of two degree, they will be smaller
%% But they approximately all have the same void around, actually the void is smaller over the height
% We have ~ 14.3 for the height of the picture, but 12.8 for the face
% itself, meaning that the height of the images is 1.17 times the height
% of the face. Followingly, to get a face of height 2 degs, I ask for 2 *
% 1.17 ~ 2.34 degs. In the parameters. And the resizing operates over the
% height, so it's the height of the face that will be 2 degs.
ratio1 = (degInPx1*tsize)/size(tImage1,1);% since size(tImage1,1) is the height of the image

%mask1= imresize(mask1,[size(Image1,1) size(Image1,2)]);
%% This would have been to get squared faces
%ttoPaste1=imresize(Image1,[degInPx*tsize,degInPx*tsize]);% Makes squared faces It will create a face of the desired size (to try, I would think more direct to use mresize(vignette,[bncols, nbrows]) but it requires to give the desired size in pxs rather than in degrees, what might not be so comfortable while changing of computer etc.
%MtoPaste1=imresize(mask1,[degInPx*tsize,degInPx*tsize]);%% JE NE SAIS PAS BIEN COMMENT FAIRE ICI ...ca depend si jutilise le meme masque pour toutes les images

% Resize in one direction only 
ttoPaste1=imresize(Image1,ratio1);%% From Jacob, it resizes the image but keeps the length over width
MtoPaste1=imresize(mask1,ratio1);
ttoPasteSize1=size(ttoPaste1);% MtoPaste1 has the same size
   

   
% Coordinates of the patch of background where the face will be pasted
TopbgCoords1=[max(1,coords1(1)-ceil((ttoPasteSize1(1)-1)/2)) ,... % coords1 is [lines cols] as well as ttoPasteSize1
        min(size(background,1), coords1(1)+floor((ttoPasteSize1(1)-1)/2)) ,...
        max(1, coords1(2)-ceil((ttoPasteSize1(2)-1)/2)) ,...
        min(size(background,2), coords1(2)+floor((ttoPasteSize1(2)-1)/2)) ]
bgCoords1=background(TopbgCoords1(1):TopbgCoords1(2),TopbgCoords1(3):TopbgCoords1(4));%% Value of the background color at each pixel where the face will be pasted in. TopbgCoords(1):TopbgCoords(2) corresponds to the pixels x1 to xn for a face (rectangle image), TopbgCoords(1):TopbgCoords(2)  whose position once pasted will be occupying from yi to yz and from yi to yz
  




%----------------------Luminance equalization-------------------------------
vignette21=stretch_histogram(ttoPaste1,bgCoords1);%% The face is returned while in the color range of the background (values below that of the patch and above take themin and max values of the patch respectively and there is a linear mapping between both).
vignette21 = ttoPaste1; fprintf('LUMINANCE NORMALIZATION IS OFF!!\n');
vignette1=vignette21;




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
%                 disp('true')
                indexmasktest234=256;
                imgRes(imgCoord1(1),imgCoord1(2))=MtoPaste1(i,j)*vignette1(i,j) ...% (1-MtoPaste(i,j))*background(imgCoord(1),imgCoord(2)) where the mask is 0, it is the background ()*face+1*background=background), where the mask is 1 ie white it becomes the face ()+ the face=face))
                    + (1-MtoPaste1(i,j))*background(imgCoord1(1),imgCoord1(2));
             end
             
             
             
             
             
       end
end
    

    
       

    pastedimage(:,:) = floor(imgRes(:,:)*255);
    % Added by Levan to resize pastedimage to 730x927, dimensions of images
    % presented to subjects during the experiment.
    pastedimage = imresize(pastedimage,[730 927]);
    pasted{itrial}=pastedimage;
   
end