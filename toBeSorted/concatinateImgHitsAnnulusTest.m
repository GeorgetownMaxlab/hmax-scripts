function concatinateImgHitsAnnulusTest(imgHits,quadType,nPatches,loadPath,savePath,startFace,endFace)
% clear; clc;
%Move to directory where imgHits is located. 
% loadPath = ['C:\Users\Levan\HMAX\naturalFaceImages\' folderName '\'];
% savePath = loadPath;
% load('C:\Users\Levan\Desktop\singles\imgHits50.mat')
% load([loadPath 'imgHits' int2str(nPatches)]);
%change this depending on the patch-type.
% load('C:\Users\Levan\HMAX\naturalFaceImages\indicesForSeparation.mat')
imgHits1 = {};
imgHits2 = {};
imgHits3 = {};
% if strcmp(quadType,'f') == 1
%     upperW = 3
% else
%     upperW = 1
% end
upperW = size(imgHits{1},2)
for n = 1:1 %for four quadrants.
    for p = 1:nPatches
                    for w = 1:upperW
                        imgHits1{p,w} = imgHits{1,n}{1,w}{p}; 
                    end
                    imgHits2{1,p} = horzcat(imgHits1{p,:});
    end
    imgHits3{1,n} = cell2mat(vertcat(imgHits2{:})); 
    %this creates patch-X-image matrix for each n quadrants.

%     imgHitsFaces{1,n} = imgHits3{1,n}(:,indFaces{n});
%     imgHitsEmpty{1,n} = imgHits3{1,n}(:,indEmpty{n});
    %this has filtered the data into empty and face quadrant data. You can
    %now concatinate the matrices for each quadrant, and have a
    %master-matrix with all patches on Y and all images on X. 
end

imgHits = horzcat(imgHits3{:});
save([savePath 'imgHitsMap' quadType '_' startFace '-' endFace], 'imgHits');

end