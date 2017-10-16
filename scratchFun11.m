%% Edit out those images from Florence's setthat have too low Michelson contrast
clear; clc; close all;
dbstop if error;

home = 'C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\data\patchSet_3x2\lfwSingle50000';
saveFolder = 'high_contrast_data';

load('C:\Users\levan\HMAX\annulusExptFixedContrast\simulation3\part1upright\exptDesign.mat')

% Get michelson values
for iImg = 1:length(exptDesign)
    face_michelson(iImg) = (max(exptDesign(iImg).faceImg(:)) - min(exptDesign(iImg).faceImg(:)))/...
                           (max(exptDesign(iImg).faceImg(:)) + min(exptDesign(iImg).faceImg(:)));
end

idx_low = find(face_michelson < 0.3);
idx_high = setdiff(1:length(face_michelson),idx_low);

% Start editing out the data.
load(fullfile(home,'facesLoc.mat'));
facesLoc{1} = facesLoc{1}(idx_high);

load(fullfile(home,'c2f.mat'));
c2f = c2f(:,idx_high);

load(fullfile(home,'bestBandsC2f.mat'));
bestBands = bestBands(:,idx_high);

load(fullfile(home,'bestLocC2f.mat'));
bestLoc = bestLoc(:,idx_high,:);

exptDesign = exptDesign(idx_high);
% Save data to a new folder

save(fullfile(home,saveFolder,'c2f.mat'),'c2f');
save(fullfile(home,saveFolder,'bestBandsC2f.mat'),'bestBands');
save(fullfile(home,saveFolder,'bestLocC2f.mat'),'bestLoc');
save(fullfile(home,saveFolder,'facesLoc.mat'),'facesLoc');
save(fullfile(home,saveFolder,'exptDesign.mat'),'exptDesign');


