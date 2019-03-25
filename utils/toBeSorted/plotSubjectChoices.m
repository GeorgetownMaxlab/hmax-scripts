%Simply plots the performance of subjects on Florence's psychophysics experiment.
load('C:\Users\Levan\Desktop\Friday\performanceByCondSubj80_woSubj3.mat');

close;
xScale = 5;                    
xShown = 5;
labels = {'Empty', 'Scrambled', 'Houses', 'Inverted', 'Configural'};
% labels = [Empty Scrambled Houses Inverted Configural]

handleMean = plot(1:xScale,performance(8,:),'.-','color','b');
set(handleMean,'linewidth',5);
hold on;
plot(1:xScale,performance(7,:),'.-','color','m');
plot(1:xScale,performance(6,:),'.-','color','c');
plot(1:xScale,performance(5,:),'.-','color','r');
plot(1:xScale,performance(4,:),'.-','color','g');
plot(1:xScale,performance(3,:),'.-','color','b');
plot(1:xScale,performance(2,:),'.-','color','y');
plot(1:xScale,performance(1,:),'.-','color','k');

% plot(1:xScale,ePercent(1:xScale,1),'.-','color','k')
axis([1 xShown 30 100]);
set(gca,'XTick',1:xScale,'XTickLabel',labels);
        e = get(gca,'XTickLabel');
        set(gca,'XTickLabel',e,'FontName','Times','fontsize',17);
ylabel('Percentage Chosen Correctly','FontSize',20,'FontWeight','bold');
title('Subject Performance By Conditions','FontSize',20,'FontWeight','bold');