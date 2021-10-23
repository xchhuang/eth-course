function f = fminGoldStandardRadial(k, P, xy, XYZ, w)

%reassemble P
% P = [p(1,1:4);p(1,5:8);p(1,9:12)];

% factorize camera matrix in to K, R and t
[K R t] = decompose(P);
%compute squared geometric error with radial distortion
xy_new = P * XYZ; % reprojection (XYZ has been homogeneous representation)
xy_new = xy_new ./ xy_new(3,:); % ensure w to be 1

r = sqrt(sum((xy_new - t).^2));

xy_undistort = (1 + k(1) * r + k(2) * r^2) * xy_new;
%compute cost function value
f = sum((xy_undistort - xy).^2);

end