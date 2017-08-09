%% Calculate michelsons contrast at every pixel, defining a window over which to calculate.
% 
% clear; clc;
% imgList = lsDir('C:\Users\levan\HMAX\annulusExptFixedContrast\backgroundsNoAnnulusResized',...
%     {'png'});
% 
% % load the mask and crop it to match the images.
% load('C:\Users\levan\HMAX\annulusExptFixedContrast\annulusMask_imperfect.mat')
% mask = uint8(mask(18:713,:));
% 
% 
% for iImg = 83:length(imgList)
%     
% img = double(imread(imgList{iImg}));
% % imgResized = resizeImage(img,927);
% 
% windowHalfWidth = 20;
% windowHalfHight = 40;
% 
% [ySize,xSize] = size(img);
% newImg = zeros(ySize,xSize);
% 
% for iRow = 1:size(img,1)
%     iRow
%     for iCol = 1:size(img,2)
%         % Define the window.
%         idxCenter = [iRow,iCol];
%         idxWindow = [(iCol - windowHalfWidth) ...
%                      (iCol + windowHalfWidth) ...
%                      (iRow - windowHalfHight) (iRow + windowHalfHight)];
%                       % x1 is the leftmost 	inate of the box.
%                       % x2 is the rightmost coordinate of the box.
%                       % y1 is the topmost.
%                       % y2 is the bottommost.
%         if idxWindow(1) <= 0 
%             idxWindow(1) = 1;
%         end
%         if idxWindow(2) > (xSize-windowHalfWidth) 
%             idxWindow(2) = xSize; 
%         end
%         if idxWindow(3) <= 0 
%             idxWindow(3) = 1; 
%         end
%         if idxWindow(4) > (ySize-windowHalfHight)
%             idxWindow(4) = ySize;
%         end
%         
%         window = img(idxWindow(3):idxWindow(4),idxWindow(1):idxWindow(2));
%         
%             michelson = (max(window(:)) - min(window(:)))/...
%                         (max(window(:)) + min(window(:)));
%         
%         
%         newImg(iRow,iCol) = michelson;
%         
%         
%     end
% end
% % imagesc(newImg,[0 1]);
% colormap(jet)
% colorbar
% clim = get(gca, 'clim');
% levels = 255;
% target = grayslice(newImg, linspace(clim(1), clim(2), levels));
% map = jet(levels);
% 
% target = target .* double(mask);
% 
% imgName = strrep(imgList{iImg},'backgroundsNoAnnulusResized','michelsonImagesWithAnnulus');
% imwrite(target, map, imgName)
% end

%% resize backgrounds
% imgList = lsDir('C:\Users\levan\HMAX\annulusExptFixedContrast\backgroundsNoAnnulus',...
%     {'jpg'});
% 
% for iImg = 1:length(imgList)
%     
% img = uint8(resizeImage(imread(imgList{iImg}),927));
% imwrite(img, [imgList{iImg}(1:end-3) 'png'])
% 
% end

%% overlay annulus on the images.
% clear; clc;
% 
% 
% uiopen('C:\Users\levan\HMAX\annulusExptFixedContrast\michelsonImages\bgBazaar001.png',1)
% 
% maskedBg = mask .* cdata;
% imshow(uint8(maskedBg));


%% Give florence the good background images.
% clear; clc;
% goodBg = lsDir('C:\Users\levan\HMAX\annulusExptFixedContrast\michelsonImagesWithAnnulusGood',...
%              {'png'});
%          
% for iImg = 1:length(goodBg)
%     
%    goodBg_EEG_path{iImg} = strrep(goodBg{iImg},... 
%        'C:\Users\levan\HMAX\annulusExptFixedContrast\michelsonImagesWithAnnulusGood\',...
%        '/home/scholl/Desktop/Florence/Expt_Model_Loc_Sept2015/AllBackgrounds/');
%    localPath{iImg} = strrep(goodBg{iImg},... 
%        'michelsonImagesWithAnnulusGood\',...
%        'backgroundsNoAnnulus\');
%    localPath{iImg} = strrep(localPath{iImg},... 
%        'png',...
%        'jpg');   
%    destination{iImg} = strrep(goodBg{iImg},... 
%        'michelsonImagesWithAnnulusGood\',...
%        'backgroundsHighContrast\');
% %    copyfile(localPath{iImg},'C:\Users\levan\HMAX\annulusExptFixedContrast\backgroundsHighContrast\');
% end
%          
%% Find a subset of images from training and testing with equal contrast distributions
clear; clc; close;
training = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\exptDesign.mat');

testing  = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\exptDesign.mat');

subplot(2,1,1)
hist(training.michelson_values,50)
title('TRAINING SET: Michelson Values')
subplot(2,1,2)
hist(testing.michelson_values,50)
title('TESTING SET: Michelson Values')

% take only data aboce 0.3 michelsons value.

highTraining = training.michelson_values(training.michelson_values > 0.3 & training.michelson_values < 0.6);
highTesting  = testing.michelson_values (testing.michelson_values  > 0.3 & testing.michelson_values < 0.6);


%% do the binning strategy

for iBin = 0:0.1:0.8
    
    binnedTraining = (highTraining(highTraining > iBin & highTraining < iBin + 0.1));
    trainCount = nnz
    
    testCount  = nnz(highTesting (highTesting  > iBin & highTesting  < iBin + 0.1))
        if trainCount ~= 0 && testCount ~= 0
            if trainCount > testCount
                trainingChosen = highTraining( 
            else
                
            end
            
        end
        
    
end


%% 
% nSubsample = 100;
% 
% h = 1;
% iteration = 1;
% while h == 1
%     if mod(iteration,20000) == 0
%         iteration
% %         plot(p)
% %         hold on
%     end
%     randTraining = randperm(nSubsample);
%     randTesting  = randperm(nSubsample);
%     newTraining = highTraining(1:nSubsample); %(randTraining);
%     newTesting  = highTesting (randTesting);
%     
%     [h,p] = ttest2(newTraining,newTesting);
%     iteration = iteration + 1;
% end
