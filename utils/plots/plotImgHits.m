function plotImgHits(imgHits, imgHits2)

i = randi(20, 1);
t = i(1);

count = 1;
for iQuad = 4
	for n = 1:t%length(imgHits{iQuad})
		for iImg = 1:t%length(imgHits{iQuad}{n})
			data(count) = imgHits{iQuad}{n}(iImg) / 50 * 100;
			count = count + 1;
		end
	end
end

count2 = 1;
for iQuad = 4
	for n = 1:t%length(imgHits2{iQuad})
		for iImg = 1:t%length(imgHits2{iQuad}{n})
			data2(count2) = imgHits2{iQuad}{n}(iImg) / 50 * 100;
			count2 = count2 + 1;
		end
	end
end

plot(1:(count - 1), data, 'b');
hold on
plot(1:(count2 - 1), data2, 'r')
end
