function quadImages(dir)
%short script to quad the background images. To quad everything, use cropQuadrants.m
if(nargin < 1) dir = '/home/bentrans/Documents/Psychophysics/backgroundImages/'; end;

imgs = lsDir(dir, {'jpeg'});
system('mkdir /home/bentrans/Documents/Psychophysics/UniqueEmpty/');
for iImg = 1:length(imgs)
	img = imread(imgs{iImg});
	[height, width] = size(img);
	width = width / 2;
	height = height / 2;
	quad1 = imcrop(img, [0, 0, width, height]);
	quad2 = imcrop(img, [width, 0, width, height]);
	quad3 = imcrop(img, [0, height, width, height]);
	quad4 = imcrop(img, [width, height, width, height]);
	imwrite(quad1, ['/home/bentrans/Documents/Psychophysics/UniqueEmpty/background' int2str(iImg) 'quad1.bmp'], 'BMP');
	imwrite(quad2, ['/home/bentrans/Documents/Psychophysics/UniqueEmpty/background' int2str(iImg) 'quad2.bmp'], 'BMP');
	imwrite(quad3, ['/home/bentrans/Documents/Psychophysics/UniqueEmpty/background' int2str(iImg) 'quad3.bmp'], 'BMP');
	imwrite(quad4, ['/home/bentrans/Documents/Psychophysics/UniqueEmpty/background' int2str(iImg) 'quad4.bmp'], 'BMP');
end

end
