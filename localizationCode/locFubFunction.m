function locFubFunction(iImg,bestBands,bestLoc,patchSize,face_loc_deg)

 parfor iPatch = 1:nPatches %fprintf('STARTING W CUSTOM PATCH!!')
            iPatch
        
        band = bestBands(iPatch, iImg);
        y1 = bestLoc(iPatch, iImg, 1);
        x1 = bestLoc(iPatch, iImg, 2);
        
        y2 = y1 + patchSize - 1;
        x2 = x1 + patchSize - 1;    
        
            % Get pixel coordinates of the C1 rep. 
            [x1p, x2p, y1p, y2p] = patchDimensionsInPixelSpace(band, x1, x2, y1, y2, c1Scale, c1Space, rfSizes, double(xSize), double(ySize));
                if(x1p > x2p) %SHOULD NOT HAPPEN! SIGNALS THAT THERE IS SOMETHING WRONG
                    fprintf(['xinversion occured for image ' int2str(iImg) ' patch ' int2str(iImg) '\n']);
                    [x1p, x2p] = swap(x1p, x2p);
%                     sanityCheck.xinversion{iPatch} = 1;
                end
                if(y1p > y2p) %SHOULD NOT HAPPEN! SIGNALS THAT THERE IS SOMETHING WRONG
                    fprintf(['yinversion occured for image ' int2str(iImg) ' patch ' int2str(iImg) '\n']);
                    [y1p, y2p] = swap(y1p, y2p);
%                     sanityCheck.yinversion{iPatch} = 1;
                end
                
                % Define the area around the face location to record a hit.
                faceBox = [position{imgFacesLoc}(2)-50 ...
                          position{imgFacesLoc}(2)+50 ...
                          position{imgFacesLoc}(1)-50 ...
                          position{imgFacesLoc}(1)+50]; %[x1 x2 y1 y2]
                          % x1 is the rightmost coordinate of the box.
                          % x2 is the leftmost coordinate of the box.
                          % y1 is the topmost.
                          % y2 is the bottommost.
                % Rescale faceBox coordinates to be relative to resized
                % image dimensions, so patch pixel coordinates can be
                % compared to it.
                faceBox = faceBox/scalingFactor;
                
                if y2p > faceBox(3) && y1p < faceBox(4) && x1p < faceBox(2) && x2p > faceBox(1) 
                   %if best match is within where the face is.
                    imgHitsFaceBoxiImg(iPatch) = 1;
%                     fprintf('FACE BOX HIT!!!!\n')
                end

                
% Get the center of the face.
ctrCol = x1p + (x2p-x1p)/2;
ctrRow = y1p + (y2p-y1p)/2;
% Due to image resizing, adjust the ctrCol and ctrRow to be relative to the
% dimensions of the images presented to subjects.
ctrCol = ctrCol * scalingFactor;
ctrRow = ctrRow * scalingFactor;
    % Trasform the center coordinates into cartesian ones
    ctrCartX = ctrCol - xSizeOrig/2; % X coordinate
    ctrCartY = ySizeOrig/2 - ctrRow; % Y coordinate                        
        [c2_loc_rad, RHO] = cart2pol(ctrCartX,ctrCartY);
        c2_loc_deg = radtodeg(c2_loc_rad);
        if c2_loc_deg < 0
            c2_loc_deg = 360 + c2_loc_deg;
        end
                        
%             sanityCheck.c2_loc_deg(iImg) = c2_loc_deg;
%             sanityCheck.face_loc_deg(iImg) = face_loc_deg;
                
                % C2 and face polar angles might be close to 0 and close to
                % each other, in which case we get an error. Following
                % corrects that
                if ((c2_loc_deg >= (360 -  22.5) && face_loc_deg <= 22.5) || ...
                    (face_loc_deg >= (360 -  22.5) && c2_loc_deg <= 22.5))
                
                    if c2_loc_deg < face_loc_deg
                        c2_loc_deg = c2_loc_deg + 360;
                    elseif face_loc_deg < c2_loc_deg
                        face_loc_deg = face_loc_deg + 360;
                    end
                end
            
        if c2_loc_deg < face_loc_deg + 22.5 && c2_loc_deg > face_loc_deg - 22.5
            imgHitsWedgeiImg(iPatch) = 1;
%             fprintf('WEDGE HIT!!!!\n')
        end
 end % iPatch loop
end