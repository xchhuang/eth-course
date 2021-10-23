function [K, R, t, k, error] = runGoldStandardRadial(xy, XYZ, rad)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT
[Pn] = dlt(xy_normalized, XYZ_normalized);
k = [-.1 -.1]; % parameters init for k1 k2

%minimize geometric error
pn = [Pn(1,:) Pn(2,:) Pn(3,:)];

for i=1:50
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized, i/5);
    p = reshape(pn, [4,3]);
    p = p';
    if mod(i,6) == 0
        [k] = fminsearch(@fminGoldStandardRadial, k, [], p, xy_normalized(:,6), XYZ_normalized(:,6), i/5);
    else
        [k] = fminsearch(@fminGoldStandardRadial, k, [], p, xy_normalized(:,mod(i,6)), XYZ_normalized(:,mod(i,6)), i/5);
    end
end


%denormalize camera matrix
pn = reshape(pn, [4,3]);
pn = pn';
P_denormalized = T \ (pn * U);

%factorize camera matrix in to K, R and t
[ K, R, t ] = decompose(P_denormalized);

%compute reprojection error
[m,n] = size(XYZ);
XYZn = [XYZ;ones(1,n)]; % append ones to homogeneous
xy_new = P_denormalized * XYZn; % reprojection
xy_new = xy_new ./ xy_new(3,:); % ensure w to be 1

for i = 1 : 6
    r = sqrt(sum((xy_new(:,i) - t).^2));
    xy_new(:,i) = t + (1 + k(1) * r + k(2) * r^2) * (xy_new(:,i) - t); % multipled by a radial distortion factor
end

error = sum((xy(1,:)-xy_new(1,:)).^2 + (xy(2,:)-xy_new(2,:)).^2)

% visualization
img = imread('images/image001.jpg');
visualize_points(P_denormalized, xy, img, 3);

end