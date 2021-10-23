function visualize_points(P, xy, img, fig_num)

xy_new = zeros(3, 8*7*10);
index = 1;
x = 0; % draw points on two planes respectively
for y = 0 : 6
    for z = 0 : 9
        xy_temp = P * [x;y;z;1]; % reprojection
        xy_new(:,index) = xy_temp ./ xy_temp(3); % ensure w to be 1
        index = index + 1;
    end
end

y = 0;
for x = 0 : 7
    for z = 0 : 9
        xy_temp = P * [x;y;z;1]; % reprojection
        xy_new(:,index) = xy_temp ./ xy_temp(3); % ensure w to be 1
        index = index + 1;
    end
end

figure(fig_num);
imshow(img);
hold on; % pay attention to adding hold on

plot(xy(1,:), xy(2,:), 'ro'); 
hold on;

plot_x = xy_new(1,:);
plot_y = xy_new(2,:);
plot(plot_x, plot_y, 'go');

end