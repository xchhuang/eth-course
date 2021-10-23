% Normalization of 2d-pts
% Inputs: 
%           x1s = 2d points
% Outputs:
%           nxs = normalized points
%           T = normalization matrix
function [nxs, T] = normalizePoints2d(x1s)
    
xy_centroid = [mean(x1s(1,:)); mean(x1s(2,:)); 1];

% First shift the point to the origin
shifted_xy = x1s - xy_centroid;
dist = sqrt(shifted_xy(1,:).^2 + shifted_xy(2,:).^2); % element-wise square
mean_dist = mean(dist); % calc the mean of distance to the origin
s2d = sqrt(2) / mean_dist; % scale by a factor sqrt(2);

T = [s2d, 0, -s2d * xy_centroid(1)
    0, s2d, -s2d * xy_centroid(2)
    0, 0, 1];

nxs = T * x1s;

end
