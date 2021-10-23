function [map, peak] = meanshiftSeg(img)

n = size(img, 3); % number of channels: l*a*b
L = size(img,1) * size(img,2); % number of total pixels
r = 30; % radius of spherical window
X = reshape(img, [L, n]);
X = double(X);
bandwidth = 0.3; % threshold for terminating move of peak

visit = zeros(L,1); % record the visited pixels and start mean shift on unvisited ones (faster)
cluster_centers = []; % store cluster centers
cluster_num = 0; % the number of clusters
counts_all_clusters = zeros(1, L); % histogram for each point to all the clusters, more rows would be added

while ~isempty(find(visit == 0))
    
    unvisit = find(visit == 0);
    index = randsample(unvisit, 1); % choose an unvisit randomly
    peak = X(index,:);
    points_cur_clusters = [];
    counts_cur_cluster = zeros(1, L);
    
    % find peak and do mean shift
    while 1
        diff = sum((peak - X).^2, 2);
        indices = find(diff < r^2); % inside a circle
%         size(indices)
        old_peak = peak;
        peak = mean(X(indices,:), 1); % mean shift
        points_cur_clusters = [points_cur_clusters indices']; % store all the points during shifting and later set them to visited state
%         size(points_cur_clusters)
        counts_cur_cluster(indices) = counts_cur_cluster(indices) + 1; % add 1 to histogram if the points belong to current clusters
        if norm(peak - old_peak) < bandwidth
           break 
        end
    end
    
    % cluster center merge or add new cluster
    isMerge = 0;
    if cluster_num > 0
        for i = 1 : cluster_num
           diff = norm(peak - cluster_centers(i,:)); % if the distance of lab color is smaller than r / 2
           if diff < r / 2
               cluster_centers(i,:) = (peak + cluster_centers(i,:)) / 2; % merge the centers with the current peak
               counts_all_clusters(i,:) = counts_all_clusters(i,:) + counts_cur_cluster; % update the histogram with current counts
               isMerge = 1; % set merged flag to be true
               break
           end
        end
    end
    
    % if not merged, add a new center and its
    if isMerge == 0
        cluster_num = cluster_num + 1;
        cluster_centers(cluster_num,:) = peak;
        counts_all_clusters(cluster_num,:) = counts_cur_cluster;
    end
    visit(points_cur_clusters) = 1;
    
end

disp(cluster_num);

[~, map] = max(counts_all_clusters, [], 1); % maximum counts of each point to all clusters
map = reshape(map, size(img,1), size(img,2)); % remember to reshape for visualization

end







