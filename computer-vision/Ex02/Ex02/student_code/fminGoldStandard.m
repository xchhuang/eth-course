function f = fminGoldStandard(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

%compute squared geometric error

xy_new = P * XYZ; % reprojection (XYZ has been homogeneous representation)
xy_new = xy_new ./ xy_new(3,:); % ensure w to be 1
%compute cost function value
% sum over d(xy, xy_new)^2
f = sum((xy(1,:)-xy_new(1,:)).^2 + (xy(2,:)-xy_new(2,:)).^2);

end