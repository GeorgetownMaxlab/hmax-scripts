%create C2 matrix specifically for high localization single-patches
clear; clc;
savePath = ('/home/levan/HMAX/choiceAnalysis/Triples/C2/');
loadPath = ('/home/levan/HMAX/choiceAnalysis/Triples/');
homePath = ('/home/levan/HMAX/choiceAnalysis/');

load([homePath 'Triples/C2/locValuesTriples.mat']);
load([loadPath 'allC2LFWBorder.mat']);
load([loadPath 'c2e.mat']);
fprintf('done loading original C2s\n');

% [sorted,indexes] = sort(hits{1,5}, 'descend');
% save([savePath 'highLocPatchInd.mat'], 'sorted', 'indexes');

top1000 = indTriples(1:1000);

c2f = c2f(top1000,:); 
c2e = c2e(top1000,:); 
c2s = c2s(top1000,:); 
c2h = c2h(top1000,:); 
c2i = c2i(top1000,:); 
c2c = c2c(top1000,:); 

save([savePath 'highLocC2Triples.mat'], 'c2e', 'c2f', 'c2s', ...
    'c2h', 'c2i', 'c2c');