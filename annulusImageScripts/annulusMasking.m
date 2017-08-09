% masking annulus images with black mask

clear; clc; close;

%% generate the mask
img = double(imread('C:\Users\levan\Desktop\msk.bmp'));

mask = ones(size(img(:,:,1)));
count = 0;
for iRow = 1:size(img,1)
    for iCol = 1:size(img,2)
        row = [img(iRow,iCol,1),img(iRow,iCol,2),img(iRow,iCol,3)];
        if isequal(row,[0,0,0]) == 1;
            count = count + 1;
            mask(iRow,iCol) = 0;
        end
    end
end
% imshow(uint8(mask))
%% Now mask the images
realImg = double(imread('C:\Users\levan\HMAX\annulusExpt\images2\s2_session1_image1.jpeg'));
newImg = realImg .* mask;
saveimage(newImg,'masked1','jpg');
% imwrite(uint8(newImg),'C:\Users\levan\Desktop\masked.jpg');