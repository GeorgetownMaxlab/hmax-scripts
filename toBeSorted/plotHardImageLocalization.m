%% Find patches that would complement doubles.

%% Define global vars
clear; clc;
patchesShown = 50;
quadType = 'f';
plotFor = 'FACE';
patchTypeOnMap = 'SINGLE';

folderName = 'patchSet4\lfwDouble100';
loadLoc = ['C:\Users\Levan\HMAX\annulusExpt\testingSetRuns\' ...
    folderName '\'];
saveLoc = loadLoc;

nPatchesInTheName = 50; % <--- this must be the same number of patches 
%for which the difficulty of images were assessed.
% nHardImages = 115

%% Load vars and preprocess.
% Load the indices of hard testing set images for the double patches. 
load([loadLoc 'imageDifficultyData_' ...
    num2str(nPatchesInTheName) '_Patches'],'IndImg','sortSumStatsImg');

nHardImages = numel(sortSumStatsImg(find(sortSumStatsImg == 0)));
hardImgIdx = IndImg(1:nHardImages);
clearvars IndImg;

% Load faces location file and reformat
load([loadLoc 'facesLoc.mat']);
facesLoc = convertFacesLocAnnulus(facesLoc);
facesLoc = horzcat(facesLoc{:});

% Now load the imageHits map for all patches on the test set of
% images. 
load('C:\Users\Levan\HMAX\annulusExpt\testingSetRuns\patchSet4\lfwSingle10000\imageDifficultyData_10000_Patches.mat',...
    'imgHitsWedge');
imgHitsWedge = imgHitsWedge';
    % Now sort the map by hard images, and select only the n hardest.
    imgHitsHardImages = imgHitsWedge(hardImgIdx,:);
%     imgHitsHardImages = imgHitsHardImages(1:nHardImages,:);

%% 
%:::::::::::SORTING THE MATRIX BY BEST PATCHES::::::::::::::::::::::::::::
for iPatch = 1:size(imgHitsHardImages,2)        
        sumStatsPatch(iPatch) = numel(find(imgHitsHardImages(:,iPatch)==1));
     sumStatsPatchRaw(iPatch) = sumStatsPatch(iPatch);
        sumStatsPatch(iPatch) = (sumStatsPatch(iPatch)*100)/size(imgHitsHardImages,1);
end
[sortSumStatsPatch, IndHardImgPatches] = sort(sumStatsPatch,'descend');
sortSumStatsPatchRaw = sortSumStatsPatch*size(imgHitsHardImages,1)/100;
imgHitsHardImages = imgHitsHardImages(:,IndHardImgPatches);

% save([saveLoc 'IndHardImgPatches.mat'],'IndHardImgPatches');

%% ::::::TRUNCATE MATRICES AND VECTORS TO WORK ONLY ON TOP N PATHCES::::::::

fprintf(['Displaying only the best ' int2str(patchesShown) ' patches!!!!\n']);
    imgHitsHardImages = imgHitsHardImages(:,1:patchesShown);
    sortSumStatsPatch = sortSumStatsPatch(1:patchesShown);
    IndHardImgPatches = IndHardImgPatches(1:patchesShown);

%% :::::::::::CALCULATE DIFFICULTY OF IMAGES::::::::::::::::::::::::
    for iImg = 1:size(imgHitsHardImages,1)
        %Find the ones that equal 1, that means face was hit by patch.s
        sumStatsImg(iImg) = numel(find(imgHitsHardImages(iImg,:)==1));
        sumStatsImg(iImg) = (sumStatsImg(iImg)*100)/size(imgHitsHardImages,2);
    end
% [sortSumStatsImg, IndImg] = sort(sumStatsImg,'ascend');
% clearvars IndImg;
% imgHitsHardImages = imgHitsHardImages(IndImg,:); % sort the whole matrix by images that were "hit" most.
%The most-hit images will be at the bottom of the matrix now.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


%% ::::::::::::::DISPLAYING THE FIGURE::::::::::::::::::::::::::::::::::::::
close; %close any previous figures.
%diplay fullscreen.
h = figure('units','normalized','outerposition',[0 0.05 1 0.95]); 
%     display docked.
%     set(figure,'WindowStyle','docked'); 
        imageDifficultyAxes  = axes('position', [0.08 0.25 0.06 0.70]);
        mainDataAxes         = axes('position', [0.17 0.25 0.80 0.70]);
        patchPerformanceAxes = axes('position', [0.17 0.05 0.80 0.13]); 
    colormap(gray);
colormap(flipud(colormap)); %Up till now, high values in matrix are white
% while lower ones are black. Flip this so that higher ones are black and
% represent a correct localization.
        axes(mainDataAxes)
            h = imagesc(imgHitsHardImages);
                    %     set(gca,'YDir','normal'); %reverse the Y-axis. 
                    set(gca,'YTick',[]);
                if strcmp(quadType,'f') == 1    
                    title(['Localization Map for ' plotFor ' Images: Patch type is ' patchTypeOnMap ...
                        '     (Black = Hit, White = Miss)'],'FontSize',12);
                else
                    title(['Localization Map for ' plotFor ' Images: Patch type is ' patchTypeOnMap ...
                        '     (Black = False Alarm, White = Correct Rejection)'],'FontSize',12);
                end
            ylabel([int2str(length(sumStatsImg)) ' Unique Images']);
        xlabel('Patches sorted by their localization value')
    
        axes(imageDifficultyAxes);
            b = barh(1:length(sumStatsImg),fliplr(sumStatsImg),'k','BarWidth',1);
                set(gca,'xdir','reverse');
%                     set(gca,'YDir','reverse'); %reverse the Y-axis. 
                    ylim([1 length(sumStatsImg)]);
                    xlim([0 100]);
                title(['"Difficulty" of ' plotFor ' Images'],'FontSize',12);
            xlabel({'% of patches that'; 'localized the face'; 'in the image'},'FontSize',7);
        ylabel('Images ARE NOT sorted by % of patches that localized the face in them');
        
        axes(patchPerformanceAxes);
             b1 = bar(1:length(sortSumStatsPatch),sortSumStatsPatch,'k','BarWidth',1);
                  xlim([1 length(sortSumStatsPatch)]);
                  ylim([0 100]);
      %             title('Patch performance','FontSize',5);
      %             xlabel('% of images Hit','FontSize',5);
        ylabel('% of localization','FontSize',7);
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%% 
% mkdir([saveLoc 'complementaryPatches\']);
% save([saveLoc 'complementaryPatches\' num2str(nHardImages) '_hardImagesLocalizationData']);
