function testClass = nn_classify(matchingCostVec,allClasses,k)
%     size(matchingCostVec);
    % find the index of minimum cost of k points
    [num,val]=sort(matchingCostVec);
    % count for max
    c = cell(1,k);
    % store string in cell
    for i = 1 : k
        c(i) = allClasses(val(i));
    end
    % find the k-nearest neig
    t = tabulate(c); 
    num = max(cell2mat(t(:,2)));
    array = find(cell2mat(t(:,2)) == num);
    testClass = c(array);
end