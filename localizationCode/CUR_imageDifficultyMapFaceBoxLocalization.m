function sortSumStatsPatch = CUR_imageDifficultyMapFaceBoxLocalization(patchType,quadType,...
    folderName, makePlot, patchesShown)

% This code analyzes the imgHitsFaceBox file and outputs data about which
% patches were the best, their indices, and other supplementary
% information, saving it all in a file.

%% ::::::BEGIN CONSTRUCTING IMAGE DIFFICULTY MAP AND STATS::::::::::::::::::::

if ispc == 1
    loadPath = fullfile('C:/Users/Levan/HMAX/',folderName);
else
    loadPath = fullfile('/home/levan/HMAX/',folderName);
end

load(fullfile(loadPath,'imgHitsFaceBox'));

if strcmp(quadType,'f')
    plotFor = 'FACE';
else
    plotFor = 'EMPTY';
end

MAT = imgHitsFaceBox';
fprintf(['Plotting for ' plotFor ' Images!!!!!!\n']);

%% :::::::::::SORTING THE MATRIX BY BEST PATCHES::::::::::::::::::::::::::::
for j = 1:size(MAT,2)
    %Find the ones that equal 1, because 1 means the patch chose
    %face.
    sumStatsPatch(j) = numel(find(MAT(:,j)==1));
    sumStatsPatch(j) = (sumStatsPatch(j)*100)/size(MAT,1);
end
[sortSumStatsPatch, IndPatch] = sort(sumStatsPatch,'descend');
MAT = MAT(:,IndPatch); % sort the whole matrix by patches that "hit" the
%images. The "best" patches will be on the left of the matrix.

%% ::::::TRUNCATE MATRICES AND VECTORS TO WORK ONLY ON TOP N PATHCES::::::::
if (nargin)<5
    patchesShown = size(MAT,2);
    fprintf('Displaying the matrix for all of the patches\n')
else
    fprintf(['Displaying only the best ' int2str(patchesShown) ' patches!!!!\n']);
    MAT = MAT(:,1:patchesShown);
    sortSumStatsPatch = sortSumStatsPatch(1:patchesShown);
end
%Its better to truncate the whole MAT file, instead of leaving it as is and
%only changing the xlim of the plots below. Because when I calculate the
%number of patches that hit a particular image, it should only count those
%patches that we want to display. If xlim is changed, calculation will
%still be done on all patches, but only certain number of the will be
%displayed.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


%% :::::::::::SORTING THE MATRIX BY IMAGE DIFFICULTY::::::::::::::::::::::::
for i = 1:size(MAT,1)
    %Find the ones that equal 1, because 1 means the patch hit the face
    sumStatsImg(i) = numel(find(MAT(i,:)==1));
    sumStatsImg(i) = (sumStatsImg(i)*100)/size(MAT,2);
end
[sortSumStatsImg, IndImg] = sort(sumStatsImg,'ascend');
MAT = MAT(IndImg,:); % sort the whole matrix by images that were "hit" most.
%The most-hit images will be at the bottom of the matrix now.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


%% ::::::::::::::DISPLAYING THE FIGURE::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if makePlot == 1
    
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
    h = imagesc(MAT);
    %     set(gca,'YDir','normal'); %reverse the Y-axis.
    set(gca,'YTick',[]);
    if strcmp(quadType,'f') == 1
        title(['Localization Map for ' plotFor ' Images: Patch type is ' patchType ...
            '     (Black = Hit, White = Miss)'],'FontSize',12);
    else
        title(['Localization Map for ' plotFor ' Images: Patch type is ' patchType ...
            '     (Black = False Alarm, White = Correct Rejection)'],'FontSize',12);
    end
    ylabel([int2str(length(sortSumStatsImg)) ' Unique Images']);
    xlabel('Patches sorted by their localization value')
    
    axes(imageDifficultyAxes);
    b = barh(1:length(sortSumStatsImg),fliplr(sortSumStatsImg),'k','BarWidth',1);
    set(gca,'xdir','reverse');
    %                     set(gca,'YDir','reverse'); %reverse the Y-axis.
    ylim([1 length(sortSumStatsImg)]);
    xlim([0 100]);
    title(['"Difficulty" of ' plotFor ' Images'],'FontSize',12);
    xlabel({'% of patches that'; 'localized the face'; 'in the image'},'FontSize',7);
    ylabel('Images sorted by % of patches that localized the face in them');
    
    axes(patchPerformanceAxes);
    b1 = bar(1:length(sortSumStatsPatch),sortSumStatsPatch,'k','BarWidth',1);
    xlim([1 length(sortSumStatsPatch)]);
    ylim([0 100]);
    %             title('Patch performance','FontSize',5);
    %             xlabel('% of images Hit','FontSize',5);
    ylabel('% of localization','FontSize',7);
end
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%%  Start saving everything
% mkdir([loadPath 'imageDifficultyMapData']);
clearvars imgHitsFaceBox
save(fullfile(loadPath,['imageDifficultyData_FaceBox_' num2str(patchesShown) '_Patches']),'-v7.3');

% % save([homePath 'sandbox/' patchType 'Everything.mat']);
% savefig([homePath '4AFCImageDifficultyMaps/Top500/' patchType quadType ...
%     'ImageDifficultyTop500.fig']);
end
