function [x, dist] = euclidean(c2)
%returns the x axis and y axis of the plot for the summed euclidean distance of each patch relative 
% to the orignal sized image
%
%c2: a cell array where each cell contains the matrix of c2 values. The rows are the patches and the 
% columns are the resized images
%
%x: cell array of x axis of the plot. The number of elements is equal to the length of its corresponding 
% distances. Goes for 0.5 to 1.5 and its elements are equally spaced apart
%dist: cell array of the summed euclidean distance of each patch relative to the original sized image
tic;
for iC2 = 1:length(c2)
	values = c2{iC2};
%	dist{iC2} = zeros(1, size(values, 2));
%	original = sqrt(sum(pdist(values(:, ceil(size(values, 2) / 2))).^2)); %summed euclidean distance of original size
%	for iVal = 1:size(values, 2)
%		dist{iC2}(iVal) = sqrt(sum(pdist(values(:, iVal)).^2)) - original; %summed euclidean distance of size relative to original
%	end
	originalCol = values(:, ceil(size(values, 2) / 2));
	values = horzcat(originalCol, values);
	dist{iC2} = sqrt(sum((values-repmat(values(:,1),1,size(values,2))).^2));
	dist{iC2} = dist{iC2}(2:length(dist{iC2}));
	inc = 1 / (length(dist{iC2}) - 1); %calculates the x distribution
	temp = 0.5:inc:1.5;
	x{iC2} = temp;
end;
toc;
end
