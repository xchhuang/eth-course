% Decompose the essential matrix
% Return P = [R|t] which relates the two views
% Yu will need the point correspondences to find the correct solution for P
function [P1, P2, P3, P4] = decomposeE(E, x1s, x2s)
    % SVD for Essential Matrix
    [U S V] = svd(E);
    
    % translation matrix
    t = U(:,3);
    
    % rotation matrix
    W = [0 -1 0; 1 0 0; 0 0 1];
    R1 = U * W * V';
    R2 = U * W' * V';
    
    % I matrix
    P1 = eye(4);
    % let the 4th rows of P to be matrix a
    a = [0, 0, 0, 1];
    % four possible solution for matrix P
    Ps = {[R1, t; a], [R1, -t; a], [R2, t; a], [R2, -t; a]};
    
    % show cameras for four possible P
    showCameras({P1, Ps{:}}, 30);
    c = zeros(4);
    
    
    for k = 1:4
        % use linear triangulation for computing X in 3D space
        X = linearTriangulation(P1, x1s, Ps{k}, x2s);
        % transformation 
        p1X = P1*X;
        p2X = Ps{k}*X;
        
        % find a matrix that all points are in front of the camera
        count = length(find(p1X(3,:) >= 0 & p2X(3,:) >= 0));
        if count == size(X,2)
        	figure(31);
            scatter3(X(1,:),X(2,:), X(3,:)); hold on;
            showCameras({P1, Ps{k}}, 31);
            
        end
        c(k) = count;               
    end
%     [~,i] = max(c);
%     % get the correct P matrix
%     P = Ps{i};
%     X = linearTriangulation(P1, x1s, P, x2s);
%     % show the correct P matrix
%     figure(31);
%     scatter3(X(1,:),X(2,:), X(3,:)); hold on;
%     showCameras({P1, P}, 31);
    
    
    
end









