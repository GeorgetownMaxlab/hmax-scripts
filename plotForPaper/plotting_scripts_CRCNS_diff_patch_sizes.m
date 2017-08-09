% Script to plot images for CRCNS paper.
clear; clc; close;
dbstop if error;

plotSinglesTraining = 0;
plotSinglesTesting  = 0;
plotSinglesOverlay  = 1;


home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3';
tasks   = {'patchSetAdam','patchSet_1x2','patchSet_2x1','patchSet_1x3','patchSet_3x1','patchSet_2x3','patchSet_3x2'};
legends = {'patchSet 2x2','patchSet 1x2','patchSet 2x1','patchSet 1x3','patchSet 3x1','patchSet 2x3','patchSet 3x2'};

% condition = 'training';
% iTask = 1;

for iTask = 1:numel(tasks)
    iTask
    %% Plot performance of single patches on testing set
    if plotSinglesTraining
        lineWidth = 2;
        set(groot,'defaultLineLineWidth',lineWidth);
        
        fontSize = 12;
        chancePerf = 8;
        yaxislimit = 70;
        
        % load the variables
        %     load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat');
        load(fullfile(home,'training','data',tasks{iTask},'lfwSingle50000','fixedLocalization','patchPerformanceInfo_Wedge_30.mat'));
        
        plot(sortSumStatsPatch)
        hold on
        plot(ones(1,length(sortSumStatsPatch))*chancePerf,'k');
        hold off
        legend('Single Patches','Chance Performance');
        ylabel('Percent Hit','FontSize',fontSize)
        xlabel('Patches','FontSize',fontSize)
        ylim([0 yaxislimit])
        
        % visual properties
        ax = gca;
        % ax.YMinorGrid = 'on';
        ax.YGrid = 'on';
        ax.XTick = [1 10000 20000 30000 40000 50000];
        ax.XTickLabel = {'1' '10,000','20,000','30,000','40,000','50,000'};
        ax.YTick = sort([0:10:yaxislimit chancePerf round(max(sortSumStatsPatch),2)],'ascend');
        
        %%%%%%%%%%%%%%%
        % SUBSET FIGURE
        %%%%%%%%%%%%%%%
        
        figure
        
        subset = 50;
        plot(sortSumStatsPatch(1:subset),'-o','LineWidth',1,'MarkerSize',5,'MarkerFaceColor','b');
        hold on
        plot(ones(1,subset)*chancePerf,'k');
        hold off
        legend('Single Patches','Chance Performance');
        ylabel('Percent Hit','FontSize',fontSize)
        xlabel('Patches','FontSize',fontSize)
        ylim([0 yaxislimit]);
        xlim([1 subset]);
        
        % visual properties
        ax = gca;
        % ax.YMinorGrid = 'on';
        ax.YGrid = 'on';
        ax.XTick = [1:10:subset subset];
        ax.XTickLabel = {'1' '10' '20' '30' '40' '50'};
        ax.YTick = sort([0:10:yaxislimit chancePerf round(max(sortSumStatsPatch(1:subset)),2)],'ascend');
    end
    %% plot single patches on the training set
    if plotSinglesTesting
        lineWidth = 2;
        set(groot,'defaultLineLineWidth',lineWidth);
        
        fontSize = 12;
        chancePerf = 8;
        yaxislimit = 70;
        
        % load the variables
        %     load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat');
        load(fullfile(home,'testing','data',tasks{iTask},'lfwSingle50000','fixedLocalization','patchPerformanceInfo_Wedge_30.mat'));
        
        plot(sortSumStatsPatch,'r')
        hold on
        plot(ones(1,length(sortSumStatsPatch))*chancePerf,'k');
        hold off
        legend('Single Patches','Chance Performance');
        ylabel('Percent Hit','FontSize',fontSize)
        xlabel('Patches','FontSize',fontSize)
        ylim([0 yaxislimit])
        
        % visual properties
        ax = gca;
        % ax.YMinorGrid = 'on';
        ax.YGrid = 'on';
        ax.XTick = [1 10000 20000 30000 40000 50000];
        ax.XTickLabel = {'1' '10,000','20,000','30,000','40,000','50,000'};
        ax.YTick = sort([0:10:yaxislimit chancePerf round(max(sortSumStatsPatch),2)],'ascend');
        
        %%%%%%%%%%%%%%%
        % SUBSET FIGURE
        %%%%%%%%%%%%%%%
        
        figure
        
        subset = 50;
        plot(sortSumStatsPatch(1:subset),'-or','LineWidth',1,'MarkerSize',5,'MarkerFaceColor','r');
        hold on
        plot(ones(1,subset)*chancePerf,'k');
        hold off
        legend('Single Patches','Chance Performance');
        ylabel('Percent Hit','FontSize',fontSize)
        xlabel('Patches','FontSize',fontSize)
        ylim([0 yaxislimit]);
        xlim([1 subset]);
        
        % visual properties
        ax = gca;
        % ax.YMinorGrid = 'on';
        ax.YGrid = 'on';
        ax.XTick = [1:10:subset subset];
        ax.XTickLabel = {'1' '10' '20' '30' '40' '50'};
        ax.YTick = sort([0:10:yaxislimit chancePerf round(max(sortSumStatsPatch(1:subset)),2)],'ascend');
    end
    
    %% overpay training and testing performance for singles
    if plotSinglesOverlay
        lineWidth = 2;
        set(groot,'defaultLineLineWidth',lineWidth);
        
        fontSize = 12;
        chancePerf = 8;
        yaxislimit = 40;
        
        % load the variables
        %     load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat',...
        %         'sortSumStatsPatch','IndPatch');
        load(fullfile(home,'testing','data',tasks{iTask},'lfwSingle50000','fixedLocalization','patchPerformanceInfo_Wedge_30.mat'));
        
        singles_testing_sorted = sortSumStatsPatch;
        ind_by_testing = idx_best_patches;
        %     load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\training\data\patchSetAdam\lfwSingle50000\imageDifficultyData_Wedge_50000_Patches.mat',...
        %         'sumStatsPatch');
        load(fullfile(home,'training','data',tasks{iTask},'lfwSingle50000','fixedLocalization','patchPerformanceInfo_Wedge_30.mat'));
        
        % recreate sumStatsPatch variable
        [~,idx_rev_sort] = sort(idx_best_patches);
        sumStatsPatch    = sortSumStatsPatch(idx_rev_sort);
        
        singles_training_unsorted = sumStatsPatch;
        singles_training_sorted_by_testing = singles_training_unsorted(ind_by_testing);
        clearvars idx_best_patches sortSumStatsPatch sumStatsPatch
        
        subplot(2,1,1)
        plot(singles_training_sorted_by_testing,'LineWidth',1)
        hold on
        plot(singles_testing_sorted,'r')
        plot(ones(1,length(singles_testing_sorted))*chancePerf,'k');
        hold off
        legend('Training Set','Testing Set', 'Chance');
        ylabel('Percent Hit','FontSize',fontSize)
        xlabel('Patches','FontSize',fontSize)
        ylim([0 yaxislimit])
        title(legends{iTask})
        
        % visual properties
        ax = gca;
        % ax.YMinorGrid = 'on';
        ax.YGrid = 'on';
        ax.XTick = [1 10000 20000 30000 40000 50000];
        ax.XTickLabel = {'1' '10,000','20,000','30,000','40,000','50,000'};
        ax.YTick = sort([0:10:yaxislimit chancePerf round(max(singles_testing_sorted),2)],'ascend');
        
        %%%%%%%%%%%%%%%
        % SUBSET FIGURE
        %%%%%%%%%%%%%%%
        
        subplot(2,1,2)
        markersize = 1;
        subset = 100;
        plot(singles_testing_sorted(1:subset),...
            '-or','LineWidth',0.5,'MarkerSize',markersize,'MarkerFaceColor','r')%,'MarkerEdgeColor','k');
        hold on
        plot(singles_training_sorted_by_testing(1:subset),...
            '-ob','LineWidth',0.5,'MarkerSize',markersize,'MarkerFaceColor','b')%,'MarkerEdgeColor','k');
        plot(ones(1,subset)*chancePerf,'k');
        hold off
        legend('Testing Set','Training Set','Chance');
        ylabel('Percent Hit','FontSize',fontSize)
        xlabel('Patches','FontSize',fontSize)
        title(legends{iTask})
        
        % visual properties
        ax = gca;
        % ax.YMinorGrid = 'on';
        ax.YGrid = 'on';
        increment = 10;
        ax.XTick = sort([0:increment:subset,1]);
        for iLabel = 1:length(ax.XTick)
            ax.XTickLabel{iLabel} = int2str(ax.XTick(iLabel));
        end
        ax.YTick = sort([0:10:yaxislimit chancePerf round(max(singles_testing_sorted(1:subset)),2)],'ascend');
        ylim([0 yaxislimit]);
        xlim([1 subset]);
        if subset > 500
            ax.XTickLabelRotation = -90;
        end
        
        saveas(gcf,['C:\Users\levan\Desktop\images\' legends{iTask} '.png'])
        
    end % if plotting singles overlay

end