function histo = bow_histogram(vFeatures, vCenters)
  % input:
  %   vFeatures: MxD matrix containing M feature vectors of dim. D
  %   vCenters : NxD matrix containing N cluster centers of dim. D
  % output:
  %   histo    : N-dim. vector containing the resulting BoW
  %              activation histogram.
  
  
  % Match all features to the codebook and record the activated
  % codebook entries in the activation histogram "histo".
    N = size(vCenters,1);
    M = size(vFeatures,1);
    histo = zeros(1,N);
    % features' nearest centers
    [idx,~] = findnn(vFeatures, vCenters);
    % iterate the number of center instead of number of features
    for i = 1 : N
        num = find(idx == i); % which features belong to this center
        histo(1,i) = histo(1,i) + length(num);
    end
end


