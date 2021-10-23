function [map cluster] = EM(img)

n = size(img,3);
L = size(img,1) * size(img,2);
X = reshape(img, [L, n]);
X = double(X);
K = 3; % 3 clusters

% use function generate_mu to initialize mus
% use function generate_cov to initialize covariances
alpha = ones(1,K) / K;
mu = generate_mu(X, K);
cov = generate_cov(X, K);

% iterate between maximization and expectation
% use function maximization
% use function expectation
e = expectation(mu, cov, alpha, X); % initial old expectation
maxIter = 100;
y = []; % for plotting
for i = 1 : maxIter
    e_old = e;
    [mu, cov, alpha] = maximization(e, X); % maximization step
    e = expectation(mu, cov, alpha, X); % expectation step
    
    error = norm( sum( (e - e_old).^2) ) % error of expectation, sum over all pixels
    y = [y error];
    if error < 0.01 % small threshold
        break
    end
end

cluster = mu;
[~, map] = max(e, [], 2);
map = reshape(map, size(img,1), size(img,2));

disp(i);
disp(alpha);
disp(mu);
disp(cov)

% plot the error curve
x = 1 : i;
figure(31);
plot(x,y);
title('Error curve of expectation for EM clustering: K = 5');
xlabel('iterations');
ylabel('Error');
end






