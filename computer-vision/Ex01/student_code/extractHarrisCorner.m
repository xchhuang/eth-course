% extract harris corner
%
% Input:
%   img           - n x m gray scale image
%   thresh        - scalar value to threshold corner strength
%   
% Output:
%   corners       - 2 x k matrix storing the keypoint coordinates
%   H             - n x m gray scale image storing the corner strength
function [corners, H] = extractHarrisCorner(img, thresh)
    [m, n] = size(img);
    
    % Blur the Image with Gaussian kernal
    filter = fspecial('gaussian', [3, 3], 0.5);
    % disp(filter);
    img = imfilter(img, filter);
    
    H = zeros(m+2, n+2); % H matrix
    corners = []; % corner candidates
    
    % gradient matrix
    Ix = zeros(m+2, n+2);
    Iy = zeros(m+2, n+2);
    
    % zero padding
    img_padded = zeros(m+2, n+2);
    img_padded(2:m+1,2:n+1) = img;

    % calculate the Intensity Gradients
    for x = 2 : m+1
       for y = 2 : n+1
           % calc the x,y-direction gradients
           Ix(x,y) = (img_padded(x+1,y) - img_padded(x-1,y)) / 2;
           Iy(x,y) = (img_padded(x,y+1) - img_padded(x,y-1)) / 2;
          % printf('%i\n', img_padded(i,j)) 
       end
    end
    
    % calculate the Harris Response Matrix
    for x = 2 : m+1
       for y = 2 : n+1
           h = 0;
           for xx = -1 : 1
               for yy = -1 : 1
                   % sum over the H matrix in 3x3 neighborhood
                   h = h + [Ix(x+xx, y+yy)^2, Ix(x+xx, y+yy)*Iy(x+xx, y+yy); Ix(x+xx, y+yy)*Iy(x+xx, y+yy), Iy(x+xx, y+yy)^2];
                   
               end
           end
           H(x,y) = det(h) / trace(h); % calc the harris response
%            k = 0.01;
%            H(x,y) = det(h) - k * trace(h);
       end
       
    end
    
    hist(H); % histogram of harris matrix
    
    % threshold setting and non-maximum suppression
    for x = 2 : m+1
       for y = 2 : n+1
           temp = H(x-1:x+1,y-1:y+1); % 3x3 neighborhood matrix
           % whether it's the local extremum point in a 3x3 neighborhood
           % if do not use non-maximum suppression, delete the last logic judgement in the if condition
           
           if H(x,y) > thresh && (H(x,y) == max(max(temp))) == 1 
               corners = cat(2, corners, [x-1;y-1]); % append this point to the corners
           end
       end
    end
%     size(corners)
end