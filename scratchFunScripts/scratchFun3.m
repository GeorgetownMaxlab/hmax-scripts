%% Separating our face images into "Training" and "Testing" Sets
% clear; clc;
% saveLoc = 'C:\Users\Levan\HMAX\naturalFaceImages\trainingTestingArrays\';
% load('C:\Users\Levan\HMAX\naturalFaceImages\naturalFaceImages2\facesLoc.mat');
% load('C:\Users\Levan\HMAX\naturalFaceImages\naturalFaceImages2\single1-40000\imgHitsMapf.mat');
% facesLoc = horzcat(facesLoc{:});
% 
%     for i = 1:length(facesLoc)
%     facesLoc{2,i} = ceil(str2num(facesLoc{1,i}(73:end-15))/4); %this puts a
%     %number below each image, which tells you which of the 100 face stimuli it
%     %paseted in that image. 
%     end
% 
% seedNum = 1234;
% rng(seedNum,'twister');
% %Below are indices for the actual face stimuli.
% trainingSet = randperm(100,50);
% testingSet  = setdiff(1:100,trainingSet);
%     %Below are indices of images in the facesLoc array that belong to
%     %training set or testing set.
%     trainingInd = find(ismember(cell2mat(facesLoc(2,:)),trainingSet) == 1);    
%     testingInd  = find(ismember(cell2mat(facesLoc(2,:)),testingSet ) == 1);
%         %Here we finally separate the facesLoc into training and testing sets.     
%         facesLocTraining = facesLoc(1,trainingInd);
%         facesLocTesting  = facesLoc(1,testingInd);
%             %Divide up the array of names into cells for each of the four
%             %quadrants. 
%                 %Do it for TRAINING images.
%                 o = 1; tw = 1; th = 1; f = 1;
%                 for j = 1:length(facesLocTraining)
%                     if size(strfind(facesLocTraining{j},'quad1'),1) ~= 0
%                         quadNames{1,1}{1,o} = facesLocTraining{j};
%                         o = o + 1;
%                     elseif size(strfind(facesLocTraining{j},'quad2'),1) ~= 0
%                         quadNames{2,1}{1,tw} = facesLocTraining{j};
%                         tw = tw + 1;
%                     elseif size(strfind(facesLocTraining{j},'quad3'),1) ~= 0
%                         quadNames{3,1}{1,th} = facesLocTraining{j};
%                         th = th + 1;
%                     elseif size(strfind(facesLocTraining{j},'quad4'),1) ~= 0
%                         quadNames{4,1}{1,f} = facesLocTraining{j};
%                         f = f + 1;
%                     end
%                 end
%                 facesLocTraining = quadNames;
%                 
%                 %Do it for TESTING images.
%                 o = 1; tw = 1; th = 1; f = 1; quadNames = {};
%                 for j = 1:length(facesLocTesting)
%                     if size(strfind(facesLocTesting{j},'quad1'),1) ~= 0
%                         quadNames{1,1}{1,o} = facesLocTesting{j};
%                         o = o + 1;
%                     elseif size(strfind(facesLocTesting{j},'quad2'),1) ~= 0
%                         quadNames{2,1}{1,tw} = facesLocTesting{j};
%                         tw = tw + 1;
%                     elseif size(strfind(facesLocTesting{j},'quad3'),1) ~= 0
%                         quadNames{3,1}{1,th} = facesLocTesting{j};
%                         th = th + 1;
%                     elseif size(strfind(facesLocTesting{j},'quad4'),1) ~= 0
%                         quadNames{4,1}{1,f} = facesLocTesting{j};
%                         f = f + 1;
%                     end
%                 end
%                 facesLocTesting = quadNames;
%                 
%             %Separate the hits matrices by training and testing images.
%             imgHitsTraining = imgHits(:,trainingInd);
%             imgHitsTesting  = imgHits(:,testingInd);
% 
% %Get best patches as based on the loc-values on the training set. 
% for j = 1:size(imgHitsTraining,1)     
%         sumStatsPatch(j) = numel(find(imgHitsTraining(j,:)==1)); 
% %         sumStatsPatch(j) = (sumStatsPatch(j)*100)/size(imgHitsTraining,2);
% end
% [sortSumStatsPatch, IndPatch] = sort(sumStatsPatch,'descend');
% 
% % save([saveLoc 'seedNum','seedNum'])
% % save([saveLoc 'facesLocTraining','facesLocTraining'])
% % save([saveLoc 'facesLocTesting','facesLocTesting'])
% % save([saveLoc 'bestPatchesTrainingSet','sortSumStatsPatch','IndPatch'])
% % save([saveLoc 'imgHitsTraining','imgHitsTraining'])
% % save([saveLoc 'imgHitsTesting','imgHitsTesting'])
% % save([saveLoc 'trainingTestingFaceStimuliIndices','trainingSet','testingSet'])
% % save([saveLoc 'everything'])

%% Subplotting patches for display
% clear; clc; close;
% nPatch = 100;
% filePaths = lsDir('C:\Users\Levan\HMAX\naturalFaceImages\sandbox\topPatches',{'JPEG'});
% for c = 1:nPatch/10
%     for r = 1:nPatch/10
%        subplot(nPatch/10,nPatch/10,r+c*10-10)
%        imshow(filePaths{r+c*10-10})
%        title('hi');
%     end
% end

%% Running combination code with patches representing different face-parts.
% clear;
% load('C:\Users\Levan\HMAX\naturalFaceImages\trainingTestingArrays\bestPatchesTrainingSet.mat')
% 
% nNonChinPatches = 25;
% nChinPatches    = 25;
% 
% saveFolder = 'combiningDifferentFaceParts\lfwTriple25Chin25NonChin'
% saveLoc    = ['C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\' saveFolder '\']
% 
% 
% nonChinPatches = lsDir('C:\Users\Levan\HMAX\naturalFaceImages\trainingTestingArrays\topPatches\nonChinPatches',...
%     {'JPEG'});
% 
% for i = 1:length(nonChinPatches)
%     A = strsplit(nonChinPatches{i},'patch');
%     B = strsplit(A{2},'-');
%     nonChinPatchesIdx(i) = str2num(B{1});
% %     nonChinPatchesIdx(i) = IndPatch(str2num(B{1}));
% end
% 
% [nonChinPatchesIdx, Idx] = sort(nonChinPatchesIdx,'ascend');
% % nonChinIdx = nonChinIdx(Idx);
% % nonChinIdx = nonChinIdx(1:nNonChinPatches);
% 
% %Concatinate indeces of chin-patche and non-chin patches.
% combinationIdx = [1:nChinPatches nonChinPatchesIdx(1:nNonChinPatches)];
% 
% save([saveLoc ...
%     'combinationIdx'],...
%     'combinationIdx');

%% Combine the C2 and bestBands and bestLoc values.
% clear;
% dbstop if error;
% saveLoc = 'C:\Users\Levan\HMAX\naturalFaceImages\naturalFaceImages2\single1-40000\';
% loadLoc = 'C:\Users\Levan\HMAX\naturalFaceImages\naturalFaceImages2\';
% 
% for i = 1:4
%     load([loadLoc 'single1-10000\c2f' int2str(i)])
%     load([loadLoc 'single1-10000\bestBandsC2f' int2str(i)])
%     load([loadLoc 'single1-10000\bestLocC2f' int2str(i)])
%     
%     c2f10000{i} = c2f;
%     bestBands10000{i} = bestBands;
%     bestLoc10000{i} = bestLoc;
% end
% 
% c2f10000 = horzcat(c2f10000{:});
% bestBands10000 = horzcat(bestBands10000{:});
% bestLoc10000 = horzcat(bestLoc10000{:});
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i = 1:4
%     load([loadLoc 'single10001-20000\c2f' int2str(i)])
%     load([loadLoc 'single10001-20000\bestBandsC2f' int2str(i)])
%     load([loadLoc 'single10001-20000\bestLocC2f' int2str(i)])
%     
%     c2f20000{i} = c2f;
%     bestBands20000{i} = bestBands;
%     bestLoc20000{i} = bestLoc;
% end
% 
% c2f20000 = horzcat(c2f20000{:});
% bestBands20000 = horzcat(bestBands20000{:});
% bestLoc20000 = horzcat(bestLoc20000{:});
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i = 1:4
%     load([loadLoc 'single20001-30000\c2f' int2str(i)])
%     load([loadLoc 'single20001-30000\bestBandsC2f' int2str(i)])
%     load([loadLoc 'single20001-30000\bestLocC2f' int2str(i)])
%     
%     c2f30000{i} = c2f;
%     bestBands30000{i} = bestBands;
%     bestLoc30000{i} = bestLoc;
% end
% 
% c2f30000 = horzcat(c2f30000{:});
% bestBands30000 = horzcat(bestBands30000{:});
% bestLoc30000 = horzcat(bestLoc30000{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i = 1:4
%     load([loadLoc 'single30001-40000\c2f' int2str(i)])
%     load([loadLoc 'single30001-40000\bestBandsC2f' int2str(i)])
%     load([loadLoc 'single30001-40000\bestLocC2f' int2str(i)])
%     
%     c2f40000{i} = c2f;
%     bestBands40000{i} = bestBands;
%     bestLoc40000{i} = bestLoc;
% end
% 
% c2f40000 = horzcat(c2f40000{:});
% bestBands40000 = horzcat(bestBands40000{:});
% bestLoc40000 = horzcat(bestLoc40000{:});
% 
% %Now vertically concatinate.
% c2f = vertcat(c2f10000,c2f20000,c2f30000,c2f40000);

%% Generate new LFW image set.
% clear; clc;
% load('C:\Users\Levan\HMAX\HMAX-OCV\targets.mat')
% load('C:\Users\Levan\HMAX\HMAX-OCV\trainingLoc.mat')
% rng(0,'twister');
% idx = randi([1 13233],1,3000);
% A = targets(idx);
% sourceImages = setdiff(A,trainingLoc);
% sourceImages = sourceImages(1:1500);
% sourceImages = [trainingLoc sourceImages];
% save('C:\Users\Levan\HMAX\patches\LFWunresized\sourceImages.mat','sourceImages');



%% Custom combination clutter code
clear; clc;

loadFolder = 'patchSet3\lfwDouble100'
saveFolder = 'patchSet3\lfwCustomTriple100'
nHardImgs = 40

% Load indices of hard images (hard for the doublets).
load(['C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\'...
    loadFolder '\complementaryPatches\' num2str(nHardImgs) '_hardImagesLocalizationData.mat'],...
    'IndHardImgPatches')

% Load the combination matrix of doublets, as well as indices of the best
% doublets.
load(['C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\'...
    loadFolder '\combinationParameterSpace.mat'],...
    'combinationMatrix')
load(['C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\'...
    loadFolder '\imageDifficultyData_4950_Patches.mat'],...
    'IndPatch')
bestDoubletIdx = IndPatch;
clearvars IndPatch;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nTopDoublets = 50;
nHardPatches = 50;
IndHardImgPatches = IndHardImgPatches(1:nHardPatches);
IndHardImgPatches = IndHardImgPatches';
HARD = repmat(IndHardImgPatches,nTopDoublets,1);

bestDoubletIdx = bestDoubletIdx(1:nTopDoublets);
MAT = combinationMatrix(bestDoubletIdx,:);
% MAT = MAT(1:nTopPatches,:);
MAT = kron(MAT,ones(nHardPatches,1));

customCombMatrix = [MAT HARD];

save(['C:\Users\Levan\HMAX\naturalFaceImages\testingSetRuns\' saveFolder ...
    '\' num2str(nHardImgs) '_Hard_Images_customCombMatrix.mat'],'customCombMatrix');