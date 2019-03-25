function overlaps = computeOverlap(boxes1, boxes2, mode)
% overlaps = computeOverlap(boxes1, boxes2, mode)
%
% Author: saurabh.me@gmail.com (Saurabh Singh).
% Revised: rsj28@georgetown.edu (Josh Rule).
%
% Computes the overlap between two sets of boxes
%
% A box entry encodes two corners. Of the 4 possible corners, corner 1 is
% closest to the origin and corner 2 is furthest from the origin. The entry is
% then [x1 y1 x2 y2].
%
% Helper functions in this file aren't commented, as they take no additional
% arguments, and their calculations are described in 'mode' below.
%
% boxes1: [nBoxes1 4] array, the first set of boxes
% boxes2: [nBoxes2 4] array, the second set of boxes
% mode: Three possible modes
%   pascal: intersection / union
%   pedro : intersection / first box area
%   wrtmin: intersection / min of two areas
%
% overlaps: [nBoxes1 nBoxes2] array, the spatial overlap of the two sets of
%   boxes with each other such that overlaps(i,j) is the overlap of boxes1(i)
%   with boxes2(j).
  switch mode
    case 'pascal'
      overlaps = computePascalOverlap(boxes1, boxes2);
    case 'pedro'
      overlaps = computePedroOverlap(boxes1, boxes2);
    case 'wrtmin'
      overlaps = computeWrtMinOverlap(boxes1, boxes2);
    otherwise
      error('Unrecognized mode');
  end
end

function overlaps = computePascalOverlap(boxes1, boxes2)
  overlaps = zeros(size(boxes1, 1), size(boxes2, 1));
  if isempty(boxes1)
    overlaps = [];
  else
    x11 = boxes1(:,1);
    y11 = boxes1(:,2);
    x12 = boxes1(:,3);
    y12 = boxes1(:,4);
    areab1 = (x12-x11+1) .* (y12-y11+1);
    x21 = boxes2(:,1);
    y21 = boxes2(:,2);
    x22 = boxes2(:,3);
    y22 = boxes2(:,4);
    areab2 = (x22-x21+1) .* (y22-y21+1);
  
    for i = 1 : size(boxes1, 1)
      for j = 1 : size(boxes2, 1)
        xx1 = max(x11(i), x21(j));
        yy1 = max(y11(i), y21(j));
        xx2 = min(x12(i), x22(j));
        yy2 = min(y12(i), y22(j));
        w = xx2-xx1+1;
        h = yy2-yy1+1;
        if w > 0 && h > 0
          overlaps(i, j) = w * h / (areab1(i) + areab2(j) - w * h);
        end
      end
    end  
  end
end

function overlaps = computePedroOverlap(boxes1, boxes2)
  overlaps = zeros(size(boxes1, 1), size(boxes2, 1));
  if isempty(boxes1)
    overlaps = [];
  else
    x1 = boxes1(:,1);
    y1 = boxes1(:,2);
    x2 = boxes1(:,3);
    y2 = boxes1(:,4);
    area = (x2-x1+1) .* (y2-y1+1);
  
    for i = 1 : size(boxes1, 1)
      for j = 1 : size(boxes2, 1)
        x21 = boxes2(j,1);
        y21 = boxes2(j,2);
        x22 = boxes2(j,3);
        y22 = boxes2(j,4);
        
        xx1 = max(x1(i), x21);
        yy1 = max(y1(i), y21);
        xx2 = min(x2(i), x22);
        yy2 = min(y2(i), y22);
        w = xx2-xx1+1;
        h = yy2-yy1+1;
        if w > 0 && h > 0
          overlaps(i, j) = w * h / area(i);
        end
      end
    end  
  end
end

function overlaps = computeWrtMinOverlap(boxes1, boxes2)
  overlaps = zeros(size(boxes1, 1), size(boxes2, 1));
  if isempty(boxes1)
    overlaps = [];
  else
    x11 = boxes1(:,1);
    y11 = boxes1(:,2);
    x12 = boxes1(:,3);
    y12 = boxes1(:,4);
    areab1 = (x12-x11+1) .* (y12-y11+1);
    x21 = boxes2(:,1);
    y21 = boxes2(:,2);
    x22 = boxes2(:,3);
    y22 = boxes2(:,4);
    areab2 = (x22-x21+1) .* (y22-y21+1);
  
    for i = 1 : size(boxes1, 1)
      for j = 1 : size(boxes2, 1)
        xx1 = max(x11(i), x21(j));
        yy1 = max(y11(i), y21(j));
        xx2 = min(x12(i), x22(j));
        yy2 = min(y12(i), y22(j));
        w = xx2-xx1+1;
        h = yy2-yy1+1;
        if w > 0 && h > 0
          overlaps(i, j) = w * h / min(areab1(i), areab2(j));
        end
      end
    end  
  end
end
