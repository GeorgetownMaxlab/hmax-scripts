function [out1, out2] = sort2(arg1, arg2, dim, order)
%sorts 2 dependent vectors
%
%arg1: first vector you wanted sorted
%arg2: second vector that corresponds to the first whose elements are connected to the first through index
%dim: dimension which to sort the vector
%		1 for column, 2 for row
%order: 'ascend' or 'descend'
%
%out1: sorted arg1
%out2: arg2 arranged to match out1

[out1, i] = sort(arg1, dim, order);
for n = 1:length(arg1)
	out2(n) = arg2(i(n));
end

end
