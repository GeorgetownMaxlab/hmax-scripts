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
% a1 = min(xAxisR(2),xAxisR(3));
% a2 = max(xAxisR(1),xAxisR(4));
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
% b1 = min(yAxisR(2),yAxisR(3));
% b2 = max(yAxisR(1),yAxisR(4));

a1 = 232;
a2 = 333;
b1 = 232;
b2 = 333;

%% Create masks for both edges
r1Mask = zeros(imgSize);
r2Mask = zeros(imgSize);

for i = 1:imgSize(2)
  for j = 1:imgSize(1)
     
    r = sqrt((i - imgCenter(2))^2 + (j - imgCenter(1))^2);
    theta = atan((j - imgCenter(1))/(i - imgCenter(2)));   
    
    rEllipse1 = a1 * b1 / sqrt((b1 * cos(theta))^2 + (a1 * sin(theta))^2);
    rEllInner1 = (a1 - d) * (b1 - d)/ sqrt(((b1 - d) * cos(theta))^2 + ((a1 - d) * sin(theta))^2);
    rEllOuter1 = (a1 + d) * (b1 + d)/ sqrt(((b1 + d) * cos(theta))^2 + ((a1 + d) * sin(theta))^2);
    
    rEllipse2 = a2 * b2 / sqrt((b2 * cos(theta))^2 + (a2 * sin(theta))^2);
    rEllInner2 = (a2 - d) * (b2 - d)/ sqrt(((b2 - d) * cos(theta))^2 + ((a2 - d) * sin(theta))^2);
    rEllOuter2 = (a2 + d) * (b2 + d)/ sqrt(((b2 + d) * cos(theta))^2 + ((a2 + d) * sin(theta))^2);    
    
    if r > rEllInner1 && r <= rEllipse1
      r1Mask(j,i) = (1/d)*(r-rEllInner1);
    elseif r > rEllipse1 && r <= rEllOuter1
      r1Mask(j,i) = (1/d)*(rEllOuter1-r);
    elseif r > rEllInner2 && r <= rEllipse2
      r2Mask(j,i) = (1/d)*(r-rEllInner2);
    elseif r > rEllipse2 && r <= rEllOuter2
      r2Mask(j,i) = (1/d)*(rEllOuter2-r);
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
% imshow(uint8(imgOut));
end