% Exercise 1
% Computer Vision, Feature Extraction
% by hxc
close all;

IMG_NAME1 = 'images/I1.jpg';
IMG_NAME2 = 'images/I2.jpg';

% read in image
img1 = im2double(imread(IMG_NAME1));
img2 = im2double(imread(IMG_NAME2));

img1 = imresize(img1, [224,224]);
img2 = imresize(img2, [224,224]);

% convert to gray image
imgBW1 = rgb2gray(img1);
imgBW2 = rgb2gray(img2);

% imshow(imgBW1');

% Task 1.1 - extract Harris corners
thresh = 0.001; % determined by histogram of H
[corners1, H1] = extractHarrisCorner(imgBW1', thresh);
[corners2, H2] = extractHarrisCorner(imgBW2', thresh);

% show images with Harris corners
showImageWithCorners(img1, corners1, 10);
showImageWithCorners(img2, corners2, 11);

% Task 1.2 - extract your own descriptors
% descr1 = extractDescriptor(corners1, imgBW1');
% descr2 = extractDescriptor(corners2, imgBW2');

% Task Bonus - my implementation of sift descriptor ignoring scale and rotation
% invariance
descr1 = sift_descriptor(corners1, imgBW1');
descr2 = sift_descriptor(corners2, imgBW2');

% Task 1.3 - match the descriptors
thresh = 0.1;
thresh = 0.005; % threshold for my SIFT descriptor
matches = matchDescriptors(descr1, descr2, thresh);

showFeatureMatches(img1, corners1(:, matches(1,:)), img2, corners2(:, matches(2,:)), 20);


% Task 1.4 - vlfeat SIFT features and descriptors
Ia = single(imgBW1) ;
Ib = single(imgBW2) ;
[fa, da] = vl_sift(Ia) ; % get feature points and descriptors
[fb, db] = vl_sift(Ib) ;
[matches, scores] = vl_ubcmatch(da, db, thresh); % match feature points in both images
corners1 = fa(1:2,:);
corners2 = fb(1:2,:);
showFeatureMatches(img1, corners1(:, matches(1,:)), img2, corners2(:, matches(2,:)), 30);