function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    w = cellWidth; % set cell dimensions
    h = cellHeight;   
    
    N = size(vPoints,1); % N points
    
    descriptors = zeros(N, nBins*4*4); % one histogram for each of the 16 cells
    patches = zeros(N, 4*w*4*h); % image patches stored in rows, 16 x 16 
    
    [grad_x,grad_y] = gradient(img); % gradients along x and y axis
    ang = atan2(grad_y, grad_x); % angles for 8 bins
    mag = sqrt(grad_x.^2 + grad_y.^2); % magnitude for bins
    
    for i = [1:size(vPoints,1)] % for all local feature points
        x = vPoints(i,1);
        y = vPoints(i,2);
        % scan through a 4x4 cell starting from left top point
        hist = zeros(16, nBins);
        cnt = 1;
        for j = x-2*h : h : x+h
            for k =  y-2*w : w : y+w
                % region of 4x4 cell
                row = j : (j + h);
                col = k : (k + w);
                % get calculated angles and magnitudes before
                angles = ang(row, col);
                mags = mag(row, col);
                % [0,2*pi), then quantization to bins
                val = rem(rem(angles, 2*pi) + 2*pi, 2*pi); 
                angle_bins = 1 + floor(val / (2 * pi / nBins));
                % change angle bins to temp histogram
                r = size(angle_bins,1);
                c = size(angle_bins,2);
                for m = 1 : r
                   for n = 1 : c
                       % add counts to the histogram
                       hist(cnt, angle_bins(m, n)) = hist(cnt, angle_bins(m, n)) + mags(m, n);
                   end
                end
                cnt = cnt + 1;
            end
        end
        % append histogram to descriptor
        descriptors(i,:) = hist(:);
        patch = img(x-2*h:x+2*h-1, y-2*w:y+2*w-1);
        patches(i,:) = patch(:);
    end % for all local feature points
    
end
