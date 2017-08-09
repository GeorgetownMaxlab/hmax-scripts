%plotPatchChoices
clear; clc;
loadPath = ('C:\Users\Levan\Desktop\Friday\Doubles\');
load([loadPath 'patchChoices.mat']);
fPercent = fTotalChoicesColl;
ePercent = eTotalChoicesColl;
dPercent = dTotalChoicesColl;


%:::::Subplots, all arranged by Face-performance in EMPTY condition:::::
% [~, fInd] = sort(fPercent(:,1)','descend');
% % Resort everything by fInd:
% fPercent(:,:) = fPercent(fInd,:);
% ePercent(:,:) = ePercent(fInd,:);
% dPercent(:,:) = dPercent(fInd,:);
%::::::::::::::::::::::::::::::::::::::::::::::::::::

load('C:\Users\Levan\Desktop\Friday\Doubles\highLocPatchInd.mat');
sorted = (sorted/5037)*100;
%:::::::::::::::::::::::A 5x1 subplot of performances by conditions:::::::
close;
xScale = 20;                    
xShown = 20;
labels = indexes(1:xScale);
% 
subplot(5,1,1)
plot(1:xScale,fPercent(1:xScale,1),'.-','color','b')
hold on;
plot(1:xScale,ePercent(1:xScale,1),'.-','color','k')
plot(1:xScale,sorted(1:xScale),'.-','color','g')
axis([1 xShown 0 100]);
set(gca,'XTick',1:xScale,'XTickLabel',labels);
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',7)
title('EMPTY Condition','FontSize',10,'FontWeight','bold')

    subplot(5,1,2)
    plot(1:xScale,fPercent(1:xScale,2),'.-','color','b')
    hold on;
    plot(1:xScale,ePercent(1:xScale,2),'.-','color','k')
    plot(1:xScale,dPercent(1:xScale,2),'.-','color','r')
    axis([1 xShown 0 100]);
    set(gca,'XTick',1:xScale,'XTickLabel',labels);
        b = get(gca,'XTickLabel');
        set(gca,'XTickLabel',b,'FontName','Times','fontsize',7)
    title('SCRAMBLED Condition','FontSize',10,'FontWeight','bold')

subplot(5,1,3)
plot(1:xScale,fPercent(1:xScale,3),'.-','color','b')
hold on;
plot(1:xScale,ePercent(1:xScale,3),'.-','color','k')
plot(1:xScale,dPercent(1:xScale,3),'.-','color','r')
axis([1 xShown 0 100]);
set(gca,'XTick',1:xScale,'XTickLabel',labels);
        c = get(gca,'XTickLabel');
        set(gca,'XTickLabel',c,'FontName','Times','fontsize',7)

title('HOUSES Condition','FontSize',10,'FontWeight','bold')
ylabel('Percentage Chosen','FontSize',30,'FontWeight','bold')

    subplot(5,1,4)
    plot(1:xScale,fPercent(1:xScale,4),'.-','color','b')
    hold on;
    plot(1:xScale,ePercent(1:xScale,4),'.-','color','k')
    plot(1:xScale,dPercent(1:xScale,4),'.-','color','r')
    axis([1 xShown 0 100]);
    set(gca,'XTick',1:xScale,'XTickLabel',labels);
        d = get(gca,'XTickLabel');
        set(gca,'XTickLabel',d,'FontName','Times','fontsize',7)
    
    title('INVERTED Condition','FontSize',10,'FontWeight','bold')

subplot(5,1,5)
plot(1:xScale,fPercent(1:xScale,5),'.-','color','b')
hold on;
plot(1:xScale,ePercent(1:xScale,5),'.-','color','k')
plot(1:xScale,dPercent(1:xScale,5),'.-','color','r')
axis([1 xShown 0 100]);
set(gca,'XTick',1:xScale,'XTickLabel',labels);
        e = get(gca,'XTickLabel');
        set(gca,'XTickLabel',e,'FontName','Times','fontsize',7)


xlabel ('40 Double-Patches','FontSize',10,'FontWeight','bold')
title('CONFIGURAL Condition','FontSize',10,'FontWeight','bold')
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::