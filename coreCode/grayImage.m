function imgOut = grayImage(imgIn)
% imgOut = grayImage(imgIn)
%
% convert an image array to grayscale
%
% imgIn:  an array representing an image
%
% imgOut: an array representing a grayscaled image
    if size(imgIn,3) == 3
        imgOut = double(rgb2gray(imgIn));
    else
        imgOut = double(imgIn);
    end
end

