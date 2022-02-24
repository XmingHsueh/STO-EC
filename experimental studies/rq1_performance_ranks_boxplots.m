% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% Visualization of the boxplots of performance ranks obtained by
% two baseline solvers and six similarity-driven S-ESTOs. The corresponding
% figures are shown in Fig. 10 in the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization”, Submitted for Peer Review.

clc,clear
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % eight task families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
source_generation = 'C'; % the constrained source generation
xis = [0 0.1 0.3 0.7 1]; % the parameter xi that governs optimum coverage
d = 10; % the problem dimension
k = 1000; % the number of solved source tasks
metrics = {'N','R','C','M1','KLD','WD','OC','SA'}; % similarity metrics

for t = 1:length(transfer_scenarios)
    count_progress = 0;
    count_total_progress = length(xis)*length(problem_families);
    ranks = [];
    for ix = 1:length(xis)
        for p = 1:length(problem_families)
            fbest_mean = zeros(1,length(metrics));
            ranks_single = zeros(1,length(metrics));
            for m = 1:length(metrics)
                load(['results-rq1\',problem_families{p},'-',transfer_scenarios{t},'-',...
                    source_generation,'-x',num2str(xis(ix)),'-d',num2str(d),'-k',...
                    num2str(k),'-S',num2str(m),'+A0.mat']);
                [~,fits] = opt_trace_processing(results_opt);
                fits_best = fits(end,:);
                fbest_mean(m) = mean(fits_best);
            end
            for m = 1:length(metrics)
                ranks_single(m) = length(find(fbest_mean<fbest_mean(m)))+1;
            end
            ranks = [ranks;ranks_single];
            count_progress = count_progress+1;
            clc;
            fprintf('The %dth boxplot (%d in total) is being plotted. (progress: %.2f%%)\n',...
                t,length(transfer_scenarios),count_progress/count_total_progress*100);
        end
    end
    fig_width = 350;
    fig_height = 300;
    screen_size = get(0,'ScreenSize');
    figurex = figure('color',[1 1 1],'position',[(screen_size(3)-fig_width)/2, (screen_size(4)-...
        fig_height)/2,fig_width, fig_height]);
    boxplot(ranks,'colors','k','Symbol','b*');
    set(gca,'linewidth',0.5);
    grid on;
    xlabel('Algorithms','interpret','latex','fontsize',12)
    ylabel('Performance Ranks','interpret','latex','fontsize',12);
    if strcmp(transfer_scenarios{t},'A')
        title('Intra-Family Transfer','interpret','latex','fontsize',14);
    else
        title('Inter-Family Transfer','interpret','latex','fontsize',14);
    end
end