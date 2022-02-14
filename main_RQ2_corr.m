% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is the entry point of experimentally investigating the
% correlation between similarity values and quality of selected solutions
% to be transferred.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization”, Submitted to IEEE Transactions on Evolutionary Computation.

clc,clear
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % the eight problem families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
source_generations = {'U','C'}; % unconstrained and constrained source generations
xis = [0 0.1 0.3 0.7 1]; % the parameter xi that governs the optimum coverage
ds = [5 10 20]; % the problem dimensions
k = 1000; % the number of source instances
optimizer = 'ea';
popsize = 20;
FEsMax = 1000;
opts_sesto.metrics = {'N','R','C','M1','KLD','WD','OC','SA'};
opts_sesto.adaptations = {'M1-P','M1-R','M1-M','M2-A','SA-L','OC-L','OC-A','OC-K','OC-N'};
opts_sesto.gen_trans  =1;
opts_sesto.gen_save = 5;
method_list = [4 1 1 2 5 2;5 1 1 2 5 2]; % algorithm-family-scenario-generation-xi-d
h=waitbar(0,'Starting');
runs_total = size(method_list,1);
count = 0;


for i =1:size(method_list,1)
    % import the sesto problem to be optimized
    sestop_tbo = SESTOP('func_target',problem_families{method_list(i,2)},'trans_sce',transfer_scenarios{method_list(i,3)},...
        'source_gen',source_generations{method_list(i,4)},'xi',xis(method_list(i,5)),'dim',ds(method_list(i,6)),'mode','opt');
    target_task = sestop_tbo.target_problem;
    knowledge_base = sestop_tbo.knowledge_base;

    % parameter configurations of the sesto solver
    problem.fnc = target_task.fnc;
    problem.lb = target_task.lb;
    problem.ub = target_task.ub;
    opts_sesto.algorithm_id = [method_list(i,1),0];
    opts_sesto.knowledge_base = knowledge_base;
    [~,~,similarity_values,candidates_quality] = sesto_optimizer_corr(problem,popsize,...
        FEsMax,optimizer,opts_sesto);
    count = count + 1;
    waitbar(count/runs_total,h,sprintf('Optimization in progress: %.2f%%',count/runs_total*100));

    % save the results
    save(['.\experimental studies\results-rq2\corrs\',problem_families{method_list(i,2)},'-',transfer_scenarios{method_list(i,3)},'-',...
        source_generations{method_list(i,4)},'-x',num2str(xis(method_list(i,5))),'-d',num2str(ds(method_list(i,6))),'-k',num2str(k),...
        '-S',num2str(method_list(i,1)),'+A0-corr-gen',num2str(opts_sesto.gen_save),'.mat'],...
        'similarity_values','candidates_quality');
end