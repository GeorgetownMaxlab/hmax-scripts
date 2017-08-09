function CUR_metaRun_C2_loop2
% This code was just created because CUR_metaRun_C2_loop.m was already
% running on kraken and didn't wanna interfere with it.
dbstop if error;

tasks = {'patchSet_2x3','patchSet_3x2','patchSet_1x2','patchSet_2x1','patchSet_1x3','patchSet_3x1'};

nPatches             = 50000;
nPatchesPerLoop      = 6250;
startingPatchLoopIdx = 1;
endingPatchLoopIdx   = 8;
nImgsAnalyzed        = 800;
nImgsPerLoop         = 200;
nImgsPerWorker       = 8;
nWorkers             = 25;
home  = 'annulusExptFixedContrast/simulation3/part2upinv/upright';

if ~ispc
    parpool(nWorkers)
end

for iTask = 1:numel(tasks)
    metaTic2 = tic;
    display(['Starting to run ' tasks{iTask}]);

    CUR_runAnnulusExpt2(fullfile(home,'facesLoc.mat'),...
                        fullfile(home,'data','sandbox',tasks{iTask},'lfwSingle50000'),...
                        home,...
                        nPatches,nPatchesPerLoop,startingPatchLoopIdx,endingPatchLoopIdx,...
                        nImgsAnalyzed, nImgsPerLoop, nImgsPerWorker,...
                        tasks{iTask});

    display(['Done with ' tasks{iTask}]);
    metaToc2 = toc(metaTic2)

end

end