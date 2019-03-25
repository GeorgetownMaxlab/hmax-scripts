%compare per trial choices
%THIS CODE IS INCOMPLETE

clearvars -except winnderQuads; clc;
path = '~/Desktop/lfw/Behavior/'; 
p = 1; s = 1; c = 1; i = 1;

load([path 'winnerQuads.mat']);
load([path 'allQuadsTrials.mat']);
load('/Users/levan/Desktop/Psychophysics/Comparing/DATA/Quadrant_EP');
load('/Users/levan/Desktop/Psychophysics/Comparing/DATA/AllTRPremSacc.mat')

minSRT = 80;
% 
% for s = 1:8
% ind = find(AllTRPremSacc{1,s} >= minSRT);
% Quadrant_EP_Thresholded{1,s} = Quadrant_EP{1,s}(ind);
% trialsThresholded{1,s} = ind;
% end
% 
% save([path 'Quadrant_EP' num2str(minSRT)],'Quadrant_EP_Thresholded');
% save([path 'trialsThresholded' num2str(minSRT)],'trialsThresholded');

load([path 'trialsThresholded' num2str(minSRT)]);
load([path 'Quadrant_EP' num2str(minSRT)]);
%:::::::::::::::::Start comparing trial by trial:::::::::::::::::::::::::::
for p = 1:size(winnerQuads,1)
    tic;
    p
%     p
    for s = 1:8
        for c = 1:5
            ind = find(allQuadsTrials{p,s,c} == trialsThresholded{1,s})
            winnerQuads{p,s,c}(1,ind)
            
            
            for i = 1:size(winnerQuads{p,s,c},2)                 
                                      
            end
        end
    end
    toc;
end; %PATCH
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



