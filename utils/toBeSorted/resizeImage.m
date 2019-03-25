function imgOut = resizeImage(imgIn,maxSize)
% imgOut = resizeSize(imgIn,maxSize)
%
% transform an image to be no larger than [maxSize maxSize] without altering its
%   aspect ratio.
%
% imgIn: an image array of any size
% maxSize: a scalar, max(size(image)) < maxSize
%
% imgOut: an image array no larger than [maxSize maxSize], but preserving the
%   aspect ratio of the original image
    imgOut = double(imresize(imgIn, maxSize/max(size(imgIn)))); %REMEMBER TO ADD BACK MIN!!!!!
end
