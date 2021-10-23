% exercise: condensation tracker

load('..\data\params.mat');
% video1
videoName = 'video1';
params.draw_plots = 1;
params.hist_bin = 16 % smalle hist bins
params.alpha = 1; % alpha=1 is better
params.sigma_observe = 3; % sigma of observe noise equal to 3 is better
params.model = 0;
params.sigma_velocity = 1;
params.num_particles = 300;
params.sigma_position = 15;
params.initial_velocity = [1,8];

% video2
% how to track the center of hand
% videoName = 'video2';
% params.draw_plots = 1;
% params.hist_bin = 16;
% params.alpha = 0.1; % alpha=0 is better
% params.sigma_observe = 3; % sigma of observe noise equal to 3 is better
% params.model = 0;
% params.sigma_velocity = 1;
% params.num_particles = 300;
% params.sigma_position = 15;
% params.initial_velocity = [16,1];

% video3
% how to track the center of hand
% videoName = 'video3';
% params.draw_plots = 1;
% params.hist_bin = 16;
% params.alpha = 0.1; % alpha=0 is better
% params.sigma_observe = 3; % sigma of observe noise equal to 3 is better
% params.model = 1;
% params.sigma_velocity = 1;
% params.num_particles = 300;
% params.sigma_position = 15;
% params.initial_velocity = [8,0]; % the velocity should not be too high

% videoName = 'video_bonus_compressed';
% params.draw_plots = 1;
% params.hist_bin = 16; % smalle hist bins
% params.alpha = 0.9; % alpha=1 is better
% params.sigma_observe = 5; % sigma of observe noise equal to 3 is better
% params.model = 1;
% params.sigma_velocity = 1;
% params.num_particles = 300;
% params.sigma_position = 15;
% params.initial_velocity = [16,16];

% run condensation algorithm
condensationTracker(videoName, params);


