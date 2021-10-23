function [sampled_particles updated_weights] = resample(particles,particles_w)

N = size(particles,1);

indices = randsample(N, N, true, particles_w); % can sample same indices with true replacement

% resample particles
sampled_particles = particles(indices,:);

% update particles weights
updated_weights = particles_w(indices,:);
updated_weights = updated_weights ./ sum(updated_weights);
end