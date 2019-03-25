function [patches locations bands] = extractAllPatches(c1r,patchSize)
% [patches locations bands] = extractAllPatches(c1r,patchSize)
%
% given a C1 response for an image, extract all possible patches of a given size
% key assumption: a single c1 activation and a single patch size
%
% c1r: cell array, a C1 response (see 'C1.m' in 'hmax')
% patchSize: double array, a vector of length 3 detailing the number of rows,
%   columns, and orientations, respectively, to use in building patches
%
% patches: double array, the extracted patches
% locations: double array, an [nPatches 2] array of patch locations in C1-space
% bands: double array, an nPatches vector of the bands each patch was taken from
    nBands = length(c1r);
    preBands = cell(nBands,1);
    preLocations = cell(nBands,1);
    allPatchCols = cell(patchSize(3),1);
    for iBand = 1:length(c1r)
        b = c1r{iBand};
        sizes = [size(b,1); size(b,2)] - patchSize(1:2) + 1;
        nRows = sizes(1);
        nCols = sizes(2);
        for i = 1:patchSize(3)
            allPatchCols{i} = im2col(b(:,:,i),patchSize(1:2),'sliding');
        end
        prePatches{iBand} = cat(1,allPatchCols{:})';
        preBands{iBand} = ones(size(prePatches{iBand},1),1)*iBand;
        preLocations{iBand} = [repmat(1:nRows,1,nCols)' ...
                               reshape(repmat(1:nCols,nRows,1),[],1)];
    end
    patches = cat(1,prePatches{:});
    bands = cat(1,preBands{:});
    locations = cat(1,preLocations{:});
end

% Reference Implementation:
% function [patches locations bands] = extractAllPatches(c1r,patchSize)
%     patches = [];
%     for iBand = 1:length(c1r)
%         b = c1r{iBand};
%         [nRows nCols ~] = size(b);
%         for iCol = 1:(nCols-patchSize(2)+1)
%             for iRow = 1:(nRows-patchSize(1)+1)
%                 r1 = iRow;
%                 c1 = iCol;
%                 r2 = r1+patchSize(1)-1;
%                 c2 = c1+patchSize(2)-1;
%                 if r1>0 && c1>0 && r2 <= nRows && c2 <= nCols &&...
%                     sum(sum(sum(isnan(b(r1:r2,c1:c2,:))))) == 0
%                     idx = size(patches,1)+1;
%                     patches(idx,:) = reshape(b(r1:r2,c1:c2,:),1,[]);
%                     locations(idx,:) = [iRow iCol];
%                     bands(idx,:) = iBand;
%                 end
%             end
%         end
%     end
% end
