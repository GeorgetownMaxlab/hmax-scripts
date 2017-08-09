function trainingSet = getBBoxTrainingSet(bboxLoc, minMargin, maxWidth)

xmlList = lsDir(bboxLoc, {'xml'});
[~, currentDirectory] = system('pwd');
trainingSet.imgList = {};
trainingSet.bboxCoordinates = {};
trainingSet.minMargin = [];
trainingSet.sizes = {};
trainingSet.faceWidth = [];
count = 1;

addpath(['/home/bentrans/Documents/HMAX/feature-learning/utils/VOCcode/']);
for iXML = 1:length(xmlList)
	xml = VOCreadxml(xmlList{iXML});
	xmin = str2num(xml.annotation.object.bndbox.xmin);
	xmax = str2num(xml.annotation.object.bndbox.xmax);
	ymin = str2num(xml.annotation.object.bndbox.ymin);
	ymax = str2num(xml.annotation.object.bndbox.ymax);
	width = str2num(xml.annotation.size.width);
	height = str2num(xml.annotation.size.height);
	minXMLMargin = min([xmin, ymin, width - xmax, height - ymax]);
	widthFace = xmax - xmin;
	if(minXMLMargin > minMargin && widthFace < maxWidth)
		trainingSet.imgList{count} = xml.annotation.filename;
		trainingSet.bboxCoordinates{count} = [xmin, ymin, xmax, ymax];
		trainingSet.minMargin(count) = minXMLMargin;
		trainingSet.sizes{count} = [width, height];
		trainingSet.faceWidth(count) = widthFace;
		count = count + 1;
	end
end
rmpath(['/home/bentrans/Documents/HMAX/feature-learning/utils/VOCcode/']);

end
