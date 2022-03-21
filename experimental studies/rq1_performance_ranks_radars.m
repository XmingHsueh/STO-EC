% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% Visualization of the radar graphs of performance ranks obtained by
% two baseline solvers and six selection-based S-ESTOs. The corresponding
% figure is shown in Fig. 9 in the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “How to Utilize Optimization Experience? Revisiting
% Evolutionary Sequential Transfer Optimization", Submitted for Peer Review.

clc,clear
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % eight task families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
generation_scheme = 'C'; % the constrained generation
xis = [0 0.1 0.3 0.7 1]; % the parameter xi that governs the optimum coverage
d = 10; % the problem dimensions
k = 1000; % the number of source tasks
metrics = {'N','R','C','M1','KLD','WD','OC','SA'}; % similarity metrics

% the problem from which the results to be visualized are collected
idx_family = 1;
ranks = [];

for t = 1:length(transfer_scenarios)
    for ix = 1:length(xis)
        fbest_mean = zeros(1,length(metrics));
        ranks_single = zeros(1,length(metrics));
        for m = 1:length(metrics)
            load(['results-rq1\',problem_families{idx_family},'-',transfer_scenarios{t},'-',...
                generation_scheme,'-x',num2str(xis(ix)),'-d',num2str(d),'-k',...
                num2str(k),'-S',num2str(m),'+A0.mat']);
            [~,fits] = opt_trace_processing(results_opt);
            fits_best = fits(end,:);
            fbest_mean(m) = mean(fits_best);
        end
        for m = 1:length(metrics)
            ranks_single(m) = length(find(fbest_mean<fbest_mean(m)))+1;
        end
        ranks = [ranks;ranks_single];
    end
end

limit=[zeros(10,1),8*ones(10,1)];
colors = [0 0 0;255 0 0;0 255 0;0 0 255;255 255 0;0 255 255;255 0 255;125 0 255;255 125 0]/255;
prefer = limit;
marks = {'o-','-+','*-','-x','-s','-d','-^','-v'};
draw_radar(ranks,limit,prefer,{'$\xi_a=0$','$\xi_a=0.1$','$\xi_a=0.3$','$\xi_a=0.7$',...
    '$\xi_a=1$','$\xi_e=0$','$\xi_e=0.1$','$\xi_e=0.3$','$\xi_e=0.7$','$\xi_e=1$'},colors,marks);