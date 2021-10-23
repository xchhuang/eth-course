function distMatrix = chi2_cost(ShapeDescriptors1, ShapeDescriptors2)
% both shape descriptor are in size (N x bins)
% return N x N cost matrix
n = size(ShapeDescriptors1, 1);
distMatrix = zeros(n, n);
for i = 1 : n
    % chi-square 
    cost = sum(  (ShapeDescriptors1(i,:) - ShapeDescriptors2).^2 ./ (ShapeDescriptors1(i,:) + ShapeDescriptors2 + eps)  ,2)/2;
    distMatrix(i,:) = cost;
end
end

