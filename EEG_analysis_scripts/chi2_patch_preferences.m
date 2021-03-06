%% Description:
% This function will perform a chi-squared test for each of the best
% singles, doublets, and triplet patches, determining which ones perform
% differently on upright vs inverted images.

%%
clear; clc; close all;
dbstop if error
%% Load and predefine variables
if ispc
    load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatches.mat')
else
    load('/home/levan/HMAX/annulusExptFixedContrast/simulation1/testing/data/patchSetAdam/lfwSingle50000/scaling_FaceBox/bestPatches.mat')
end

nUpright  = 800;
nInverted = 800;
nAllImg   = nUpright + nInverted;

raw_hits_up_singles   = round((bestSingles.singles_upright*nUpright)  /100);
raw_hits_inv_singles  = round((bestSingles.singles_inverted*nInverted)/100);

raw_hits_up_doublets  = round((bestDoublets.doublets_upright*nUpright)  /100);
raw_hits_inv_doublets = round((bestDoublets.doublets_inverted*nInverted)/100);

raw_hits_up_triplets  = round((bestTriplets.triplets_upright*nUpright)  /100);
raw_hits_inv_triplets = round((bestTriplets.triplets_inverted*nInverted)/100);

% This below is the old way of calculating raw hits for up/inv
% % load imgHits map for upright images
% imgHitsWedge_up = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\upright\imgHitsWedge.mat');
% imgHitsWedge_up = imgHitsWedge_up.imgHitsWedge;
% raw_hits_up = sum(imgHitsWedge_up,2);
% raw_hits_up_bestSingles = raw_hits_up(bestSingles.idx_crossValid);
% % load imgHits map for inverted images
% imgHitsWedge_inv = load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\part2Inverted_all_subj\inverted\imgHitsWedge.mat');
% imgHitsWedge_inv = imgHitsWedge_inv.imgHitsWedge;
% raw_hits_inv = sum(imgHitsWedge_inv,2);
% raw_hits_inv_bestSingles = raw_hits_inv(bestSingles.idx_crossValid);

%% SINGLES chi2 test.
display('working on singles...');

% Predefine variables for speed
tbl_singles  = cell(1,length(bestSingles.idx_crossValid));
chi_singles  = zeros(1,length(bestSingles.idx_crossValid));
pval_singles = zeros(1,length(bestSingles.idx_crossValid));

% loop over all patches
parfor iPatch = 1:length(bestSingles.idx_crossValid)
    if mod(iPatch,500) == 0
        display(['Singles, ' int2str(iPatch)]);
    end
    n1 = raw_hits_up_singles (iPatch); % number of hits on upright.
    n2 = raw_hits_inv_singles(iPatch); % number of hits on inverted.
    nHits = raw_hits_up_singles(iPatch) + raw_hits_inv_singles(iPatch);
    nMiss = nAllImg - nHits;
        x1 = [repmat('a',nHits,1); repmat('b',nMiss,1)];
        x2 = [repmat(1,n1,1); repmat(2,n2,1); repmat(1,nUpright-n1,1); repmat(2,nInverted-n2,1)]; %#ok<REPMAT>
    [tbl_singles{iPatch},chi_singles(iPatch),pval_singles(iPatch)] = crosstab(x1,x2);
end
clearvars n1 n2 x1 x2 nHits nMiss
%% DOUBLETS chi2 test.
display('working on doublets...');

% Predefine variables for speed
tbl_doublets  = cell(1,length(bestDoublets.idx_crossValid));
chi_doublets  = zeros(1,length(bestDoublets.idx_crossValid));
pval_doublets = zeros(1,length(bestDoublets.idx_crossValid));

% loop over all patches
parfor iPatch = 1:length(bestDoublets.idx_crossValid)
    if mod(iPatch,500) == 0
        display(['Doublets, ' int2str(iPatch)]);
    end
    n1 = raw_hits_up_doublets (iPatch); % number of hits on upright.
    n2 = raw_hits_inv_doublets(iPatch); % number of hits on inverted.
    nHits = raw_hits_up_doublets(iPatch) + raw_hits_inv_doublets(iPatch);
    nMiss = nAllImg - nHits;
        x1 = [repmat('a',nHits,1); repmat('b',nMiss,1)];
        x2 = [repmat(1,n1,1); repmat(2,n2,1); repmat(1,nUpright-n1,1); repmat(2,nInverted-n2,1)]; %#ok<REPMAT>
    [tbl_doublets{iPatch},chi_doublets(iPatch),pval_doublets(iPatch)] = crosstab(x1,x2);
end
clearvars n1 n2 x1 x2 nHits nMiss
%% save the interim data
bestSingles.chi2_up_vs_inv.table     = tbl_singles;
bestSingles.chi2_up_vs_inv.chi_stat  = chi_singles;
bestSingles.chi2_up_vs_inv.pval      = pval_singles;

bestDoublets.chi2_up_vs_inv.table     = tbl_doublets;
bestDoublets.chi2_up_vs_inv.chi_stat  = chi_doublets;
bestDoublets.chi2_up_vs_inv.pval      = pval_doublets;

if ispc
    save('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatches.mat',...
         'bestSingles','bestDoublets','bestTriplets','comments')
else
    save('/home/levan/HMAX/annulusExptFixedContrast/simulation1/testing/data/patchSetAdam/lfwSingle50000/scaling_FaceBox/bestPatches.mat',...
         'bestSingles','bestDoublets','bestTriplets','comments')
end

clear tbl_singles chi_singles pval_singles tbl_doublets chi_doublets pval_doublets
%% TRIPLETS chi2 test.
% Predefine variables for speed
tbl_triplets  = cell(1,length(bestTriplets.idx_crossValid));
chi_triplets  = zeros(1,length(bestTriplets.idx_crossValid));
pval_triplets = zeros(1,length(bestTriplets.idx_crossValid));

% loop over all patches
parfor iPatch = 1:length(bestTriplets.idx_crossValid)
    if mod(iPatch,2000) == 0
        display(['Triplets, ' int2str(iPatch)]);
    end
    n1 = raw_hits_up_triplets (iPatch); % number of hits on upright.
    n2 = raw_hits_inv_triplets(iPatch); % number of hits on inverted.
    nHits = raw_hits_up_triplets(iPatch) + raw_hits_inv_triplets(iPatch);
    nMiss = nAllImg - nHits;
        x1 = [repmat('a',nHits,1); repmat('b',nMiss,1)];
        x2 = [repmat(1,n1,1); repmat(2,n2,1); repmat(1,nUpright-n1,1); repmat(2,nInverted-n2,1)]; %#ok<REPMAT>
    [tbl_triplets{iPatch},chi_triplets(iPatch),pval_triplets(iPatch)] = crosstab(x1,x2);
end
clearvars n1 n2 x1 x2
% %% save the final data
bestTriplets.chi2_up_vs_inv.table     = tbl_triplets;
bestTriplets.chi2_up_vs_inv.chi_stat  = chi_triplets;
bestTriplets.chi2_up_vs_inv.pval      = pval_triplets;

if ispc
    save('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatches.mat',...
         'bestSingles','bestDoublets','bestTriplets','comments')
else
    save('/home/levan/HMAX/annulusExptFixedContrast/simulation1/testing/data/patchSetAdam/lfwSingle50000/scaling_FaceBox/bestPatches.mat',...
         'bestSingles','bestDoublets','bestTriplets','comments')
end




