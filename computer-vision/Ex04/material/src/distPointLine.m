function d = distPointLine( point, line )
% d = distPointLine( point, line )
% point: inhomogeneous 3d point (3-vector)
% line: 2d homogeneous line equation (3-vector)
point = point / point(3,:);
d = abs(sum(point .* line));
d = d / sqrt(line(1)^2 + line(2)^2);
end


