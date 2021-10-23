function [w_x,w_y,E] = tps_model(Xunwarped,Y,lambda)
      n = size(Xunwarped,1);
      
      % 2 tps model for fx, fy, respectively
      v_x = [Y(:,1); zeros(3,1)];
      v_y = [Y(:,2); zeros(3,1)];
      
      % U(0)=0, U(t)=t^2*log(t)
      d = dist2(Xunwarped,Xunwarped);
      K = d.*log(d);
      for i = 1 : n
         K(i, i) = 0; 
      end
      
      % construct P and A
      P = ones(3,n);
      P(2:3,:) = Xunwarped';
      P = P';
      A = [K + lambda * eye(n,n), P; P', zeros(3,3)];
      % 1st tps model for x
      % w_x contains a
      b = v_x;
      w_x = A\b;
      E = w_x(1:n)' * K * w_x(1:n);
      % 2nd tps model for y
      % w_y contains a
      b = v_y;
      w_y = A\b;
      % sum the error
      E = E + w_y(1:n)' * K * w_y(1:n);
end