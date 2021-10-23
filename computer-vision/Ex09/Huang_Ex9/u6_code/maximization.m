function [mu, var, alpha] = maximization(P, X)

K = size(P,2);
L = size(X,1);
n = size(X,2);
mu = zeros(K,n);
var = zeros(n,n,K);
alpha = sum(P) / L; % new alpha

for k = 1 : K
    mu(k,:) = sum(X .* P(:,k)) / sum(P(:,k)); % calculate the new mu based on the equation
end

for k = 1 : K
    s = 0;
    for i = 1 : L
        s = s + P(i,k) .* ((X(i,:) - mu(k,:))' * (X(i,:) - mu(k,:)));
    end
    var(:,:,k) = s ./ sum(P(:,k)); % new cov based on new mu
end





