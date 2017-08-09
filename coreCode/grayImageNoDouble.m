function imgOut = grayImageNoDouble(imgIn)
% imgOut = grayImage(imgIn)
%
% convert an image array to grayscale
%
% imgIn:  an array representing an image
%
% imgOut: an array representing a grayscaled image
    if size(imgIn,3) == 3
        imgOut = rgb2gray(imgIn);
    else
        imgOut = imgIn;
    end
end

