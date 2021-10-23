function sLabel = bow_recognition_nearest(histogram,vBoWPos,vBoWNeg)

% Find the nearest neighbor in the positive and negative sets
% and decide based on this neighbor
    % nearest distance
    [DistPos, ~] = min(sqrt(sum((histogram - vBoWPos).^2, 2)));
    [DistNeg, ~] = min(sqrt(sum((histogram - vBoWNeg).^2, 2)));
    
    if (DistPos<DistNeg)
        sLabel = 1;
    else
        sLabel = 0;
    end
  
end
