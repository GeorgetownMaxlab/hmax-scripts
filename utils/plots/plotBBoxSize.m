function [width, height] = plotBBoxSize(annotation)

for i = 1:length(annotation)
	width(i) = annotation{i}.x2 - annotation{i}.x1;
	height(i) = annotation{i}.y2 - annotation{i}.y1;
end

end
