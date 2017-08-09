function image = stretch_histogram( original, reference )
%
%STRETCH_HISTOGRAM returns an image coresponding to the original image
% with a range of values similar to the reference image (we do not consider
% 'outliers': if there's just one pixel at 255, and then the brighest ones
% are around 200, the 255 pixel won't be taken into account
%
%   stretch_histogram( original, reference )
%      original  - original image to transform
%      reference - reference image to determine the range od values
%
%   Examples:
%      imgResult = stretch_histogram( imgOriginal, imgRef )
%
%   Author:      Adrien Brilhault
%   Date:        2010-06-11
%   E-mail:      adrien.brilhault@gmail.com


image=imadjust(original,stretchlim(original),stretchlim(reference));
