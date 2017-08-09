function concatPatchChoices(patchType, incr, lastPatch, helperNum)

loadPath = ['/home/levan/HMAX/choiceAnalysis/' patchType '/'];
savePath = loadPath;
load(['/home/levan/HMAX/choiceAnalysis/' patchType '/patchChoices1-' num2str(incr) '.mat']);
fTotalChoicesColl = patchChoices.fTotalChoicesColl;
eTotalChoicesColl = patchChoices.eTotalChoicesColl;
dTotalChoicesColl = patchChoices.dTotalChoicesColl;

    fTotalChoices = patchChoices.fTotalChoices;
    eTotalChoices = patchChoices.eTotalChoices;
    dTotalChoices = patchChoices.dTotalChoices;

for startPatch = incr:incr:helperNum
    if startPatch == helperNum
        load(['/home/levan/HMAX/choiceAnalysis/' patchType '/patchChoices' int2str(startPatch+1) ...
            '-' int2str(lastPatch) '.mat']);
        fprintf('loaded LAST patchChoices file\n');
            fTotalChoicesColl = [fTotalChoicesColl; patchChoices.fTotalChoicesColl];
            eTotalChoicesColl = [eTotalChoicesColl; patchChoices.eTotalChoicesColl];
            dTotalChoicesColl = [dTotalChoicesColl; patchChoices.dTotalChoicesColl];

            fTotalChoices = [fTotalChoices; patchChoices.fTotalChoices];
            eTotalChoices = [eTotalChoices; patchChoices.eTotalChoices];
            dTotalChoices = [dTotalChoices; patchChoices.dTotalChoices];
    else

load(['/home/levan/HMAX/choiceAnalysis/' patchType '/patchChoices' num2str(startPatch+1) '-' num2str(startPatch+incr) '.mat'])
fTotalChoicesColl = [fTotalChoicesColl; patchChoices.fTotalChoicesColl];
eTotalChoicesColl = [eTotalChoicesColl; patchChoices.eTotalChoicesColl];
dTotalChoicesColl = [dTotalChoicesColl; patchChoices.dTotalChoicesColl];

    fTotalChoices = [fTotalChoices; patchChoices.fTotalChoices];
    eTotalChoices = [eTotalChoices; patchChoices.eTotalChoices];
    dTotalChoices = [dTotalChoices; patchChoices.dTotalChoices];
    end
end

save([savePath 'patchChoices1-' int2str(lastPatch) '.mat'], 'fTotalChoices','eTotalChoices', ...
    'dTotalChoices','fTotalChoicesColl','eTotalChoicesColl','dTotalChoicesColl');

end