function [facesLoc] = convertFacesLoc(facesLoc)
%Function created to convert the file paths from linux to windows so the
%facesLoc file can run on Levan's PC laptop. 

for q = 1:4
    for img = 1:size(facesLoc{q},2)
    facesLocWin{q,1}{img} = ['C:\Users\Levan\HMAX\naturalFaceImages\quadImages\' ...
        facesLoc{q,1}{img}(69:end)];
    end
end

facesLoc = facesLocWin;
end