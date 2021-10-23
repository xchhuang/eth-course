function [k, b] = ransacLine(data, dim, iter, threshDist, inlierRatio)
% data: a 2xn dataset with #n data points
% num: the minimum number of points. For line fitting problem, num=2
% iter: the number of iterations
% threshDist: the threshold of the distances between points and the fitting line
% inlierRatio: the threshold of the number of inliers

number = size(data,2); % Total number of points
bestInNum = 0;         % Best fitting line with largest number of inliers
k=0; b=0;              % parameters for best fitting line


for i=1:iter
    % Randomly select 2 points
    sampled_index = randperm(number);
    sampled_index = sampled_index(1:2);
    % Compute the distances between all points with the fitting line
    sampled_pts = data(:,sampled_index);
    delta = (sampled_pts(:,2) - sampled_pts(:,1));
    tempk = delta(2) / delta(1); % compute the k of line y = kx + b
    p = sampled_pts(:,1);
    tempb = p(2) - tempk * p(1); % computer b of line y = kx + b
    % Compute the inliers with distances smaller than the threshold
    dist = ([tempk -1] * data + tempb) / (sqrt(tempk^2 + 1)); % compute distance for all points using matrix multiplication instead of for loop
    inliers = find(abs(dist) < threshDist); % use "find" function to find index that the absolute distance less than threshold
    inliers_num = length(inliers);
    
    if round(inlierRatio * number) > inliers_num % continue of not enough inliers
       continue 
    end
    % Update the number of inliers and fitting model if better model is found
    if bestInNum < inliers_num
       bestInNum = inliers_num;
       k = tempk; % update k and b for line y = kx + b
       b = tempb;
    end
end

end
