function [sourceImages] = convertSourceImages(sourceImages)
%Function created to convert the file paths from linux to windows so the
%lfw trainingLoc file can run on Levan's PC laptop. 

%THERE IS A SIMPLER WAY TO DO THIS SO CHANGE THIS.

% clear;
% load('C:\Users\Levan\HMAX\lfwImageDatabase\trainingLoc.mat')
    for img = 1:length(sourceImages)
        sourceImagesWin{img} = ['C:\Users\Levan\HMAX\lfwImageDatabase\' ...
            sourceImages{img}(35:end)] ;
%         ind = strfind(sourceImagesWin{img},'/');
%         sourceImagesWin{img}(ind) = '\';
    end
sourceImages = sourceImagesWin;
end