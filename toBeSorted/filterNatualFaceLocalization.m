function filterNatualFaceLocalization(folderName,lastPatch)
%Script to filter out data about empty quad-images from the data structures
%Ben created using when calculating localization on the natural face
%images.


%%%%%%%LOAD EACH FILE AND FILTER USING THE OBTAINED INDICES%%%%%%%%%%%%%%
% clear; clc;
% folderName = 'lfwDouble100'
% lastPatch  = 4950;
loadPath   = 'C:\Users\Levan\HMAX\naturalFaceImages\unseparatedData\';
mkdir([loadPath 'separated2\'],folderName);
savePath   = [loadPath 'separated2\' folderName '\'];

load([loadPath '\indicesForSeparation.mat']);
imgHits1 = {};
imgHits2 = {};
load([loadPath folderName '\imgHits' int2str(lastPatch) '.mat']);
load([loadPath folderName '\facesLoc.mat']);


for n = 1:4
    %Load the files of the n'th quadrant.
    load([loadPath folderName '\bestBandsC2f' int2str(n) '.mat']);
    load([loadPath folderName '\bestLocC2f' int2str(n) '.mat']);
    load([loadPath folderName '\c2f' int2str(n) '.mat']);
        %contatinate some of the matrices.
        bestBands = horzcat(bestBands{1,:});
        bestLoc  = horzcat(bestLoc{1,:,:});
            %Now filter bestBands, bestLoc, and c2f, and save them. 
            bestBandsEmpty = bestBands(:,indEmpty{n});
            bestLocEmpty = bestLoc(:,indEmpty{n},:);
            c2e = c2f(:,indEmpty{n});
            save([savePath 'bestBandsC2e' int2str(n)],'bestBandsEmpty');
            save([savePath 'bestLocC2e' int2str(n)],'bestLocEmpty');
            save([savePath 'c2e' int2str(n)],'c2e');            
                bestBandsFaces = bestBands(:,indFaces{n});
                bestLocFaces = bestLoc(:,indFaces{n},:);
                c2f = c2f(:,indFaces{n});
                save([savePath 'bestBandsC2f' int2str(n)],'bestBandsFaces');
                save([savePath 'bestLocC2f' int2str(n)],'bestLocFaces');
                save([savePath 'c2f' int2str(n)],'c2f');
                    %Filter facesLoc.mat file
                    emptyLoc{n,1} = facesLoc{n,1}(:,indEmpty{n});
                    facesLoc{n,1} = facesLoc{n,1}(:,indFaces{n});
            %Transform the imgHits file
            for p = 1:lastPatch
                for w = 1:6
                    imgHits1{p,w} = imgHits{1,n}{1,w}{p};
                end
                imgHits2{1,p} = horzcat(imgHits1{p,:});
            end
            imgHits3{1,n} = cell2mat(vertcat(imgHits2{:}));
        %Now filter out the empty quadrants from face quadrants in imgHits.
        imgHitsFaces{1,n} = imgHits3{1,n}(:,indFaces{n});
        imgHitsEmpty{1,n} = imgHits3{1,n}(:,indEmpty{n});
end
%Concatinage the imgHits to get a patch-by-image matrix, which will be used
%to display the "image difficulty" maps.
imgHitsFacesMap = horzcat(imgHitsFaces{:});
imgHitsEmptyMap = horzcat(imgHitsEmpty{:});
    
    %Calculate patch localization and image difficulty values.
    for p = 1:lastPatch
        sumStatsPatchFaces(p) = nnz(imgHitsFacesMap(p,:));
        sumStatsPatchEmpty(p) = nnz(imgHitsEmptyMap(p,:));
    end
        for i = 1:size(imgHitsFacesMap,2)
            sumStatsImagesFaces(i) = nnz(imgHitsFacesMap(:,i));
        end
    for i = 1:size(imgHitsEmptyMap,2)
        sumStatsImagesEmpty(i) = nnz(imgHitsEmptyMap(:,i));
    end
    %::::::::::::::::::::::::::::::::::::::::::::::::::::::::


save([savePath 'sumStatsPatchFaces'],'sumStatsPatchFaces');
save([savePath 'sumStatsPatchEmpty'],'sumStatsPatchEmpty');
save([savePath 'sumStatsImagesFaces'],'sumStatsImagesFaces');
save([savePath 'sumStatsImagesEmpty'],'sumStatsImagesEmpty');

save([savePath 'imgHitsFacesMap'],'imgHitsFacesMap');
save([savePath 'imgHitsEmptyMap'],'imgHitsEmptyMap');

save([savePath 'imgHitsFaces'],'imgHitsFaces');
save([savePath 'imgHitsEmpty'],'imgHitsEmpty');
save([savePath 'facesLoc'],'facesLoc');
save([savePath 'emptyLoc'],'emptyLoc');
end