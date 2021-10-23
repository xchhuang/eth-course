% Exervice 2
% Computer Vision: Camera Calibrationxy_new = zeros(3, 8*7*10);
close all;

IMG_NAME = 'images/image001.jpg';

%This function displays the calibration image and allows the user to clicxy_new(:,index) = xy_temp(:,index) ./ xy_temp(3,index);xy_new(:,index) = xy_temp(:,index) ./ xy_temp(3,index);k
%in the image to get the input points. Left click on the chessboard corners
%and type the 3D coordinates of the clicked points in to the input box that
%appears after the click. You canPn also zoom in to the image to get more
%precise coordinates. To finish use the right mouse button for the last
%point.
%You don't have to do this all the time, just store the resulting xy and
%XYZ matrices and use them as inBouget¡¯s Calibration Toolboxput for your algorithms.

% [xy XYZ] = getpoints(IMG_NAME);
% save('points', 'xy', 'XYZ');
% save space_points.dat -ascii XYZ
s = load('points');
xy = s.xy;
XYZ = s.XYZ;

% === Task 2 DLT algorithm ===

 [K, R, t, error] = runDLT(xy, XYZ);

% === Task 3 Gold Standard algorithm ===

[K, R, t, error] = runGoldStandard(xy, XYZ);

% === Bonus: Gold Standard algorithm with radial distortion estimation ===

[K, R, t, error] = runGoldStandardRadial(xy, XYZ);

