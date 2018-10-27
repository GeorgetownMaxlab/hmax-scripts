% % % clear; clc; close;
% % % load('C:\Users\Levan\HMAX\Singles\patchChoices1-10000.mat');
% % % load('C:\Users\Levan\HMAX\subjPerformance\performanceByCondSubj80.mat');
% % % meanPerf = performanceByCondSubj80(9,:);
% % % 
% % % for i = 1:size(fTotalChoicesColl,1);
% % % [R(i), P(i)] = corr(meanPerf',fTotalChoicesColl(i,:)');
% % % end
% % % sigInd = find(P < 0.05);
% % % sigR = R(sigInd);
% % % S = [sigR; sigInd; ones(1,length(sigInd))]; 
% % % SChoices = fTotalChoicesColl(sigInd,:);
% % % clear R P;
% % % 
% % %     load('C:\Users\Levan\HMAX\Doubles\patchChoices1-4950.mat');
% % %     for i = 1:size(fTotalChoicesColl,1);
% % %     [R(i), P(i)] = corr(meanPerf',fTotalChoicesColl(i,:)');
% % %     end
% % %     sigInd = find(P < 0.05);
% % %     sigR = R(sigInd);
% % %     D = [sigR; sigInd; ones(1,length(sigInd))*2];
% % %     DChoices = fTotalChoicesColl(sigInd,:);
% % %     clear R P;
% % %     fprintf('Doubles done')
% % % load('C:\Users\Levan\HMAX\Triples\patchChoices1-19600.mat');
% % % for i = 1:size(fTotalChoicesColl,1);
% % % [R(i), P(i)] = corr(meanPerf',fTotalChoicesColl(i,:)');
% % % end
% % % sigInd = find(P < 0.05);
% % % sigR = R(sigInd);
% % % T = [sigR; sigInd; ones(1,length(sigInd))*3];
% % % TChoices = fTotalChoicesColl(sigInd,:);
% % % clear R P;
% % % fprintf('Triples done')
% % %     load('C:\Users\Levan\HMAX\BlurDoubles\patchChoices1-4950.mat');
% % %     for i = 1:size(fTotalChoicesColl,1);
% % %     [R(i), P(i)] = corr(meanPerf',fTotalChoicesColl(i,:)');
% % %     end
% % %     sigInd = find(P < 0.05);
% % %     sigR = R(sigInd);
% % %     BD = [sigR; sigInd; ones(1,length(sigInd))*4];
% % %     BDChoices = fTotalChoicesColl(sigInd,:);
% % %     clear R P;
% % % load('C:\Users\Levan\HMAX\BlurTriples\patchChoices1-19600.mat');
% % % for i = 1:size(fTotalChoicesColl,1);
% % % [R(i), P(i)] = corr(meanPerf',fTotalChoicesColl(i,:)');
% % % end
% % % sigInd = find(P < 0.05);
% % % sigR = R(sigInd);
% % % BT = [sigR; sigInd; ones(1,length(sigInd))*5];
% % % BTChoices = fTotalChoicesColl(sigInd,:);
% % % clear R P;
% % % 
% % % ALL = [S D T BD BT];
% % % save('correlationsAll');
% % % ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% % % ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% % clear; clc;
% % load('correlationsAll.mat');
% % ALLSorted = sortrows(ALL'); ALLSorted = fliplr(ALLSorted');
% % % meanPerf = load('C:\Users\Levan\HMAX\subjPerformance\performanceByCondSubj80.mat');
% % % meanPerf = meanPerf.performanceByCondSubj80;
% % ALLSorted = ALLSorted(:,1:50);
% % SPR  = ALLSorted(1:2,(find(ALLSorted(3,:) == 1)));
% % load('C:\Users\Levan\HMAX\Singles\patchChoices1-10000.mat');
% % SChoicesSorted = fTotalChoicesColl(SPR(2,:),:);
% % DPR  = ALLSorted(1:2,(find(ALLSorted(3,:) == 2)));
% % load('C:\Users\Levan\HMAX\Doubles\patchChoices1-4950.mat');
% % DChoicesSorted = fTotalChoicesColl(DPR(2,:),:);
% % TPR  = ALLSorted(1:2,(find(ALLSorted(3,:) == 3)));
% % load('C:\Users\Levan\HMAX\Triples\patchChoices1-19600.mat');
% % TChoicesSorted = fTotalChoicesColl(TPR(2,:),:);
% % BDPR = ALLSorted(1:2,(find(ALLSorted(3,:) == 4)));
% % load('C:\Users\Levan\HMAX\BlurDoubles\patchChoices1-4950.mat');
% % BDChoicesSorted = fTotalChoicesColl(BDPR(2,:),:);
% % BTPR = ALLSorted(1:2,(find(ALLSorted(3,:) == 5)));
% % load('C:\Users\Levan\HMAX\BlurTriples\patchChoices1-19600.mat');
% % BTChoicesSorted = fTotalChoicesColl(BTPR(2,:),:);
% % 
% % %Now calculate Diff between subj performance and patch performance
% % perf = repmat(meanPerf,size(SChoicesSorted,1),1);
% % SDiffSorted = perf - SChoicesSorted;
% % perf = repmat(meanPerf,size(DChoicesSorted,1),1);
% % DDiffSorted = perf - DChoicesSorted;
% % perf = repmat(meanPerf,size(TChoicesSorted,1),1);
% % TDiffSorted = perf - TChoicesSorted;
% % perf = repmat(meanPerf,size(BDChoicesSorted,1),1);
% % BDDiffSorted = perf - BDChoicesSorted;
% % perf = repmat(meanPerf,size(BTChoicesSorted,1),1);
% % BTDiffSorted = perf - BTChoicesSorted;
% % %:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% % 
% % save('correlationStage2');
% clear; clc; close;
% load('correlationStage3'); %After stage 2, I calculated the confidence intervals for 
% %the mean subject performances using the [h,p,ci,stats] = ttest(x) formula.
% %:::PLOT ABSOLUTE VALUES::::::::
% % subj = plot(meanPerf,'color','m');
% subj = errorbar(meanPerf,ciHalf,'color','m');
% hold on;
% 
% sing = plot(SChoicesSorted','color','m');
% doub = plot(DChoicesSorted','color','g');
% trip = plot(TChoicesSorted','color','b');
% bdoub = plot(BDChoicesSorted','color','k');
% btrip = plot(BTChoicesSorted','color','r');
%     set(subj,'linewidth',2);
%     set(doub,'linewidth',2);
%     set(trip,'linewidth',2);
%     set(bdoub,'linewidth',2);
%     % legend('singles','doubles','triples','blurr doubles','blur triples')
%     labels = {'Empty','Scrambled','Houses','Inverted','Configural'};
%     set(gca,'XTick',1:5,'XTickLabel',labels);
%     title('Plotting Absolute Performance Values of Subjects and 95% Confidense Intervals, and top 50 Patch Performances in the EMPTY Condition');
%     xlabel('Conditions','FontSize',15);
%     ylabel('Absolute Value of Face Selectivity in the EMPTY Condition');
% 
% %:::PLOT Diff::::::::
% % sing = plot(SDiffSorted','color','m');
% % hold on;
% % doub = plot(DDiffSorted','color','g');
% % trip = plot(TDiffSorted','color','b');
% % bdoub = plot(BDDiffSorted','color','k');
% % btrip = plot(BTDiffSorted','color','r');
% % set(doub,'linewidth',2);
% % set(trip,'linewidth',2);
% % set(bdoub,'linewidth',2);
% % % legend('singles','doubles','triples','blurr doubles','blur triples')
% % labels = {'Empty','Scrambled','Houses','Inverted','Configural'};
% % set(gca,'XTick',1:5,'XTickLabel',labels);
% % title('Plotting Differences Between Subject and top 50 Patch Performances');
% % xlabel('Conditions','FontSize',15);
% % ylabel('Difference in Selectivity Percentage');

%:::script for parsing the names and then filtering the heatmap::::::::
% clear; clc;
% load('C:\Users\Levan\HMAX\Singles\locationFiles\locOrigFiles.mat');
% 
% for i = 1:length(filteredQuadNames)
%    noQuad{:,i} = strsplit(filteredQuadNames{1,i},'quad')'; 
% end
% backUp = noQuad;
% for i = 1:length(filteredQuadNames)
% noQuad{1,i} = noQuad{1,i}{1,1};
% end
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

%:::::::::::::::Singling our the EMPTY CONDITION RECURSIVELY::::::::::::::
% 
% 
% % if (nargin < 1)
%     quadType = 'empty';
%     helperNum = 4500;
%     lastPatch = 4950;
%     incr = 500;
%     loadPath = 'C:\Users\Levan\HMAX\Doubles\';
% % end
% 
% for f = 4500:incr:helperNum
%     fprintf('loading next winnerQuads file\n');
%     if f == helperNum
%         load([loadPath 'winnerQuads' int2str(f+1) '-' int2str(lastPatch) '.mat']);
%         fprintf('loaded the LAST winnerQuads file');
%     else
%     load([loadPath 'winnerQuads' int2str(f+1) '-' int2str(f+incr) '.mat']);
%     fprintf(['loaded ' int2str(f+1) '-' int2str(f+incr) '\n']);
%     end   
% 
% % load([loadPath 'WQ1-500.mat']);
% 
% %Choose only the EMPTY condition, discard the rest:
%     WQ = winnerQuads(:,:,1); 
%     clear winnerQuads; 
%     save([loadPath 'WQ' quadType int2str(f+1) '-' int2str(f+incr) '.mat'], 'WQ');
% end

%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


%% ::::::::HEATMAP CONSTRUCTION STUFF::::::::::::::::::::::::::
% clear; clc; close;
% loadPath = 'C:\Users\Levan\HMAX\Singles\';
% load([loadPath 'heatMapMatrixempty.mat']);
% 
% MAT = WQpure';
%     for i = 1:size(MAT,1)
%     sumStats(i) = numel(find(MAT(i,:)==1));
%     sumStats(i) = (sumStats(i)*100)/size(MAT,2);
%     end
% [sortSumStats, Ind] = sort(sumStats,'ascend');
% MAT = MAT(Ind,:); % sort the whole matrix by images that were "hit" most. 
% 
%     h = imagesc(MAT);
%     colormap(gray);
%     colormap(flipud(colormap)); %flip values, so that white = "hit", black = "miss."
%     set(gca,'YDir','normal'); %reverse the Y-axis. 
%     
%     %MUST ADD: HEATMAP ON THE SIDE, FORMATTING THE AXES.
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% load([loadPath 'filteredNames.mat']); %load the paths to unique face-quadrants.


%% :::::::::::FILTERING SHIT::::::::::::::::::::
% clear; clc;
% loadPath = 'C:\Users\Levan\HMAX\Singles\';
% savePath = 'C:\Users\Levan\HMAX\4AFCHeatMaps\';
% load('C:\Users\Levan\HMAX\4AFCHeatMaps\fullyFilteredNamesAndInfo.mat')
% load([loadPath 'allQuadsTrials1-500.mat']); 
% 
% trialsEmpty = allQuadsTrials(1,:,1);
%     trialsEmptyHorzcat = horzcat(trialsEmpty{1,:});
% subjectsTrials = cell2mat({filteredQuadNamesFilteredTrials{2,:}; filteredQuadNamesFilteredTrials{4,:}});
%     
%     
% filterVector = [];    
% for s = 1:size(trialsEmpty,2);
%     
%     for t = 1:size(trialsEmpty{s},2)
%             if ~isempty(find(subjectsTrials(1,:) == s & subjectsTrials(2,:) == trialsEmpty{1,s}(t)))
%                 if s == 1
%                     filterVector(end+1) = t;
%                 else
%                     filterVector(end+1) = size(trialsEmpty{s-1},2) + t;
%                 end
%             end
%     end
% end
% load('C:\Users\Levan\HMAX\Singles\WQpureempty1-10000.mat');
% WQpure1 = WQpure(:,filterVector);
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

%:::::::::::::::sanity checking the filtering of the heatmap matrix:::::
% for s = 1:8
% 
% trialsEmpty{1,s}(2,:) = s;
% 
% end
% trialsEmptyHorzcat = trialsEmptyHorzcat';
% [uniq ia ic] = unique(trialsEmptyHorzcat,'rows','stable');
% %::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

% %::::::::::::::::::::::IMAGE DIFFICULTY::::::::::::::::::::::::::::::::::
% %how many trials in the matrix had two faces. 
% 
% cellsz = cellfun(@length,filterVectorForImagesOrigSorted);
% bar(cellsz);
% scatter(1:length(cellsz),cellsz,'.',4);
% ylim([0 2.5]);
% xlim([0 length(cellsz)]);
% %:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




