function [winnerQuads, patchChoices] = getWinnerQuadStatistics(allQuads, loadPath, savePath)
%For each trial finds the quadrant C2 that is the minimum.
% Also calculates percentage-wise, how many times did pathces "choose"
% face-quadrants, empty-quadrants, distractor-quadrants. 

if (nargin < 1) 
    loadPath = '/home/levan/HMAX/choiceAnalysis/Triples/'; %#ok<*NASGU>
    savePath = '/home/levan/HMAX/choiceAnalysis/Triples/';
    load([loadPath 'allQuads1-10.mat']);
end;

%::::::::::Find the "winner" quad trial-by-trial::::::::::::
% p = 1; s = 1; c = 1; i = 1;
%clear; clc;
% load([loadPath 'allQuads.mat']);
winnerQuads = {};
for p = 1:size(allQuads,1)
    tic;
    	if mod(p,10) == 0
	 	display(p)
	 	end

    for s = 1:8
        for c = 1:5
            for i = 1:size(allQuads{p,s,c},2)                 
                [minC2, indC2] = min(allQuads{p,s,c}{1,i}(:,1));
                winnerQuads{p,s,c}{1,i}(1,:) = allQuads{p,s,c}{1,i}(indC2,:);                           
            end
        end
    end
    toc;
end; %PATCH
save([savePath 'winnerQuads'],'winnerQuads');
fprintf('saved winnerQuads\n');
%:::::::::::::::::::%:::::::::::::::::::%:::::::::::::::::::%:::::::::::::::::::


%:::::::::::::::::::Calculate Patch Performance::::::::::::::::

%patchChoices is a struct containing 
% - fTotalChoices: # of times face was chosen, broken down by subjects;
% - fTotalChoicesColl: collapsed across subjects;
% - eTotalChoices: # of times face was chosen, broken down by subjects;
% - eTotalChoicesColl: collapsed across subjects;
% - dTotalChoices: # of times face was chosen, broken down by subjects. 
% - dTotalChoicesColl: collapsed across subjects;
fChoices = 0; eChoices = 0; dChoices = 0;
fChoicesColl = 0; eChoicesColl = 0; dChoicesColl = 0; %to get the patch-choice data collapsed across subjects.
for p = 1:size(winnerQuads,1)
    
	 if mod(p,10) == 0
	 display(p)
	 end

    for c = 1:5
        for s = 1:8
            if s == 3 && c == 4 
               fTotalChoices(p,s,c) = NaN; %#ok<*SAGROW>
               eTotalChoices(p,s,c) = NaN;
               dTotalChoices(p,s,c) = NaN;
            else
            patchRow = winnerQuads{p,s,c}; %pre-define the row so parfor/for loop is faster. 
            for t = 1:size(patchRow,2)
               if patchRow{1,t}(1,2) == 6
                   fChoices = fChoices + 1;
                   fChoicesColl = fChoicesColl + 1;
               elseif patchRow{1,t}(1,2) == 1
                   eChoices = eChoices + 1;
                   eChoicesColl = eChoicesColl + 1;
               else
                   dChoices = dChoices + 1;
                   dChoicesColl = dChoicesColl + 1;                   
               end
            end
               fTotalChoices(p,s,c) = fChoices; %#ok<*SAGROW>
               eTotalChoices(p,s,c) = eChoices;
               dTotalChoices(p,s,c) = dChoices;
               fChoices = 0; eChoices = 0; dChoices = 0;
            end% If statement. 
        end %SUBJ
        fTotalChoicesColl(p,c) = (fChoicesColl*100)/(fChoicesColl + eChoicesColl + dChoicesColl);
        eTotalChoicesColl(p,c) = (eChoicesColl*100)/(fChoicesColl + eChoicesColl + dChoicesColl);
        dTotalChoicesColl(p,c) = (dChoicesColl*100)/(fChoicesColl + eChoicesColl + dChoicesColl);
        fChoicesColl = 0; eChoicesColl = 0; dChoicesColl = 0;
    end %CONDITION
end %PATCH
patchChoices.fTotalChoices = fTotalChoices;
patchChoices.eTotalChoices = eTotalChoices;
patchChoices.dTotalChoices = dTotalChoices;
patchChoices.fTotalChoicesColl = fTotalChoicesColl;
patchChoices.eTotalChoicesColl = eTotalChoicesColl;
patchChoices.dTotalChoicesColl = dTotalChoicesColl;
fprintf('starting to save patchChoices\n');
save([savePath 'patchChoices'],'patchChoices');
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
end
