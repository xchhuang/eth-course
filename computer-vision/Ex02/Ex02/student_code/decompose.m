function [ K, R, C ] = decompose(P)
% decompose P into K, R and t

% P = [KR|-KRC], decompose KR using QR decomposition
KR = P(1:3,1:3); % inv(M) = inv(R) * inv(K);
M = inv(KR); % q = inv(R), r = inv(K);
[q,r] = qr(M); % qr decomposition
K = inv(r);
R = inv(q);

% calculate the camera center point
C = null(P);
C = C / C(4); % camera center

C = C(1:3);
C = -R * C;
C = C / C(3); % principle point used in radial distortion
end