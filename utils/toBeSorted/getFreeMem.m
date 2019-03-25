function freeMem = getFreeMem()
%Outputs the amount of free memory in Gb

	[~, memInfo] = system('free | grep Mem');
	parseMemInfo = str2double(regexp(memInfo, '[0-9]*', 'match'));
	freeMem = (parseMemInfo(3) + parseMemInfo(end)) / 1e6;

end
