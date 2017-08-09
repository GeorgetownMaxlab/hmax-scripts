function errorBars(singleHits, combinationHits, total)

addpath('/home/bentrans/Documents/HMAX/feature-learning/utils/');
[singleHits, singleIndex] = sort2(singleHits, 1:length(singleHits), 2, 'descend');
%[combinationHits, combinationIndex] = sort2(combinationHits, 1:length(combinationHits), 2, 'descend');
singleHits = singleHits(1:100)./total;
combinationHits = combinationHits./total;
totalCombSingHits = cell(1, length(singleHits));
combSingLen = ones(1, length(singleHits));

count = 0;
for patch1 = 1:length(singleHits) - 1
	for patch2 = patch1 + 1:length(singleHits)
		count = count + 1;
		totalCombSingHits{patch1}(combSingLen(patch1)) = combinationHits(count);
		totalCombSingHits{patch2}(combSingLen(patch2)) = combinationHits(count);
		combSingLen(patch1) = combSingLen(patch1) + 1;
		combSingLen(patch2) = combSingLen(patch2) + 1;
	end
end
E = zeros(1, length(singleHits));

avgCombSingHits = zeros(1, length(singleHits));
for i = 1:length(avgCombSingHits)
	avgCombSingHits(i) = mean(totalCombSingHits{i});
	E(i) = std(totalCombSingHits{i});
	L(i) = avgCombSingHits(i) - min(totalCombSingHits{i});
	U(i) = max(totalCombSingHits{i}) - avgCombSingHits(i);
end
rmpath('/home/bentrans/Documents/HMAX/feature-learning/utils/');

errorbar(1:length(singleHits), avgCombSingHits, L, U, 'r')
hold on
plot(1:length(singleHits), singleHits, 'k')
errorbar(avgCombSingHits, E)

end
