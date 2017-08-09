function [x1 x2 y1 y2] = c1ToPixel(x,y,band,c1Scale,c1Space,rfSizes,imgSizeX,imgSizeY)
% [x1 x2 y1 y2] = c1ToPixel(x,y,band,c1Scale,c1Space,rfSizes,imgSizeX,imgSizeY)
%
% translate a point in C1-space back to the area in pixel-space generating it.
% The actual size of the image is optional, but should be included for the best
% accuracy. Otherwise, all pooling operations will be calculated as if the image
% were perfectly sized such that there were no partial pooling neighborhoods.
%
% x: scalar double, the column in which the point appears in C1-space
% y: scalar double, the row in which the point appears in C1-space
% band: scalar double, the C1-band in which the point appears (see 'C1.m' in 'hmax')
% c1Scale: double array, the c1Scale of the C1 activation (see C1.m in 'hmax')
% c1Space: double array, the c1Space of the C1 activation  (see C1.m in 'hmax')
% rfSizes: double array, the receptive field sizes used by initGabor for the C1
%   activation (see initGabor.m in 'hmax')
% imgSizeX: scalar double, the number of columns in the image, optional
% imgSizeY: scalar double, the number of rows in the image, optional
%
% x1,x2,y1,y2: scalar doubles, the minimum and maximum of the columns and rows
%   in pixel-space generating the point [x,y] in C1-space.
    if (nargin < 8) imgSizeY = bitmax; end;
    if (nargin < 7) imgSizeX = bitmax; end;

    if isnan(x) || isnan(y)
        x1 = false; x2 = false; y1 = false; y2 = false;
    else
        % reverse C1 (maxFilter)
        poolSize = c1Space(band);
        halfPool = poolSize/2;
        s1XMin = (x-1)*halfPool+1; % 1:halfpool:s1xSize
        s1YMin = (y-1)*halfPool+1; % 1:halfpool:s1ySize
        s1XMax = s1XMin+poolSize-1;
        s1YMax = s1YMin+poolSize-1;

        % reverse S1 (conv2)
        halfMaxSize = max(rfSizes(c1Scale(band):c1Scale(band+1)-1))/2;
        x1 = max(min(s1XMin-(ceil(halfMaxSize)-1), ...
                     s1XMax-(ceil(halfMaxSize)-1)), ...
                 1);
        x2 = min(max(s1XMin+floor(halfMaxSize), ...
                     s1XMax+floor(halfMaxSize)), ...
                 imgSizeX);
        y1 = max(min(s1YMin-(ceil(halfMaxSize)-1), ...
                     s1YMax-(ceil(halfMaxSize)-1)), ...
                 1);
        y2 = min(max(s1YMin+floor(halfMaxSize), ...
                     s1YMax+floor(halfMaxSize)), ...
                 imgSizeY);
    end
end
