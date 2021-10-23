function hist = color_histogram(xMin, yMin, xMax, yMax, frame, hist_bin)

% round or floor to integer
xMin = round(xMin);
yMin = round(yMin);
xMax = round(xMax);
yMax = round(yMax);

height = size(frame,1);
width = size(frame,2);

hist = zeros(hist_bin, hist_bin, hist_bin); % hist_bin^3

for x = xMin : xMax
   for y = yMin : yMax
       if y <= height && y >= 1 && x <= width && x >= 1 % may exceed the indices of frame
           rgb = frame(y,x,:);
           rgb = rgb(:);
           bin = floor(rgb / (256 / hist_bin)) + 1 ; % floor()+1 is to allocate bins
           % may exceed the bins
           if bin(1) < hist_bin && bin(2) < hist_bin && bin(3) < hist_bin
                hist(bin(1), bin(2), bin(3)) = hist(bin(1), bin(2), bin(3)) + 1;
           end
       end
   end
    
end

% normalization?
hist = hist(:);

end