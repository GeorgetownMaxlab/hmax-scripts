clear; clc;
scz=get(0,'ScreenSize');

fig=figure('Position',[round(scz(1,3)/4) round(scz(1,4)/8) 700 500],'MenuBar','None','NumberTitle','off','Name','Draw Lines','Resize','off');



[x, y] = getline(fig);
plot(x,y);
axis([0 1 0 1]);