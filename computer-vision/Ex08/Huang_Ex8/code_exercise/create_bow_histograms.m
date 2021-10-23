function vBoW = create_bow_histograms(nameDir, vCenters)

  vImgNames = dir(fullfile(nameDir,'*.png'));
%   vImgNames = dir(fullfile(nameDir,'*.jpg'));
  nImgs = length(vImgNames);  
  vBoW  = [];
  
  cellWidth = 4;
  cellHeight = 4;
  nPointsX = 10;
  nPointsY = 10;
  border = 8;
  
  % Extract features for all images in the given directory
  for i=1:nImgs, 
    disp(strcat('  Processing image ', num2str(i),'...'));
    
    % load the image
    img = double(rgb2gray(imread(fullfile(nameDir,vImgNames(i).name))));

    % Collect local feature points for each image
    vPoints = grid_points(img, nPointsX, nPointsY, border);
    % and compute a descriptor for each local feature point
    [descriptors, patches] = descriptors_hog(img, vPoints, cellWidth, cellHeight);
    % Create a BoW activation histogram for this image
    bow = bow_histogram(descriptors, vCenters);
    % append the bow of each image
    vBoW = [vBoW; bow];
  end
  
end

