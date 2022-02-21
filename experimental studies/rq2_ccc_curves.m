% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% Visualization of the comprehensive correlation coefficients obtained by six
% similarity metrics. The corresponding figures are shown in Fig. 13 in the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization”, Submitted to IEEE Transactions on Evolutionary Computation.

clc,clear
warning off;
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % eight problem families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
source_generation = 'C'; % the constrained source generation
xi = 1; % the parameter xi that governs the optimum coverage
d = 10; % the problem dimension
k = 1000; % the number of solved source instances
metrics = {'C','M1','KLD','WD','OC','SA'}; % similarity metrics
problem_plot = [5 1]; % the problem from which the results to be visualized are collected, family-scenario 

fig_width = 350;
fig_height = 300;
screen_size = get(0,'ScreenSize');
figure1 = figure('color',[1 1 1],'position',[(screen_size(3)-fig_width)/2, (screen_size(4)-...
    fig_height)/2,fig_width, fig_height]);
color_list = [0 255 0;0 0 255;255 255 0;0 255 255;255 0 255;125 0 255]/255;
marker_list = ['*','x','s','d','^','v'];
idx_retrive = ceil(linspace(1,50,15));
Gens = 1:50;
un_std = 0.5;
for i = 1:length(metrics)
    load(['.\results-rq2\cccs\',problem_families{problem_plot(1)},'-',...
        transfer_scenarios{problem_plot(2)},'-',source_generation,'-x',num2str(xi),'-d',...
        num2str(d),'-k',num2str(k),'-S',num2str(i),'+A0-coe.mat']);
    ccc_total = [];
    for j = 1:length(results_ccc)
        ccc_total = [ccc_total,[0;results_ccc(j).ccc]];
    end
    ccc_mean = mean(ccc_total,2);
    plot(Gens(idx_retrive),ccc_mean(idx_retrive),'linewidth',1,'color',color_list(i,:),'marker',marker_list(i));hold on;
    pp1=ccc_mean+un_std*std(ccc_total,1,2);
    pp2=ccc_mean-un_std*std(ccc_total,1,2);
    fill([Gens';Gens(end:-1:1)'],[pp1;pp2(end:-1:1)],color_list(i,:),'facealpha',0.3,'edgecolor',color_list(i,:),'edgecolor','none');
end
axis([0 50 0 1]);
set(gca,'linewidth',0.5);
grid on;
xlabel('Generations','interpret','latex','fontsize',12)
ylabel('$\rho\left(t\right)$','interpret','latex','fontsize',12);
title('Coefficient curves','interpret','latex','fontsize',14);