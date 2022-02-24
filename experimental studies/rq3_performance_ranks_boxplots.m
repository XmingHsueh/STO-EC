% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% Visualization of the boxplots of performance ranks obtained by two
% baseline solvers and nine adaptation-driven S-ESTOs. The corresponding
% figures are shown in Fig. 16 in the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization”, Submitted for Peer Review.

clc,clear
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % eight task families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
source_generation = 'U'; % the unconstrained source generation
xis = [0 0.1 0.3 0.7 1]; % the parameter xi that governs optimum coverage
d = 20; % the problem dimension
k = 1000; % the number of solved source tasks
adaptations = {'M1-P','M1-R','M1-M','M2-A','SA-L','OC-L','OC-A','OC-K','OC-N'}; % adaptation models

ranks = [];
count_progress = 0;
count_total_progress = length(xis)*length(transfer_scenarios)*length(problem_families);
for ix = length(xis):-1:1
    for t = 1:length(transfer_scenarios)
        for p = 1:length(problem_families)
            fbest_mean = zeros(1,length(adaptations)+2);
            ranks_single = zeros(1,length(adaptations)+2);
            for m = 1:2
                load(['results-rq1\',problem_families{p},'-',transfer_scenarios{t},'-',...
                    source_generation,'-x',num2str(xis(ix)),'-d',num2str(d),'-k',...
                    num2str(k),'-S',num2str(m),'+A0.mat']);
                [~,fits] = opt_trace_processing(results_opt);
                fits_best = fits(end,:);
                fbest_mean(m) = mean(fits_best);
            end
            for a = 1:length(adaptations)
                load(['results-rq3\',problem_families{p},'-',transfer_scenarios{t},'-',...
                    source_generation,'-x',num2str(xis(ix)),'-d',num2str(d),'-k',...
                    num2str(k),'-S0+A',num2str(a),'.mat']);
                [~,fits] = opt_trace_processing(results_opt);
                fits_best = fits(end,:);
                fbest_mean(a+2) = mean(fits_best);
            end
            for m = 1:length(adaptations)+2
                ranks_single(m) = length(find(fbest_mean<fbest_mean(m)))+1;
            end
            ranks = [ranks;ranks_single];
            count_progress = count_progress+1;
            clc;
            fprintf('The boxplots are being plotted. (progress: %.2f%%)\n',...
                count_progress/count_total_progress*100);
        end
    end
    if ix == length(xis)
        ranks_xi1 = ranks;
    elseif ix ==1
        ranks_all = ranks;
    end
end

fig_width = 350;
fig_height = 300;
screen_size = get(0,'ScreenSize');
figure1 = figure('color',[1 1 1],'position',[(screen_size(3)-fig_width)/2, (screen_size(4)-...
    fig_height)/2,fig_width, fig_height]);
boxplot(ranks_all,'colors','k','Symbol','b*');
set(gca,'linewidth',0.5);
grid on;
xlabel('Algorithms','interpret','latex','fontsize',12)
ylabel('Performance Ranks','interpret','latex','fontsize',12);
title(['$d=',num2str(d),', \mathcal{G}=',source_generation,'$'],'interpret','latex','fontsize',14);
fig_width = 350;
fig_height = 300;
screen_size = get(0,'ScreenSize');
figure1 = figure('color',[1 1 1],'position',[(screen_size(3)-fig_width)/2, (screen_size(4)-...
    fig_height)/2,fig_width, fig_height]);
boxplot(ranks_xi1,'colors','k','Symbol','b*');
set(gca,'linewidth',0.5);
grid on;
xlabel('Algorithms','interpret','latex','fontsize',12)
ylabel('Performance Ranks','interpret','latex','fontsize',12);
title(['$d=',num2str(d),', \mathcal{G}=',source_generation,', \xi=1$'],...
        'interpret','latex','fontsize',14);