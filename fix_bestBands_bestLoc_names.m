clear; clc;

if ispc
    home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\testing\data';
else
    home = '/home/levan/HMAX/annulusExptFixedContrast/simulation3/testing/data';
end

tasks = {'patchSetAdam','patchSet_1x2','patchSet_2x1','patchSet_1x3','patchSet_3x1','patchSet_2x3','patchSet_3x2'};

for iTask = 1:numel(tasks)
    iTask
    load(fullfile(home,tasks{iTask},'lfwSingle50000','bestBands.mat'));
    load(fullfile(home,tasks{iTask},'lfwSingle50000','bestLoc.mat')); 
    
    save(fullfile(home,tasks{iTask},'lfwSingle50000','bestBandsC2f.mat'),'bestBands');
    save(fullfile(home,tasks{iTask},'lfwSingle50000','bestLocC2f.mat'),  'bestLoc');    
    
    delete(fullfile(home,tasks{iTask},'lfwSingle50000','bestBands.mat'));
    delete(fullfile(home,tasks{iTask},'lfwSingle50000','bestLoc.mat'));  
    
end