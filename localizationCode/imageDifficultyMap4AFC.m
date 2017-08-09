function imageDifficultyMap4AFC(patchType,quadType,helperNum,lastPatch,incr)
%This code is written to process *only* the EMPTY condition. Other
%conditions can be incorporated easily if needed.

if (nargin < 2)
    quadType = 'empty'
end

if (nargin < 1)
    patchType = 'BlurTriples'
%     helperNum = 4500;
%     lastPatch = 4950;
%     incr = 500;
end
% dbstop if error;
% %Global variables predefined:
homePath = 'C:\Users\Levan\HMAX\';
loadPath = ['C:\Users\Levan\HMAX\' patchType '\'];

% %:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% %%::::::::::GENERATE THE PURE MATRIX FROM THE CELL ARRAYS:::::::::::::::
% % This will be a matrix, with patches on Y and trials on X, depicting
% % whether or not each path "hit" the face-quadrant on a particular trial.

% WQpure = [];
% for f = 0:incr:helperNum
%     if f == helperNum
%         fprintf(['loading ' int2str(f+1) '-' int2str(lastPatch) ' WQempty file\n']);
%         load([loadPath 'WQempty' int2str(f+1) '-' int2str(lastPatch) '.mat']);
%         fprintf('loaded the LAST WQempty file');
%     else
%     fprintf(['loading ' int2str(f+1) '-' int2str(f+incr) ' WQempty file\n']);    
%     load([loadPath 'WQempty' int2str(f+1) '-' int2str(f+incr) '.mat']);
%     fprintf(['loaded ' int2str(f+1) '-' int2str(f+incr) '\n']);
%     end   
% 
% 
% for r = 1:size(WQ,1)
%     r
%     for c = 1:size(WQ,2)
%         WQrc = WQ{r,c}; %for making parfor faster.
% %         WQ2  = cell(1,size(WQrc,2)); %pre-define for speed.
%             for i = 1:size(WQrc,2)
%                 WQ1(i) = WQrc{1,i}(1,2);
%             end
%         WQ2{r,c} = WQ1; %This way parfor can run.
%         clear WQ1;
%     end
%     WQpure(end+1,:) = horzcat(WQ2{r,:}); % <---- theres a problem here!!!
% end
% % clearvars -except WQpure;
%     
% % save([loadPath 'WQpure' quadType '1-' int2str(f+incr) '.mat'], 'WQpure');
% % %THE ABOVE LINE WILL SOMETIMES GIVE THE WRONG NAME TO THE LAST WQpure FILE.
% save([homePath '4AFCImageDifficultyMaps\imageDifficultyMapMatrix' patchType ...
%     quadType '.mat'],'WQpure');
% 
% 
% end
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


%::::::::::::LOAD THE FILTERED FILE LIST:::::::::::::::::::::::::::::::
% load('C:\Users\Levan\HMAX\compareImages\filteredNamesfaces.mat');
load([homePath '\4AFCImageDifficultyMaps\imageDifficultyMapMatrix' patchType quadType '.mat']);
% %See compareImages.m for details. 
% 
% % :::::::::::::GENERATE INFO FROM THE FILE LIST::::::::::::::::::::::::
%     *************MOVE THIS CHUNK AS SEPARATE CODE**************
%
%     load('C:\Users\Levan\HMAX\Matrix_Design\info_distr\trialType.mat');
% % 
%         %put four quadrant files in one line.
%         filteredQuadNamesInfo= horzcat(filteredQuadNames{:,1}); 
% 
%             %Get all the information from the file name, such as what
%             %subject saw that image, on what session, what trial, etc. The
%             %output will have the following lines:
%                 % - First row is the same, the name of the file.
%                 % - Second row is the subjects #.
%                 % - Third row is the session #.
%                 % - Fourth - absolute trial #.
%                 % - Fifth - quadrant number (position within the trial)
%                 % - Sixth - type of quadrant: face, empty, inverted, etc. 
%                 % - Seventh - type of condition on that trial.
%              for i = 1:size(filteredQuadNamesInfo,2)
%                 fileName = filteredQuadNamesInfo{1,i}(1:end-4);
%                 C = strsplit(fileName, 'quad');
%                 B = strsplit(C{1,1}, '_');
%                 filteredQuadNamesInfo{2,i} = str2num(B{1,2});
%                 filteredQuadNamesInfo{3,i} = str2num(B{1,4});
%                 filteredQuadNamesInfo{4,i} = (filteredQuadNamesInfo{3,i}-1) * ...
%                                              72 + str2num(B{1,6});
%                 filteredQuadNamesInfo{5,i} = str2num(C{1,2});
%                 filteredQuadNamesInfo{6,i} = 6;
%                 filteredQuadNamesInfo{7,i} = trialType{1,filteredQuadNamesInfo{2,i}}...
%                                             (filteredQuadNamesInfo{4,i});
%              end
% % 
% %         %Finally, find matching trials and get rid of the images.
% %         temp = {filteredQuadNamesInfo{2,:}; filteredQuadNamesInfo{4,:}};
% %         temp = cell2mat(temp);
% %         [temp1 iA iC] = unique(temp','rows','stable');
% %         filteredQuadNamesInfo = filteredQuadNamesInfo(:,iA');
% % 
%     %Now, divide them up by quadrants and save as a different variable.
%     for j = 1:4
%         filteredQuadNamesInfoDIVIDED{j,1} = ...
%             filteredQuadNamesInfo(:,(find(cell2mat(filteredQuadNamesInfo(5,:)) == j)))
%     end
% %         
% README_filteredNamesInfo = ['This is a list of paths to face-quadrant files.',...
%     ' it was filtered so that no same image is replicated.'...
%      ' This still has images that appeared on the same trial but in'...
%      ' different quadrants. So that should still be filtered!!!'];
% save([homePath '4AFCImageDifficultyMaps\filteredNamesInfo.mat'],...
%     'filteredQuadNamesInfo','filteredQuadNamesInfoDIVIDED',...
%     'README_filteredNamesInfo');

load('C:\Users\Levan\HMAX\4AFCImageDifficultyMaps\filteredNamesInfo.mat');
% %::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
% %:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% %:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

%:::::::::::FILTER THE MATRIX BY THE UNIQUE FILE LIST::::::::::::::::::::
% clear; clc;
% loadPath = 'C:\Users\Levan\HMAX\Singles\';
% savePath = 'C:\Users\Levan\HMAX\4AFCImageDifficultyMaps\';
% load('C:\Users\Levan\HMAX\4AFCImageDifficultyMaps\fullyFilteredNamesAndInfo.mat')
if strcmp(patchType,'Triples') == 1
    load([loadPath 'allQuadsTrials1-500TEST2.mat']);
else
    load([loadPath 'allQuadsTrials1-500.mat']);
end

allQuadsTrialsEmpty = allQuadsTrials(1,:,1); %#ok<*NODEF>
allQuadsTrialsEmptyHorzcat = horzcat(allQuadsTrialsEmpty{1,:}); %#ok<*NASGU>

subjectsTrials = cell2mat({filteredQuadNamesInfo{2,:}; filteredQuadNamesInfo{4,:}}); %#ok<*USENS>
%cell2mat transformation is done so that the "find" function can work efficiently later.  

%Now check which of the EMPTY condition trials had the images that are
%contained in the filtered image list. Discard the ones that were not.

filterVectorForMatrix = []; %this will contain indexes of those trials on 
%which a face-quadrant was resented that was also part of the unique face-
%quadrant set.
filterVectorForImages = []; %this will contain idexes of those unique 
%face-quadrant images that were presented on one of the trials of the 
%condition.
filterVectorForImagesOrig = {};

for s = 1:size(allQuadsTrialsEmpty,2);
    
    for t = 1:size(allQuadsTrialsEmpty{s},2)
           
        if ~isempty(find(subjectsTrials(1,:) == s &...
                         subjectsTrials(2,:) == allQuadsTrialsEmpty{1,s}(t)))

                [~, uniqueIndex] = (find(subjectsTrials(1,:) == s &...
                      subjectsTrials(2,:) == allQuadsTrialsEmpty{1,s}(t)));
                filterVectorForImages(end+1) = uniqueIndex(1); %this ignores the issue
                %that there were two faces displayed on some trials. Must
                %be taken care of for the artificial-image dataset.
                filterVectorForImagesOrig{end+1} = uniqueIndex;

            if s == 1
                filterVectorForMatrix(end+1) = t;
            else
                filterVectorForMatrix(end+1) = ... 
                sum(cellfun(@numel, allQuadsTrialsEmpty(1:(s-1)))) ...
                + t;
            end
        end
    end
end

WQPureFiltered = WQpure(:,filterVectorForMatrix);
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


% %::::::BEGIN CONSTRUCTING IMAGE DIFFICULTY MAP AND STATS::::::::::::::::::::
% clear; clc; close;
% loadPath = 'C:\Users\Levan\HMAX\Singles\';
% load([loadPath 'imageDifficultyMatrixempty.mat']);
close;
MAT = WQPureFiltered'; %transpose so that images are Y and pathcs X axis.

%%%%%%%%%%%%%%%%%%%%%FOR TESTING THE CODE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAT = ones(size(MAT,1),size(MAT,2));
% % MAT(100:400,1:10) = 6;
% MAT(401:2:end,:) = 6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%:::::::::::SORTING THE MATRIX BY BEST PATCHES::::::::::::::::::::::::::::
for j = 1:size(MAT,2)
        %Find the ones that equal 6, because 6 means the patch chose 
        %face-quadrant. 1 means it chose empty quadrant.        
        sumStatsPatch(j) = numel(find(MAT(:,j)==6)); 
        sumStatsPatch(j) = (sumStatsPatch(j)*100)/size(MAT,1);
end
[sortSumStatsPatch, IndPatch] = sort(sumStatsPatch,'descend');
MAT = MAT(:,IndPatch); % sort the whole matrix by patches that "hit" the 
%images. The "best" patches will be on the left of the matrix. 

%::::::TRUNCATE MATRICES AND VECTORS TO WORK ONLY ON TOP N PATHCES::::::::
patchesShown = 500;
fprintf(['Displaying only the best ' int2str(patchesShown) ' patches!!!!']);
    MAT = MAT(:,1:patchesShown);
    sortSumStatsPatch = sortSumStatsPatch(1:patchesShown);
%Its better to truncate the whole MAT file, instead of leaving it as is and
%only changing the xlim of the plots below. Because when I calculate the
%number of patches that hit a particular image, it should only count those
%patches that we want to display. If xlim is changed, calculation will
%still be done on all patches, but only certain number of the will be
%displayed.

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


%:::::::::::SORTING THE MATRIX BY IMAGE DIFFICULTY::::::::::::::::::::::::
    for i = 1:size(MAT,1)
        %Find the ones that equal 6, because 6 means the patch chose 
        %face-quadrant. 1 means it chose empty quadrant.
        sumStatsImg(i) = numel(find(MAT(i,:)==6));
        sumStatsImg(i) = (sumStatsImg(i)*100)/size(MAT,2);
    end
[sortSumStatsImg, IndImg] = sort(sumStatsImg,'ascend');
MAT = MAT(IndImg,:); % sort the whole matrix by images that were "hit" most.
%The most-hit images will be at the bottom of the matrix now.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%For retreiving quad-image paths and viewing the quad-image, generate the list of the
%unique images that were presented. Use imshow to view the quad-images.
    uniqueQuadsPresented = filteredQuadNamesInfo(:,filterVectorForImages);
    
%Now sort this list of unique presented quadrants by # patches that hit them.
    uniqueQuadsPresentedSorted = uniqueQuadsPresented(:,IndImg);
    filterVectorForImagesOrigSorted = filterVectorForImagesOrig(:,IndImg);

%Now, get the path for the full image with all four quadrants.
    parts = strsplit(uniqueQuadsPresentedSorted{1,1},'faces');
        for k = 1:size(IndImg,2)
        uniqueImagesPresentedSorted{k} = [parts{1} ...
            'Images\Suj' int2str(uniqueQuadsPresentedSorted{2,k}) '\' ...
            int2str(uniqueQuadsPresentedSorted{2,k}) ...
            '_ses' int2str(uniqueQuadsPresentedSorted{3,k}) '_trial' ...
            int2str(uniqueQuadsPresentedSorted{4,k}-((uniqueQuadsPresentedSorted{3,k}-1)*72)) ...
            '.bmp'];
        end
%WEIRD OBSERVATION: THE MOST DIFFICULT IMAGES SEEMS TO BE THE LESS
%CLUTTERED ONES. DOUBLE, TRIPLE, QUADRUPLE CHECK THAT THE CODE IS RIGHT.
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


%::::::::::::::DISPLAYING THE FIGURE::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
h = figure('units','normalized','outerposition',[0 0.05 1 0.95]); %diplay fullscreen.
%     set(figure,'WindowStyle','normal'); %display docked.
        imageDifficultyAxes  = axes('position', [0.08 0.25 0.10 0.70]);
        mainDataAxes         = axes('position', [0.22 0.25 0.65 0.70]);
        patchPerformanceAxes = axes('position', [0.22 0.05 0.65 0.13]); 
    colormap(gray);
colormap(flipud(colormap)); %Up till now, high values in matrix are white
% while lower ones are black. Flip this so that higher ones are black and
% represent a "hit".

        axes(mainDataAxes)
            h = imagesc(MAT);
                    %     set(gca,'YDir','normal'); %reverse the Y-axis. 
                    set(gca,'YTick',[]);
                title(['Patch type is ' patchType '     (Black = Hit, White = Miss)'],'FontSize',15);
            ylabel([int2str(length(sortSumStatsImg)) ' Unique Trials']);
        xlabel('Patches sorted by number of face-quadrants they "Hit"')
    
        axes(imageDifficultyAxes);
            b = barh(1:length(sortSumStatsImg),fliplr(sortSumStatsImg),'k','BarWidth',1);
                set(gca,'xdir','reverse');
%                     set(gca,'YDir','reverse'); %reverse the Y-axis. 
                    ylim([0 length(sortSumStatsImg)]);
                    xlim([0 100]);
                title('"Difficulty" of Images','FontSize',15);
            xlabel('% of patches that "Hit" the face-quadrant','FontSize',7);
        ylabel('Images sorted by % of patches that "Hit" them');
        
        axes(patchPerformanceAxes);
             b1 = bar(1:length(sortSumStatsPatch),sortSumStatsPatch,'k','BarWidth',1);
                  xlim([1 length(sortSumStatsPatch)]);
                  ylim([0 100]);
      %             title('Patch performance','FontSize',5);
      %             xlabel('% of images Hit','FontSize',5);
        ylabel('% of images Hit','FontSize',7);
% %::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% save([homePath 'sandbox\' patchType 'Everything.mat']);
savefig([homePath '4AFCImageDifficultyMaps\Top500\' patchType quadType ...
    'ImageDifficultyTop500.fig']);
end
