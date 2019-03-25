function mwut = ranksumC2(x, y, patchSize)

for i = 1:length(x)
	pValue(i) = -log10(ranksum(x(i,:),y(i,:)));
end
save('pValue', 'pValue');
%pValue = load('pValue.mat');
%pValue = pValue.pValue;

disp('plot');
bin = 2000;%logspace(min(pValue), max(pValue));
hist(pValue, bin);
xlabel('P values');
ylabel('Number of Patches');
axis([0, 100, 0, 200]);
xlabels = [0:10:100];
set(gca, 'XTick', xlabels);
title(['Run1, first 1070 shuffled faces as training, last 500 as testing - Class-specific Patches, size ' patchSize 'x' patchSize]);

end
