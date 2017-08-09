function [x1 x2 y1 y2] = pixelToC1(x,y,band,c1Scale,c1Space,rfSizes)
% [x1 x2 y1 y2] = pixelToC1(x,y,band,c1Scale,c1Space,filterSizes)
%
% translate a point in pixel-space into a corresponding area in C1-space
%
% x: scalar double, the column in which the point appears
% y: scalar double, the row in which the point appears
% band: scalar double, the C1-band of interest (see 'C1.m' in 'hmax')
% c1Scale: double array, the c1Scale of the C1 activation (see C1.m in 'hmax')
% c1Space: double array, the c1Space of the C1 activation  (see C1.m in 'hmax')
% rfSizes: double array, the receptive field sizes used by initGabor for the C1
%   activation (see initGabor.m in 'hmax')
%
% x1,x2,y1,y2: scalar doubles, the minimum and maximum of the columns and rows
%   affected in C1-space by the point [x,y] in pixel-space.
    % for each scale, filter size determines the area affected by a given point.
    % The max affected area is thus given by the largest filter in a band.
    % The largest filter is given by maxing over the scales in the band.
    % That should give the max affected area in S1 space.

    if isnan(x) || isnan(y)
        x1 = false; x2 = false; y1 = false; y2 = false;
    else
        halfMaxSize = max(rfSizes(c1Scale(band):c1Scale(band+1)-1))/2;

        % affected area in S1-space is img(sx1:sx2,sy1:sy2);
        sx1 = x-floor(halfMaxSize);
        sx2 = x+ceil(halfMaxSize)-1;
        sy1 = y-floor(halfMaxSize);
        sy2 = y+ceil(halfMaxSize)-1;

        % The affected area in C1 space depends on the pooling range given by
        % c1Space. That gives the neighborhood represented by each max-filtered
        % C1-space entry. Knowing that, we identify affected areas and return
        % the C1-space coordinates.

        step = c1Space(band)/2;
        rowIndices = 1:step:sy2; % sy2 is sufficient, since coordinate's covered
        colIndices = 1:step:sx2; % sx2 is sufficient, since coordinate's covered
        c1xs = find(colIndices >= sx1+1-(2*step) & colIndices <= sx2);
        c1ys = find(rowIndices >= sy1+1-(2*step) & rowIndices <= sy2);
        x1 = min(c1xs); x2 = max(c1xs);
        y1 = min(c1ys); y2 = max(c1ys);
    end
end
