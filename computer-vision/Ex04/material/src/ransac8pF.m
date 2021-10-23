function [in1, in2, out1, out2, m, F] = ransac8pF(xy1, xy2, threshold)
    [~, n] = size(xy1);
    iter = 1000;
    m = 1;
    bestInlierNum = 0;
    % homo. coordinate
    xy1 = [xy1; ones(1,n)];
    xy2 = [xy2; ones(1,n)];
    
    for i = 1 : 100000
        % randomly choose 8 points from feature points
        sampled_index = randperm(n);
        sampled_index = sampled_index(1:8);
        sampled_xy1 = xy1(:,sampled_index);
        sampled_xy2 = xy2(:,sampled_index);

        [Fh, ~] = fundamentalMatrix(sampled_xy1, sampled_xy2);
        
        % get the residual mse error
        dist1 = distPointLine(xy2, Fh*xy1);
        dist2 = distPointLine(xy1, Fh'*xy2);
        dist = dist1 + dist2
        
        % find inliers and outliers according to threshold
        inliers = find(dist <= threshold);
        outliers = find(dist > threshold);
        inliersNum = length(inliers);
        % get the inlier ratio for adaptive RANSAC
        inlierRatio = inliersNum / n;
        
        % update params if find less outliers
        if bestInlierNum < inliersNum
            bestInlierNum = inliersNum;
            in1 = xy1(:,inliers);
            in2 = xy2(:,inliers);
            out1 = xy1(:,outliers);
            out2 = xy2(:,outliers);
            F = Fh;
        end
        
        % adaptive RANSAC with fixing p as 0.99
        if 1 - (1 - inlierRatio^8)^i > 0.99
            m = i;
            break
        end
    end
    m = i;
%     [F, ~] = fundamentalMatrix(in1, in2);
%     dist = residual_error(F, in1, in2);
%     inliers = find(dist <= threshold);
%     outliers = find(dist > threshold);
%     in1 = xy1(:,inliers);
%     in2 = xy2(:,inliers);
%     out1 = xy1(:,outliers);
%     out2 = xy2(:,outliers);
end





