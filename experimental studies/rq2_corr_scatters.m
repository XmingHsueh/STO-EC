% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% Visualization of the correlation between similarity and transferability values.
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
methods = [2];

idx_problem = 7; % the problem from which the results to be visualized are collected
fig_width = 350;
fig_height = 300;
screen_size = get(0,'ScreenSize');
figure1 = figure('color',[1 1 1],'position',[(screen_size(3)-fig_width)/2, (screen_size(4)-...
    fig_height)/2,fig_width, fig_height]);
for m = 1:length(methods)
    load(['results-rq2\corrs\',task_families{specifications(idx_problem,1)},...
        '-T',transfer_scenarios{specifications(idx_problem,2)},...
        '-xi',num2str(xis(specifications(idx_problem,3))),...
        '-S',similarity_distributions{specifications(idx_problem,4)},...
        '-d',num2str(specifications(idx_problem,5)),...
        '-k',num2str(specifications(idx_problem,6)),...
        '-S-',metrics{methods(m)},'+A-N-corr-gen.mat']);
    plot(similarity_values,candidates_quality,'x','linewidth',1,'markersize',7,'color','r');
    set(gca,'linewidth',0.5);
    grid on;
    corr_estimate = corr(similarity_values,candidates_quality);
    xlabel('Similarity','interpret','latex','fontsize',14)
    ylabel('Transferability','interpret','latex','fontsize',14);
    title(['Generation: 5',', $\rho=',num2str(corr_estimate),'$'],'interpret','latex','fontsize',14)
end