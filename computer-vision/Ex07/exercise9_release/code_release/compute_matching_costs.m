function matchingCostMatrix = compute_matching_costs(objects,nbSamples)
    n = length(objects);
    matchingCostMatrix = zeros(n, n);
    for i = 1 : 1
       for j = 1 : 2
           if j ~= i
               % iterate for all pairs
               X = objects(1).X;
               Y = objects(2).X;
               % random sampling
%                X_nsamp = get_samples(X, nbSamples);
%                Y_nsamp = get_samples(Y, nbSamples);
               % sampling method proposed in paper
               X_nsamp = get_samples_1(X, nbSamples);
               Y_nsamp = get_samples_1(Y, nbSamples);
               matchingCost = shape_matching(X_nsamp, Y_nsamp, 1);
               matchingCostMatrix(i,j) = matchingCost;
           end
       end
    end
end