function euclideanBySize(c2t, c2d)

EUC = {}; 

%:::::::Calculate Euclidean Distances for Face Images::::::::
for i = 1:size(c2t,2)
    origInd = ceil(size(c2t{i}, 2) / 2); %Find original size C2s. 
    c2t{i} = [c2t{i}(:,origInd) c2t{i}]; %Put the original size C2 column at the beginning of the matrix, because pdist starts by comparing the first 
    EUC{i} = pdist(c2t{i}'); %Note the transpose. This is because pdist compares rows to rows, not columns.
    EUC{i} = EUC{i}(1:(size(c2t{i},2)-1)); %Retain only first part of the vector, since pdist compares all rows to all rows, but we only need the comparison of the first row with the rest.
end
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

%::::::::::::Calculate the Euclidean Distance for AnA Image::::::
%origInd = size(c2AnA, 2);
%c2AnA = [c2AnA(:,origInd) c2AnA];
%EUC{5} = pdist(c2AnA');
%EUC{5} = EUC{5}(1:(size(c2AnA,2)-1));
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
save('euclideanBySize','EUC');
end
