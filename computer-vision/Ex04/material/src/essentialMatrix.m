% Compute the essential matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xn matrices
%
% Output
% 	Eh 			Essential matrix with the det F = 0 constraint and the constraint that the first two singular values are equal
% 	E 			Initial essential matrix obtained from the eight point algorithm
%

function [Eh, E] = essentialMatrix(x1s, x2s)
    [m, n] = size(x1s);
    EM = zeros(8, 9);
    
    % normalize the homo points so that their their root-mean-squared distance is sqrt(2)
    [x1s, T1] = normalizePoints2d(x1s);
    [x2s, T2] = normalizePoints2d(x2s);
    
    for i = 1 : 8
        p1 = x1s(:,i);
        p2 = x2s(:,i);
        % use eight-point for construction
        EM(i,:) = [p2(1)*p1(1), p2(1)*p1(2), p2(1), p2(2)*p1(1), p2(2)*p1(2), p2(2), p1(1), p1(2), 1];
    end
    
    % use SVD for getting fundamental matrix F
    [U S V] = svd(EM);
    E = V(:,9);
    E = reshape(E, [3,3]);
    E = E';
    
     % use SVD again and zero the third singular value and make sure that
     % the first two singular values are the same
    [U S V] = svd(E);
    S(3,3) = 0;
    S(1,1) = (S(1,1) + S(2,2)) / 2;
    S(2,2) = S(1,1);
    
    Eh = U * S * V';
    
    % renormalize
    E = T2' * E * T1;
    Eh = T2' * Eh * T1;
end
