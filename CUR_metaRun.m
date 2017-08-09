function CUR_metaRun(blurMasks,nPatchesAnalyzed,nPatchesPerLoop, ...
    nImgsAnalyzed, nImgsPerLoop,nImgsPerWorker)
if (nargin < 1)
    blurMasks = [10,20,30,40,50,60,80];
    nPatchesAnalyzed = 50000;
    nPatchesPerLoop = 12500;
    nImgsAnalyzed = 320;
    nImgsPerLoop = 160;
    nImgsPerWorker = 5;
    condition = 's10/normalized';
end
dbstop if error;
    for iRun = 1:length(blurMasks)
        iRun
        CUR_runAnnulusExpt(...
            ['s10/normalized/facesLocTraining_blurEdges_' int2str(blurMasks(iRun)) 'px'],...
            ['s10/normalized/trainingRuns/patchSetAdam/edgeBlurring/' int2str(blurMasks(iRun)) 'px_mask/lfwSingle' int2str(nPatchesAnalyzed)],...
            condition,...
            nPatchesAnalyzed,nPatchesPerLoop,nImgsAnalyzed,nImgsPerLoop,nImgsPerWorker)
        display(['done with ' int2str(blurMasks(iRun)) ' mask run']);
    end

end