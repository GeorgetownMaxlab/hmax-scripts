% %% Excluding faces that were pasted at the top and bottom locations
% clear; clc;
% load('C:\Users\Levan\HMAX\annulusExpt\exptDesign.mat')
% 
% topRange = (80:1:100)
% bottomRange = (260:1:280)
% 
% topIdx = find(ismember(positionAngle,topRange))
% bottomIdx = find(ismember(positionAngle,bottomRange))
% 
% topBottomIdx_allImages = unique([topIdx bottomIdx])
% 
% 
% % Load run specific stuff.
% loadLoc = 'C:\Users\Levan\HMAX\annulusExpt\testingSetRuns\patchSet4\lfwSingle10000\';
% load([loadLoc 'imgHitsWedge.mat'])
% load([loadLoc 'facesLoc.mat']);
% 
%     % Add the img number below each faceLoc cell.
%     for iImg = 1:length(facesLoc{1})
%         key = '_session'; %#ok<*NOPRT>
%         key2 = '_image';
%         idx = strfind(facesLoc{1}{iImg},key);
%         idx2 = strfind(facesLoc{1}{iImg},key2);               
%         subj = str2double(facesLoc{1}{iImg}(idx-1))
%         ses  = str2double(facesLoc{1}{iImg}(idx+8))
%         imgNum = facesLoc{1}{iImg}(idx2+6:end)
%         imgNum(strfind(imgNum,'.jpeg'):end) = []
%         imgNum = str2double(imgNum)
%         imgFacesLoc = 64*(5*(subj-2)+ses-1)+imgNum
%         facesLocImgNum{1}{1,iImg} = imgFacesLoc;
%     end
%     facesLocImgNum = cell2mat(facesLocImgNum{1});
% 
% 
% % Find the excludable images in the imgHitsWedge
% excludeImages = find(ismember(facesLocImgNum,topBottomIdx_allImages))
% keepImages = setdiff(1:480,excludeImages)
% 
% imgHitsWedgeFilt = imgHitsWedge(:,keepImages);
% 
% save([loadLoc 'excludeTopBottom\imgHitsWedgeFilt.mat'],'imgHitsWedgeFilt');


%% 
% origfl1 = origfl;
% for iUnq = 1:length(unq)
%     
%    for iFace = 1:length(fl)
%       if strcmp(unq{iUnq},fl{iFace}) == 1
%           fl{iFace} = {};
%           break
%       else
%       end
%    end
%     
% end
% 
% idx = find(~cellfun(@isempty,fl))
% 
% flFilt = fl(idx)
% 
% for j = 1:length(flFilt)
%     
%    fprintf([flFilt{j} '\n']) 
% end

%% Changing the path from images with annulus to images without annulus.
% facesLoc{1}
% 
% for i = 1:length(facesLoc{1})
%    facesLoc{1}{i} = strrep(facesLoc{1}{i},...
%        '/home/levan/HMAX/annulusExpt/images2/',...
%        '/home/levan/HMAX/annulusExpt/Images_Faces_Backgrounds/background_with_faces_without_annulus/');
% end


%% Checking the florence's experimental design variable has consistent face locations. 
% clear; clc;
% home = 'C:\Users\Levan\HMAX\annulusExptFixedContrast\preBehavioral\';
% load([home 'exptDesign.mat']);
% 
% for i = 1:length(position)
%         [angle_rad{i}, RHO] = cart2pol(position{i}(2)-(927/2),(730/2)-position{i}(1));
%         angle_deg{i} = radtodeg(angle_rad{i});
%         
%         if angle_deg{i} <= 0
%             angle_deg{i} = 360 + angle_deg{i};
%         end
%         
%         [X{i}, Y{i}] = pol2cart(angle_rad{i},RHO);
%         location{i} = ceil([X{i} Y{i}]);
% 
% end

%% 
% clear; clc;
% load('facesLocTraining.mat')
% 
% for i = 1:length(facesLoc{1})
%    facesLoc{1}{i} = strrep(facesLoc{1}{i},'background_with_faces_without_annulus','background_with_faces_without_annulus_no_luminance_normalization_tsize=2.34')
% end

%% Load all clusters and plot them.
% clear; clc;
% A = ones(1,10)*2;
% B = 6:15;
% k = A.^B;
% 
% loadLoc = 'C:\Users\levan\HMAX\annulusExpt\trainingRuns\patchSetAdam\lfwSingle50000\clustering\';
% 
% 
% for i = 1:length(k)-2
%     load([loadLoc int2str(k(i)) 'clusters/imageDifficultyData_Wedge_' ...
%           int2str(k(i)) '_Patches.mat'],'sortSumStatsPatch')
%     perf(i) = sortSumStatsPatch(1);     
% end
% 
% plot(k(1:end-2),perf,'-X')

%% Edit the training testing split files. Change paths to different folders.
% clear; clc;
% load('C:\Users\levan\HMAX\annulusExpt\trainingTestingSplit\facesLocTrainingWin.mat');
% 
% newStr = 'images2_blurEdges_40px';
% 
% for iImg = 1:length(facesLoc{1})
%    facesLoc{1}{iImg} = strrep(facesLoc{1}{iImg},'images2',newStr); 
% end
% save facesLocTraining_blurEdges_40pxWin.mat facesLoc
%% Plotting effect of blurring edges.
% clear; clc;
% load('C:\Users\levan\HMAX\annulusExpt\sandbox\blur\10px\imageDifficultyData_Wedge_1000_Patches.mat')
% B10 = sumStatsPatch;
% load('C:\Users\levan\HMAX\annulusExpt\sandbox\blur\14px\imageDifficultyData_Wedge_1000_Patches.mat')
% B14 = sumStatsPatch;
% load('C:\Users\levan\HMAX\annulusExpt\sandbox\blur\20px\imageDifficultyData_Wedge_1000_Patches.mat')
% B20 = sumStatsPatch;
% load('C:\Users\levan\HMAX\annulusExpt\sandbox\blur\30px\imageDifficultyData_Wedge_1000_Patches.mat')
% B30 = sumStatsPatch;
% load('C:\Users\levan\HMAX\annulusExpt\sandbox\blur\40px\imageDifficultyData_Wedge_1000_Patches.mat')
% B40 = sumStatsPatch;
% load('C:\Users\levan\HMAX\annulusExpt\sandbox\blur\noBlur\imageDifficultyData_Wedge_1000_Patches.mat')
% NB = sumStatsPatch;
% 
% diff10 = B10-NB;
% mean_diff10 = mean(diff10);
% 
% diff14 = B14-NB;
% mean_diff14 = mean(diff14);
% 
% diff20 = B20-NB;
% mean_diff20 = mean(diff20);
% 
% diff30 = B30-NB;
% mean_diff30 = mean(diff30);
% 
% diff40 = B40-NB;
% mean_diff40 = mean(diff40);
% 
% subplot(2,3,1)
% hist(diff10,30)
% hold on
% plot(ones(1,230)*mean_diff10,1:230,'r','lineWidth',2)
% xlim([-15 15]);
% ylim([0 230]);
% xlabel('Difference in Wedge Localization');
% ylabel('Number of Patches');
% [h,p,ci,stats] = ttest(diff10);
% title({['10 Pixel Blur.']; ['Mean Diff = ' num2str(mean_diff10)];['t = ' num2str(stats.tstat)]; ['p = ' num2str(p)]});
% 
% subplot(2,3,2)
% hist(diff14,30)
% hold on
% plot(ones(1,230)*mean_diff14,1:230,'r','lineWidth',2)
% xlim([-15 15]);
% ylim([0 230]);
% xlabel('Difference in Wedge Localization');
% [h,p,ci,stats] = ttest(diff14);
% title({['14 Pixel Blur.']; ['Mean Diff = ' num2str(mean_diff14)];['t = ' num2str(stats.tstat)]; ['p = ' num2str(p)]});
% ylabel('Number of Patches');
% 
% 
% subplot(2,3,3)
% hist(diff20,30)
% hold on
% plot(ones(1,230)*mean_diff20,1:230,'r','lineWidth',2)
% xlim([-15 15]);
% ylim([0 230]);
% xlabel('Difference in Wedge Localization');
% [h,p,ci,stats] = ttest(diff20);
% title({['20 Pixel Blur.']; ['Mean Diff = ' num2str(mean_diff20)];['t = ' num2str(stats.tstat)]; ['p = ' num2str(p)]});
% ylabel('Number of Patches');
% 
% subplot(2,3,4)
% hist(diff30,30)
% hold on
% plot(ones(1,230)*mean_diff30,1:230,'r','lineWidth',2)
% xlim([-15 15]);
% ylim([0 230]);
% xlabel('Difference in Wedge Localization');
% [h,p,ci,stats] = ttest(diff30);
% title({['30 Pixel Blur.']; ['Mean Diff = ' num2str(mean_diff30)];['t = ' num2str(stats.tstat)]; ['p = ' num2str(p)]});
% ylabel('Number of Patches');
% 
% 
% subplot(2,3,5)
% hist(diff40,30)
% hold on
% plot(ones(1,230)*mean_diff40,1:230,'r','lineWidth',2)
% xlim([-15 15]);
% ylim([0 230]);
% xlabel('Difference in Wedge Localization');
% [h,p,ci,stats] = ttest(diff40);
% title({['40 Pixel Blur.']; ['Mean Diff = ' num2str(mean_diff40)];['t = ' num2str(stats.tstat)]; ['p = ' num2str(p)]});
% ylabel('Number of Patches');
% 

%% gray the mask and find the bad ones.
clear; clc;
load('C:\Users\levan\HMAX\annulusExptFixedContrast\justTraining\normalized\exptDesign.mat')
saveLoc = 'C:\Users\levan\HMAX\annulusExptFixedContrast\justTraining\normalized\';

for i = 1:length(mask)
    grayMask{i} = rgb2gray(mask{i});
    imwrite(grayMask{i},[saveLoc 'maskImages\mask' int2str(i) '.png']);
end

save([saveLoc 'grayMasks'],'grayMask');


    
    

