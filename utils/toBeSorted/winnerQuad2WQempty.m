% :::::::::::::::Singling our the EMPTY CONDITION RECURSIVELY::::::::::::::
%This code is just a helper function to transform winnerQuad.mat files into
%files that contain only the EMPTY condition. Otherwise the winnerQuad.mat
%loading took too long.
%It could be used for any condition though. 


% if (nargin < 1)
    quadType = 'empty';
    helperNum = 4500;
    lastPatch = 4950;
    incr = 500;
    loadPath = 'C:\Users\Levan\HMAX\BlurDoubles\';
% end

for f = 0:incr:helperNum
    fprintf('loading next winnerQuads file\n');
    if f == helperNum
        load([loadPath 'winnerQuads' int2str(f+1) '-' int2str(lastPatch) '.mat']);
        fprintf('loaded the LAST winnerQuads file');
    else
    load([loadPath 'winnerQuads' int2str(f+1) '-' int2str(f+incr) '.mat']);
    fprintf(['loaded ' int2str(f+1) '-' int2str(f+incr) '\n']);
    end   

% load([loadPath 'WQ1-500.mat']); %why is this here?

%Choose only the EMPTY condition, discard the rest:
    WQ = winnerQuads(:,:,1); 
    clear winnerQuads; 
    save([loadPath 'WQ' quadType int2str(f+1) '-' int2str(f+incr) '.mat'], 'WQ');
end

% ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::