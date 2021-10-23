function moving_particles = propagate(particles, sizeFrame, params)

height = sizeFrame(1);
width = sizeFrame(2);

if params.model==1
    A = [[1;0],[0;1],[1;0],[0;1]]; % constant velocity
%     A = eye(4);
%     A(1,3) = 1;
%     A(2,4) = 1;
else
    A = eye(2); % no motion at all
end

num_particles = params.num_particles;
moving_particles = zeros(num_particles, size(particles,2));

count = 1;
% ensure all the moving points are still inside bounding box
while count <= num_particles
    noise_position = params.sigma_position * randn([1,2]); % Bw, and sample noise position [x,y] from normal distribution
    moving_particles(count, 1:2) = round( (A * particles(count,:)')' + noise_position); % As + w
    if moving_particles(count,1) <= width && moving_particles(count,1) >= 1 && moving_particles(count,2) <= height && moving_particles(count,2) >= 1
        if params.model == 1
            noise_vel = params.sigma_velocity * randn([1,2]);
            % constant velocity
            moving_particles(count, 3:4) = params.initial_velocity + noise_vel;
        end
        
        count = count + 1;
    end
    
end

end