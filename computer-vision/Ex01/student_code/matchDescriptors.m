% match descriptors
%
% Input:
%   descr1        - k x n descriptor of first image
%   descr2        - k x m descriptor of second image
%   thresh        - scalar value to threshold the matches
%   
% Output:
%   matches       - 2 x w matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, thresh)
    [n,k] = size(descr1);
    [m,k] = size(descr2);
    
    % responding matches for corner points in both images
    matches = [];
    
    for i = 1 : n
       temp = [];
       minn = 100000;
       for j = 1 : m
           % calc the SSD (sum of square differences)
           ssd = sum((descr1(i,:) - descr2(j,:)).^2);
           % sdd small enough
           if ssd < thresh
               % choose the closest point
               if ssd < minn
                    minn = ssd;
                    temp = [i;j];
               end
           end

       end
       % add pair to matches
       matches = cat(2, matches, temp);
    end
    size(matches);
end