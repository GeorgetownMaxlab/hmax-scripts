function plotHist(matrix, bins, saveName, ext)

if(nargin < 4)
	ext = 'png';
end

color = ['r' 'g' 'b' 'c' 'm' 'k'];
hist(matrix, bins);
h = findobj(gca, 'Type', 'patch');
display(h);
for iBar = 1:length(h)
	set(h(iBar), 'FaceColor', color(iBar), 'EdgeColor', 'k');
end
legend(h, 'non-resized patches', 'resized patches');
saveas(gca, saveName, ext);
end
