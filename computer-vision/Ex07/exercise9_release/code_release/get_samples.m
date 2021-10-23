function X_nsamp = get_samples(X, nbSamples)
% random sampling
n = length(X);
sample_index = randsample(n, nbSamples);
X_nsamp = X(sample_index,:);

end