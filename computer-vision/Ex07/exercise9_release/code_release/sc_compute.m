function sc_desc = sc_compute(X,nbBins_theta,nbBins_r,smallest_r,biggest_r)
    % X: shape (2,100)
    n = size(X,2);
    sc_desc = zeros(n, nbBins_theta  * nbBins_r);
    %% first: radial histogram
    % calculate distance between sample points: shape (100,100)
    % scale-invariant
    dist_array = real(sqrt(dist2(X', X')));
    mean_dist = mean(dist_array(:));
    dist_array = dist_array / mean_dist;
    
    % log space distance between biggest r and smallest r with nbins 
    logr = logspace(log10(smallest_r), log10(biggest_r), nbBins_r);
    
    dist_hist = zeros(n, n);
    % get the bin by adding if it is less than logr distance
    % the nearer points would get larger values
    for i = 1 : nbBins_r
        dist_hist = dist_hist + (dist_array < logr(i)); % distance histogram
    end
    
    %% second: theta histogram
    % theta matrix between sample points: shape (100,100)
    % use repmat to avoid for loops
    theta_array = atan2(repmat(X(2,:)', 1, n) - repmat(X(2,:), n, 1), repmat(X(1,:)', 1, n) - repmat(X(1,:), n, 1));

    % changed to [0,2pi), rem -> mod
    ang = rem(rem(theta_array, 2*pi) + 2*pi, 2*pi);
    % quantize to theta nbins=6 because abs value before
    theta_hist = 1+floor(ang / (2 * pi / nbBins_theta));
%     fprintf('%i %i\n', min(dist_hist), max(dist_hist));
    
    % merge distance and angle histogram
    % 2 for loops slowly
    
    for i = 1 : n
        hist_temp = zeros(nbBins_r, nbBins_theta);
        for j = 1 : n
            if dist_hist(i,j)~= 0 && theta_hist(i,j) ~= 0
                hist_temp(dist_hist(i,j), theta_hist(i,j)) = hist_temp(dist_hist(i,j), theta_hist(i,j)) + 1;
            end
%             s = dist_hist(i,j) .* theta_hist(i,j);
%             if s ~= 0
%                 sc_desc(i,s) = sc_desc(i,s) + 1;
%             end
        end
        hist_temp = hist_temp(:);
        for j = 1 : nbBins_r * nbBins_theta
            sc_desc(i,j) = sc_desc(i,j) + hist_temp(j);
        end
    end
end