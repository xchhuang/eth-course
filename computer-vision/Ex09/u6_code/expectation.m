function P = expectation(mu,var,alpha,X)

K = length(alpha);
L = size(X,1);
n = size(X,2);
p_z = zeros(L,1);
P = zeros(K, L);

for k = 1 : K
    for i = 1 : L
        % calculate p(z|x)
        p_z(i) = alpha(k) ./ ((2*pi).^(n/2)*sqrt(det(var(:,:,k)))) .* exp(-0.5*(X(i,:)-mu(k,:))*inv(var(:,:,k))*(X(i,:)-mu(k,:))');
    end
    P(k,:) = p_z;
%       vectorized dimension is too high
%       P(k,:) = alpha(k) ./ ((2*pi).^(n/2)*sqrt(det(var(:,:,k)))) .* exp(-0.5*(X-mu(k,:))*inv(var(:,:,k))*(X-mu(k,:))');
end

% normalization on k clusters
P = P ./ sum(P);
P = P';

end
