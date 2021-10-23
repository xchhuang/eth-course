function vCenters = kmeans(vFeatures,k,numiter)

    nPoints  = size(vFeatures,1);
    nDims    = size(vFeatures,2);
    vCenters = zeros(k,nDims);

    % Initialize each cluster center to a different random point.
    sample_index = randsample(nPoints, k);
    vCenters = vFeatures(sample_index,:);
  
    % Repeat for numiter iterations
    for i = 1 : numiter
        % Assign each point to the closest cluster
        [Idx Dist] = findnn(vFeatures, vCenters);
        
        % Shift each cluster center to the mean of its assigned points
        for j = 1 : k
           indices = find(Idx == j); % indices of points belong to this center
           vCenters(j,:) = mean(vFeatures(indices,:),1); % update the center by mean of points
        end
        
        disp(strcat(num2str(i),'/',num2str(numiter),' iterations completed.'));
    end
end
