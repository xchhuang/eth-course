function [K, R, t, error] = runDLT(xy, XYZ)

% normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

% compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

% denormalize camera matrix
P_denormalized = T \ (P_normalized * U); % use A\b instead of inv(A)*b

% factorize camera matrix in to K, R and t

[ K, R, t ] = decompose(P_denormalized)

% compute reprojection error
[m,n] = size(XYZ);
XYZn = [XYZ;ones(1,n)]; % append ones to homogeneous
xy_new = P_denormalized * XYZn; % reprojection
xy_new = xy_new ./ xy_new(3,:); % ensure w to be 1

% compare xy and the reprojection of xy
% xy
% xy_new

% error of reprojection
error = sum((xy(1,:)-xy_new(1,:)).^2 + (xy(2,:)-xy_new(2,:)).^2)

% visualize the 6 chosen points
% figure(4);
% img = imread('images/image001.jpg');
% imshow(img);
% hold on;
% plot_x = xy(1,:);
% plot_y = xy(2,:);
% plot(plot_x, plot_y, 'ro');

% visualization
img = imread('images/image001.jpg');
visualize_points(P_denormalized, xy, img, 1); % 1 is figure index


end