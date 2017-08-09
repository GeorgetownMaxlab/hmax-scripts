function [x1o,x2o,y1o,y2o] = patchDimensionsInPixelSpace( ...
  band,x1i,x2i,y1i,y2i,c1Scale,c1Space,rfSizes,imgSizeX,imgSizeY)
% [x1o,x2o,y1o,y2o] = patchDimensionsInPixelSpace( ...
%   band,x1i,x2i,y1i,y2i,c1Scale,c1Space,rfSizes,imgSizeX,imgSizeY)
%
% Given information about a patch, return the area in pixel space which
% contributes to it.
%
% band: scalar double, the C1-band of interest (see 'C1.m' in 'hmax')
% x1i,x2i,y1i,y2i: scalar doubles, the four corners of the patch in C1-space
% c1Scale: double array, the c1Scale of the C1 activation (see C1.m in 'hmax')
% c1Space: double array, the c1Space of the C1 activation  (see C1.m in 'hmax')
% rfSizes: double array, the receptive field sizes used by initGabor for the C1
%   activation (see initGabor.m in 'hmax')
% imgSizeX: scalar double, the number of columns in the image, optional
% imgSizeY: scalar double, the number of rows in the image, optional
%
% x1o,x2o,y1o,y2o: scalar doubles, the four corners of the patch in pixel-space
    if (nargin < 10) imgSizeY = bitmax; end;
    if (nargin < 9)  imgSizeX = bitmax; end;

    [x1x1,x1x2,y1y1,y1y2] = c1ToPixel(x1i,y1i,band,c1Scale,c1Space,rfSizes, ...
                                      imgSizeX,imgSizeY);
    [x2x1,x2x2,y2y1,y2y2] = c1ToPixel(x2i,y2i,band,c1Scale,c1Space,rfSizes, ...
                                      imgSizeX,imgSizeY);
    x1o = min(x1x1,x2x1);
    x2o = max(x1x2,x2x2);
    y1o = min(y1y1,y2y1);
    y2o = max(y1y2,y2y2);
end
