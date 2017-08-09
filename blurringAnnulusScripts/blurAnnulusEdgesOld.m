function imgOut = blurAnnulusEdges(imgIn,d)
% blurAnnulusImg(imgIn,d)
% 
% filter to smooth the edges of the two concentric ellipses of the annulus images
% 
% imgIn = grayscale input annulus image
% d = half-width of edge mask 

imgSize = size(imgIn);
imgCenter = ceil(imgSize/2);

%% Edge Detection: Not very reliable so commented out and hard-coded
% baseColor = imgIn(1,1);
% xAxisEdges = zeros(1,4);
% yAxisEdges = zeros(1,4);
% 
% % Scan across x-axis and find four points where inAnnulusImg ~= baseColor
% for iPxl = 2:imgSize(2)
%   if xAxisEdges(1) == 0 && imgIn(imgCenter(1),iPxl) ~= baseColor;
%     xAxisEdges(1) = iPxl;
%   elseif xAxisEdges(1) ~= 0 && xAxisEdges(2) == 0 && imgIn(imgCenter(1),iPxl) == baseColor;
%     xAxisEdges(2) = iPxl;
%   elseif all(xAxisEdges(1:2) ~= 0) && xAxisEdges(3) == 0 && imgIn(imgCenter(1),iPxl) ~= baseColor;
%     xAxisEdges(3) = iPxl;    
%   elseif all(xAxisEdges(1:3) ~= 0) && xAxisEdges(4) == 0 && imgIn(imgCenter(1),iPxl) == baseColor;
%     xAxisEdges(4) = iPxl;   
%   end
% end
% 
% xAxisR = abs(imgCenter(2)-xAxisEdges);
% xAxisR1 = min(xAxisR(2),xAxisR(3));
% xAxisR2 = max(xAxisR(1),xAxisR(4));
% 
% % Scan across y-axis and find four points where inAnnulusImg ~= baseColor
% for iPxl = 2:imgSize(1)
%   if yAxisEdges(1) == 0 && imgIn(iPxl,imgCenter(2)) ~= baseColor;
%     yAxisEdges(1) = iPxl;
%   elseif yAxisEdges(1) ~= 0 && yAxisEdges(2) == 0 && imgIn(iPxl,imgCenter(2)) == baseColor;
%     yAxisEdges(2) = iPxl;
%   elseif all(yAxisEdges(1:2) ~= 0) && yAxisEdges(3) == 0 && imgIn(iPxl,imgCenter(2)) ~= baseColor;
%     yAxisEdges(3) = iPxl;    
%   elseif all(yAxisEdges(1:3) ~= 0) && yAxisEdges(4) == 0 && imgIn(iPxl,imgCenter(2)) == baseColor;
%     yAxisEdges(4) = iPxl;   
%   end
% end
% 
% yAxisR = abs(imgCenter(1)-yAxisEdges);
% yAxisR1 = min(yAxisR(2),yAxisR(3));
% yAxisR2 = max(yAxisR(1),yAxisR(4));

xAxisR1 = 221;
xAxisR2 = 317;
yAxisR1 = 232;
yAxisR2 = 333;

%% Create masks for each edge
r1Mask = zeros(imgSize);
r2Mask = zeros(imgSize);

for i = 1:imgSize(2)
  for j = 1:imgSize(1)
    a = xAxisR1;
    b = yAxisR1;

    r = sqrt((i - imgCenter(2))^2 + (j - imgCenter(1))^2);
    theta = atan((j - imgCenter(1))/(i - imgCenter(2)));
    
    rEllipse = a * b / sqrt((b * cos(theta))^2 + (a * sin(theta))^2);
    rEllInner = (a - d) * (b - d)/ sqrt(((b - d) * cos(theta))^2 + ((a - d) * sin(theta))^2);
    rEllOuter = (a + d) * (b + d)/ sqrt(((b + d) * cos(theta))^2 + ((a + d) * sin(theta))^2);
    
    if r > rEllInner && r <= rEllipse
      r1Mask(j,i) = (1/d)*(r-rEllInner);
    elseif r > rEllipse && r <= rEllOuter
      r1Mask(j,i) = (1/d)*(rEllOuter-r);
    end
  end
end

for i = 1:imgSize(2)
  for j = 1:imgSize(1)
    a = xAxisR2;
    b = yAxisR2;
    
    r = sqrt((i - imgCenter(2))^2 + (j - imgCenter(1))^2);
    theta = atan((j - imgCenter(1))/(i - imgCenter(2)));
    
    rEllipse = a * b / sqrt((b * cos(theta))^2 + (a * sin(theta))^2);
    rEllInner = (a - d) * (b - d)/ sqrt(((b - d) * cos(theta))^2 + ((a - d) * sin(theta))^2);
    rEllOuter = (a + d) * (b + d)/ sqrt(((b + d) * cos(theta))^2 + ((a + d) * sin(theta))^2);
    
    if r > rEllInner && r <= rEllipse
      r2Mask(j,i) = (1/d)*(r-rEllInner);
    elseif r > rEllipse && r <= rEllOuter
      r2Mask(j,i) = (1/d)*(rEllOuter-r);
    end
  end
end

edgeMask = r1Mask + r2Mask;
inverseMask = 1 - edgeMask;

%% Apply convolution and recombine
imgEdge = edgeMask .* double(imgIn);
imgInverse = inverseMask .* double(imgIn);

convMatrix = ones(2*d+1);
convMatrix = convMatrix/sum(sum(convMatrix));

imgConv = conv2(double(imgIn), convMatrix, 'same');
imgConv = imgConv .* edgeMask;
imgOut = imgInverse + imgConv;

end