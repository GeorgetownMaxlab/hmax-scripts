%% 
clear; clc; close;
load('C:\Users\levan\HMAX\annulusExptFixedContrast\s11\normalized\exptDesign.mat')
load('C:\Users\levan\HMAX\annulusExptFixedContrast\s11\normalized\facesLoc.mat')
lineWidth = 1;
set(groot,'defaultLineLineWidth',lineWidth)


%% start script
% imshow(mask{1})

% binarize all masks
cutOffValue = 0.005;
for iMask = 1:length(mask)
   mask_bin{iMask} = mask{iMask} > cutOffValue;
   idx = find(mask{iMask} > cutOffValue);
%    figure
%    imshow(mask_bin{1})
   vignette_bin{iMask}  = vignette{iMask}.*mask_bin{iMask};
   mean_vignette(iMask) = mean(vignette{iMask}(idx));
   max_vignette(iMask)  = max (vignette{iMask}(idx));
   min_vignette(iMask)  = min (vignette{iMask}(idx));   
   
   michelson_values(iMask) = (max_vignette(iMask) - min_vignette(iMask))/...
                           (max_vignette(iMask) + min_vignette(iMask));
   weber_values(iMask) =       (max_vignette(iMask) - min_vignette(iMask))/...
                           mean_vignette(iMask);
end
% imshow(mask_bin{1})
% imshow(vignette_bin{1})

%% scatterplot
% scatter(michelson_values,weber_values,7,...
%         'MarkerEdgeColor','k',...
%         'MarkerFaceColor',[0 .75 .75])
% title('Scatterplot of michelson and Weber Values')
% xlabel('michelson')
% ylabel('Weber')
% grid on

%% Categorize images into low/high/med, cut out face locations and write to separate folders.

% sort the values
[sort_michelson_values, idx_sorted_michelson_values] = sort(michelson_values,'ascend');
sorted_facesLoc = facesLoc{1}(idx_sorted_michelson_values);
sorted_position = position(idx_sorted_michelson_values);

% Start low.
halfWidth = 80;
giantFaceCutOut = [];
idx = find(sort_michelson_values >= 0.54);
imgCounter = 1;

%% Start loop
% for iImg = idx
%     iImg
%         faceBox = [sorted_position{iImg}(2)-halfWidth ...
%                    sorted_position{iImg}(2)+halfWidth ...
%                    sorted_position{iImg}(1)-halfWidth ...
%                    sorted_position{iImg}(1)+halfWidth]; %[x1 x2 y1 y2]
%                    % x1 is the leftmost coordinate of the box.
%                    % x2 is the rightmost coordinate of the box.
%                    % y1 is the topmost.
%                    % y2 is the bottommost.
%                    
%                    % Now crop.
%                    img = imread(sorted_facesLoc{iImg});
%                    faceCutOut = img(faceBox(3):faceBox(4),...
%                               faceBox(1):faceBox(2));
%                    faceCutOut = padarray(faceCutOut,[20,2],255);
%                    giantFaceCutOut = [giantFaceCutOut; faceCutOut];
% %                    imshow(img(faceBox(3):faceBox(4),...
% %                               faceBox(1):faceBox(2)));
%     imwrite(faceCutOut,...
%     ['C:\Users\levan\HMAX\annulusExptFixedContrast\s11\normalized\categorizedImages\above0.54\'...
%     int2str(iImg) '_ofLowImages_'...
%     int2str(idx_sorted_michelson_values(iImg)) '_ofAllImages_contrast='...
%     num2str(sort_michelson_values(iImg)) '.png']);
% imgCounter = imgCounter + 1;
% end
% imwrite(giantFaceCutOut,...
%     ['C:\Users\levan\HMAX\annulusExptFixedContrast\s11\normalized\categorizedImages\above0.54\'...
%     'giantImage.png']);
% 

%% Choose 320 images of top contrasts and make sure they have good variability of images.

% Plot histogram of contrasts 
nTopImgs = 320;
topImgsContrast = sort_michelson_values(end-nTopImgs+1:end);
subplot(2,2,1)
hist(topImgsContrast,50)
title({['Contrast Distribution in the Top ' int2str(nTopImgs) ' Images','Example'];...
    ['Mean is ' num2str(mean(topImgsContrast))]});
hold on
plot(ones(1,40)*mean(topImgsContrast),1:40,'r','lineWidth',2)
hold off

% Plot the distribution of positions. 
topImgsPositions = positionAngle(idx_sorted_michelson_values(end-nTopImgs+1:end))
nQuad1 = numel(find((topImgsPositions >= 0 & topImgsPositions < 90) | ...
    topImgsPositions == 360))
nQuad2 = numel(find(topImgsPositions >= 90  & topImgsPositions < 180))
nQuad3 = numel(find(topImgsPositions >= 180 & topImgsPositions < 270))
nQuad4 = numel(find(topImgsPositions >= 270 & topImgsPositions < 360))
assert(nQuad1+nQuad2+nQuad3+nQuad4 == length(topImgsPositions));
subplot(2,2,2)
bar([nQuad1,nQuad2,nQuad3,nQuad4])
title('Number of images positioned in different quadrants')
barTitles = {'0-90' '90-180' '180-270' '270-360'};
set(gca,'XTickLabel',barTitles)
xlabel('Degrees')

% Plot distribution of face identities.
totalUniqueFaces = numel(unique(faceImg))
topImgsFaces = faceImg(idx_sorted_michelson_values(end-nTopImgs+1:end))
nTopImgsUniqueFaces = numel(unique(topImgsFaces))
[topImgsUniqueFaces,ia_faces,ic_faces] = unique(topImgsFaces)
subplot(2,2,3)
hist(ic_faces,nTopImgsUniqueFaces)
title(['Distribution of the ' int2str(nTopImgsUniqueFaces) ' Unique Face Identities'])
xlabel('Each number is a distinct face identity');

% Plot distribution of bg images.
% close
totalUniqueBg = numel(unique(bgImg));
topImgsBg = bgImg(idx_sorted_michelson_values(end-nTopImgs+1:end));
nTopImgsUniqueBg = numel(unique(topImgsBg));
[topImgsUniqueBg,ia_bg,ic_bg] = unique(topImgsBg);
subplot(2,2,4)
hist(ic_bg,nTopImgsUniqueBg)
title(['Distribution of the ' int2str(nTopImgsUniqueBg) ' Unique Background Images']);
xlabel('Each number is a distinct Background Image');

%% Selectively show low contrast images. 
edges = 1:nTopImgsUniqueBg+1; % this will create the edges of the bins within
% which to count up the frequency of occurrence of indices pf particular bg
% images. 
N = histcounts(ic_bg,edges);

[sorted_freq_of_each_bg,idx_sorted_freq_of_each_bg] = sort(N,'ascend');

sorted_topImgsUniqueBg_by_frequency = topImgsUniqueBg(idx_sorted_freq_of_each_bg);

giantImg = [];
for iRep = 1:length(sorted_topImgsUniqueBg_by_frequency)
    sorted_topImgsUniqueBg_by_frequency{iRep} = ...
        strrep(sorted_topImgsUniqueBg_by_frequency{iRep},...
        '/home/scholl/Desktop/Florence/Expt_Model_Loc_Sept2015/AnnulusBackground1/',...
        'C:/Users/levan/HMAX/annulusExptFixedContrast/AnnulusBackground1/');

    giantImg = [giantImg; imread(sorted_topImgsUniqueBg_by_frequency{iRep})];
end
imwrite(giantImg,'C:\Users\levan\backgrounds.png');
% create a giant horizontal image.

% create a vertical plot to show the frequencies of these images. 
plot(sorted_freq_of_each_bg,[1:length(sorted_freq_of_each_bg)])
set(gca, 'ydir', 'reverse');
ylabel('background images');
% ylim([1 30]);
xlabel('Frequency of occurrence');
title('A plot of frequency of occurance for bg images within top 320 annulus images');

%% How about, instead of frequency of occurrence we measure the actual contrast of the background images.
close;
bgImgPaths = lsDir('C:\Users\levan\HMAX\annulusExptFixedContrast\AnnulusBackground1',...
                  {'jpg'});
              
for iBg = 1:length(bgImgPaths)
   bgImgs{iBg} = double(imread(bgImgPaths{iBg}));
   michelson_bg(iBg) = (max(bgImgs{iBg}(:)) - min(bgImgs{iBg}(:)))/...
                           (max(bgImgs{iBg}(:)) + min(bgImgs{iBg}(:)));
end

[sorted_michelson_bg, idx_sorted_michelson_bg] = sort(michelson_bg,'ascend');
% ax.XTickLabelRotation = 45
plot(sorted_michelson_bg);
title('Michelson Values for the Background Images')
xlabel('Images')
ylabel('Michelson Value')
% ax.XTick = 0:1:length(sorted_michelson_bg)

sorted_bgImgs = bgImgs(idx_sorted_michelson_bg);

% Now construct a giant image.
a = sorted_bgImgs;

nCol = 6

for r = 0:(length(a)/nCol)-1
    montageImg{r+1} = horzcat(a{r*nCol+1:r*nCol+nCol})
end
montageImg = uint8(vertcat(montageImg{:}));
% imshow(montageImg,'InitialMagnification',100);
imwrite(montageImg,'C:\Users\levan\Desktop\montageAll.png') 


%% Plot position distribution for all of the images
% Plot the distribution of positions. 
% nQuad1 = numel(find((positionAngle >= 0 & positionAngle < 90) | ...
%     positionAngle == 360))
% nQuad2 = numel(find(positionAngle >= 90  & positionAngle < 180))
% nQuad3 = numel(find(positionAngle >= 180 & positionAngle < 270))
% nQuad4 = numel(find(positionAngle >= 270 & positionAngle < 360))
% assert(nQuad1+nQuad2+nQuad3+nQuad4 == length(positionAngle));
% close
% % subplot(2,2,2)
% bar([nQuad1,nQuad2,nQuad3,nQuad4])
% title('Number of images positioned in different quadrants FOR ALL IMAGES')
% barTitles = {'0-90' '90-180' '180-270' '270-360'};
% set(gca,'XTickLabel',barTitles)
% xlabel('Degrees')