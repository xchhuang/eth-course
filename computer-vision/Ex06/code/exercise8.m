% =========================================================================
% Exercise 8
% =========================================================================

% Initialize VLFeat (http://www.vlfeat.org/)

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
% use peak_thresh because this two views is too far, in order to optimize
% the result and inliers
[fa, da] = vl_sift(img1,'PeakThresh',2);
[fb, db] = vl_sift(img2,'PeakThresh',2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);

showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);

%% Compute essential matrix and projection matrices and triangulate matched points
% extracted inhomo. points and homo. transformation
x1_inhomo = fa(1:2, matches(1,:)); 
x2_inhomo = fb(1:2, matches(2,:));
x1_homo = makehomogeneous(x1_inhomo);
x2_homo = makehomogeneous(x2_inhomo);

% cannot directly estimate the Essential matrix, so first get the
% fundamental matrix
t = 0.002;
%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices

[F, inliers] = ransacfitfundmatrix(x1_homo, x2_homo, t);
% use the transform of F and E below
E = K' * F * K;

showFeatureMatches(img1, fa(1:2, matches(1,inliers)), img2, fb(1:2, matches(2,inliers)), 21); % show inliers
outliers = setdiff(matches(1,:),inliers); % in order to show outliers
showFeatureMatches(img1, fa(1:2, outliers), img2, fb(1:2, outliers), 32);
% show epipolar lines
% show clicked points
figure(41), imshow(img1, []); hold on, plot(fa(1, matches(1,inliers)), fa(2, matches(1,inliers)), '*r');
figure(51), imshow(img2, []); hold on, plot(fb(1, matches(2,inliers)), fb(2, matches(2,inliers)), '*b');

% draw epipolar geometry, notice that for image, we should use F/F' * (points in image 2)
figure(41)
for k = 1:size(inliers,2)
    drawEpipolarLines(F'*[fb(1:2, matches(2,inliers(:,k)));1], img1);
end
figure(51)
for k = 1:size(inliers,2)
    drawEpipolarLines(F*[fa(1:2, matches(1,inliers(:,k)));1], img2);
end

inliers_fa = fa(1:2, matches(1,inliers)); % for plotting showFeatures
inliers_fb = fb(1:2, matches(2,inliers));
inliers_fa_homo = makehomogeneous(inliers_fa); % just store inliers and discard others
inliers_fb_homo = makehomogeneous(inliers_fb);
x1_calibrated = K \ inliers_fa_homo; % calibrate the point in order to estimate the projection matrix using ransac dlt
x2_calibrated = K \ inliers_fb_homo;

% decompose E
Ps{1} = eye(4);
Ps{2} = decomposeE(E, x1_calibrated, x2_calibrated); % get projection matrix from Essential matrix

%triangulate the inlier matches with the computed projection matrix
X = linearTriangulation(Ps{1}, x1_calibrated, Ps{2}, x2_calibrated); % homo. 3D space point
figure(31)
p = plot3(X(1,:), X(2,:), X(3,:), 'g.'); hold on;

%% Add an addtional view of the scene 
%% Add image 2
imgName3 = '../data/house.002.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated

[matches1, scores] = vl_ubcmatch(da(:,matches(1,inliers)), dc); % use inliers in a to match c


% get calibrated points from extracted matched feature points
x3_inhomo = fc(1:2, matches1(2,:));
x3_homo= makehomogeneous(x3_inhomo);
x3_calibrated = K \ x3_homo;

%run 6-point ransac and get inliers, the inputs are init 3d points and new
%image's 2d points

% run directly to estimate the projection matrix with 2d and 3d corresponses
[P, inliers1] = ransacfitprojmatrix(x3_calibrated(1:2,:), X(1:3,matches1(1,:)), t); 
Ps{3} = P;
% ensure that the rotation matrix's determinant is positive without
% changing the result because of homogeneous
if (det(Ps{3}(1:3,1:3)) < 0 )
    Ps{3} =  -Ps{3};
end

showFeatureMatches(img1, inliers_fa(1:2, matches1(1,inliers1)), img3, fc(1:2, matches1(2,inliers1)), 22); % use inliers and matches between a and c
outliers1 = setdiff(matches1(1,:),inliers1); % in order to show outliers
showFeatureMatches(img1, fa(1:2, outliers1), img3, fb(1:2, outliers1), 33);

%triangulate the inlier matches with the computed projection matrix
% use inliers
X1 = linearTriangulation(Ps{1}, x1_calibrated(:,matches1(1,inliers1)), Ps{3}, x3_calibrated(:,inliers1));
figure(31)
p1 = plot3(X1(1,:), X1(2,:), X1(3,:), 'r.'); hold on;

%% Add more views...
%% Add image 1
imgName4 = '../data/house.001.pgm';
img4 = single(imread(imgName4));
[fd, dd] = vl_sift(img4);

%match against the features from image 1 that where triangulated

[matches4, scores] = vl_ubcmatch(da(:,matches(1,inliers)), dd); % use inliers in a to match c


x4_inhomo = fd(1:2, matches4(2,:));
x4_homo= makehomogeneous(x4_inhomo);
x4_calibrated = K \ x4_homo; % calibrated points for DLT in projmatrix function, estimating R and t.

%run 6-point ransac
[P, inliers2] = ransacfitprojmatrix(x4_calibrated(1:2,:) , X(1:3,matches4(1,:)), t);
Ps{4} = P;
% ensure that the rotation matrix's determinant is positive without
% changing the result because of homogeneous
if (det(Ps{4}(1:3,1:3)) < 0 )
    Ps{4} =  -Ps{4};
end

showFeatureMatches(img1, inliers_fa(1:2, matches4(1,inliers2)), img4, fd(1:2, matches4(2,inliers2)), 23); % use inliers and matches between a and c
outliers2 = setdiff(matches4(1,:),inliers2); % in order to show outliers
showFeatureMatches(img1, fa(1:2, outliers2), img4, fb(1:2, outliers2), 34);

%triangulate the inlier matches with the computed projection matrix
X2 = linearTriangulation(Ps{1}, x1_calibrated(:,matches4(1,inliers2)), Ps{4}, x4_calibrated(:,inliers2));
figure(31)
p2 = plot3(X2(1,:), X2(2,:), X2(3,:), 'b.'); hold on;

%% Add image 3: the same operations with the previous image 1, just be patient about the indices
imgName5 = '../data/house.003.pgm';
img5 = single(imread(imgName5));
[fe, de] = vl_sift(img5);

%match against the features from image 1 that where triangulated

[matches5, scores] = vl_ubcmatch(da(:,matches(1,inliers)), de); % use inliers in a to match c


x5_inhomo = fe(1:2, matches5(2,:));
x5_homo= makehomogeneous(x5_inhomo);
x5_calibrated = K \ x5_homo;

%run 6-point ransac
[P, inliers3] = ransacfitprojmatrix(x5_calibrated(1:2,:), X(1:3,matches5(1,:)), t);
Ps{5} = P;
% ensure that the rotation matrix's determinant is positive without
% changing the result because of homogeneous
if (det(Ps{5}(1:3,1:3)) < 0 )
    Ps{5} =  -Ps{5};
end

showFeatureMatches(img1, inliers_fa(1:2, matches5(1,inliers3)), img5, fe(1:2, matches5(2,inliers3)), 24); % use inliers and matches between a and c
outliers3 = setdiff(matches5(1,:),inliers3); % in order to show outliers
showFeatureMatches(img1, fa(1:2, outliers3), img5, fb(1:2, outliers3), 35);

%triangulate the inlier matches with the computed projection matrix
X3 = linearTriangulation(Ps{1}, x1_calibrated(:,matches5(1,inliers3)), Ps{5}, x5_calibrated(:,inliers3));
figure(31)
p3 = plot3(X3(1,:), X3(2,:), X3(3,:), 'k.'); hold on;

%% Plot stuff
%use plot3 to plot the triangulated 3D points
fig = 31;
figure(fig);

%draw cameras
drawCameras(Ps, fig);


