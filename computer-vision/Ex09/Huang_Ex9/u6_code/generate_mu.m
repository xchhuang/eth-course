% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(X, K)

% generate k mu by random sample from pixels
mu = zeros(K,3);
L = size(X,1);
index = randsample(L,K);
for k = 1 : K
   mu(k,:) = X(index(k),:); 
end

end