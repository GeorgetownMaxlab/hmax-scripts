function [] = plotFI(c2_faces,c2_dist, patchSize)

fi = fisher(c2_faces',c2_dist');

nbins = 50;
hist(fi,nbins);
xlabel('FI values');
ylabel('number of Patches');
axis([0,2,0,100]);
set(gca,'XTick',[0:0.2:2])
xlabels =[0:0.2:2];
set(gca,'XTickLabel',xlabels);
title(['FI from HMAX-MATLAB C2s for ' patchSize 'x' patchSize ' size patches'])
   
end
