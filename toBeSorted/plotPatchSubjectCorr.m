function plotPatchSubjectCorr(patchType, lastPatch)
%analyzes the correlation between each patch performance across conditions
%to the mean subject performance across conditions.
if (nargin < 2) 
    patchType = 'BlurTriples';
    lastPatch = 19600;
end

loadPath = ['/home/levan/HMAX/choiceAnalysis/' patchType '/'];
savePath = loadPath;
homePath = '/home/levan/HMAX/choiceAnalysis/';


load([homePath 'subjPerformance/performanceByCondSubj80.mat']);
load([loadPath 'patchChoices1-' int2str(lastPatch) '.mat']);
load([loadPath 'C2/locValues' patchType '.mat']);

% load(['C:\Users\Levan\Desktop\Friday\' patchType '\patchChoices.mat']);
% load(['C:\Users\Levan\Desktop\Friday\' patchType '\highLocPatchInd.mat'])

performance = performanceByCondSubj80;
patchChoices = fTotalChoicesColl;
indexes = indBlurTriples; % <------ CHANGE THIS

for i = 1:size(patchChoices,1);
[R(i), P(i)] = corr(performance(9,:)',patchChoices(i,:)');
end

lineColor = 'b';
close;
xLabelSize = 8;
xShown = 100;
xScale = lastPatch;

%:::::::::::::::::::::PLOTTING R-VALUES:::::::::::::::::::::::::::::::::
figure(1)
subplot(2,1,1)
rValues = plot(1:xScale,R(1:xScale),'-','color',lineColor);
% set(rValues,'linewidth',2);
labels = indexes(1:xScale);
set(gca,'XMinorTick','on','YMinorTick','on');

%     a = get(gca,'XTickLabel');
%     set(gca,'XTickLabel',a,'FontName','Times','fontsize',8)
%             set(gca,'XTick',1:xScale,'XTickLabel',labels);
%             set(gca(),'XTickLabel',indexes);
%             rotateXLabels(gca(),90);
% set(gca,'XTickLabel','');
xlabel([int2str(xScale) ' Patches'],'FontSize',15,'FontWeight','bold');
ylabel('R Value','FontSize',15,'FontWeight','bold');
title(['R values for ' patchType],'FontSize',20,'FontWeight','bold');

        figure(2)
        subplot(2,1,1)
        rValuesSub = plot(1:xScale,R(1:xScale),'-','color',lineColor);
        set(rValuesSub,'linewidth',2);
        grid on;
        labels = indexes(1:xScale);
        axis([0 xShown 0 100]);
        axis 'auto y';
        set(gca,'YMinorTick','on');
            a = get(gca,'XTickLabel');
            set(gca,'XTickLabel',a,'FontName','Times','fontsize',xLabelSize)
                    set(gca,'XTick',1:xScale,'XTickLabel',labels);
                    set(gca(),'XTickLabel',indexes);
                    rotateXLabels(gca(),90);
        xlabel([int2str(xShown) ' Patches'],'FontSize',15,'FontWeight','bold');
        ylabel('R Value','FontSize',15,'FontWeight','bold');
        title(['R values for ' patchType],'FontSize',20,'FontWeight','bold');

%::::::::::::::::::::::::::::::::::::::::::::::::::::::

%:::::::::::::::PLOTTING P-VALUES::::::::::::::::::::::
figure(1)
subplot(2,1,2)
pValues = plot(1:xScale,P(1:xScale),'-','color',lineColor);
% set(pValues,'linewidth',2);
set(gca,'XMinorTick','on','YMinorTick','on');
%     a = get(gca,'XTickLabel');
%     set(gca,'XTickLabel',a,'FontName','Times','fontsize',8) 
% set(gca,'XTick',1:xScale,'XTickLabel',labels);
% set(gca(),'XTickLabel',indexes);
% rotateXLabels(gca,90);
% set(gca,'XTickLabel','');
xlabel([int2str(xScale) ' Patches'],'FontSize',15,'FontWeight','bold');
ylabel('P Value','FontSize',15,'FontWeight','bold');
title(['P values for ' patchType],'FontSize',20,'FontWeight','bold');
hold on;
plot(1:xScale,ones(1,xScale)*0.05,'color','r');
hold off;

        figure(2)
        subplot(2,1,2)
        pValuesSub = plot(1:xScale,P(1:xScale),'-','color',lineColor);
        set(pValuesSub,'linewidth',2);
        grid on;
        axis([0 xShown 0 100]);
        axis 'auto y';
        set(gca,'YMinorTick','on');
            a = get(gca,'XTickLabel');
            set(gca,'XTickLabel',a,'FontName','Times','fontsize',xLabelSize)
        set(gca,'XTick',1:xScale,'XTickLabel',labels);
        set(gca(),'XTickLabel',indexes);
        rotateXLabels(gca,90);
        xlabel([int2str(xShown) ' Patches'],'FontSize',15,'FontWeight','bold');
        ylabel('P Value','FontSize',15,'FontWeight','bold');
        title(['P values for ' patchType],'FontSize',20,'FontWeight','bold');
        hold on;
        plot(1:xScale,ones(1,xScale)*0.05,'color','r');
        hold off;
%::::::::::::::::::::::::::::::::::::::::::::::::::::::

end