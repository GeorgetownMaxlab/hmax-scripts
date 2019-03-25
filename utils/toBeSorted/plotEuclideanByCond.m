
function plotEuclideanByCond (patchType,nPatches)
%Find euclidean distance between subjects' performance by conditions and
%patch performances by condition.
%PatchType signifies whether patches analyzed are the single- or
%double-patches.

if (nargin < 1)
    patchType = 'Singles';
    nPatches = 10000;
end
   
loadPath = ('/home/levan/HMAX/choiceAnalysis/');
savePath = loadPath;

load([loadPath patchType '/patchChoices1-' int2str(nPatches) '.mat']);
load([loadPath patchType '/C2/locValues' patchType '.mat']);
load([loadPath 'subjPerformance/performanceByCondSubj80.mat']);

performance = performanceByCondSubj80;

euclidReady = [performance(9,:); fTotalChoicesColl];

D = pdist(euclidReady); D = D(1:nPatches);


plotName = patchType(1:end-1);
xScale = nPatches;
xShown = 100;
lineColor = 'b';

labels = indBlurTriples; %< ----- CHANGE THIS

close;
subplot(2,1,1)
plot(1:xScale,D(1:xScale),'-.','color',lineColor);
set(gca,'YMinorTick','on');
% set(gca,'XTick',1:xScale,'XTickLabel',labels);
%         a = get(gca,'XTickLabel');
%         set(gca,'XTickLabel',a,'FontName','Times','fontsize',8)
%         rotateXLabels(gca,90); 
title(['Euclidean Distances between subjects and ' int2str(nPatches) ' ' plotName ' patches broken down by condition'], ...
    'FontSize',17,'FontWeight','bold')
xlabel ([int2str(nPatches) ' ' plotName 'Patches'],'FontSize',15,'FontWeight','bold')
ylabel ('Euclidean Distance','FontSize',15,'FontWeight','bold')

subplot(2,1,2)
top100 = plot(1:xScale,D(1:xScale),'-.','color',lineColor);
set(top100,'linewidth',2);
axis([0 xShown 0 100]);
axis 'auto y';
set(gca,'YMinorTick','on');
set(gca,'XTick',1:xScale,'XTickLabel',labels);
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',10)
        rotateXLabels(gca,90); 
title(['Euclidean Distances between subjects and ' int2str(xShown) ' ' plotName ' patches broken down by condition'], ...
    'FontSize',17,'FontWeight','bold')
xlabel ([int2str(xShown) ' ' plotName ' Patches'],'FontSize',15,'FontWeight','bold')
ylabel ('Euclidean Distance','FontSize',15,'FontWeight','bold')
end

