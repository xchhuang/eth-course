function weights = observe(particles, frame, HeightBB, WidthBB, hist_bin, hist_target, sigma_observe)

N = size(particles,1);
weights = zeros(N,1);

for i = 1 : N
    % compared color histogram for all particles with updated target
    % histogram
    h = color_histogram(particles(i,1)-0.5*WidthBB, particles(i,2)-0.5*HeightBB, particles(i,1)+0.5*WidthBB, particles(i,2)+0.5*HeightBB, frame, hist_bin);
    cost = chi2_cost(h, hist_target);
    weights(i) = ( 1 / (sqrt(2 * pi) * sigma_observe) ) * exp( -cost / (2 * sigma_observe^2) );
end

weights = weights ./ sum(weights); % normalization, sum=1

end