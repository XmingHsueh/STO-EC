% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% Visualization of the correlation between similarity and transferability. The
% corresponding figure is shown as Fig. 12 in the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization”, Submitted for Peer Review.

clc,clear
warning off;
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % eight task families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
source_generations = {'U','C'}; % constrained and unconstrained source generations
xis = [0 0.1 0.3 0.7 1]; % the parameter xi that governs the optimum coverage
ds = [5 10 20]; % problem dimensions
k = 1000; % the number of solved source tasks
gen_save = 5; % the specified generation at which the correlation data are collected
metrics = {'N','R','C','M1','KLD','WD','OC','SA'}; % similarity metrics
method_list = [5 1 1 2 5 2;4 1 1 2 5 2]; % algorithm-family-scenario-generation-xi-d
num_methods = size(method_list,1);

fig_width = 700;
fig_height = 300;
screen_size = get(0,'ScreenSize');
figure1 = figure('color',[1 1 1],'position',[(screen_size(3)-fig_width)/2, (screen_size(4)-...
    fig_height)/2,fig_width, fig_height]);
for i = 1:num_methods
    subplot(1,num_methods,i);
    load(['.\results-rq2\corrs\',problem_families{method_list(i,2)},'-',transfer_scenarios{method_list(i,3)},'-',...
        source_generations{method_list(i,4)},'-x',num2str(xis(method_list(i,5))),'-d',num2str(ds(method_list(i,6))),'-k',num2str(k),...
        '-S',num2str(method_list(i,1)),'+A0-corr-gen',num2str(gen_save),'.mat']);
    plot(similarity_values,candidates_quality,'*','linewidth',1,'markersize',10,'color','r');
    set(gca,'linewidth',0.5);
    grid on;
    corr_estimate = corr(similarity_values,candidates_quality);
    xlabel('$s$','interpret','latex','fontsize',14)
    ylabel('$q$','interpret','latex','fontsize',14);
    title(['Generation: 5',', $\rho=',num2str(corr_estimate),'$'],'interpret','latex','fontsize',14)
end