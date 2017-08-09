function checkBandsAndLoc(quadType,quadNum,nPatches,nImg,folderName)
% Checking bestBands and bestLoc accuracy.

% quadType: 'f' or 'e'
% quadNum: a string, which of the four quadrant files are loaded.
% nPatches: number of pathces.
% nImg: number of images.
% folderName: which folder in the /naturalFaceImgaes/ directory contains the files?

if (nargin < 1)
    quadType = 'f';
    quadNum  = '1';
    nPatches = 100;
    nImg     = 15;
    folderName = 'debugLevan/emptyOrdered';
end
   
% loadPath = ['C:\Users\Levan\HMAX\naturalFaceImages\debugLevan\' folderName '\'];
loadPath = ['/home/bentrans/Documents/HMAX/feature-learning/HMAX-MATLAB/naturalFaceImages/' folderName '/'];
load([loadPath 'bestBandsC2' quadType quadNum '.mat']);
load([loadPath 'bestLocC2'   quadType quadNum '.mat']);
load([loadPath 's2'          quadType quadNum '.mat']);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bandACC = {}; %array records whether bestBands variable is correct.
locACC  = {}; %records if bestLoc variables are correct.

for img = 1:nImg
    for patch = 1:nPatches
      
        bestBand = bestBands{1}(patch,img);
        if strcmp(quadType,'f')
            allBands = s2f{img}{patch};
        else
            allBands = s2e{img}{patch};
        end
            for i = 1:8
                %Crop all of the bands by 2 units from top and left.
                % 5 unites from right and bottom. 
                %allBands{i} = allBands{i}(3:end-5,3:end-5);
                allMinS2(i) = min(allBands{i}(:)); %find the min S2 for each band.
            end
            [minS2, manualBand] = min(allMinS2); %manualBand will give the 
            %band number that has the lowest S2 obtained manually. 
            
                S2 = allBands{bestBand};
                %Find the minimum S2 for the bestBand S2 matrix.
                minS2 = min(S2(:));
                %Find row and column of the minS2 IN THE CROPPED S2 MATIX. 
                [r,c] = find(S2 == minS2);
            
%                     %Inspect the heatMap of the S2 matrix.
%                         %Find row and column of the minS2
%                         [r,c] = find(allBands{idx} == minS2);
%                         %Now change that minS2 in the matrix to 0 value.
%                         allBands{idx}(r,c) = 0;
%                         imagesc(allBands{idx});
%                         colorbar;
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%                         Record the actual minimum S2 values for 
%                         each patch and image.
%                       MATminS2{patch,img} = minS2;

                %Does manually obtain minS2 come from the band specified by 
                %bestBands file? 
                if manualBand == bestBand
                    bandACC{patch,img} = 1;
                else
                    bandACC{patch,img} = 0;
                end

            %What does bestLoc say about minimum S2?
            r1 = bestLoc{1}(patch,img,1);
            c1 = bestLoc{1}(patch,img,2);
            %Do the r and c match r1 and c1?
            if r == r1 && c == c1
                locACC{patch,img} = 1;
            else
                locACC{patch,img} = 0;
            end     
    end
end
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This will output the number of incorrect bands or location variables.
bandsINCORRECT = nPatches*nImg - nnz(cell2mat(bandACC))
locINCORRECT   = nPatches*nImg - nnz(cell2mat(locACC))

end
















