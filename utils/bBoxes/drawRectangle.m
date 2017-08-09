function img2 = drawRectangle(img, x1, x2, y1, y2, t)
% drawRectangle(m,x,y,w,h,t)
%
% draw a rectangle in an image
%
% m1: double array, the image
% x1: scalar, the left boundary of the box to bound
% x2: scalar, the right boundary of the box to bound
% y1: scalar, the bottom boundary of the box to bound
% y2: scalar, the top boundary of the box to bound
% t: scalar, the thickness of the rectangle in pixels
%
% m2: double array, the image with the rectangle
    if (nargin < 6) t = 2; end;
   
	 if(y2 < y1) 
	 	temp = y1;
		y1 = y2;
		y2 = temp;
	end
	if(x2 < x1)
		temp = x1;
		x1 = x2;
		x2 = temp;
	end

	img2 = uint8(img);

	img2(x1:x2, (y1 - t + 1):y1, 1:3) = 0;
	img2(x1:x2, y2:(y2 + t - 1), 1:3) = 0;
	img2((x1 - t + 1):x1, y1:y2, 1:3) = 0;
	img2(x2:(x2 + t - 1), y1:y2, 1:3) = 0;

end
