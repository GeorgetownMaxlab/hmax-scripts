function setOfClusters(loadFolder,saveFolder)

% pOut: cell array of patch matrices, the universal patches (centroids)
% labels: cell array, the centroids to which each patch from pIn was assigned

%% Global variables
if (nargin < 1)
    loadFolder = 'patchSetAdam';
    saveFolder = 'patchSetAdam';
end

if ispc == 1
    loadLoc    = ['C:\Users\Levan\HMAX\patches\' loadFolder '\'];
    saveLoc    = ['C:\Users\Levan\HMAX\patches\' saveFolder '\'];
else    
    loadLoc    = ['/home/levan/HMAX/patches/' loadFolder '/'];
    saveLoc    = ['/home/levan/HMAX/patches/' saveFolder '/'];
end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end

% Load the patches
load([loadLoc 'patches.mat']);
sizes = ps.sizes(1:3,1);
pIn = ps.patches;
ps = [];

%% Start script
% Create an array with desired cluster sizes specified.
A = ones(1,10)*2;
B = 6:15;
k = A.^B;
% temporary
k = k(10);
nClusterSizes = length(k);

% Run clustering 
for iClusterSize = 1:nClusterSizes
    fprintf(['Breaking it down into ' int2str(k(iClusterSize)) ' clusters\n']);
    [labels,pOut] = cellfun(@(x) kmeansPlusPlus(x,k(iClusterSize)),pIn,'UniformOutput',0);
    
    ps.patches = pOut;
    ps.sizes   = [sizes; size(pOut{1},2)];
    ps.labels  = labels;
    
    if ~exist([saveLoc int2str(k(iClusterSize)) 'clusters'],'dir')
        mkdir([saveLoc int2str(k(iClusterSize)) 'clusters'])
    end
    
    fprintf('started saving data');
    save([saveLoc int2str(k(iClusterSize)) 'clusters\patches.mat'],'ps');
    fprintf('Done and saved\n');    
    % clear variables;
    ps = [];
    pOut = [];
    labels = [];
end

end