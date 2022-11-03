% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% Visualization of the convergence curves obtained by two baseline solvers 
% and the adaptation-based S-ESTOs.
%
% ------------
% Reference:
% ------------
% X. Xue, C. Yang, L. Feng, et al. ¡°How to Exploit Optimization Experience? Revisiting Evolutionary 
% Sequential Transfer Optimization: Part B - Algorithm Analysis", Submitted for Peer Review.

clc,clear
warning off;
task_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % eight task families
transfer_scenarios = {'a','e'}; % intra-family and inter-family transfers
xis = [0 0.7 1]; % the parameter xi that controls optimum coverage
similarity_distributions = {'c','u','i','d'}; % four representative similarity distributions
k = 1000; % the number of previously-solved source tasks
specifications = [1 1 1 1 50 k; % STOP 1
    2 2 1 2	25 k; % STOP 2
    3 1 1 3	30 k; % STOP 3
    4 2 1 4	50 k; % STOP 4
    5 1 3 3	25 k; % STOP 5
    6 2 3 2	50 k; % STOP 6
    7 1 2 3	25 k; % STOP 7
    8 2 2 4	30 k; % STOP 8
    1 1 3 1	25 k; % STOP 9
    6 2 2 1	30 k; % STOP 10
    5 1 2 1	50 k; % STOP 11
    2 2 3 1	50 k]; % STOP 12
num_problems = size(specifications,1); % the number of individual benchmark problems
baselines  = {'N','R'};
adaptations = {'M1-Ap','M1-Ar','M1-Am','M1-M','M2-A','OC-L','OC-A','OC-K','OC-N',...
    'ROC-L','SA-L'}; % similarity metrics

idx_problem = 11; % the problem from which the results to be visualized are collected
fig_width = 350;
fig_height = 300;
screen_size = get(0,'ScreenSize');
figure1 = figure('color',[1 1 1],'position',[(screen_size(3)-fig_width)/2, (screen_size(4)-...
    fig_height)/2,fig_width, fig_height]);
num_points_plot = 15;
std_level = 0.5;
c_list = [0 0 0;255 0 0;0 255 0;0 0 255;255 255 0;0 255 255;255 0 255;125 0 255;255 125 0;...
    0 125 255;125 255 0;255 0 125;0 255 125]/255;
m_list = ['o','+','*','x','s','d','^','v','p','>','<','h','.'];
for m = 1:length(baselines)
    load(['results-rq1\',task_families{specifications(idx_problem,1)},...
        '-T',transfer_scenarios{specifications(idx_problem,2)},...
        '-xi',num2str(xis(specifications(idx_problem,3))),...
        '-S',similarity_distributions{specifications(idx_problem,4)},...
        '-d',num2str(specifications(idx_problem,5)),...
        '-k',num2str(specifications(idx_problem,6)),...
        '-S-',baselines{m},'+A-N.mat']);
    [FEs,fits] = opt_trace_processing(results_opt);
    idx_retrive = ceil(linspace(1,length(FEs),num_points_plot));
    y = log(mean(fits,2));
    plot(FEs(idx_retrive),y(idx_retrive),'linewidth',1,'color',c_list(m,:),'marker',m_list(m));hold on;
    std_upper = log(mean(fits,2)+std_level*std(fits,1,2));
    std_lower = log(mean(fits,2)-std_level*std(fits,1,2));
    fill([FEs;FEs(end:-1:1)],[std_upper;std_lower(end:-1:1)],c_list(m,:),'facealpha',0.3,...
        'edgecolor',c_list(m,:),'edgecolor','none');
end
for m = 1:length(adaptations)
    load(['results-rq3\',task_families{specifications(idx_problem,1)},...
        '-T',transfer_scenarios{specifications(idx_problem,2)},...
        '-xi',num2str(xis(specifications(idx_problem,3))),...
        '-S',similarity_distributions{specifications(idx_problem,4)},...
        '-d',num2str(specifications(idx_problem,5)),...
        '-k',num2str(specifications(idx_problem,6)),...
        '-S-N+A-',adaptations{m},'.mat']);
    [FEs,fits] = opt_trace_processing(results_opt);
    idx_retrive = ceil(linspace(1,length(FEs),num_points_plot));
    y = log(mean(fits,2));
    plot(FEs(idx_retrive),y(idx_retrive),'linewidth',1,'color',c_list(m+length(baselines),:),...
        'marker',m_list(m+length(baselines)));hold on;
    std_upper = log(mean(fits,2)+std_level*std(fits,1,2));
    std_lower = log(mean(fits,2)-std_level*std(fits,1,2));
    fill([FEs;FEs(end:-1:1)],[std_upper;std_lower(end:-1:1)],c_list(m+length(baselines),:),...
        'facealpha',0.3,'edgecolor',c_list(m+length(baselines),:),'edgecolor','none');
end
set(gca,'linewidth',0.5);
grid on;
xlabel('FEs','interpret','latex','fontsize',12)
ylabel('log$\left(y\right)$','interpret','latex','fontsize',12);
title(['LS: STOP ',num2str(idx_problem),],'interpret','latex','fontsize',14);