function facesLoc = convertFacesLocAnnulusFixedContrast(facesLoc,pcStatus)
%% replace linux file paths with windows and vice versa
% clear; clc;
% load('facesLocTraining.mat')

% This changes \ to /. Windows can read / delimiter, but linux can't read
% the \ delimiter.
for i = 1:length(facesLoc{1})
    facesLoc{1}{i} = strrep(facesLoc{1}{i},'\','/');
end

if pcStatus == 1
    if any(strfind(facesLoc{1}{1},'/home/levan/'))
        for i = 1:length(facesLoc{1})
            facesLoc{1}{i} = strrep(facesLoc{1}{i},'/home/levan/',...
            'C:/Users/levan/');
        end
    end
elseif pcStatus == 0
    if any(strfind(facesLoc{1}{1},'/Users/levan/'))
        for i = 1:length(facesLoc{1})
            facesLoc{1}{i} = strrep(facesLoc{1}{i},'C:/Users/levan/',...
            '/home/levan/');
        end
    end
end
end