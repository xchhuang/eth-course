function [K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT
[Pn] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error
pn = [Pn(1,:) Pn(2,:) Pn(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized, i/5);
end

%denormalize camera matrix
pn = reshape(pn, [4,3]);
pn = pn'; 
P_denormalized = T \ (pn * U);

% factorize camera matrix in to K, R and t

[ K, R, t ] = decompose(P_denormalized);

% compute reprojection error
% [m,n] = size(XYZ);
% XYZn = [XYZ;ones(1,n)]; % append ones to homogeneous
[m,n] = size(XYZ);
XYZn = [XYZ;ones(1,n)]; % append ones to homogeneous
xy_new = P_denormalized * XYZn; % reprojection
xy_new = xy_new ./ xy_new(3,:); % ensure w to be 1

% compare the xy and reproject of xy
% xy
% xy_new

% error of reprojection
error = sum((xy(1,:)-xy_new(1,:)).^2 + (xy(2,:)-xy_new(2,:)).^2)

% visualization
img = imread('images/image001.jpg');
visualize_points(P_denormalized, xy, img, 2);

end