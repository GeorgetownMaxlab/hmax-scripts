function plotEuclidean(x, dist)

colors = {'b', 'g', 'r', 'c', 'm', '-', 'd', 'x'}; 
for iDist = 1:length(dist)
	if(iDist > 5)
		plot(x{iDist}, dist{iDist}, ['k' colors{iDist}]);
	else
		plot(x{iDist}, dist{iDist}, colors{iDist});
	end
	hold on;
end

hleg1 = legend('AnA Image1: 256 x 256', 'AnA Image2: 256 x 256', 'ImageNet Face1: 200 x 303', 'ImageNet Face2: 500 x 331',...
					'ImageNet Face3: 150 x 225', 'ImageNet Face4: 102 x 145', 'ImageNet Face5: 400 x 500', 'ImageNet Face6: 175 x 250');
xlabel('Scaled pixel size','fontWeight','bold');
ylabel('Euclidean Distance (resized vs original image)','fontWeight','bold');

h = figure(1);
saveas(h,'euclideanBySize');
% saveas(h,['euclideanBySize','.png']);
end
