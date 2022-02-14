% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is the entry point of experimentally investigating the
% comprehensive correlation coefficients obtained by the six similarity
% metrics on 10D problems with constrainedly generated sources under
% xi=1.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization”, Submitted to IEEE Transactions on Evolutionary Computation.

clc,clear
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % the eight problem families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
source_generation = 'C'; % unconstrained and constrained source generations
xi = 1; % the parameter xi that governs the optimum coverage
d = 10; % the problem dimensions
k = 1000; % the number of source instances
optimizer = 'ea';
popsize = 20;
FEsMax = 1000;
runs = 30;
opts_sesto.metrics = {'C','M1','KLD','WD','OC','SA'};
opts_sesto.adaptations = {'M1-P','M1-R','M1-M','M2-A','SA-L','OC-L','OC-A','OC-K','OC-N'};
opts_sesto.gen_trans  =1;
algorithm_list = [transpose(1:length(opts_sesto.metrics)),zeros(length(opts_sesto.metrics),1)]; % similarty-driven S-ESTOs
h=waitbar(0,'Starting');
runs_total = size(algorithm_list,1)*length(problem_families)*length(transfer_scenarios)*runs;
count = 0;

for a = 1:length(algorithm_list)
    for p = 1:length(problem_families)
        for t = 1:length(transfer_scenarios)
            results_ccc = struct;
            for r = 1:runs
                % import the sesto problem to be optimized
                sestop_tbo = SESTOP('func_target',problem_families{p},'trans_sce',transfer_scenarios{t},...
                    'source_gen',source_generation,'xi',xi,'dim',d,'mode','opt');
                target_task = sestop_tbo.target_problem;
                knowledge_base = sestop_tbo.knowledge_base;

                % parameter configurations of the sesto solver
                problem.fnc = target_task.fnc;
                problem.lb = target_task.lb;
                problem.ub = target_task.ub;
                opts_sesto.algorithm_id = algorithm_list(a,:);
                opts_sesto.knowledge_base = knowledge_base;
                [~,~,~,~,ccc_run] = sesto_optimizer_coe(problem,popsize,...
                    FEsMax,optimizer,opts_sesto);
                results_ccc(r).ccc = ccc_run;
                count = count + 1;
                waitbar(count/runs_total,h,sprintf('Optimization in progress: %.2f%%',count/runs_total*100));
            end
            % save the results
            save(['.\experimental studies\results-rq2\cccs\',problem_families{p},'-',transfer_scenarios{t},'-',...
                source_generation,'-x',num2str(xi),'-d',num2str(d),'-k',num2str(k),...
                '-S',num2str(algorithm_list(a,1)),'+A0-coe.mat'],'results_ccc');
        end
    end
end