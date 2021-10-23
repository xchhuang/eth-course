function vPoints = grid_points(img,nPointsX,nPointsY,border)
    height = size(img,1);
    width = size(img, 2);
    vPoints = zeros(nPointsX * nPointsY, 2); % number of grid points
    
    intervalX = floor((height-border*2-1) / (nPointsX-1)); % m pixels have (m-1) intervals, n points have (n-1) intervals (border=8, each dim = 4)
    intervalY = floor((width-border*2-1) / (nPointsY-1)); % floor to avoid index out of image
    
    x = border+1 : intervalX : (height-border); % a : b : c = begin : interval : end
    y = border+1 : intervalY : (width-border);
    
    [X Y] = meshgrid(x, y);
    index = 1;
    for i = 1 : nPointsX
       for j = 1 : nPointsY
           vPoints(index,:) = [X(i,j) Y(i,j)];
           index = index + 1;
       end
    end
    
end
