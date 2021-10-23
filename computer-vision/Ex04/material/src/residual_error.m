function dist = residual_error(Fh, xy1, xy2)
    projected_xy1 = Fh * xy1;
    projected_xy1 = projected_xy1 ./ projected_xy1(3,:);
    projected_xy2 = Fh' * xy2;
    projected_xy2 = projected_xy2 ./ projected_xy2(3,:);

    dist1 = sqrt(sum((projected_xy1 - xy2).^2));
    dist2 = sqrt(sum((projected_xy2 - xy1).^2));
    dist = dist1 + dist2;
    dist = dist;
end