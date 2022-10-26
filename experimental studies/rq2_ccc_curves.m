% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% Visualization of the comprehensive correlation coefficients obtained by
% seven similarity metrics in the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, C. Yang, L. Feng, et al. ¡°How to Exploit Optimization Experience? Revisiting Evolutionary 
% Sequential Transfer Optimization: Part B - Empirical Studies", Submitted for Peer Review.

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
    6 2 2 1	50 k; % STOP 10
    5 1 2 1	25 k; % STOP 11
    2 2 3 1	30 k]; % STOP 12
metrics = {'C','M1','KLD','WD','OC','ROC','SA'}; % similarity metrics

idx_problem = 7; % the problem from which the results to be visualized are collected
fig_width = 350;
fig_height = 300;
screen_size = get(0,'ScreenSize');
figure1 = figure('color',[1 1 1],'position',[(screen_size(3)-fig_width)/2, (screen_size(4)-...
    fig_height)/2,fig_width, fig_height]);
num_points_plot = 15;
c_list = [0 255 0;0 0 255;255 255 0;0 255 255;255 0 255;125 0 255;255 125 0]/255;
m_list = ['*','x','s','d','^','v','p'];
gen_max = 50;
idx_retrive = ceil(linspace(1,gen_max,num_points_plot));
Gens = 1:gen_max;
std_level = 0.5;
for m = 1:length(metrics)
    load(['results-rq2\cccs\',task_families{specifications(idx_problem,1)},...
        '-T',transfer_scenarios{specifications(idx_problem,2)},...
        '-xi',num2str(xis(specifications(idx_problem,3))),...
        '-S',similarity_distributions{specifications(idx_problem,4)},...
        '-d',num2str(specifications(idx_problem,5)),...
        '-k',num2str(specifications(idx_problem,6)),...
        '-S-',metrics{m},'+A-N-ccc.mat']);
    ccc_total = [];
    for j = 1:length(results_corr_history)
        ccc_total = [ccc_total,[0;results_corr_history(j).corrs]];
    end
    ccc_mean = mean(ccc_total,2);
    plot(Gens(idx_retrive),ccc_mean(idx_retrive),'linewidth',1.5,'color',c_list(m,:),'marker',m_list(m));hold on;
    std_upper=ccc_mean+std_level*std(ccc_total,1,2);
    std_lower=ccc_mean-std_level*std(ccc_total,1,2);
    fill([Gens';Gens(end:-1:1)'],[std_upper;std_lower(end:-1:1)],c_list(m,:),'facealpha',0.3,'edgecolor',c_list(m,:),'edgecolor','none');
end
set(gca,'linewidth',0.5);
grid on;
xlabel('Generations','interpret','latex','fontsize',12)
ylabel('$\rho\left(t\right)$','interpret','latex','fontsize',12);
title(['SD: STOP ',num2str(idx_problem)],'interpret','latex','fontsize',14);