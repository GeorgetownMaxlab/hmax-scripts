% % %file for random small scripts.
% 
% 
%% %%%%%%%%FILTERING OUT EMPTY QUADRANTS FROM NATURAL HUMAN FACE DATA%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear; clc;
% folderName = 'lfwDouble100'
% loadPath = 'C:\Users\Levan\HMAX\naturalFaceImages\';
% savePath = [loadPath 'separated\' folderName];
% load([loadPath 'Face_quadrant.mat']);
% load([loadPath folderName '\facesLoc.mat']);
% % % % % % facesLoc{quad,1} = lsDir([loadPath 'quadImages'],{'BMP'});
% % 
% % %:::::::::::ADD THE 2nd and 3rd ROWS DEPICTING NAT# AND QUAD#::::::::::::::
% for quad = 1:4
% for i = 1:size(facesLoc{quad,1},2)
%    i
%     for j = 1:400
%         if size(strfind(facesLoc{quad,1}{1,i},['Nat_' int2str(j) '-']),1) ~= 0
%                facesLoc{quad,1}{2,i} = j;
%                break;
%         end
%     end
% % %     
% % % % % %     for q = 1:4
% % % % % %         if size(strfind(facesLoc{quad,1}{1,i},['quad' int2str(q)]),1) ~= 0
% % % % % %                facesLoc{quad,1}{3,i} = q;
% % % % % %                break;
% % % % % %         end
% % % % % %     end
% end
% 
% for k = 1:size(facesLoc{quad,1},2)
%     facesLoc{quad,1}{3,k} = quad;
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %::::::::::::::::::::ADD 4th ROW FOR WHERE FACE IS::::::::::::::::::::::
% 
% imagQuad = cell2mat(facesLoc{quad,1}(2:3,:));
% 
% for i = 1:length(facePos)
%    ind = find(imagQuad(1,:) == i & imagQuad(2,:) == facePos(i));
%    if isempty(ind) == 0
%    facesLoc{quad,1}{4,ind} = 1;
%    end
% end
% 
% for i = 1:length(facesLoc{quad,1})
%     if isempty(facesLoc{quad,1}{4,i}) == 1
%         facesLoc{quad,1}{4,i} = 0;
%     end
% end
% %:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% 
% %::::::::::::::SEPARATE FACE AND EMPTY QUAD NAMES:::::::::::::::::::::::::s
% indFaces{quad,1} = find(cell2mat(facesLoc{quad,1}(4,:)) == 1);
% indEmpty{quad,1} = find(cell2mat(facesLoc{quad,1}(4,:)) == 0);
% 
% % faceQuadNames =  facesLoc{quad,1}(:,indFaces);
% % emptyQuadNames = facesLoc{quad,1}(:,indEmpty);
% end
% 
% save([loadPath 'separated\indices.mat'],'indFaces','indEmpty');



%%%%%%%LOAD EACH FILE AND FILTER USING THE OBTAINED INDICES%%%%%%%%%%%%%%
% ******see filterNatualFaceLocalization.m for most up-to-date code******
%
% clear; clc;
% folderName = 'lfwSingle1-10k'
% lastPatch  = 10000;
% loadPath   = 'C:\Users\Levan\HMAX\naturalFaceImages\';
% mkdir([loadPath 'separated\'],folderName);
% savePath   = [loadPath 'separated\' folderName '\'];
% 
% load([loadPath 'separated\indices.mat']);
% imgHits1 = {};
% imgHits2 = {};
% load([loadPath folderName '\imgHits' int2str(lastPatch) '.mat']);
% load([loadPath folderName '\facesLoc.mat']);
% 
% for n = 1:4
%     %Load the files of the n'th quadrant.
%     load([loadPath folderName '\bestBandsC2f' int2str(n) '.mat']);
%     load([loadPath folderName '\bestLocC2f' int2str(n) '.mat']);
%     load([loadPath folderName '\c2f' int2str(n) '.mat']);
%         %contatinate some of the matrices.
%         bestBands = horzcat(bestBands{1,:});
%         bestLoc  = horzcat(bestLoc{1,:,:});
%             %Now filter bestBands, bestLoc, and c2f, and save them. 
%             bestBandsEmpty = bestBands(:,indEmpty{n});
%             bestLocEmpty = bestLoc(:,indEmpty{n},:);
%             c2e = c2f(:,indEmpty{n});
%             save([savePath 'bestBandsC2e' int2str(n)],'bestBandsEmpty');
%             save([savePath 'bestLocC2e' int2str(n)],'bestLocEmpty');
%             save([savePath 'c2e' int2str(n)],'c2e');            
%                 bestBandsFaces = bestBands(:,indFaces{n});
%                 bestLocFaces = bestLoc(:,indFaces{n},:);
%                 c2f = c2f(:,indFaces{n});
%                 save([savePath 'bestBandsC2f' int2str(n)],'bestBandsFaces');
%                 save([savePath 'bestLocC2f' int2str(n)],'bestLocFaces');
%                 save([savePath 'c2f' int2str(n)],'c2f');
%                     %Filter and save facesLoc.mat file
%                     emptyLoc{n,1} = facesLoc{n,1}(:,indEmpty{n});
%                     facesLoc{n,1} = facesLoc{n,1}(:,indFaces{n});
%             %Transform the imgHits file
%             for p = 1:lastPatch
%                 for w = 1:6
%                     imgHits1{p,w} = imgHits{1,n}{1,w}{p};
%                 end
%                 imgHits2{1,p} = horzcat(imgHits1{p,:});
%             end
%             imgHits3{1,n} = cell2mat(vertcat(imgHits2{:}));
%         %Now filter out the empty quadrants from face quadrants in imgHits.
%         imgHitsFaces{1,n} = imgHits3{1,n}(:,indFaces{n});
%         imgHitsEmpty{1,n} = imgHits3{1,n}(:,indEmpty{n});
% end
% 
% %Concatinage the imgHits to get a patch-by-image matrix, which will be used
% %to display the "image difficulty" maps.
% imgHitsFacesMap = horzcat(imgHitsFaces{:});
% imgHitsEmptyMap = horzcat(imgHitsEmpty{:});
% 
% save([savePath 'imgHitsFacesMap'],'imgHitsFacesMap');
% save([savePath 'imgHitsEmptyMap'],'imgHitsEmptyMap');
% save([savePath 'imgHitsFaces'],'imgHitsFaces');
% save([savePath 'imgHitsEmpty'],'imgHitsEmpty');
% save([savePath 'facesLoc'],'facesLoc');
% save([savePath 'emptyLoc'],'emptyLoc');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%CHECK THAT FILTERS ARE CORRECT IN SEPARATING EMPTY AND FACE IMAGES%%%%%
% clear; clc;
% load('C:\Users\Levan\HMAX\naturalFaceImages\lfwDouble100\facesLoc.mat')
% load('C:\Users\Levan\HMAX\naturalFaceImages\separated\indices.mat')
% 
% for n = 1:4 
% for j = 1:size(indEmpty{n},2)
%     status = system(['cp ' facesLoc{n,1}{indEmpty{n,1}(j)} ...
%         'C:\Users\Levan\HMAX\sandbox\isFilterRight\empty\']);
% end
% end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%::::::::::CONCATINATE SINGLE MAPS::::::::::::::::::::::::::::::::::::
% clear; clc;
% load('C:\Users\Levan\HMAX\naturalFaceImages\separated\lfwSingle1-10k\imgHitsEmptyMap.mat');
% load('C:\Users\Levan\HMAX\naturalFaceImages\separated\lfwSingle1-10k\imgHitsFacesMap.mat');
% imgHitsEmptyMap1 = imgHitsEmptyMap;
% imgHitsFacesMap1 = imgHitsFacesMap;
%     load('C:\Users\Levan\HMAX\naturalFaceImages\separated\lfwSingle10k-20k\imgHitsEmptyMap.mat');
%     load('C:\Users\Levan\HMAX\naturalFaceImages\separated\lfwSingle10k-20k\imgHitsFacesMap.mat');
%     imgHitsEmptyMap2 = imgHitsEmptyMap;
%     imgHitsFacesMap2 = imgHitsFacesMap;
%         load('C:\Users\Levan\HMAX\naturalFaceImages\separated\lfwSingle20k-30k\imgHitsEmptyMap.mat');
%         load('C:\Users\Levan\HMAX\naturalFaceImages\separated\lfwSingle20k-30k\imgHitsFacesMap.mat');
%         imgHitsEmptyMap3 = imgHitsEmptyMap;
%         imgHitsFacesMap3 = imgHitsFacesMap;
%             load('C:\Users\Levan\HMAX\naturalFaceImages\separated\lfwSingle30k-40k\imgHitsEmptyMap.mat');
%             load('C:\Users\Levan\HMAX\naturalFaceImages\separated\lfwSingle30k-40k\imgHitsFacesMap.mat');
%             imgHitsEmptyMap4 = imgHitsEmptyMap;
%             imgHitsFacesMap4 = imgHitsFacesMap;
%     %Now concatinate vertically
%     imgHitsEmptyMap = [imgHitsEmptyMap1; imgHitsEmptyMap2; imgHitsEmptyMap3; imgHitsEmptyMap4];
%     imgHitsFacesMap = [imgHitsFacesMap1; imgHitsFacesMap2; imgHitsFacesMap3; imgHitsFacesMap4];
% save('C:\Users\Levan\HMAX\naturalFaceImages\separated\lfwSingle1-40k\imgHitsEmptyMap.mat','imgHitsEmptyMap');
% save('C:\Users\Levan\HMAX\naturalFaceImages\separated\lfwSingle1-40k\imgHitsFacesMap.mat','imgHitsFacesMap');


%% ::::DOUBLE CHECKING THE CONCATINATION OF IMGHITS FILE::::::::::::::::::
% lastPatch = 10000;
% imgHits1 = {};
% imgHits2 = {};
% imgHits3 = {};
% for n = 1:4
%     for p = 1:lastPatch
%                     for w = 1:6
%                         imgHits1{p,w} = imgHits{1,n}{1,w}{p};
%                     end
%                     imgHits2{1,p} = horzcat(imgHits1{p,:});
%     end
%                 imgHits3{1,n} = cell2mat(vertcat(imgHits2{:}));
% end
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

%% ::::::::::::Separating actual images into different folders::::::::::::::
% clear; clc;
% folderName = 'lfwDouble100'
% loadPath = 'C:\Users\Levan\HMAX\naturalFaceImages\';
% savePath = [loadPath 'separated\' folderName];
% load([loadPath 'Face_quadrant.mat']);
% load([loadPath folderName '\facesLoc.mat']);
% % % % % % facesLoc{quad,1} = lsDir([loadPath 'quadImages'],{'BMP'});
% % 
% % %:::::::::::ADD THE 2nd and 3rd ROWS DEPICTING NAT# AND QUAD#::::::::::::::
% for quad = 1:4
% for i = 1:size(facesLoc{quad,1},2)
%    i
%     for j = 1:400
%         if size(strfind(facesLoc{quad,1}{1,i},['Nat_' int2str(j) '-']),1) ~= 0
%                facesLoc{quad,1}{2,i} = j;
%                break;
%         end
%     end
% % %     
% % % % % %     for q = 1:4
% % % % % %         if size(strfind(facesLoc{quad,1}{1,i},['quad' int2str(q)]),1) ~= 0
% % % % % %                facesLoc{quad,1}{3,i} = q;
% % % % % %                break;
% % % % % %         end
% % % % % %     end
% end
% 
% for k = 1:size(facesLoc{quad,1},2)
%     facesLoc{quad,1}{3,k} = quad;
% end
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %::::::::::::::::::::ADD 4th ROW FOR WHERE FACE IS::::::::::::::::::::::
% 
% imagQuad = cell2mat(facesLoc{quad,1}(2:3,:));
% 
% for i = 1:length(facePos)
%    ind = find(imagQuad(1,:) == i & imagQuad(2,:) == facePos(i));
%    if isempty(ind) == 0
%    facesLoc{quad,1}{4,ind} = 1;
%    end
% end
% 
% for i = 1:length(facesLoc{quad,1})
%     if isempty(facesLoc{quad,1}{4,i}) == 1
%         facesLoc{quad,1}{4,i} = 0;
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ::::::::::::Are BestLoc and BestBands done correctly:::::::::::::::::::::
% clear; clc;
% folderName = 'localizationData/lfwSingle1-10kS2'
% %FACES!!!!!!!!!!!!!!!!!!!!!
% 
% load(['C:\Users\Levan\HMAX\naturalFaceImages\' folderName '\s2f1.mat'])
% load(['C:\Users\Levan\HMAX\naturalFaceImages\' folderName '\bestBandsC2f1.mat'])
% load(['C:\Users\Levan\HMAX\naturalFaceImages\' folderName '\bestLocC2f1.mat'])
% 
% i1p1 = s2f{1}{1}; %UNCROPPED.
% 
% %NOW CROP THE MATRICES
% for i = 1:size(i1p1,2)
%     p2C{i} = i1p1{i}(1:end-10,1:end-10);
%     MINp2C(i) = min(p2C{i}(:));
% end
% colorbar;

% %::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% for i = 1:size(imgHits4,1)
%     locValue(i) = nnz(imgHits4(i,:));
% end
% locValueSort = sort(locValue,'descend');
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% 
% for i = 1:length(imgHitsEmptyMap)
%     sumStat(i) = nnz(imgHitsEmptyMap(i,:));
% end
% 
% [sortSumStatsPatchEmpty, indBestLocValuePatchesEmpty] = sort(sumStatsPatchEmpty,'descend');
%

%% Check BestBands is Accurate
% %Results: it is accurate if cropping is done.
% clear; clc; close;
% load('C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\emptyOrdered\bestBandsC2f2.mat')
% load('C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\emptyOrdered\bestLocC2f2.mat')
% load('C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\emptyOrdered\s2e2.mat')
% 
% ACC = {};
% for img = 1:15
%     for patch = 1:100
% 
%         bestBand = bestBands{1}(patch,img);
%         allBands = s2f{img}{patch};
%        
%             for i = 1:8
%                 %Crop all of the bands by 2 units from top and left.
%                 % 5 unites from right and bottom. 
%                 allBands{i} = allBands{i}(3:end-5,3:end-5);
%                 allMinS2(i) = min(allBands{i}(:));
%             end
%             [minS2 idx] = min(allMinS2);
%             
%             %Inspect the heatMap of the S2 matrix.
% %                 %Find row and column of the minS2
% %                 [r,c] = find(allBands{idx} == minS2);
% %                 %Now change that minS2 in the matrix to 0 value.
% %                 allBands{idx}(r,c) = 0;
% %                 imagesc(allBands{idx});
% %                 colorbar;
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%                 %Record the actual minimum S2 values for 
%                 %each patch and image.
%                 MATminS2{patch,img} = minS2;
% 
%             %Does manually obtain minS2 come from the band specified by 
%             %bestBands file? 
%             if idx == bestBand
%                 ACC{patch,img} = 1;
%             else
%                 ACC{patch,img} = 0;
%             end
%     end
% end
% nnz(cell2mat(ACC)) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Check if BestLoc is accurate
% %Result: it is accurate if cropping is done. 
% clear; clc; close;
% %Load all the variables.
% load('C:\Users\Levan\HMAX\naturalFaceImages\localizationData\lfwSingle1-40k\indBestLocValuePatchesEmpty.mat')
% load('C:\Users\Levan\HMAX\naturalFaceImages\localizationData\lfwSingle1-40k\imgHitsEmptyMap.mat')
% load('C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\emptyOrdered\s2e4.mat')
% load('C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\emptyOrdered\bestBandsC2f4.mat')
% load('C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\emptyOrdered\bestLocC2f4.mat')
% 
% fprintf('Loaded the 4th quadrant\n');
% 
% %sort the hits matrix by best patches
% imgHitsMapSorted = imgHitsEmptyMap(indBestLocValuePatchesEmpty,:);
% 
% for img = 1:15
%     for patch = 1:100
% 
% bestBand = bestBands{1}(patch,img);
% S2 = s2e{img}{patch}{bestBand};
% 
%     %Crop the S2 matrix.
%     S2 = S2(3:end-5,3:end-5);
% 
%     %Find the minimum S2 for the best band matrix.
%     minS2 = min(S2(:));
%     
%     %Find row and column of the minS2
%     [r,c] = find(S2 == minS2);
% %     imagesc(S2);
% %     colorbar;
%     
%         %Now change that minS2 in the matrix to 0 value.
% %         S2(r,c) = 0;
% %         imagesc(S2);
% %         colorbar;
% 
%             % %Change the lowest value on the map to be black.
%             % newmap = jet;
%             % ncol = size(newmap,1);
%             % newmap(1,:) = [1 1 1];
%             % colormap(newmap);
% 
%         %What does bestLoc say about minimum S2?
%         r1 = bestLoc{1}(patch,img,1);
%         c1 = bestLoc{1}(patch,img,2);
%             
%             %Do the r and c match r1 and c1?
%             if r == r1 && c == c1
%                 ACC{patch,img} = 1;
%             else
%                 ACC{patch,img} = 0;
%             end
%     end
% end
% nnz(cell2mat(ACC)) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Convert Linux loc.mat files for windows


for q = 1:4
    for img = 1:50
    facesLocTrainingWin{q,1}{img} = ['C:\Users\Levan\HMAX\naturalFaceImages\quadImages\' ...
        facesLocTraining{q,1}{img}(69:end)] 
    end
end

% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% How does prompting work
% function promptTesting
%     x = input('What is the quad type?\n')
%     
% %     fprintf(x)
% 
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Comparing run before and after editing the runNaturalPsych1.m code.
clear;
nQuad = '4';
    load(['C:\Users\Levan\HMAX\naturalFaceImages\checks\first100\c2f' nQuad '.mat'])
    c2f100 = c2f;
    load(['C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\300SinglesFaces\c2f' nQuad '.mat'])

isequal(c2f100,c2f(1:100,:))
%% -------------------------------------------------------------------------
clear; clc;
nQuad = '4';
    load(['C:\Users\Levan\HMAX\naturalFaceImages\checks\first100\bestBandsC2f' nQuad '.mat'])
    bestBands100 = bestBands;
    load(['C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\300SinglesFaces\bestBandsC2f' nQuad '.mat'])

isequal(bestBands100{1},bestBands{1}(1:100,:))

%% ---------------------
clear; clc;
nQuad = '4';
    load(['C:\Users\Levan\HMAX\naturalFaceImages\checks\first100\bestLocC2f' nQuad '.mat'])
    bestLoc100 = bestLoc;
    load(['C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\300SinglesFaces\bestLocC2f' nQuad '.mat'])

isequal(bestLoc100{1},bestLoc{1}(1:100,:,:))
%% -------------------------------------
clear; clc;
load('C:\Users\Levan\HMAX\naturalFaceImages\checks\first100\hitsf.mat');
hits100 = hits;
load('C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\300SinglesFaces\hitsf.mat');
    for i = 1:5
        hits{i} = hits{i}(1:100);
    end
isequal(hits,hits100)

%% ------------------------------------
clear; clc;
  load(['C:\Users\Levan\HMAX\naturalFaceImages\checks\first100\imgHitse100.mat'])
   imgHits100 = imgHits;
    load(['C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\300SinglesEmpty\imgHitse300.mat'])
    for i = 1:4
        imgHits{i}{1} = imgHits{i}{1}(1:100) 
    end
isequal(imgHits,imgHits100)
%% ------------------------------------
clear; clc;
  load(['C:\Users\Levan\HMAX\naturalFaceImages\checks\first100\imgHitsf100.mat'])
   imgHits100 = imgHits;
    load(['C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\300SinglesFaces\imgHitsf300.mat'])
    for i = 1:4
        imgHits{i}{1} = imgHits{i}{1}(1:100) 
    end
isequal(imgHits,imgHits100)

%% ------------------------------------
clear; clc;
  load(['C:\Users\Levan\HMAX\naturalFaceImages\checks\first100\imgHitsMape.mat'])
   imgHits100 = imgHits;
    load(['C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\300SinglesEmpty\imgHitsMape.mat'])

isequal(imgHits(1:100,:),imgHits100)


