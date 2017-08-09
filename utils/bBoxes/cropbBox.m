function cropbBox(annotation)
%crops the the pictures to where the bounding box is
%
%annotation: the file created by drawBBox.m

system('rm -rf /home/bentrans/Documents/lfwbBox/');
system('mkdir /home/bentrans/Documents/lfwbBox/');

for i = 1:length(annotation)
	img = imread(annotation{i}.loc);
	[~, name, ext] = fileparts(annotation{i}.loc);
	y1 = annotation{i}.x1;
	y2 = annotation{i}.x2;
	x1 = annotation{i}.y1;
	x2 = annotation{i}.y2;
	
	if(x2 < x1)
		[x1, x2] = swap(x1, x2);
	end
	if(y2 < y1)
		[y1, y2] = swap(y1, y2);
	end

	croppedImg = imcrop(img, [x1, y1, (x2 - x1), (y2 - y1)]);
	imwrite(croppedImg, [name ext], ext(2:length(ext)));
	system(['cp ' name ext ' /home/bentrans/Documents/lfwbBox/']);
	system(['rm ' name ext]);
end

end
