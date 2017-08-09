% visualize impact of normalization.
%% load relavant variables
clear; clc; close;
lineWidth = 1;
set(groot,'defaultLineLineWidth',lineWidth)

load('C:\Users\levan\HMAX\annulusExptFixedContrast\s10\normalized\trainingRuns\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat',...
    'sumStatsImg','sortSumStatsImg','imgHitsWedge')

% First, get the indices of training (or testing images)
load('C:\Users\levan\HMAX\annulusExptFixedContrast\s10\normalized\trainingFacesIdx.mat')

load('C:\Users\levan\HMAX\annulusExptFixedContrast\s10\normalized\exptDesign.mat')

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
%% now sort by michelsons contrast

% get only the training image mean vignette values. 
training_michelson_values = michelson_values(trainingFacesIdx);
[sort_training_michelson_values, idx_sorted_michelson_values] = sort(training_michelson_values,'ascend');

image_localization_sorted_by_michelson = sumStatsImg(idx_sorted_michelson_values);

%% now sort by typically defined contrast

% get only the training image mean vignette values. 
training_weber_values = weber_values(trainingFacesIdx);
[sort_training_weber_values, idx_sorted_weber_values] = sort(training_weber_values,'ascend');
 
image_localization_sorted_by_weber = sumStatsImg(idx_sorted_weber_values);

%% now plot stuff
load('C:\Users\levan\HMAX\annulusExptFixedContrast\s10\normalized\facesLocTraining.mat')
% hist(sortedStatsImg_weber)

%% Plot scatterplot of michelson and Weber contrast

scatter(training_michelson_values,training_weber_values,7,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 .75 .75])
title('Scatterplot of michelson and Weber Values')
xlabel('michelson')
ylabel('Weber')
grid on

%% Plot sorted michelson and weber

subplot(1,2,1)
plot(sort_training_michelson_values)
title('michelson')
xlabel('Images')
ylabel('michelson Value')
xlim([0 320])

subplot(1,2,2)
plot(sort_training_weber_values,'r')
title('Weber')
xlabel('Images')
ylabel('Weber Value')
xlim([0 320])


%% Plotting localization on Y and sorted contrast value on X.
% subplot(2,1,1)
% plot(image_localization_sorted_by_michelson)
% title('michelson')
% xlabel('Sorted by michelsons contrast, lowest -> highest')
% ylabel('Localization')
% xlim([0 320])
% 
% subplot(2,1,2)
% plot(image_localization_sorted_by_weber)
% xlabel('Sorted by typical contrast, lowest -> highest')
% title('Weber Contrast')
% ylabel('Localization')
% xlim([0 320])
%% Bin the michelson luminances into equal low, med, high.
% idxLow = 1:106;
% idxMed = 107:213;
% idxHigh = 214:320;
% 
% meanLow_michelson  = mean(image_localization_sorted_by_michelson(idxLow));
% stdLow_michelson   = std (image_localization_sorted_by_michelson(idxLow));
% stemLow_michelson  = stdLow_michelson/...
%     sqrt(numel(image_localization_sorted_by_michelson(idxLow)));
% 
% meanMed_michelson  = mean(image_localization_sorted_by_michelson(idxMed));
% stdMed_michelson   = std (image_localization_sorted_by_michelson(idxMed));
% stemMed_michelson  = stdMed_michelson/...
%     sqrt(numel(image_localization_sorted_by_michelson(idxMed)));
% 
% meanHigh_michelson = mean(image_localization_sorted_by_michelson(idxHigh));
% stdHigh_michelson  = std (image_localization_sorted_by_michelson(idxHigh));
% stemHigh_michelson  = stdHigh_michelson/...
%     sqrt(numel(image_localization_sorted_by_michelson(idxHigh)));
% 
% % subplot(1,2,1)
% % bar([meanLow_michelson meanMed_michelson meanHigh_michelson])
% % hold on
% % errorbar(1:3,[meanLow_michelson meanMed_michelson meanHigh_michelson],...
% %              [stemLow_michelson,stemMed_michelson,stemHigh_michelson],'.')
% % barTitles = {'Low michelson' 'Medium michelson' 'High michelson'};
% % set(gca,'XTickLabel',barTitles)
% % title('michelson Contrast')
% % ylabel('Localization')

%% Bin the Weber luminances into equal low, med, high.
% meanLow_weber = mean(image_localization_sorted_by_weber(idxLow));
% stdLow_weber = std(image_localization_sorted_by_weber(idxLow));
% stemLow_weber  = stdLow_weber/...
%     sqrt(numel(image_localization_sorted_by_weber(idxLow)));
% 
% meanMed_weber = mean(image_localization_sorted_by_weber(idxMed));
% stdMed_weber = std(image_localization_sorted_by_weber(idxMed));
% stemMed_weber  = stdMed_weber/...
%     sqrt(numel(image_localization_sorted_by_weber(idxMed)));
% 
% meanHigh_weber = mean(image_localization_sorted_by_weber(idxHigh));
% stdHigh_weber = std(image_localization_sorted_by_weber(idxHigh));
% stemHigh_weber  = stdHigh_weber/...
%     sqrt(numel(image_localization_sorted_by_weber(idxHigh)));
% 
% % subplot(1,2,2)
% % bar(1:3,[meanLow_weber meanMed_weber meanHigh_weber])
% % hold on
% % errorbar(1:3,[meanLow_weber meanMed_weber meanHigh_weber],...
% %              [stemLow_weber,stemMed_weber,stemHigh_weber],'.')
% % barTitles = {'Low Contrast' 'Medium Contrast' 'High Contrast'};
% % set(gca,'XTickLabel',barTitles)
% % title('Typical Contrast')
% % ylabel('Localization')
% % ylim([0 60]);

%% Visualizing the face images to double-check the accuracy of calculating the normalization






%% Create a giant image of cut-out faces!!!
% sortedFacesLoc_weber = facesLoc{1}(idx_sorted_weber_values);
% sortedFacesLoc_michelson = facesLoc{1}(idx_sorted_michelson_values);
% % montage(sortedFacesLoc_michelson(1:15));
% 
% position_trainingImgs = position(trainingFacesIdx);
% position_trainingImgs_sorted_michelson = position_trainingImgs(idx_sorted_michelson_values);
% position_trainingImgs_sorted_weber = position_trainingImgs(idx_sorted_weber_values);


% define the outline for low/med/high
% lowPaddingM = zeros(1,length(lowM));
% medPaddingM = 100*ones(1,length(medM));
% highPaddingM = 255*ones(1,length(highM));
% wholePaddingArrayM = [lowPaddingM medPaddingM highPaddingM];
% 
% lowPaddingW = zeros(1,length(lowW));
% medPaddingW = 100*ones(1,length(medW));
% highPaddingW = 255*ones(1,length(highW));
% wholePaddingArrayW = [lowPaddingW medPaddingW highPaddingW];
% 
% halfWidth = 80;
% giantFaceCutOut = [];
% for iImg = 1:length(position_trainingImgs_sorted_michelson)
%     iImg
%         faceBox = [position_trainingImgs_sorted_michelson{iImg}(2)-halfWidth ...
%                    position_trainingImgs_sorted_michelson{iImg}(2)+halfWidth ...
%                    position_trainingImgs_sorted_michelson{iImg}(1)-halfWidth ...
%                    position_trainingImgs_sorted_michelson{iImg}(1)+halfWidth]; %[x1 x2 y1 y2]
%                    % x1 is the leftmost coordinate of the box.
%                    % x2 is the rightmost coordinate of the box.
%                    % y1 is the topmost.
%                    % y2 is the bottommost.
%                    
%                    % Now crop.
%                    img = imread(sortedFacesLoc_michelson{iImg});
%                    faceCutOut = img(faceBox(3):faceBox(4),...
%                               faceBox(1):faceBox(2));
%                    faceCutOut = padarray(faceCutOut,[20,2],wholePaddingArrayM(iImg));
%                    giantFaceCutOut = [giantFaceCutOut; faceCutOut];
% %                    imshow(img(faceBox(3):faceBox(4),...
% %                               faceBox(1):faceBox(2)));
%     
% end
% imwrite(giantFaceCutOut,'C:\Users\levan/Desktop/giantFaceCutOut_michelson.png');

% for iImg = 1:length(position_trainingImgs_sorted_weber)
%     iImg
%         faceBox = [position_trainingImgs_sorted_weber{iImg}(2)-halfWidth ...
%                    position_trainingImgs_sorted_weber{iImg}(2)+halfWidth ...
%                    position_trainingImgs_sorted_weber{iImg}(1)-halfWidth ...
%                    position_trainingImgs_sorted_weber{iImg}(1)+halfWidth]; %[x1 x2 y1 y2]
%                    % x1 is the leftmost coordinate of the box.
%                    % x2 is the rightmost coordinate of the box.
%                    % y1 is the topmost.
%                    % y2 is the bottommost.
%                    
%                    % Now crop.
%                    img = imread(sortedFacesLoc_weber{iImg});
%                    faceCutOut = img(faceBox(3):faceBox(4),...
%                               faceBox(1):faceBox(2));
%                    faceCutOut = padarray(faceCutOut,[20,2],wholePaddingArrayW(iImg));
%                    giantFaceCutOut = [giantFaceCutOut; faceCutOut];
% %                    imshow(img(faceBox(3):faceBox(4),...
% %                               faceBox(1):faceBox(2)));
%     
% end
% imwrite(giantFaceCutOut,'C:\Users\levan/Desktop/giantFaceCutOut_Weber.png');

%% Bin the michelson luminances into low, med, high.

lowM  = find(training_michelson_values < 0.26);
medM  = find(training_michelson_values >= 0.26 & ...
             training_michelson_values < 0.55);             
highM = find(training_michelson_values >= 0.55);
assert(numel(lowM) + numel(medM) + numel(highM) == 320);

meanLow_michelson  = mean(sumStatsImg(lowM));
stdLow_michelson   = std (sumStatsImg(lowM));
stemLow_michelson  = stdLow_michelson/...
    sqrt(numel(sumStatsImg(lowM)));

meanMed_michelson  = mean(sumStatsImg(medM));
stdMed_michelson   = std (sumStatsImg(medM));
stemMed_michelson  = stdMed_michelson/...
    sqrt(numel(sumStatsImg(medM)));

meanHigh_michelson = mean(sumStatsImg(highM));
stdHigh_michelson  = std (sumStatsImg(highM));
stemHigh_michelson  = stdHigh_michelson/...
    sqrt(numel(sumStatsImg(highM)));

% subplot(1,2,1)
% bar([meanLow_michelson meanMed_michelson meanHigh_michelson])
% hold on
% errorbar(1:3,[meanLow_michelson meanMed_michelson meanHigh_michelson],...
%              [stemLow_michelson,stemMed_michelson,stemHigh_michelson],'.')
% barTitles = {'Low michelson' 'Medium michelson' 'High michelson'};
% set(gca,'XTickLabel',barTitles)
% title('michelson Contrast')
% ylabel('% Patches that Hit')

%% Bin the Weber luminances into equal low, med, high.
% bin the Weber distribution into low/med/high
lowW  = find(training_weber_values < 0.5);
medW  = find(training_weber_values >= 0.5 &...
             training_weber_values < 1);
highW = find(training_weber_values >= 1);
assert(numel(lowW) + numel(medW) + numel(highW) == 320);


meanLow_weber = mean(sumStatsImg(lowW));
stdLow_weber = std(sumStatsImg(lowW));
stemLow_weber  = stdLow_weber/...
    sqrt(numel(lowW));

meanMed_weber = mean(sumStatsImg(medW));
stdMed_weber = std(sumStatsImg(medW));
stemMed_weber  = stdMed_weber/...
    sqrt(numel(medW));

meanHigh_weber = mean(sumStatsImg(highW));
stdHigh_weber = std(sumStatsImg(highW));
stemHigh_weber  = stdHigh_weber/...
    sqrt(numel(highW));

% subplot(1,2,2)
% bar(1:3,[meanLow_weber meanMed_weber meanHigh_weber])
% hold on
% errorbar(1:3,[meanLow_weber meanMed_weber meanHigh_weber],...
%              [stemLow_weber,stemMed_weber,stemHigh_weber],'.')
% barTitles = {'Low Weber' 'Medium Weber' 'High Weber'};
% set(gca,'XTickLabel',barTitles)
% title('Weber Contrast')
% ylabel('% Patches that hit')

%% Sticking with michelson's going forward.

ranges = (0:0.1:max(training_michelson_values))

% Code below is if binning as a sliding window
% for iBin = 1:8
%     lowEnd = ranges(iBin);
%     if iBin == 8
%         uppEnd = max(training_michelson_values);
%     else
%         uppEnd = ranges(iBin+1);
%     end         
%     bins{iBin} = find(training_michelson_values >  lowEnd &...
%                    training_michelson_values <= uppEnd);
%         
%         % Now find best patches for these different bins.
%         hitsMap{iBin} = imgHitsWedge(:,bins{iBin});
%         
%         for iPatch = 1:size(hitsMap{iBin},1)
%            hitRate(iBin,iPatch) = nnz(hitsMap{iBin}(iPatch,:));            
%         end
%         
%         % Now get the indices of the best patches for each of these bins
%                
% end

% Code blow is binning as if from certain vlaue to the maximum luminance.
for iBin = 1:8
    lowEnd = ranges(iBin);
    uppEnd = max(training_michelson_values);
            
    bins{iBin} = find(training_michelson_values >  lowEnd);
        
        % Now find best patches for these different bins.
        hitsMap{iBin} = imgHitsWedge(:,bins{iBin});
        
        for iPatch = 1:size(hitsMap{iBin},1)
           hitCount(iPatch,iBin) = nnz(hitsMap{iBin}(iPatch,:));       
           hitCount_percentage(iPatch,iBin) = ...
               (hitCount(iPatch,iBin) * 100)/numel(bins{iBin});
        end
        
%         [hitCount_sorted_descend,index_of_sorted_patches] = sort(hitCount,'descend');
%         
%         for iPatch = 1:size(hitsMap{iBin},1)
%             hitCount_sorted_descend_percentage(iPatch,iBin) = ...
%                 (hitCount_sorted_descend(iPatch,iBin) * 100)/numel(bins{iBin});
%         end
end

% Now sort the arrays by best patch
[hitCount_sorted_descend,index_of_sorted_patches] = sort(hitCount,'descend');
for iBin = 1:8
    hitCount_percentage_sorted(:,iBin) = hitCount_percentage(index_of_sorted_patches(:,iBin),iBin);
end
%% plot a bar graph for the best patch
xTickNames = [{'0-max'},{'0.1-max'},{'0.2-max'},{'0.3-max'},{'0.4-max'},...
              {'0.5-max'},{'0.6-max'},{'0.7-max'}];

bar(hitCount_percentage_sorted(1,:))
set(gca,'XTickLabel',xTickNames)
ylabel('Percent hit for the best patch')
xlabel('Michelson Ranges')
ylim([0 130]) 
set(gca,'YMinorTick','on')
grid on

%% Barplots for individual patches.

subplot(2,3,1)
patchIdx = 14273;
V = hitCount_percentage(patchIdx,:)
bar(V)
xTickNames = [{'0-max'},{'0.1-max'},{'0.2-max'},{'0.3-max'},{'0.4-max'},...
              {'0.5-max'},{'0.6-max'},{'0.7-max'}];
set(gca,'XTickLabel',xTickNames)

ylabel('Percent hit for the patch')
xlabel('Michelson Ranges')
ylim([0 130]) 
set(gca,'YMinorTick','on','FontSize',6)
grid on
title(['Patch ' int2str(patchIdx)]);

subplot(2,3,2)
patchIdx = 44307;
V = hitCount_percentage(patchIdx,:)
bar(V)
xTickNames = [{'0-max'},{'0.1-max'},{'0.2-max'},{'0.3-max'},{'0.4-max'},...
              {'0.5-max'},{'0.6-max'},{'0.7-max'}];
set(gca,'XTickLabel',xTickNames)

ylabel('Percent hit for the patch')
xlabel('Michelson Ranges')
ylim([0 130]) 
set(gca,'YMinorTick','on','FontSize',6)
grid on
title(['Patch ' int2str(patchIdx)]);

subplot(2,3,3)
patchIdx = 3271;
V = hitCount_percentage(patchIdx,:)
bar(V)
xTickNames = [{'0-max'},{'0.1-max'},{'0.2-max'},{'0.3-max'},{'0.4-max'},...
              {'0.5-max'},{'0.6-max'},{'0.7-max'}];
set(gca,'XTickLabel',xTickNames)

ylabel('Percent hit for the patch')
xlabel('Michelson Ranges')
ylim([0 130]) 
set(gca,'YMinorTick','on','FontSize',6)
grid on
title(['Patch ' int2str(patchIdx)]);

subplot(2,3,4)
patchIdx = 37204;
V = hitCount_percentage(patchIdx,:)
bar(V)
xTickNames = [{'0-max'},{'0.1-max'},{'0.2-max'},{'0.3-max'},{'0.4-max'},...
              {'0.5-max'},{'0.6-max'},{'0.7-max'}];
set(gca,'XTickLabel',xTickNames)

ylabel('Percent hit for the patch')
xlabel('Michelson Ranges')
ylim([0 130]) 
set(gca,'YMinorTick','on','FontSize',6)
grid on
title(['Patch ' int2str(patchIdx)]);

subplot(2,3,5)
patchIdx = 45;
V = hitCount_percentage(patchIdx,:)
bar(V)
xTickNames = [{'0-max'},{'0.1-max'},{'0.2-max'},{'0.3-max'},{'0.4-max'},...
              {'0.5-max'},{'0.6-max'},{'0.7-max'}];
set(gca,'XTickLabel',xTickNames)

ylabel('Percent hit for the patch')
xlabel('Michelson Ranges')
ylim([0 130]) 
set(gca,'YMinorTick','on','FontSize',6)
grid on
title(['Patch ' int2str(patchIdx)]);

%% make a 3D for n top patches, looking at their localization for each bin

n = 200;
% get indices of the best 100 patches across all images.
idxTopPatches = index_of_sorted_patches(1:n);

% Now make a matrix with top 100 patches as rows and localization for each
% bin as columns.
topPatchesByBins = hitCount_percentage(idxTopPatches,:);
surf(topPatchesByBins);
xlabel('Bins')
ylabel('Patches sorted by localization on all images')
zlabel('Localization')
rotate3d on
title('All 50,000 patches, sorted by localization on all images')



