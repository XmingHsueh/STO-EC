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
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % the eight problem families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
source_generation = 'C'; % unconstrained and constrained source generations
xi = 1; % the parameter xi that governs the optimum coverage
d = 10; % the problem dimensions
k = 1000; % the number of source instances
gen_save = 5;
metrics = {'C','M1','KLD','WD','OC','SA'}; % similarity metrics
problem_plot = [5 1]; % family-scenario

color_list = [0 255 0;0 0 255;255 255 0;0 255 255;255 0 255;125 0 255]/255;
marker_list = ['*','x','s','d','^','v'];
idx_retrive = ceil(linspace(1,50,15));
Gens = 1:50;
un_std = 0.5;
figure1 = figure('color',[1 1 1],'position',[559.6667  322.3333  560.0000  420.0000]);
for i = 1:length(metrics)
    load(['.\results-rq2\cccs\',problem_families{problem_plot(1)},'-',transfer_scenarios{problem_plot(2)},...
        '-',source_generation,'-x',...
        num2str(xi),'-d',num2str(d),'-k',num2str(k),'-S',num2str(i)...
        ,'+A0-coe.mat']);
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