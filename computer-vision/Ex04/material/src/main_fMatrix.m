clickPoints = false;


dataset = 1;   % Your pictures
% dataset = 1; % ladybug
% dataset = 2; % rect

% image names
if(dataset==0)
    imgName1 = '';
    imgName2 = '';
elseif(dataset==1)
    imgName1 = 'images/ladybug_Rectified_0768x1024_00000064_Cam0.png';
    imgName2 = 'images/ladybug_Rectified_0768x1024_00000080_Cam0.png';
elseif(dataset==2)
    imgName1 = 'images/rect1.jpg';
    imgName2 = 'images/rect2.jpg';
end

% read in images
img1 = im2double(imread(imgName1));
img2 = im2double(imread(imgName2));

[pathstr1, name1] = fileparts(imgName1);
[pathstr2, name2] = fileparts(imgName2);

cacheFile = [pathstr1 filesep 'matches_' name1 '_vs_' name2 '.mat'];

% get point correspondences
if (clickPoints)
    [x1s, x2s] = getClickedPoints(img1, img2);
    save(cacheFile, 'x1s', 'x2s', '-mat');
else
    load('-mat', cacheFile, 'x1s', 'x2s');
end

% show clicked points
figure(1),clf, imshow(img1, []); hold on, plot(x1s(1,:), x1s(2,:), '*r');
figure(2),clf, imshow(img2, []); hold on, plot(x2s(1,:), x2s(2,:), '*r');


%% YOUR CODE ...
% estimate fundamental matrix
[Fh, F] = fundamentalMatrix(x1s, x2s);


% draw epipolar lines in img 1
% draw epipole for 
[U S V] = svd(F);
[Uh Sh Vh] = svd(Fh);

e1 = V(:,3);
e2 = U(:,3);
e1 = e1 / e1(3,:);
e2 = e2 / e2(3,:);

eh1 = Vh(:,3);
eh2 = Uh(:,3);
eh1 = eh1 / eh1(3,:);
eh2 = eh2 / eh2(3,:);

figure(1)

for k = 1:size(x1s,2)
    drawEpipolarLines(Fh'*x2s(:,k), img1);
end

plot(eh1(1), eh1(2), 'ro'); hold on;

% draw epipolar lines in img 2
figure(2)

for k = 1:size(x2s,2)
    drawEpipolarLines(Fh*x1s(:,k), img2);
end

plot(eh2(1), eh2(2), 'ro'); hold on;

%show epipolar line for a new point
image_to_clic=1;
figure(image_to_clic)
newp=ginput(1);newp=[newp 1]';
plot(newp(1), newp(2), '*g')
figure(3-image_to_clic)
if image_to_clic==1
    figure(2);drawEpipolarLines(Fh*newp, img2);
else
    figure(1);drawEpipolarLines(Fh'*newp, img1);
end
