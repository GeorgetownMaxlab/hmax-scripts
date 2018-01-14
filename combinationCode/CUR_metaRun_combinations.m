function CUR_metaRun_combinations(nPatches,nTPatchesAll,nCPatchesAll,simulation)
% This function makes it easier to run various combinations with various
% numbers of top-patches and complementary-patches.

% It uses:
% - CUR_genDoublets_norep.m
% - CUR_runScaledDoublet_FaceBox.m
% - CUR_runScaledDoublet_wedge90.m

% Watch that the following variables in the CUR_genDoublets_norep script are set
% right:

% - acrossCombination.
% - condition.
% - combination_type.

%% Looped sequence of script to run doublet combination on training then testing automatically.
dbstop if error;

if (nargin < 1)
    nPatches = 50000;
    nTPatchesAll = [100, 1000,200, 1000,2000,2000]
    nCPatchesAll = [1000,100, 1000,200, 2000,3000]
    
    % nTPatchesAll = [10,20];
    % nCPatchesAll = [20,10];
    
    simulation = 'simulation6';
end

for iRun = 1:length(nTPatchesAll)
    iRun
    % Create doublets using various combination of TPatches and CPatches.
    CUR_genDoublets_norep(nPatches,nTPatchesAll(iRun),...
                          ceil(nTPatchesAll(iRun)/32),...
                          nCPatchesAll(iRun),...
                          simulation);
    display(['done with making doublets for run' int2str(iRun)]);
    
    % Now test these with FACE-BOX criterion.
    CUR_runScaledDoublet_FaceBox(nTPatchesAll(iRun),nCPatchesAll(iRun),simulation);
    display(['done with testing doublets with FB for run' int2str(iRun)]);

    % Now test these with WEDGE criterion.
    CUR_runScaledDoublet_wedge30(nTPatchesAll(iRun),nCPatchesAll(iRun),simulation);
    display(['done with testing doublets with wedge for run' int2str(iRun)]);    
end   

end