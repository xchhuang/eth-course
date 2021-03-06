function hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin)
    box = frame(yMin:yMax,xMin:xMax,:);
    r = box(:,:,1);
    g = box(:,:,2);
    b = box(:,:,3);
    
%     [h_r,~] = histcounts(r,hist_bin,'Normalization','probability');
%     [h_g,~] = histcounts(g,hist_bin,'Normalization','probability');
%     [h_b,~] = histcounts(b,hist_bin,'Normalization','probability');
       
    [h_r,~] = histcounts(r,hist_bin);
    [h_g,~] = histcounts(g,hist_bin);
    [h_b,~] = histcounts(b,hist_bin);
    
    h_r = h_r/sum(h_r);
    h_g = h_g/sum(h_g);
    h_b = h_b/sum(h_b);
    
    
    hist = [h_r;h_g;h_b];
    