% =========================================================================
% Exercise 4
% =========================================================================

%don't forget to initialize VLFeat

%Load images
% imgName1 = '';
% imgName2 = '';
imgName1 = 'images/ladybug_Rectified_0768x1024_00000064_Cam0.png';
imgName2 = 'images/ladybug_Rectified_0768x1024_00000080_Cam0.png';
% imgName1 = 'images/I1.jpg';
% imgName2 = 'images/I2.jpg';

img1 = im2double(imread(imgName1));
img2 = im2double(imread(imgName2));

% img1 = imresize(img1, [224,224]);
% img2 = imresize(img2, [224,224]);

img1 = rgb2gray(img1);
img2 = rgb2gray(img2);
img1_single = single(img1);
img2_single = single(img2);

%extract SIFT features and match
[fa, da] = vl_sift(img1_single);
[fb, db] = vl_sift(img2_single);
[matches, scores] = vl_ubcmatch(da, db);

%show matches
showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);

% =========================================================================

%run 8-point RANSAC (Simple and Adaptive)

[inliers1, inliers2, outliers1, outliers2, M, F] = ransac8pF(fa(1:2, matches(1,:)), fb(1:2, matches(2,:)), 10);

%show inliers and outliers
% size(fa(1:2, matches(1,:)))
showFeatureMatches(img1, inliers1(1:2,:), img2, inliers2(1:2,:), 21);
showFeatureMatches(img1, outliers1(1:2,:), img2, outliers2(1:2,:), 22);
%show number of iterations needed
numIter = M
%show inlier ratio
inlier_ratio1 = length(inliers1) / length(fa(1:2, matches(1,:)))
inlier_ratio2 = length(inliers2) / length(fb(1:2, matches(2,:)))

%and check the epipolar geometry of the computed F

figure(23),clf, imshow(img1, []); hold on, plot(inliers1(1,:), inliers1(2,:), '*r');
figure(24),clf, imshow(img2, []); hold on, plot(inliers2(1,:), inliers2(2,:), '*r');

figure(23)
size(inliers2)
for k = 1:size(inliers1,2)
%    drawEpipolarLines(%..., img1);
    drawEpipolarLines(F'*inliers2(:,k), img1);
end

figure(24)
for k = 1:size(inliers2,2)
%    drawEpipolarLines(%..., img2);
    drawEpipolarLines(F*inliers1(:,k), img2);
end
% =========================================================================