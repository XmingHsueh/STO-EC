% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% Visualization of the radar graphs of performance ranks obtained by
% two baseline solvers and nine adaptation-based S-ESTOs. The 
% corresponding figure is shown in Fig. 15 in the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “How to Utilize Optimization Experience? Revisiting
% Evolutionary Sequential Transfer Optimization", Submitted for Peer Review.

clc,clear
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % eight task families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
generation_scheme = 'U'; % the unconstrained generation
xis = [0 0.1 0.3 0.7 1]; % the parameter xi that governs optimum coverage
d = 20; % the problem dimension
k = 1000; % the number of solved source tasks
adaptations = {'M1-P','M1-R','M1-M','M2-A','SA-L','OC-L','OC-A','OC-K','OC-N'}; % adaptation models

% the problem from which the results to be visualized are collected
idx_family = 1;
ranks = [];

for t = 1:length(transfer_scenarios)
    for ix = 1:length(xis)
        fbest_mean = zeros(1,length(adaptations)+2);
        ranks_single = zeros(1,length(adaptations)+2);
        for m = 1:2
            load(['results-rq1\',problem_families{idx_family},'-',transfer_scenarios{t},'-',...
                generation_scheme,'-x',num2str(xis(ix)),'-d',num2str(d),'-k',...
                num2str(k),'-S',num2str(m),'+A0.mat']);
            [~,fits] = opt_trace_processing(results_opt);
            fits_best = fits(end,:);
            fbest_mean(m) = mean(fits_best);
        end
        for a = 1:length(adaptations)
            load(['results-rq3\',problem_families{idx_family},'-',transfer_scenarios{t},'-',...
                generation_scheme,'-x',num2str(xis(ix)),'-d',num2str(d),'-k',...
                num2str(k),'-S0+A',num2str(a),'.mat']);
            [~,fits] = opt_trace_processing(results_opt);
            fits_best = fits(end,:);
            fbest_mean(a+2) = mean(fits_best);
        end
        for m = 1:length(adaptations)+2
            ranks_single(m) = length(find(fbest_mean<fbest_mean(m)))+1;
        end
        ranks = [ranks;ranks_single];
    end
end

limit=[zeros(10,1),11*ones(10,1)];
colors = [0 0 0;255 0 0;0 255 0;0 0 255;255 255 0;0 255 255;255 0 255;125 0 255;...
    255 125 0;255 0 125;0 125 255]/255;
prefer = limit;
markers = {'o-','+-','*-','x-','s-','d-','^-','v-','>-','<-','p-'};
draw_radar(ranks,limit,prefer,{'$\xi_a=0$','$\xi_a=0.1$','$\xi_a=0.3$','$\xi_a=0.7$',...
    '$\xi_a=1$','$\xi_e=0$','$\xi_e=0.1$','$\xi_e=0.3$','$\xi_e=0.7$','$\xi_e=1$'},colors,markers);