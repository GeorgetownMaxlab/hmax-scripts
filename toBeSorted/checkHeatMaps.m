function checkHeatMaps(patch,img)
%check if heat maps work correctly. 
% clear; clc; 
%Load all the variables.
load('C:\Users\Levan\HMAX\naturalFaceImages\localizationData\lfwSingle1-40k\indBestLocValuePatchesEmpty.mat')
load('C:\Users\Levan\HMAX\naturalFaceImages\localizationData\lfwSingle1-40k\imgHitsEmptyMap.mat')
load('C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\emptyOrdered\s2e1.mat')
load('C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\emptyOrdered\bestBandsC2f1.mat')
load('C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\emptyOrdered\bestLocC2f1.mat')

%sort the hits matrix by best patches
imgHitsMapSorted = imgHitsEmptyMap(indBestLocValuePatchesEmpty,:);

% img = 6;
% patch = 6;
bestBand = bestBands{1}(patch,img);
S2 = s2e{img}{patch}{bestBand};

    %Crop the S2 matrix.
    S2 = S2(3:end-5,3:end-5);

    %Find the minimum S2 for the best band matrix.
    minS2 = min(S2(:));
    
    %Find row and column of the minS2
    [r,c] = find(S2 == minS2);
%     imagesc(S2);
%     colorbar;
    
        %Now change that minS2 in the matrix to 0 value.
        S2(r,c) = 0;
        imagesc(S2);
        colorbar;

            % %Change the lowest value on the map to be black.
            % newmap = jet;
            % ncol = size(newmap,1);
            % newmap(1,:) = [1 1 1];
            % colormap(newmap);

        %What does bestLoc say about minimum S2?
        r1 = bestLoc{1}(patch,img,1);
        c1 = bestLoc{1}(patch,img,2);
end