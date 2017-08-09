function CUR_metaRun_C2_loop
% This will simply loop to run the CUR_runAnnulusExpt2 script for
% differently sized patches.
dbstop if error;

nPatches             = 50000;
nPatchesPerLoop      = 6250;
startingPatchLoopIdx = 1;
endingPatchLoopIdx   = 8;
nImgsAnalyzed        = 800;
nImgsPerLoop         = 200;
nImgsPerWorker       = 8;
nWorkers             = 28;
home  = 'annulusExptFixedContrast/simulation3/part2upinv/upright';
tasks = {'patchSetAdam'};

if ~ispc
    parpool(nWorkers)
end

for iTask = 1:numel(tasks)
    metaTic1 = tic;
    display(['Starting to run ' tasks{iTask}]);
    
    CUR_runAnnulusExpt2(...
        fullfile(home,'facesLoc.mat'),...
        fullfile(home,'data',tasks{iTask},'lfwSingle50000'),...
        home,...
        nPatches,nPatchesPerLoop,startingPatchLoopIdx,endingPatchLoopIdx,...
        nImgsAnalyzed, nImgsPerLoop, nImgsPerWorker,...
        tasks{iTask});
    
    display(['Done with ' tasks{iTask}]);
    metaToc1 = toc(metaTic1)
    
end

end