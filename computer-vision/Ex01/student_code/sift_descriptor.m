% My simple implementation of sift descriptor ignoring scale and rotation
% invariances
%
% Input:
%   keyPoints     - detected keypoints in a 2 x n matrix holding the key
%                   point coordinates
%   img           - the gray scale image
%   
% Output:
%   descr         - w x n matrix, stores for each keypoint a
%                   descriptor. m is the size of the image patch,
%                   represented as vector (number of points x 128d vector)
function descr = sift_descriptor(corners, img)  
%     size(corners)
    [m,n] = size(img);
    [p,k] = size(corners);
%     patch_size = 16; % following the size of SIFT
%     padding = 8;

    % zero padding
    img_padded = zeros(m+16, n+16);
    img_padded(9:m+8, 9:n+8) = img;
    
    gradient_mag_orien = zeros(m+16, n+16, 2);
    
    for x = 9 : m+8
       for y = 9 : m+8
           % calc the x,y-direction gradients
           Ix = (img_padded(x+1,y) - img_padded(x-1,y)) / 2;
           Iy = (img_padded(x,y+1) - img_padded(x,y-1)) / 2;
           % calc the magnitute and orientation for gradients for getting
           % the histogram next
           mag = sqrt(Ix^2 + Iy^2);
           orien = atan2(Ix, Iy);
           gradient_mag_orien(x,y,1) = mag;
           gradient_mag_orien(x,y,2) = orien;
           
       end
    end
    
    % descriptors matrix
    descr = zeros(k, 128);

    for i = 1 : k
        px = corners(1,i);
        py = corners(2,i);
        index = 1; % index of region 4x4
        % histogram of gradients as SIFT descriptor
        hist = zeros(16,8);
        % scan through region 16x16
        for x = px : 4 : px+12
           for y = py : 4 : py+12
               % scan through region 4x4
               for xx = x : x+3
                  for yy = y : y+3
                        % calc the angle and distribute it to a bin (8 bins)
                        bin = 1 + round(8*(gradient_mag_orien(xx, yy, 2) + pi) / (2*pi));
                        if(bin == 8 +1)
                            bin = 1;
                        end
                        % calc the intensity of that bin
                        hist(index, bin) = hist(index, bin) + gradient_mag_orien(xx, yy, 1);
                  end
               end
               index = index + 1;
           end
        end
        hist = hist(:);
        size(hist);
        hist = hist / sum(hist); % normalization
        descr(i,:) = hist';
    end
end