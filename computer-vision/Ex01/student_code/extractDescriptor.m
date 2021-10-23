% extract descriptor
%
% Input:
%   keyPoints     - detected keypoints in a 2 x n matrix holding the key
%                   point coordinates
%   img           - the gray scale image
%   
% Output:
%   descr         - w x n matrix, stores for each keypoint a
%                   descriptor. m is the size of the image patch,
%                   represented as vector
function descr = extractDescriptor(corners, img)  
%     size(corners)
    [m,n] = size(img);
    [p,k] = size(corners);
%     patch_size = 9;
%     padding = 4;

    % zero padding
    img_padded = zeros(m+8, n+8);
    img_padded(5:m+4, 5:n+4) = img;
    
    % descriptors matrix
    descr = zeros(k, 81);
    
    for i = 1 : k
        x = corners(1,i);
        y = corners(2,i);
        vec = img_padded(x: x+8, y : y+8); % store a 9x9 region for feature description
        vec = vec(:);
%         size(vec)
        descr(i,:) = vec';
    end
end