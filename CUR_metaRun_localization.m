function CUR_metaRun_localization(nPatches,tasks,patchSizes)

% Note, this script doesn't do parallel looping. Best use CUR_genLoc.m

% This will simply loop to run the CUR_annulusWedgeAndBoxLocalization_resizing_diff_patchSizes
% script for differently sized patches.
if (nargin < 1)
    tasks = {'patchSetAdam','patchSet_1x2','patchSet_2x1','patchSet_1x3','patchSet_3x1','patchSet_2x3','patchSet_3x2'};
    
    nPatches = 50;
    patchSizes = [2,1,2,1,3,2,3;...
                  2,2,1,3,1,3,2;...
                  4,4,4,4,4,4,4;...
                  nPatches,nPatches,nPatches,nPatches,nPatches,nPatches,nPatches];
    home = 'annulusExptFixedContrast/simulation2/set2/';
end



for iTask = 5%1:numel(tasks)
    
    saveFolder = fullfile(home,'data',tasks{iTask},'lfwSingle50000','oldCode1');
    loadFolder = fullfile(home,'data',tasks{iTask},'lfwSingle50000');
    
    
    tic
    display(['Starting to run ' tasks{iTask}]);
    
    CUR_annulusWedgeAndBoxLocalization_resizing_diff_patchSizes(...
        nPatches,...
        patchSizes(:,iTask),...
        loadFolder,...
        home,...
        saveFolder)
    
%     CUR_annulusWedgeAndBoxLocalization_resizing_diff_patchSizes(...
%         50000,...
%         [2;3;4;50000],...
%         fullfile('annulusExptFixedContrast/simulation2/set2/data/patchSet_2x3/lfwSingle50000'),...
%         'annulusExptFixedContrast/simulation2/set2/')
    
    
    display(['Done with ' tasks{iTask}]);
    toc
    
end
end