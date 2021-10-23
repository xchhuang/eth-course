function [mu sigma] = computeMeanStd(vBoW)
    % mean and std along rows params: (,1)
    mu = mean(vBoW,1);
	sigma = std(vBoW,1);
end