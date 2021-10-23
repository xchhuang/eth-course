function [P] = dlt(xy, XYZ)
% computes DLT, xy and XYZ should be normalized before calling this function

[m,n] = size(xy);
% define matrix A with 2n x 12
A = zeros(2*n,12);

% construct the A matrix
% i: rows
% j: colums
j = 1;
for i = 1 : 2 : 2*n
    Xi = XYZ(1,j);
    Yi = XYZ(2,j);
    Zi = XYZ(3,j);
    xi = xy(1,j);
    yi = xy(2,j);
    % construct two rows for each point
    A(i,:) = [Xi, Yi, Zi, 1, 0, 0, 0, 0, -xi*Xi, -xi*Yi, -xi*Zi, -xi];
    A(i+1,:) = [0, 0, 0, 0, -Xi, -Yi, -Zi, -1, yi*Xi, yi*Yi, yi*Zi, yi];
    j = j + 1;
end

% svd decomposition for A
[U S V] = svd(A);

% get the last column of V matrix, pay attention to the reshape func
P = V(:,12);
P = reshape(P, [4,3]);
P = P';


end
