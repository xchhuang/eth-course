function [xyn, XYZn, T, U] = normalization(xy, XYZ)

[~,n] = size(xy);
% data normalization
% first compute centroid

% can also use mean function
% transpose the matrix in order to fit the dimension
xy_centroid = [sum(xy(1,:))/n, sum(xy(2,:))/n]';
XYZ_centroid = [sum(XYZ(1,:))/n, sum(XYZ(2,:))/n, sum(XYZ(3,:))/n]';

% then, compute scale
% First shift the point to the origin
shifted_xy = xy - xy_centroid;
dist = sqrt(shifted_xy(1,:).^2 + shifted_xy(2,:).^2); % element-wise square
mean_dist = sum(dist)/n; % calc the mean of distance to the origin
s2d = sqrt(2)/mean_dist; % scale by a factor sqrt(2)

% the same operation for 3D space points
shifted_XYZ = XYZ - XYZ_centroid;
dist = sqrt(shifted_XYZ(1,:).^2 + shifted_XYZ(2,:).^2 + shifted_XYZ(3,:).^2);
mean_dist = sum(dist)/n;
s3d = sqrt(3)/mean_dist; % scale by a factor sqrt(3)

% create T and U transformation matrices

% --First shift and then scale, so Cx, Cy should be multiplied by scale--
T = [s2d, 0, -s2d * xy_centroid(1)
    0, s2d, -s2d * xy_centroid(2)
    0, 0, 1];

U = [s3d, 0, 0, -s3d * XYZ_centroid(1)
    0, s3d, 0, -s3d * XYZ_centroid(2)
    0, 0, s3d, -s3d * XYZ_centroid(3)
    0, 0, 0, 1];

% and normalize the points according to the transformations

% append ones for the last rows and do normalization
xyn = [xy;ones(1,n)];
xyn = T * xyn;
% validation for average distance
% mean(sqrt(xyn(1,:).^2 + xyn(2,:).^2))

XYZn = [XYZ;ones(1,n)];
XYZn = U * XYZn;
% validation for average distance
% mean(sqrt(XYZn(1,:).^2 + XYZn(2,:).^2 + XYZn(3,:).^2))

end