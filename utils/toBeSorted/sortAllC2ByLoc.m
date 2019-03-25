function sortAllC2ByLoc(patchType)

%patchType is a string indicating what kind of patches to sort and therefore where to look for these patches.

savePath = (['/home/levan/HMAX/choiceAnalysis/' patchType '/C2/']);
loadPath = (['/home/levan/HMAX/choiceAnalysis/' patchType '/C2/']);
homePath = ('/home/levan/HMAX/choiceAnalysis/');

load([loadPath '/locValues' patchType '.mat']);
load([loadPath '/allC2LFWBorder.mat']);
% load([loadPath '/c2e.mat']);
fprintf('done loading original C2s\n');

% [sorted,indexes] = sort(hits{1,5}, 'descend');
% save([savePath 'highLocPatchInd.mat'], 'sorted', 'indexes');

indexes = indSingles; % <------ CHANGE THIS

c2f = c2f(indexes,:); 
c2e = c2e(indexes,:); 
c2s = c2s(indexes,:); 
c2h = c2h(indexes,:); 
c2i = c2i(indexes,:); 
c2c = c2c(indexes,:); 

save([savePath 'sortedC2ByLocValue.mat'], 'c2e', 'c2f', 'c2s', ...
    'c2h', 'c2i', 'c2c'); % <----- CHANGE THIS
% fprintf('done saving all but c2e');
% save([savePath 'c2eSorted.mat'], 'c2e', '-v7.3');
end
