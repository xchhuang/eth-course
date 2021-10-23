function m = estimate(particles, particles_w)

N = size(particles,2);
m = zeros(1,N);
% size(particles)
% size(particles_w)

m = sum(particles .* particles_w); % E[mean state] = state .* weights (prob.)

end