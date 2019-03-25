%function [patch1, patch2] = helper(patchNumber)
%
%	count = 0;
%	for a = 1:99
%		for b = a + 1:100
%				count = count + 1;
%				if(count == patchNumber)
%					patch1 = a;
%					patch2 = b;
%					a = 99;
%				end
%		end	
%	end
%end

function hits = helper(hits)

	for i = 1:10000
		hits{5}(i) = hits{1}(i) + hits{2}(i) + hits{3}(i) + hits{4}(i);
	end

end

%function count = helper(imgHits)
%
%count = 0;
%%
%for a = 1:length(imgHits{1})
%	count = sum(imgHits{1}{a}) + count;
%end
%
%end
