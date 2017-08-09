
% This script will look at the bestPatches.mat file, and will explore which
% ones across all patch types significantly prefer upright faces, inverted
% faces, or are neutral.

% Script will then take these patches and filter out those that did not
% perform at a certain threshold defined manually.

%% find and save patches that are discriminative for up or inverted images
clear; clc;
load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatches.mat')
alpha = 0.05;
threshold_s = 35;
threshold_d = 40;
threshold_t = 40;

%% Find ones that do significantly discriminate upright vs. inverted.
s_idx_sign = find(bestSingles.chi2_up_vs_inv.pval  < alpha);
d_idx_sign = find(bestDoublets.chi2_up_vs_inv.pval < alpha);
t_idx_sign = find(bestTriplets.chi2_up_vs_inv.pval < alpha);
% Find ones that do not significantly discriminate up/inv
s_idx_neutral = find(bestSingles.chi2_up_vs_inv.pval  >= alpha);
d_idx_neutral = find(bestDoublets.chi2_up_vs_inv.pval >= alpha);
t_idx_neutral = find(bestTriplets.chi2_up_vs_inv.pval >= alpha);

%% Find ones with up>inv absolute number of hits
s_idx_up = find(bestSingles.singles_upright   > bestSingles.singles_inverted);
d_idx_up = find(bestDoublets.doublets_upright > bestDoublets.doublets_inverted);
t_idx_up = find(bestTriplets.triplets_upright > bestTriplets.triplets_inverted);
% Find ones with inv<up absolute number of hits
s_idx_inv = find(bestSingles.singles_upright   <= bestSingles.singles_inverted);
d_idx_inv = find(bestDoublets.doublets_upright <= bestDoublets.doublets_inverted);
t_idx_inv = find(bestTriplets.triplets_upright <= bestTriplets.triplets_inverted);

%% Of up>inv, find ones that are significant on chi2 test
s_idx_up_sign = intersect(s_idx_up,s_idx_sign);
d_idx_up_sign = intersect(d_idx_up,d_idx_sign);
t_idx_up_sign = intersect(t_idx_up,t_idx_sign);
% Of inv<up, find ones that are significant on chi2 test
s_idx_inv_sign = intersect(s_idx_inv,s_idx_sign);
d_idx_inv_sign = intersect(d_idx_inv,d_idx_sign);
t_idx_inv_sign = intersect(t_idx_inv,t_idx_sign);

%% Of significant UPR preferer patches, find ones that pass threshold performance ON UPRIGHT images.
s_idx_up_sign_thresh = intersect(s_idx_up_sign,find(bestSingles.singles_upright   > threshold_s));
d_idx_up_sign_thresh = intersect(d_idx_up_sign,find(bestDoublets.doublets_upright > threshold_d));
t_idx_up_sign_thresh = intersect(t_idx_up_sign,find(bestTriplets.triplets_upright > threshold_t));
% Of significant INV preferer patches, find ones that pass threshold performance ON INVERTED images.
s_idx_inv_sign_thresh = intersect(s_idx_inv_sign,find(bestSingles.singles_inverted   > threshold_s));
d_idx_inv_sign_thresh = intersect(d_idx_inv_sign,find(bestDoublets.doublets_inverted > threshold_d));
t_idx_inv_sign_thresh = intersect(t_idx_inv_sign,find(bestTriplets.triplets_inverted > threshold_t));
% Of non-significant discriminators (neutral patches) find ones that pass
% threshold on both UP and INV images.
s_idx_neutral_thresh = intersect(find(bestSingles.singles_upright  > threshold_s & ...
                                      bestSingles.singles_inverted > threshold_s),...
                                 s_idx_neutral);
d_idx_neutral_thresh = intersect(find(bestDoublets.doublets_upright  > threshold_d & ...
                                      bestDoublets.doublets_inverted > threshold_d),...
                                 d_idx_neutral);
t_idx_neutral_thresh = intersect(find(bestTriplets.triplets_upright  > threshold_t & ...
                                      bestTriplets.triplets_inverted > threshold_t),...
                                 t_idx_neutral);

%% save relevant data.

% % record UP preferers that survived tests
% preference_analysis.s_idx_up_sign_thresh = s_idx_up_sign_thresh;
% preference_analysis.d_idx_up_sign_thresh = d_idx_up_sign_thresh;
% preference_analysis.t_idx_up_sign_thresh = t_idx_up_sign_thresh;
% % record INV preferers that survived tests
% preference_analysis.s_idx_inv_sign_thresh = s_idx_inv_sign_thresh;
% preference_analysis.d_idx_inv_sign_thresh = d_idx_inv_sign_thresh;
% preference_analysis.t_idx_inv_sign_thresh = t_idx_inv_sign_thresh;
% % record NEUTRALS that survived tests
% preference_analysis.s_idx_neutral_thresh = s_idx_neutral_thresh;
% preference_analysis.d_idx_neutral_thresh = d_idx_neutral_thresh;
% preference_analysis.t_idx_neutral_thresh = t_idx_neutral_thresh;

% Its better to record all data, and then do thresholding when plotting. So
% code above is commented and instead the one below is used.
% record UP preferers that survived tests
preference_analysis.s_idx_up_sign = s_idx_up_sign;
preference_analysis.d_idx_up_sign = d_idx_up_sign;
preference_analysis.t_idx_up_sign = t_idx_up_sign;
% record INV preferers that survived tests
preference_analysis.s_idx_inv_sign = s_idx_inv_sign;
preference_analysis.d_idx_inv_sign = d_idx_inv_sign;
preference_analysis.t_idx_inv_sign = t_idx_inv_sign;
% record NEUTRALS that survived tests
preference_analysis.s_idx_neutral = s_idx_neutral;
preference_analysis.d_idx_neutral = d_idx_neutral;
preference_analysis.t_idx_neutral = t_idx_neutral;

% save thresholds used in filtering
% preference_analysis.parameters.threshold_s = threshold_s;
% preference_analysis.parameters.threshold_d = threshold_d;
% preference_analysis.parameters.threshold_t = threshold_t;
preference_analysis.parameters.chi2_alpha  = alpha;

save('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1\testing\data\patchSetAdam\lfwSingle50000\scaling_FaceBox\bestPatches.mat',...
         'bestSingles','bestDoublets','bestTriplets','preference_analysis','comments')
pause(0.5);












