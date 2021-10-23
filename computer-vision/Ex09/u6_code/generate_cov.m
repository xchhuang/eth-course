% Generate initial values for the K
% covariance matrices

function cov = generate_cov(X, K)

% generate randomly intial covariance matrix using diag function and random
% sample
cov = zeros(3,3,K);
L = size(X,1);
index = randsample(L,K);
for k = 1 : K
    cov(:,:,k) = diag(X(index(k),:));
%     cov(:,:,k) = diag(X(index(1),:));
end

end

