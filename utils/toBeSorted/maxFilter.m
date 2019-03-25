function maxval = mymaxfilter(image,poolrange)
    [numrows numcols] = size(image);
    halfpool = poolrange/2;
    therowindices = 1:halfpool:(numrows - poolrange) + poolrange;
    thecolindices = 1:halfpool:(numcols - poolrange) + poolrange;
    maxval = zeros(size(therowindices,2),size(thecolindices,2));
    xcount = 1;
    ycount = 1;
    for i=therowindices
        for j=thecolindices
            %maxval(xcount,ycount) = max(max(image(i:min(i+poolrange,numrows),j:min(j+poolrange,numcols))));
            % MJR, 11/12/13: The pooling range of line above is actually
            % poolrange+1. The line below implements the correct pooling
            % range.
            maxval(xcount,ycount) = max(max(image(i:min(i+poolrange-1,numrows), ...
                                                  j:min(j+poolrange-1,numcols))));
            ycount=ycount+1;
        end
        xcount=xcount+1;
        ycount=1;
    end
end
