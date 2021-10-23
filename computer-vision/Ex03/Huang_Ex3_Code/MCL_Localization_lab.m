% 1DOF ROBOT LOCALIZATION IN A CIRCULAR HALLWAY USING A HISTOGRAM FILTER
function MCLLocalization1DOFRobotInTheHallway
    clear all; %close all;
    global frame figure_handle plot_handle firstTime;

    fprintf('Loading the animation data...\n'); 
    load animation;  
    fprintf('Animation data loaded\n');

    % Algorithm parameters
    simpar.circularHallway=1;                               % 1:yes, 0:no
    simpar.animate=1;                                       % 1: Draw the animation of the gaussian. 0: do not draw (speed up the simulation)
    simpar.nSteps=500;                                      % number of steps of the algorithm 
    simpar.domain = 850;                                    % Domain size (in centimeters)
    simpar.xTrue_0=[mod(abs(ceil(simpar.domain*randn(1))), simpar.domain); 20];
    simpar.numberOfParticles = 100;                                             
    simpar.wk_stdev=1;                                      % stddev of the noise used in acceleration to simulate the robot movement.                                      
    simpar.door_locations = [222,326,611];                  % Position of the doors (in centimetres). This is the Map definition.
    simpar.door_stdev=90/4;                                 % +-2sigma of the door observation is assumend to be 90 cm which is the wide of the door
    simpar.odometry_stdev = 2;                              % Odometry uncertainty. Std. deviation of a Gaussian pdf. [cm]
    simpar.T=1;                                             % Simulation sample time

    % Fixe the position of the figure to the up left corner
    % Fixe the size depending on the screen size
    scrsz = get(0,'ScreenSize');
    % figure_handle=figure('Position',[0 0 scrsz(3)/3.5 scrsz(4)]);
    figure_handle=figure(1);

    firstTime=ones(6);

    xTrue_k=simpar.xTrue_0;

    % Initial Robot belief is generated from the uniform distribution 
    belief_particles = random('unif',0,simpar.domain,1,simpar.numberOfParticles);
    disp(belief_particles)
	% The localization algorithm starts here %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

	for k = 1:simpar.nSteps
		 DrawRobot(xTrue_k(1), simpar); %Plots the robot 

		 xTrue_k_1=xTrue_k;
		 xTrue_k=SimulateRobot(xTrue_k_1,simpar);  %Simulates the robot movement   

		 uk=get_odometry(xTrue_k,xTrue_k_1,simpar);                                          
		 zk=get_measurements(xTrue_k(1),xTrue_k_1(1),simpar); % 1 for door 0 for wall

		 fprintf('step=%d,zk=%d uk=%f\n',k,zk,uk); 

		% Aplies the particle filter to localize the robot and draws the
		% particles in the figure
		 belief_particles=MCL(belief_particles,uk,zk,simpar);

    end
end
% The Localization Algorith ends here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Simulate how the robot moves %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xTrue_kNew=SimulateRobot(xTrue_k, simpar)
    %We will need to update the robot position here taking into account the
    %noise in acceleration
    wk=randn(1)*simpar.wk_stdev;
    xTrue_kNew = [1 simpar.T; 0 1]* xTrue_k + [simpar.T^2/2; simpar.T] * wk;

    if simpar.circularHallway,
        % the hallway is assumed to be circular
        xTrue_kNew=mod(xTrue_kNew,simpar.domain);
    else
        % the hallway is assumed to be linear
        if xTrue_kNew(1)>simpar.domain
            xTrue_kNew(1) = simpar.domain-mod(xTrue_kNew(1),simpar.domain);
            xTrue_kNew(2) = -xTrue_kNew(2); % change direction of motion
        end
        if xTrue_kNew(1)<0
            xTrue_kNew(1) = -xTrue_kNew(1);
            xTrue_kNew(2) = -xTrue_kNew(2); % change direction of motion
        end
    end
end

% Simulates the odometry measurements including noise%%%%%%%%%%%%%%%%%%
function uk=get_odometry(xTrue_k,xTrue_k_1,simpar)
%     uk=mod(xTrue_k(1)-xTrue_k_1(1)+simpar.odometry_stdev*randn(1),simpar.domain);
    speed = xTrue_k(1)-xTrue_k_1(1)+simpar.odometry_stdev*randn(1);
    uk = mod(abs(speed), simpar.domain) * sign(speed);
end
    
% Simulates the detection of doors by the robot sensor %%%%%%%%%%%%%%%%
function sensor=get_measurements(xTrue_k,xTrue_k_1,simpar)
    i=1;
    sensor = 0;
    while(i<=length(simpar.door_locations) && sensor ~= 1)
       if ((xTrue_k(1) >= simpar.door_locations(i) && simpar.door_locations(i)>= xTrue_k_1(1)) || (xTrue_k(1) <= simpar.door_locations(i) && simpar.door_locations(i)<= xTrue_k_1(1))) && (abs(xTrue_k(1)-xTrue_k_1(1))<180)
          sensor = 1;
       end  
       i = i + 1;
    end
end

% Draws the robot
function DrawRobot(x, simpar)
    global frame figure_handle

    if simpar.animate
        figure(figure_handle);
        x = mod(x,simpar.domain);
        i=x*332/simpar.domain;

        % keep the frame within the correct boundaries
        if  i<1, i=1; end;
        if i>332, i=332; end;    if  i<1, i=1; end;   

        subplot(6,1,1);
        image(frame(ceil(i)).image);  %axis equal;
    end
    drawnow;
end


% Plots a Gaussian using a bar plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DrawParticles(sp,label,pdf,weight,simpar)
    global firstTime plot_handle figure_handle

    if simpar.animate

        if firstTime(sp)
            figure(figure_handle);
            subplot(6,1,sp);
            firstTime(sp)=0;    
            plot_handle(sp)=scatter(pdf,zeros(1,simpar.numberOfParticles),weight*20+2, 'filled');
            axis([0 simpar.domain -0.1 1]);
            xlabel(label);
        else
            figure(figure_handle);
            subplot(6,1,sp);

            set(plot_handle(sp),'XData',pdf,'YData',zeros(1,simpar.numberOfParticles),'SizeData',weight*20+2);
        end
    end    
end
    
function DrawGaussian(sp,label,pdf_values,simpar)
    global figure_handle

    if simpar.animate
        figure(figure_handle);
        subplot(6,1,sp);
        plot([1:simpar.domain],pdf_values,'-b');
        axis([0 simpar.domain 0 max(pdf_values)]);
        xlabel(label);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%   COMPLETE THESE FUNCTION  %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Aplies the MCL algorithm and plots the results


function updated_belief_particles=MCL(priorbelief_particles,uk,zk,simpar)
% COMPLETE THIS FUNCTION
	% This lines must be replaced by your solution to the MCL localization
	% problem. They are provided only to allow for the execution of the program
	% before solving the lab.
    
    % My code %
    % measurement here means when the robot observer the door (zk = 1), the
    % probability distribution of weights of particles should be looked like
    % that with 3 gaussian distributions in the whole hallway
    measurement_model_particles = zeros(1, simpar.domain);
    measurement_model_particles = measurement_model_particles + pdf('Normal', [1:simpar.domain], simpar.door_locations(1), simpar.door_stdev) + pdf('Normal', [1:simpar.domain], simpar.door_locations(2), simpar.door_stdev) + pdf('Normal', [1:simpar.domain], simpar.door_locations(3), simpar.door_stdev);
    measurement_model_particles = measurement_model_particles / sum(measurement_model_particles); % normalize
    
    % My Code: 3 steps for localization %
    predict_particles = sample_motion_model(uk, priorbelief_particles, simpar); % sample motion model
    weights_particles = measurement_model(zk, predict_particles, measurement_model_particles, simpar); % measurement model
    updated_belief_particles = ReSampling(predict_particles, weights_particles, simpar);% Resampling
    
    % pdf_valus not used
	pdf_values= pdf('unif',[1:simpar.domain],0,simpar.domain); % change this value for the correct one


    % plotting the pdfs for the animation 
    DrawParticles(2,'prior',priorbelief_particles,ones(1,simpar.numberOfParticles),simpar);
    DrawParticles(3,'predict',predict_particles,ones(1,simpar.numberOfParticles),simpar);
    DrawGaussian (4,'measurement model',measurement_model_particles,simpar);
	DrawParticles(5,'Weighted Particles',predict_particles,ones(1,simpar.numberOfParticles), simpar);
    DrawParticles(6,'update',updated_belief_particles,ones(1,simpar.numberOfParticles), simpar);
end

function predict_particles=sample_motion_model(uk,prior_belief_particles,simpar)
% COMPLETE THIS FUNCTION
%     predict_particles=prior_belief; % change this value for the correct one

    % My Code %
    % Each particle have the same speed but different noise
    predict_particles = prior_belief_particles + uk + simpar.odometry_stdev * randn([1,simpar.numberOfParticles]); % move with noise normrnd(0.0,simpar.odometry_stdev); 
end

function particle_weights=measurement_model(zk,pdf_particles,measurement,simpar)
% COMPLETE THIS FUNCTION
    % wk = P( zk | xk ) (Bayes Rules)
    
    % My Code %
    % Calculation of Importance Weights by Normal Distribution
    particle_weights = ones(1,simpar.numberOfParticles); % initialized weights
    [~, n] = size(simpar.door_locations);
    for i = 1 : simpar.numberOfParticles
        % This is my choice of building a distribution for zk and distance
        % between particles and door landmarks, but it does not work well.
        % p = 1.0;
        % for j = 1 : n
        %    dist = abs(pdf_particles(i) - simpar.door_locations(j));
        %    p = p * pdf('Normal', dist/850, 1-zk, simpar.door_stdev);
        % end
            
        % use measurement directly when zk=1
        % the weights would be uniform distribution when zk=0
        if zk == 1
            index = mod(round(pdf_particles(i)), simpar.domain) ;
            if index == 0
                index = simpar.domain;
            end
            particle_weights(i) = particle_weights(i) * measurement(index);
        end
    end
   
    particle_weights = particle_weights ./ sum(particle_weights); % normalize
    
end


function resampled_particals = ReSampling(particles, weights, simpar)
	% My Code %
    N = simpar.numberOfParticles;
    resampled_particals = particles;
    i = 1; % collecting N particles in the next round
    index = 1; % index of current particles
    while i <= N % N samples in total
        if weights(index) > rand % sample from uniform 0-1 and see whether the importance weight is higher
            resampled_particals(i) = particles(index);
            i = i + 1;
        end
        index = mod(index + 1, N); % traverse all particles
        if index == 0
           index = N; 
        end
    end
    
%         Udacity's Implementation using Resampling Wheel
%     beta = 0.0;
%     index = randi([1, N]);
%     mw = max(weights);
%     beta = beta + rand * 2.0 * mw;
%     for i = 1 : N
%         while beta > weights(index)
%             beta = beta - weights(index);
%             index = mod(index + 1, N);
%             if index == 0
%                index = 1; 
%             end
% 
%         end
%         resampled_particals(i) = particles(index);
%     end
    
end
