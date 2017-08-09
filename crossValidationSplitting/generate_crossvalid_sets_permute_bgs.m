% In this script, part1upright set of images are examined for backgrounds
% and face identities. The script will choose the face-identities and
% backgrounds to keep for the training set vs testing set. 
% Then, it will find indices of images in part1upright and other image-sets
% we have, that correspond to those faces-images.
% 
% Script then calls generate_crossvalid_files.m which will create new C2
% and related files only for those images.

% Those files can then be run through the localization, combination, and
% whatever code.

%% If dual monitor, make plots appear on the second one. Might need to
% restart matlab.
r = get(groot);
if size(r.MonitorPositions,1) > 1
    p = [-951.0000  119.6667  560.0000  420.00];
%       p = [-10.2783    0.0090    1.2773    0.6353];
    set(0, 'DefaultFigurePosition', p);
end


%% Cross-validation: overlap between the part2up and part1up sets in terms of bg and face identity images.
clear; clc; close all;
% check if exptDesign was created correctly.
dbstop if error
if ispc
    home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation1';
else
    home = '/home/levan/HMAX/annulusExptFixedContrast/simulation1';
end
% load exptDesign for part1.
part1 = load(fullfile(home,'part1upright','exptDesign.mat'));
part2 = load(fullfile(home,'part2Inverted_all_subj','upright','exptDesign.mat'));

training = load(fullfile(home,'training','exptDesign.mat'));
testing  = load(fullfile(home,'testing','exptDesign.mat'));

% bg names
display([int2str(numel(unique(cell2mat(part1.bgName)))) ' bgs in part1']);
% display([int2str(numel(unique(cell2mat(part2.bgName)))) ' bgs in part2']);
% display([int2str(numel(unique(cell2mat(training.bgName)))) ' bgs in training']);
% display([int2str(numel(unique(cell2mat(testing.bgName)))) ' bgs in testing']);

% assert(isempty(intersect(cell2mat(part1.bgName),cell2mat(part2.bgName))),'Backgrounds aren''t different between part1 and part2');

% face IDs
display([int2str(numel(unique(part1.faceName))) ' faces in part1']);
% display([int2str(numel(unique(part2.faceName))) ' faces in part2']);
% display([int2str(numel(unique(training.faceName))) ' faces in training']);
% display([int2str(numel(unique(testing.faceName))) ' faces in testing']);
% assert(isempty(intersect(cell2mat(part1.bgName),cell2mat(part2.bgName))),'Backgrounds aren''t different between part1 and part2');
% assert(isempty(intersect(part1.faceName,part2.faceName)),'Faces aren''t different between part1 and part2');

% common_faces_part1_and_part2      = intersect(unique(part1.faceName),   unique(part2.faceName));
% common_faces_training_and_testing = intersect(unique(training.faceName),unique(testing.faceName));
% common_faces_training_and_part1   = intersect(unique(training.faceName),unique(part1.faceName));
% common_faces_training_and_part2   = intersect(unique(training.faceName),unique(part2.faceName));
% common_faces_testing_and_part1    = intersect(unique(testing.faceName), unique(part1.faceName));
% common_faces_testing_and_part2    = intersect(unique(testing.faceName), unique(part2.faceName));
% 
% 
% 
% common_bgs_part1_and_part2      = intersect(unique(cell2mat(part1.bgName)),   unique(cell2mat(part2.bgName)));
% common_bgs_training_and_testing = intersect(unique(cell2mat(training.bgName)),unique(cell2mat(testing.bgName)));
% common_bgs_training_and_part1   = intersect(unique(cell2mat(training.bgName)),unique(cell2mat(part1.bgName)));
% common_bgs_training_and_part2   = intersect(unique(cell2mat(training.bgName)),unique(cell2mat(part2.bgName)));
% common_bgs_testing_and_part1    = intersect(unique(cell2mat(testing.bgName)), unique(cell2mat(part1.bgName)));
% common_bgs_testing_and_part2    = intersect(unique(cell2mat(testing.bgName)), unique(cell2mat(part2.bgName)));


%% Check how many images are in part1 that do not overlap with part2up.
% Find images with unique face-IDs in part1.
% idx_faces_only_part1 = find(~ismember(part1.faceName,part2.faceName));
% 
% % Find images with unique bgs in part1.
% idx_bg_only_part1 = find(~ismember(cell2mat(part1.bgName),cell2mat(part2.bgName)));
% 
% % Find images with both, unique face-ID and unique bgs in part1.
% idx_overlap = intersect(idx_faces_only_part1,idx_bg_only_part1);

%% double check that the above worked
% for i = 1:numel(idx_overlap)
% %     i
%     assert(~ismember(part1.faceName{idx_overlap(i)},part2.faceName))
%     assert(~ismember(cell2mat(part1.bgName(idx_overlap(i))),cell2mat(part2.bgName)))
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% count number of occurrences for faces and bgs in part1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iFace = 1:length(part1.faceName)
   faceName_num(iFace) = str2double(part1.faceName{iFace}(1:end-4));
end
   bgName_num = cell2mat(part1.bgName); % get the bg names as a matrix instead of cell array. Just easier to work with.
% hist(faceName_num,numel(unique(part1.faceName)));
% title('Face Frequencies')
% xlabel('Face Idx')
% 
% figure
% hist(cell2mat(part1.bgName),numel(unique(cell2mat(part1.bgName))))
% 
% title('Bg Frequencies')
% xlabel('Bg Idx')
    
%% Calculate how many different backgrounds is each face pasted in, and vice-versa.
%% All of this for PART1
unique_faceName_num = unique(faceName_num);
unique_bgName_num   = unique(bgName_num);
for iFace = 1:length(unique_faceName_num)
    % The below line gives count for each face-ID in part1 images, as well as their indices in the whole set!
    idx_faceIDs{iFace,1} = find(faceName_num == unique_faceName_num(iFace));
    
    % For each face-ID, the below line checks which bgs they were pasted in.
    bgs_per_face{iFace,1} = unique(cell2mat(part1.bgName(idx_faceIDs{iFace})));
end

unique_bgName_num = unique(cell2mat(part1.bgName));
for iBg = 1:length(unique_bgName_num)
    % The below line gives count for each bg in part1 images, as well as their indices in the whole set!    
    idx_bgs{iBg,1} = find(cell2mat(part1.bgName) == unique_bgName_num(iBg));

    % For each bg, the below line checks which faces were pasted in them.
    faces_per_bg{iBg,1} = unique(faceName_num(idx_bgs{iBg}));
    
end   
    
%% Plot scatterplot of background distribution per face
% close all;
% figure
% for iFace = 1:length(bgs_per_face)
%     scatter(ones(1,length(bgs_per_face{iFace}))*iFace,bgs_per_face{iFace},...
%         20,'MarkerEdgeColor','k',...
%               'MarkerFaceColor','b'...
%               )
%     hold on   
% end

%% Choose faces and bgs to be separated
% close all;
% training_faces = [unique_faceName_num(1:10),unique_faceName_num(end-4:end)];
% training_faces = [unique_faceName_num(end-14:end)]; %unique_faceName_num(end-4:end)];
% 
% 
% bgs_of_training_faces = bgs_per_face(training_faces);
% bgs_of_training_faces = horzcat(bgs_of_training_faces{:});
% % figure
% [count,centers] = hist(bgs_of_training_faces,length(unique(bgs_of_training_faces)));
% 
% [sorted_count,idx] = sort(count,'descend');
% training_bgs = idx(1:17);
% 
% %% See how many trials are left in part1 after removing training faces and training bgs
% idx_non_training_faces_part1 = find(~ismember(faceName_num,training_faces));
% idx_non_training_bgs_part1   = find(~ismember(cell2mat(part2.bgName),training_bgs));
% idx_leftover_part1           = intersect(idx_non_training_faces_part1,idx_non_training_bgs_part1);

%% META LOOP TO TRY VARIOUS COMBINATIONS OF NUMBER OF FACES AND NUMBER OF BACKGROUNDS
face_quantities = 10;%10:5:20;
bg_quantities   = 10; %10:5:20;
quant_mat       = [];
for iQuant = 1:numel(face_quantities)
    quant_mat_temp = [ones(1,numel(bg_quantities))*face_quantities(iQuant);bg_quantities];
    quant_mat = [quant_mat quant_mat_temp];
end

for iQuantComb = 1:size(quant_mat,2)
    
%% Alternative: Start by choosing face-IDs for testing.
% Then just take the bgs they are pasted in. See if that works.

% testing_faces = [3,4,13,14,16,17,19,23,30,31,36,7,11,21,22,29]; % These faces have large number of bgs associated with them. So the remaining backgrounds must be used in training, and their number will be small. 
testing_faces = [41,40,39,38,37,35,34,28,27,25,18,6,5]; % These faces have small number of bgs associated with them. So the remaining backgrounds must be used in training, and their number will be large. 
testing_faces = [testing_faces,10,9,8,7,4,3,2,1];
testing_faces = [testing_faces,17,16,15,14,13,12,11];

testing_faces = [16:41]; % changed this because these faces are least used in the part2upright and set2 image sets, so higher chances that images will be left in those sets.
testing_faces = [10 : 9 + quant_mat(1,iQuantComb)]; % now trying just 10 testing faces and 10 bgs.

n_testing_faces  = numel(testing_faces)
training_faces   = setdiff(1:41,testing_faces);
n_training_faces = numel(training_faces);

bgs_of_testing_faces        = bgs_per_face(testing_faces);
bgs_of_testing_faces        = horzcat(bgs_of_testing_faces{:});
unique_bgs_of_testing_faces = numel(unique(bgs_of_testing_faces));

out = [unique(bgs_of_testing_faces); ...
       histc(bgs_of_testing_faces,unique(bgs_of_testing_faces))]; % This counts the frequency of each bg.

[sortedFreq,indices] = sort(out(2,:),'descend'); % Sort the bgs by their frequency, so we can take the most frequent ones to be included in testing set.
outSorted = out(:,indices); % Sort the out matrix


%% See how many imgs in part 1 have only the testing faces.

idx_testing_faces_part1  = find(ismember(faceName_num,testing_faces)); % This gives indices of all images in part1 that had the chosen faces.

%% Now choose bgs for testing
% Below lines if choosing bgs based on frequency
% n_testing_bgs = 24
% testing_bgs = outSorted(1,1:n_testing_bgs);
% training_bgs = setdiff(unique_bgName_num,testing_bgs);
% n_training_bgs = numel(training_bgs)
% 
% idx_testing_bgs_part1    = find(ismember(bgName_num,testing_bgs));   % This gives indices of all images in part1 that had the chosen bgs.
% idx_testing_images_part1 = intersect(idx_testing_faces_part1,idx_testing_bgs_part1);
% n_testing_imgs = numel(idx_testing_images_part1)



% Below lines if permuting the bgs 
n_testing_bgs = quant_mat(2,iQuantComb)
n_training_bgs = 48-n_testing_bgs;

% predefine
nPerm = 50000;
testing_bgs = zeros(n_testing_bgs,nPerm);
n_testing_imgs = zeros(1,nPerm);

for iPerm = 1:nPerm
    if mod(iPerm,10000) == 0
        iPerm
    end
    testing_bgs(:,iPerm) = randperm(48,n_testing_bgs);
    
    idx_testing_bgs_part1    = find(ismember(bgName_num,testing_bgs(:,iPerm)));   % This gives indices of all images in part1 that had the chosen bgs.
    idx_testing_images_part1 = intersect(idx_testing_faces_part1,idx_testing_bgs_part1);
    
    n_testing_imgs(1,iPerm) = numel(idx_testing_images_part1);
end

% plot(n_testing_imgs);

% Get the max and take those
[max_imgs,idx_max] = max(n_testing_imgs);
testing_bgs        = testing_bgs(:,idx_max);
training_bgs       = setdiff(1:48,testing_bgs);




%% Save the indices to an appropriate folder.
if ispc
    home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3';
else
    home = '/home/levan/HMAX/annulusExptFixedContrast/simulation3';
end
crossValidInfo.testing_faces  = testing_faces';
crossValidInfo.testing_bgs    = testing_bgs;

crossValidInfo.training_faces = training_faces';
crossValidInfo.training_bgs   = training_bgs';

%% see how many training imgs we get

[total_training_imgs(iQuantComb), total_testing_imgs_across_sets(iQuantComb)] = generate_crossvalid_files_only_images(crossValidInfo)

total_testing_imgs(iQuantComb) = max_imgs
% pause(1)
save(fullfile(home,['crossValidInfo_' int2str(total_training_imgs) '-' ...
                                      int2str(total_testing_imgs_across_sets) '-' ...
                                      int2str(total_testing_imgs) '_' ...                                      
                                      datestr(now,'yyyy-mmm-dd-HH-MM-SS') '.mat']),'crossValidInfo');


end % iQuantComb


