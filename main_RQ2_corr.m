% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is the entry point of experimentally investigating the
% correlation between similarity values and quality of selected solutions.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “How to Exploit Experience? Revisiting Evolutionary
% Sequential Transfer Optimization: Part B", Submitted for Peer Review.

clc,clear
warning off;
task_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % eight task families
transfer_scenarios = {'a','e'}; % intra-family and inter-family transfers
xis = [0 0.7 1]; % the parameter xi that determines optimum coverage
similarity_distributions = {'c','u','i','d'}; % four representative similarity distributions
k = 1000; % the number of previously-solved source tasks
no_problems = 12; % the number of individual benchmark problems
folder_problems = '.\benchmarks';
specifications = [1 1 1 1 50 k; % STOP 1
    2 2 1 2	25 k; % STOP 2
    3 1 1 3	30 k; % STOP 3
    4 2 1 4	50 k; % STOP 4
    5 1 2 1	50 k; % STOP 5
    6 2 2 2	30 k; % STOP 6
    7 1 2 3	25 k; % STOP 7
    8 2 2 4	30 k; % STOP 8
    1 1 3 1	25 k; % STOP 9
    6 2 3 2	50 k; % STOP 10
    5 1 3 3	25 k; % STOP 11
    2 2 3 4	30 k]; % STOP 12
num_problems = size(specifications,1);
idx_problem = 11;
optimizer = 'ea'; % evolutionary optimizer
popsize = 50; % population size
FEsMax = 2500; % the number of function evaluations available
runs = 30; % the number of independent runs
opts_sesto.metrics = {'N','R','C','M1','WD','OC','ROC','KLD','SA'}; % similarity metrics
opts_sesto.adaptations = {'M1-Ap','M1-Ar','M1-Am','M1-M','M2-A','OC-L','OC-A',...
    'OC-K','OC-N','ROC-L','SA-L'}; % adaptation models
opts_sesto.gen_trans  =1; % the generation gap of periodically triggering the knowledghe transfer
algorithm_list = [4 0;8 0]; % selection-based S-ESTO algorithms
% [naming rule of an S-ESTO algorithm: idxS-idxA, while 0 is random selection or no adaptation]
% examples: [4 0] denotes a selection-based S-ESTO equipped with the metric S-M1
% [0 4] denotes an adaptation-based S-ESTO equipped with the adaptation A-M2-A
% [6 7] denotes an integration-based S-ESTO equipped with S-WD and A-OC-A
h=waitbar(0,'Starting'); % process monitor
runs_total = size(algorithm_list,1);
count = 0;

for i =1:size(algorithm_list,1)
    % import the black-box STO problem to be solved
    stop_tbo = STOP('func_target',task_families{specifications(idx_problem,1)},'trans_sce',...
        transfer_scenarios{specifications(idx_problem,2)},'xi',xis(specifications(idx_problem,3)),...
        'sim_distribution',similarity_distributions{specifications(idx_problem,4)},'dim',...
        specifications(idx_problem,5),'k',specifications(idx_problem,6),'mode','opt',...
        'folder_stops',folder_problems);
    target_task = stop_tbo.target_problem;
    knowledge_base = stop_tbo.knowledge_base;
    problem.fnc = target_task.fnc;
    problem.lb = target_task.lb;
    problem.ub = target_task.ub;

    % parameter configurations of the sesto solver
    opts_sesto.algorithm_id = [algorithm_list(i,1),algorithm_list(i,2)]; % selection-based S-ESTO
    opts_sesto.knowledge_base = knowledge_base;
    [~,~,similarity_values,candidates_quality] = optimizer_corr(problem,popsize,...
        FEsMax,optimizer,opts_sesto);
    count = count + 1;
    waitbar(count/runs_total,h,sprintf('In progress: %.2f%%',count/runs_total*100));

    % save the results
    save(['.\experimental studies\results-rq2\corrs\',task_families{specifications(idx_problem,1)},...
        '-T',transfer_scenarios{specifications(idx_problem,2)},'-xi',...
        num2str(xis(specifications(idx_problem,3))),'-S',...
        similarity_distributions{specifications(idx_problem,4)},'-d',...
        num2str(specifications(idx_problem,5)),'-k',num2str(specifications(idx_problem,6)),...
        '-S-',opts_sesto.metrics{algorithm_list(i,1)},'+A-N-corr-gen.mat'],...
        'similarity_values','candidates_quality');
end