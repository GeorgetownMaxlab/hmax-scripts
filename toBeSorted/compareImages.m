function compareImages(imgPath, savePath, quadType)
%folderName - a string, name of the folder where the images are.
%savePath   - location where you want to save stuff.
%quadType   - a string, 'faces' 'empty' 'scrambled' 'houses' 'inverted' or 'configural'. 
%The quadType variable is simply used to save the filtered file list under the appropriate name.

if(nargin < 1)
	imgPath = '/home/bentrans/Documents/Psychophysics/naturalFaceImages/quadImages/';
	savePath = imgPath;
	quadType = 'naturalFaces';
end
%pathToFolders = ['C:\Users\Levan\HMAX\psychoImages\' folderName '\']; %'C:\Users\Levan\HMAX\sandbox\'; %
%savePath      = 'C:\Users\Levan\HMAX\compareImages\';

%Get all the files of particular extension from the folder. 
fileNames = lsDir(imgPath,{'BMP'});
%     save ([savePath 'fileNames' quadType '.mat'], 'fileNames');
    
 %Separate different quadrant images so that finding unique images takes
 %less time. This avoids comparing different quadrant images to each
 %other.
    o = 1; tw = 1; th = 1; f = 1;
    for j = 1:length(fileNames)
        if size(strfind(fileNames{j},'quad1'),1) ~= 0
%		  		fprintf('if 1');
            quadNames{1,1}{1,o} = fileNames{j};
            o = o + 1;
        elseif size(strfind(fileNames{j},'quad2'),1) ~= 0
%		  		fprintf('if 2');
            quadNames{2,1}{1,tw} = fileNames{j};
            tw = tw + 1;
        elseif size(strfind(fileNames{j},'quad3'),1) ~= 0
%		  		fprintf('if 3');
            quadNames{3,1}{1,th} = fileNames{j};
            th = th + 1;
        elseif size(strfind(fileNames{j},'quad4'),1) ~= 0
%		  		fprintf('if 4');
            quadNames{4,1}{1,f} = fileNames{j};
            f = f + 1;
        end
    end
    
%   save([savePath 'justNames' quadType '.mat'],'fileNames','quadNames');
%   load([savePath 'justNames.mat']); 

%For the set of images for each quadrant, compare each image to the rest.
for q = 1:4
    for i = 1:length(quadNames{q,1})
        i %Display i to see progress. 
        IMG{1,i} = imread(quadNames{q,1}{1,i}); %Read out images as matrices.
        VECT(1:length(IMG{1,i}(:)),i) = IMG{1,i}(:); %Transform matrices into
        %vectors so to use the "unique" operation.
        %figure out how to make this compatible with parfor...
    end
    [~,ia{q,1},ic{q,1}] = unique(VECT','rows','stable'); %Find unique vectors.
    %see "doc unique" to understand what "ia" and "ic" stand for. 
    clear VECT IMG
    filteredQuadNames{q,:} = quadNames{q,1}(1,ia{q,1}'); %Gives paths to the files
    %that are unique. We should run only these files through HMAX.
end
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

save([savePath 'filteredNames' quadType '.mat'],'filteredQuadNames',...
    'fileNames','ia','ic','quadNames');

end
