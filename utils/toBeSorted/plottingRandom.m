%scrap script

%% ::::Plot Correlation Between Choice Analysis and Localization of Patches:
% clear; clc; close;
% patchType = 'BlurTriples';
% lastPatch = 19600;
% loadPath = ['/home/levan/HMAX/choiceAnalysis/' patchType '/'];
% loadPath = ['C:\Users\Levan\HMAX\' patchType '\'];
% 
% 
% load([loadPath 'patchChoices1-' int2str(lastPatch) '.mat']);
% load([loadPath 'C2/locValues' patchType '.mat']);
% 
% locValues = sortedBlurTriples; % <--- CHANGES WITH DIFFERENT patchType
% faceChoices = fTotalChoicesColl(:,1);
% 
% subplot(2,2,1)
% plot(1:length(locValues),locValues,'-.','color','b');
% hold on
% plot(1:length(locValues),faceChoices,'color','m');
% legend('Localization Percentage','Face-quadrant selectivity in EMPTY Condition');
% xlabel('Patches','FontSize',15);
% ylabel('Percentage','FontSize',15);
% title(['All ' int2str(lastPatch) ' ' patchType],'FontWeight','Bold','FontSize',15);
% 
% subplot(2,2,2)
% scatter(locValues,faceChoices,4);
% xlabel('Localization Percentage','FontSize',15);
% ylabel('Face-quadrant Selectivity','FontSize',15);
% title(['Scatterplot for ALL ' int2str(lastPatch) ' ' patchType],'FontWeight','Bold','FontSize',15);
% 
% subplot(2,2,3)
% plot(1:length(locValues),locValues,'-.','color','b');
% hold on
% plot(1:length(locValues),faceChoices,'color','m');
% axis([0 100 0 100]);
% grid minor;
% set(axh,'XGrid','on');
% xlabel('Patches','FontSize',15);
% ylabel('Percentage','FontSize',15);
% title(['Top 100 ' patchType],'FontWeight','Bold','FontSize',15);
% 
% subplot(2,2,4)
% figure2 = scatter(locValues(1:100),fTotalChoicesColl(1:100,1),4);
% xlabel('Localization Percentage','FontSize',15);
% ylabel('Face-quadrant Selectivity','FontSize',15);
% title(['Scatter Plot for Top 100 ' patchType],'FontWeight','Bold','FontSize',15);
% 
% [R P] = corr(locValues',faceChoices);
% R^2
% [R100 P100] = corr(locValues(1:100)',faceChoices(1:100));
% R100^2

%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;


%% :::::::::::::::::COMPARING LOC-VALUES FOR HALF vs. WHOLE FACE-SET::::::::
% hits1 = hits1{1,5};
% [s,i] = sort(hits,'descend');
% [s1,i1] = sort(hits1,'descend');
% s = s/10073*100;
% s1 = s1/5037*100;
% 
% close;
% % subplot(5,1,1)
% plot(1:100,s1(1:100),'color','k');
% hold on;
% plot(1:100,s(1:100),'color','b');
% legend('Localizations over half face-set','New localizations over the whole set');
% title('TRIPLE-patch Localization values calculated over half vs. whole face-quad set')
% ylabel('Percentage Localization');
% %:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

%% ::::Ploting the Loc Scores of singles, doubles, and triples on one graph::::::
% close;
% singles = plot(1:10000,(sortedSingles),'color','r');
% hold on;
% doubles = plot(1:4950, (sortedDoubles),'color','g');
% triples = plot(1:19600, (sortedTriples),'color','b');
% legend('10000 SINGLE pathces','4950 DOUBLE patches','19600 TRIPLE patches');
% set(singles,'linewidth',2);
% set(doubles,'linewidth',2);
% set(triples,'linewidth',2);
% xlabel('Patches','FontSize',15);
% ylabel('Localization Percentage','FontSize',20);
% title('Localization Scores across ALL face-quadrants','FontSize',20);
% axis([1 50 0 100]);

%% ::::::::::::::PLOT MEAN SUBJ PERFORMANCE AND PATCH PERFORMANCE::::::::::::::::::::::::::::::::::
% clear; clc; close;
% homePath = ('C:\Users\Levan\HMAX\');
% load([homePath 'subjPerformance\performanceByCondSubj80.mat']);
% load([homePath '\Singles\patchChoices1-10000.mat'])
% close;
% 
% subplot(1,5,1)
% meanSubj = plot(performanceByCondSubj80(9,:));
% hold on;
% plot(fTotalChoicesColl');
%     legend('Mean subject score');
%     set(meanSubj,'linewidth',2);
%     axis([0 5 0 100]);
%     axis 'auto x';
%     ylabel('Performance','FontSize',20)
%     title('Singles','FontSize',15)
%     set(gca,'YMinorTick','on');
% 
% load([homePath '\Doubles\patchChoices1-4950.mat'])
% subplot(1,5,2)
% meanSubj = plot(performanceByCondSubj80(9,:));
% hold on;
% plot(fTotalChoicesColl');
%     set(meanSubj,'linewidth',2);
%     axis([0 5 0 100]);
%     axis 'auto x';
%     title('Doubles','FontSize',15)
%     set(gca,'YMinorTick','on');
% 
% load([homePath '\Triples\patchChoices1-19600.mat'])
% subplot(1,5,3)
% meanSubj = plot(performanceByCondSubj80(9,:));
% hold on;
% plot(fTotalChoicesColl');
%     set(meanSubj,'linewidth',2);
%     axis([0 5 0 100]);
%     axis 'auto x';
%     title('Triples','FontSize',15);
%     set(gca,'YMinorTick','on');
% 
% load([homePath '\BlurDoubles\patchChoices1-4950.mat'])
% subplot(1,5,4)
% meanSubj = plot(performanceByCondSubj80(9,:));
% hold on;
% plot(fTotalChoicesColl');
%     set(meanSubj,'linewidth',2);
%     axis([0 5 0 100]);
%     axis 'auto x';
%     title('BlurDoubles','FontSize',15);
%     set(gca,'YMinorTick','on');
% 
% load([homePath '\BlurTriples\patchChoices1-19600.mat'])
% subplot(1,5,5)
% meanSubj = plot(performanceByCondSubj80(9,:));
% hold on;
% plot(fTotalChoicesColl');
%     set(meanSubj,'linewidth',2);
%     axis([0 5 0 100]);
%     axis 'auto x';
%     title('BlurTriples','FontSize',15);
%     set(gca,'YMinorTick','on');S
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


%% :::::::::::PLOT SUBJ-PATCH PERFORMANCE DIFFERENCES:::::::::::::::::::::
%     clear; clc;
%     load('/home/levan/HMAX/choiceAnalysis/subjPerformance/performanceByCondSubj80.mat');
%     load('/home/levan/HMAX/choiceAnalysis/Singles/patchChoices1-10000.mat')
%     close;
% 
% subplot(1,5,1)
% meanSubj = plot(performanceByCondSubj80(9,:));
% set(meanSubj,'linewidth',2);
% hold on;
% plot(performanceByCondSubj80(9,:)-1,'color','w');
%     perf = repmat(performanceByCondSubj80(9,:),size(fTotalChoicesColl,1),1);
%     DIFF = perf - fTotalChoicesColl;
% plot(DIFF');
% legend('Absolute mean subject score','Other lines are subj-patch differences');
% axis([0 5 -20 100]);
% axis 'auto x';
% ylabel('Performance','FontSize',20)
% title('Singles','FontSize',15)
% set(gca,'YMinorTick','on');
% 
% load('/home/levan/HMAX/choiceAnalysis/Doubles/patchChoices1-4950.mat')
% subplot(1,5,2)
% meanSubj = plot(performanceByCondSubj80(9,:));
% hold on;
%     perf = repmat(performanceByCondSubj80(9,:),size(fTotalChoicesColl,1),1);
%     DIFF = perf - fTotalChoicesColl;
% plot(DIFF');
% set(meanSubj,'linewidth',2);
% axis([0 5 -20 100]);
% axis 'auto x';
% title('Doubles','FontSize',15)
% set(gca,'YMinorTick','on');
% 
% load('/home/levan/HMAX/choiceAnalysis/Triples/patchChoices1-19600.mat')
% subplot(1,5,3)
% meanSubj = plot(performanceByCondSubj80(9,:));
% hold on;
%     perf = repmat(performanceByCondSubj80(9,:),size(fTotalChoicesColl,1),1);
%     DIFF = perf - fTotalChoicesColl;
% plot(DIFF');
% set(meanSubj,'linewidth',2);
% axis([0 5 -20 100]);
% axis 'auto x';
% title('Triples','FontSize',15);
% set(gca,'YMinorTick','on');
% 
% load('/home/levan/HMAX/choiceAnalysis/BlurDoubles/patchChoices1-4950.mat')
% subplot(1,5,4)
% meanSubj = plot(performanceByCondSubj80(9,:));
% hold on;
%     perf = repmat(performanceByCondSubj80(9,:),size(fTotalChoicesColl,1),1);
%     DIFF = perf - fTotalChoicesColl;
% plot(DIFF');
% set(meanSubj,'linewidth',2);
% axis([0 5 -20 100]);
% axis 'auto x';
% title('BlurDoubles','FontSize',15);
% set(gca,'YMinorTick','on');
% 
% load('/home/levan/HMAX/choiceAnalysis/BlurTriples/patchChoices1-19600.mat')
% subplot(1,5,5)
% meanSubj = plot(performanceByCondSubj80(9,:));
% hold on;
%     perf = repmat(performanceByCondSubj80(9,:),size(fTotalChoicesColl,1),1);
%     DIFF = perf - fTotalChoicesColl;
% plot(DIFF');
% set(meanSubj,'linewidth',2);
% axis([0 5 -20 100]);
% axis 'auto x';
% title('BlurTriples','FontSize',15);
% set(gca,'YMinorTick','on');
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%% Fininding natural face images that get "missed" constantly
% clear
% load('C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\lfwDouble100\imageDifficultyMapData\everything.mat')
% load('C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\lfwDouble100\facesLoc.mat')
% indImgDoubles = IndImg;
% load('C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\lfwTriple50\imageDifficultyMapData\everything.mat')
% indImgTriples = IndImg;
% facesLoc = convertFacesLoc(facesLoc);
% 
% facesLoc = horzcat(facesLoc{:});
% 
% nDoubleFacesToPlot = 40;
% nTripleFacesToPlot = 25;
% 
% indImgDoubles = indImgDoubles(1:nDoubleFacesToPlot);
% indImgTriples = indImgTriples(1:nTripleFacesToPlot);
% 
% commonFaceImagesIdx = intersect(indImgDoubles,indImgTriples);
% 
% % for i = 1:length(facesLoc(commonFaceImagesIdx))
% %    imwrite(imread(facesLoc{commonFaceImagesIdx(i)}),...
% %        ['image' int2str(commonFaceImagesIdx(i)) '.JPEG']) 
% % end
% 
% for i = 1:length(facesLoc(commonFaceImagesIdx))
%     img = imread(facesLoc{commonFaceImagesIdx(i)});
%     a{i} = img(1:384,:);
%        imwrite(a{i},...
%        ['image' int2str(commonFaceImagesIdx(i)) '.JPEG']) 
% end
% images = lsDir('C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\sandbox\missed by both doubles and triples',{'JPEG'})
% montage(images(:));

%% Fininding natural face images that get "hit" constantly
% clear
% load('C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\lfwDouble100\imageDifficultyMapData\everything.mat')
% load('C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\lfwDouble100\facesLoc.mat')
% indImgDoubles = fliplr(IndImg);
% load('C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\lfwTriple50\imageDifficultyMapData\everything.mat')
% indImgTriples = fliplr(IndImg);
% facesLoc = convertFacesLoc(facesLoc);
% 
% facesLoc = horzcat(facesLoc{:});
% 
% nDoubleFacesToPlot = 100;
% nTripleFacesToPlot = 100;
% 
% indImgDoubles = indImgDoubles(1:nDoubleFacesToPlot);
% indImgTriples = indImgTriples(1:nTripleFacesToPlot);
% 
% commonFaceImagesIdx = intersect(indImgDoubles,indImgTriples);
% 
% % for i = 1:length(facesLoc(commonFaceImagesIdx))
% %    imwrite(imread(facesLoc{commonFaceImagesIdx(i)}),...
% %        ['image' int2str(commonFaceImagesIdx(i)) '.JPEG']) 
% % end
% 
% for i = 1:length(facesLoc(commonFaceImagesIdx))
%     img = imread(facesLoc{commonFaceImagesIdx(i)});
%     a{i} = img(1:384,:);
%        imwrite(a{i},...
%        ['image' int2str(commonFaceImagesIdx(i)) '.JPEG']) 
% end
% images = lsDir('C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\sandbox\missed by both doubles and triples',{'JPEG'})
% montage(images(:));


%% Plot images that get "missed" for various types of patches and patch-combinations
% clear; close; clc;
% loadLocT = 'C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\';
%     folderNameT = 'lfwBlurTriple50\';
% saveLoc = [loadLocT folderNameT];
% load([loadLocT folderNameT 'imageDifficultyMapData\everything.mat']);
% load([loadLocT folderNameT 'facesLoc.mat']);
% facesLoc = convertFacesLoc(facesLoc);
% facesLoc = horzcat(facesLoc{:});
% 
% nImagesShown = 200;
% IndImg = IndImg(1:nImagesShown);
% 
% 
% for i = 1:length(facesLoc(IndImg))
%     img = imread(facesLoc{IndImg(i)});
%     a{i} = padarray(img(1:384,:),[1 1]);
% end
% 
% % Now construct a giant image.
% nCol = 5
% 
% for r = 0:(length(a)/nCol)-1
%     montageImg{r+1} = horzcat(a{r*nCol+1:r*nCol+nCol})
% end
% montageImg = vertcat(montageImg{:});
% % imshow(montageImg,'InitialMagnification',100);
% imwrite(montageImg,...
%        [saveLoc 'imageDifficultyMapData\montageAll.JPEG']) 
%% Histogram of backgrounds by the # of hits
% clear;
% load('C:\Users\Levan\HMAX\naturalFaceImages\Name_of_backgrounds.mat')
% load('C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\lfwSingle500\imageDifficultyMapData\everything.mat')
% load('C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\lfwSingle500\facesLoc.mat')
% 


%% 
% clear; clc; close;
% load('C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\patchSet2\lfw50Doubles100HardPatches\imageDifficultyData_5000_Patches.mat')
% data = sortSumStatsPatch(1:100);
% 
% bar(data);
%   xlim([1 length(data)]);
%   ylim([0 100]);
% 

%%
% 
% clear; clc; close;
% load('C:\Users\Levan\HMAX\annulusExpt\patchSet2\lfwSingle146\imageDifficultyData_146_Patches.mat')
% 
% plot(sumStatsPatch);
% hold on
% load('C:\Users\Levan\HMAX\annulusExpt\patchSet2\lfwSingle146_Run2\imageDifficultyData_146_Patches.mat')
% plot(sumStatsPatch);
% 
% xlabel('146 patches')
% ylabel('Localization %')
% 
% legend('BMP format','jpeg format')

