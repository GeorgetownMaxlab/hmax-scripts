function [m, gaussOutput] = testGaussian()

	m = randi(10, 10, 10);
	for row = 1:size(m, 1) - 1
		for col = 1:size(m, 2) - 1
			gaussOutput(row, col) = (m(row, col) + m(row, col + 1) + m(row + 1, col) + m(row + 1, col + 1)) / 4;
		end
	end

end
