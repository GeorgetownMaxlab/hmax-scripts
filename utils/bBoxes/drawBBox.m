function annotation = drawBBox(loc, start)
%Allows you to manually draw the bounding boxes for the pictures
%
%loc: the locations of the images you want to draw bounding boxes for
%start: starting point to start drawing bounding boxes or pick up from the last point
%		  WILL OVERRIDE ANYTHING THAT WAS DONE PREVIOUSLY AT OVERLAPPING LOCATIONS
%
%annotation: the annotations that contains the picture location, name, and coordinates
%
%system('rm -rf bBoxes');
%system('mkdir bBoxes');
load('annotation');
i = length(annotation) - 1;
if(nargin < 2) start = 1; end;
for iImg = start:length(loc)
	img = imread(loc{iImg});
	imshow(img);
	hold on
	[y, x] = ginput(2);
	y = uint8(y);
	x = uint8(x);
	annotation{iImg}.loc = loc{iImg};
	annotation{iImg}.x1 = x(1);
	annotation{iImg}.x2 = x(2);
	annotation{iImg}.y1 = y(1);
	annotation{iImg}.y2 = y(2);
	save('annotation', 'annotation');
	img2 = drawRectangle(img, x(1), x(2), y(1), y(2), 3);
	[~, name, ext] = fileparts(loc{iImg});
	imwrite(img2, [name ext], ext(2:length(ext)));
	system(['cp ' name ext ' bBoxes']);
	system(['rm ' name ext]);
end

end
