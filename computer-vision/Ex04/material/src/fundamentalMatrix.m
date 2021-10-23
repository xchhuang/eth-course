% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences
%
% Output
% 	Fh 			Fundamental matrix with the det F = 0 constraint
% 	F 			Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)
    [m, n] = size(x1s);
    FM = zeros(8, 9);
    
    % normalize the homo points so that their their root-mean-squared distance is sqrt(2)
    [x1s, T1] = normalizePoints2d(x1s);
    [x2s, T2] = normalizePoints2d(x2s);
    
    % construct FM matrix for computing F next
    for i = 1 : 8
        p1 = x1s(:,i);
        p2 = x2s(:,i);
        % use eight-point for construction
        FM(i,:) = [p2(1)*p1(1), p2(1)*p1(2), p2(1), p2(2)*p1(1), p2(2)*p1(2), p2(2), p1(1), p1(2), 1];
    end

    % use SVD for getting fundamental matrix F
    [U S V] = svd(FM);
    F = V(:,9);
    F = reshape(F, [3,3]);
    F = F';
    
    % use SVD again and zero the third singular value
    [U S V] = svd(F);
    S(3,3) = 0;
    % Compute Fh by multiplication again
    Fh = U * S * V';
    
    % renormalize F and Fh
    F = T2' * F * T1;
    Fh = T2' * Fh * T1;
    
end



