function [winnerQuads, patchChoices] = getWinnerQuadStatisticsConcat(allQuads, innerP, incr, lastPatch, savePath)
%Loads allQuads and other variables from parent code - allQuadAllTrials.m
%For each trial finds the quadrant C2 that is the minimum.
% Also calculates percentage-wise, how many times did pathces "choose"
% face-quadrants, empty-quadrants, and distractor-quadrants. 

%:::::::::::::VARIABLES::::::::::
%patchType - specify the type of patches that were analyzed, and therefore
%which folder to look in.
%incr - the increments of difference between the allQuads mat files.
%lastPatch - the total number of patches in all of the allQuads files.
%helperNum - see the f for loop. 
%::::::::::::::::::::::::::::::::

% if (nargin < 1)
%     patchType = 'Doubles';
%     incr = incr;
%     lastPatch = 4950;
%     helperNum = 4500;
% end;

% %:::::::::::loop for loading the allQuads files one by one:::::::::
% for f = 0:incr:helperNum
%     if f == helperNum
%         load([loadPath 'allQuads' int2str(f+1) '-' int2str(lastPatch) 'TEST2.mat']);
%         fprintf('loaded the LAST allQuads file');
%     else
%     load([loadPath 'allQuads' int2str(f+1) '-' int2str(f+incr) 'TEST2.mat']);
%     fprintf(['loaded ' int2str(f+1) '-' int2str(f+incr) '\n']);
%     end
% %::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


%::::::::::Find the "winner" quad trial-by-trial::::::::::::

HAVEN'T RUN SINCE LAST EDIT. CHECK FUNCTIONALITY


firstP = innerP-incr+1;
lastIncr = size(allQuads,1);
winnerQuads = {};
for p = 1:size(allQuads,1)
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
end; %PATCH

% if f == helperNum
%     fprintf(['started saving LAST winnerQuads' int2str(f+1) '-' int2str(lastPatch) '\n']); 
%     save([savePath 'winnerQuads' int2str(f+1) '-' int2str(lastPatch)],'winnerQuads');
%     fprintf(['saved the LAST winnerQuads' int2str(f+1) '-' int2str(lastPatch) '\n']);
% else
% fprintf(['started saving winnerQuads' int2str(f+1) '-' int2str(f+incr) '\n']); 
% save([savePath 'winnerQuads' int2str(f+1) '-' int2str(f+incr)],'winnerQuads');
% fprintf(['saved winnerQuads' int2str(f+1) '-' int2str(f+incr) '\n']);
% end
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

if innerP == lastPatch
    fprintf(['starting to save LAST patchChoices' int2str(innerP-lastIncr) '-' int2str(innerP) '\n']);
    save([savePath 'patchChoices' int2str(innerP-lastIncr) '-' int2str(innerP)],'patchChoices');
    fprintf(['done saving LAST patchChoices' int2str(innerP-lastIncr) '-' int2str(innerP) '\n']);
        fprintf(['started saving LAST winnerQuads' int2str(innerP - lastIncr) '-' int2str(innerP) '\n']); 
        save([savePath 'winnerQuads' int2str(innerP - lastIncr) '-' int2str(innerP)],'winnerQuads');
        fprintf(['saved LAST winnerQuads' int2str(innerP - lastIncr) '-' int2str(innerP) '\n']);
else
fprintf(['starting to save patchChoices' int2str(firstP) '-' int2str(innerP) '\n']);
save([savePath 'patchChoices' int2str(firstP) '-' int2str(innerP)],'patchChoices');
fprintf(['done saving patchChoices' int2str(firstP) '-' int2str(innerP) '\n']);
    fprintf(['started saving winnerQuads' int2str(firstP) '-' int2str(innerP) '\n']); 
    save([savePath 'winnerQuads' int2str(firstP) '-' int2str(innerP)],'winnerQuads');
    fprintf(['saved winnerQuads' int2str(firstP) '-' int2str(innerP) '\n']);
end


% if f == helperNum
%     fprintf(['starting to save LAST patchChoices' int2str(f+1) '-' int2str(lastPatch) '\n']);
%     save([savePath 'patchChoices' int2str(f+1) '-' int2str(lastPatch)],'patchChoices');
%     fprintf(['done saving LAST patchChoices' int2str(f+1) '-' int2str(lastPatch) '\n']);
% else
% fprintf(['starting to save patchChoices' int2str(f+1) '-' int2str(f+incr) '\n']);
% save([savePath 'patchChoices' int2str(f+1) '-' int2str(f+incr)],'patchChoices');
% fprintf(['done saving patchChoices' int2str(f+1) '-' int2str(f+incr) '\n']);
% end
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% clearvars -except loadPath savePath patchType incr helperNum lastPatch;

% end %file loop.
end
