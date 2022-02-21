% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% Visualization of the bar graphs of success rates obtained by solver-R and
% six similarity-driven S-ESTOs against solver-N. The corresponding figures are
% shown in Fig. 8 in the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization”, Submitted to IEEE Transactions on Evolutionary Computation.

clc,clear
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % eight problem families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
source_generations = {'C','U'}; % constrained and unconstrained source generations
xis = [0 0.1 0.3 0.7 1]; % the parameter xi that governs optimum coverage
ds = [5 10 20]; % problem dimensions
k = 1000; % the number of solved source instances
metrics = {'N','R','C','M1','KLD','WD','OC','SA'}; % similarity metrics

fig_width = 700;
fig_height = 300;
screen_size = get(0,'ScreenSize');
figure1 = figure('color',[1 1 1],'position',[(screen_size(3)-fig_width)/2, (screen_size(4)-...
    fig_height)/2,fig_width, fig_height]);
for s = 1:length(source_generations)
    count_progress = 0;
    count_total_progress = length(transfer_scenarios)*length(xis)*length(problem_families)*...
        length(ds);
    success_rates = zeros(length(transfer_scenarios),length(xis));
    count_sum = length(problem_families)*length(ds)*(length(metrics)-1);
    for t = 1:length(transfer_scenarios)
        for ix = 1:length(xis)
            for p = 1:length(problem_families)
                for d = ds
                    load(['results-rq1\',problem_families{p},'-',transfer_scenarios{t},'-',...
                        source_generations{s},'-x',num2str(xis(ix)),'-d',num2str(d),'-k',num2str(k),...
                        '-S1+A0.mat']);
                    [~,fits_no] = opt_trace_processing(results_opt);
                    fits_best_no = fits_no(end,:);
                    for m = 2:length(metrics)
                        load(['results-rq1\',problem_families{p},'-',transfer_scenarios{t},'-',...
                            source_generations{s},'-x',num2str(xis(ix)),'-d',num2str(d),'-k',...
                            num2str(k),'-S',num2str(m),'+A0.mat']);
                        [~,fits_metric] = opt_trace_processing(results_opt);
                        fits_best_metric = fits_metric(end,:);
                        p_value = ranksum(fits_best_no,fits_best_metric);
                        if p_value<0.05 && mean(fits_best_no)-mean(fits_best_metric)>0
                            success_rates(t,ix) = success_rates(t,ix)+1;
                        end
                    end
                    count_progress = count_progress+1;
                    clc;
                    fprintf('The %dth bar graph (%d in total) is being plotted. (progress: %.2f%%)\n',...
                        s,length(source_generations),count_progress/count_total_progress*100);
                end
            end
        end
    end
    success_rates = success_rates/count_sum*100;
    subplot(1,length(source_generations),s);
    b = bar(success_rates','FaceColor','flat');
    for z = 1:size(success_rates',2)
        b(z).CData = z;
    end
    set(gca,'linewidth',0.5,'xticklabel',{'0','0.1','0.3','0.7','1'});
    grid on;
    xlabel('$\xi$','interpret','latex','fontsize',12)
    ylabel('Success Rate (\%)','interpret','latex','fontsize',12);
    title(['$\mathcal{G}=',source_generations{s},'$'],'interpret','latex','fontsize',14);
    axis([0.5 5.5 0 100]);
end