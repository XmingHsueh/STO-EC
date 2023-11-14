% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is the entry point of experimentally comparing various domain
% adaptation models for enhancing the transferability in how to transfer.
%
% ------------
% Reference:
% ------------
% X. Xue, C. Yang, L. Feng, et al. "Solution Transfer in Evolutionary Optimization: An
% Empirical Study on Sequential Transfer", Submitted for Peer Review.

clc,clear
warning off;
task_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % eight task families
transfer_scenarios = {'a','e'}; % intra-family and inter-family transfers
similarity_distributions = {'h1','h2','m1','m2','m3','m4','l1','l2'}; % eight similarity distributions
k = 100; % the number of source tasks
folder_problems = '.\benchmarks-ea-k100'; % the folder that stores the test problems
specifications = [1 1 1 50 k; % STOP 1
    2 2 2 25 k; % STOP 2
    3 1 2 30 k; % STOP 3
    4 2 1 50 k; % STOP 4
    5 1 3 25 k; % STOP 5
    6 2 4 50 k; % STOP 6
    7 1 5 25 k; % STOP 7
    8 2 6 30 k; % STOP 8
    1 1 7 25 k; % STOP 9
    6 2 8 30 k; % STOP 10
    5 1 8 50 k; % STOP 11
    2 2 7 50 k]; % STOP 12
num_problems = size(specifications,1);
optimizer = 'ea'; % evolutionary optimizer
popsize = 50; % population size
FEsMax = 5000; % the number of function evaluations available
runs = 30; % the number of independent runs
opts_sesto.transfer_mode = 'How'; %{'What','When','How'};
opts_sesto.metrics = {'N','Ra','H','M1','WD','OC','ROC','KLD','SA'}; % two baselines and seven transferability measurements
opts_sesto.evaluators = {'N','Re','F-1','F-5','F-10','D-M','D-P','D-G'}; % two baselines and six transferability evaluators
opts_sesto.adaptations = {'N','Rh','M1-Te','M1-Tr','M1-Tm','M1-M','M2-A','OC-L','OC-A','OC-K','OC-N','ROC-L','SA-L'}; % two baselines and eleven transferability enhancers
opts_sesto.gen_trans  = 1; % the transfer interval in what to transfer and how to transfer
algorithm_list = 1:length(opts_sesto.adaptations);
h=waitbar(0,'Starting'); % process monitor
runs_total = length(algorithm_list)*num_problems*runs;
count = 0*num_problems*runs*length(algorithm_list);

for n = 1:num_problems
    results_opt = struct;
    % import the STOP to be solved
    stop_tbo = STOP('func_target',task_families{specifications(n,1)}, ...
        'trans_sce',transfer_scenarios{specifications(n,2)},...
        'sim_distribution',similarity_distributions{specifications(n,3)}, ...
        'dim',specifications(n,4),...
        'k',specifications(n,5), ...
        'mode','opt',...
        'folder_stops',folder_problems);
    target_task = stop_tbo.target_problem;
    knowledge_base = stop_tbo.knowledge_base;
    problem.fnc = target_task.fnc;
    problem.lb = target_task.lb;
    problem.ub = target_task.ub;
    for r = 1:runs
        solutions_all = cell(FEsMax/popsize,length(algorithm_list));
        objs_all = cell(FEsMax/popsize,length(algorithm_list));
        qualities_all = cell(1,length(algorithm_list));
        for m = 1:length(algorithm_list)
            % parameter configurations of the TEA search engine
            opts_sesto.algorithm_id = algorithm_list(m);
            opts_sesto.knowledge_base = knowledge_base;
            [solutions,objs,extras] = transfer_evolutionary_search(problem,popsize,FEsMax,...
                optimizer,opts_sesto);
            solutions_all(:,m) = solutions;
            objs_all(:,m) = objs;
            qualities_all{m} = extras.qualities;
            count = count+1;
            fprintf(['Algorithm: ','How-',opts_sesto.adaptations{algorithm_list(m)},', STOP-',num2str(n),', run: ',num2str(r),'\n']);
            waitbar(count/runs_total,h,sprintf('Optimization in progress: %.2f%%',count/runs_total*100));
        end
        results_opt(r).solutions = solutions_all;
        results_opt(r).objs = objs_all;
        results_opt(r).qualities = qualities_all;
    end
    % save the results
    save(['.\experimental studies\results-how-opt-k100\',task_families{specifications(n,1)},'-T',...
        transfer_scenarios{specifications(n,2)},'-S',similarity_distributions{specifications(n,3)},...
        '-d',num2str(specifications(n,4)),'-k',num2str(specifications(n,5)),'-how.mat'],'results_opt');
end
close(h);
