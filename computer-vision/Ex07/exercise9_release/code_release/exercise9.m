% exercise 9
% shape context
% main

% try different number of k
k = [1 3 5 7];
for i = 1 : length(k)
    classificationAccuracy = shape_classification(k(i));
end