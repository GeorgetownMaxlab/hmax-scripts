function facesLoc = convertFacesLocBlurring(facesLoc,d)

newLocation = ['images_blurEdges_' int2str(2*d) 'px'];

for i = 1:length(facesLoc{1})
    
     facesLoc{1}{i} = strrep(facesLoc{1}{i},'\images\',...
         ['\' newLocation '\']);
    
end

save(['facesLocTesting_blurEdges_' int2str(2*d) 'pxWin.mat'],'facesLoc');
end