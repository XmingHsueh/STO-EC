% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is the entry point of experimentally investigating the
% correlation between similarity values and quality of selected solutions.
% Alternatively, the results of this script can be downloaded from the
% following sharepoint:
% https://portland-my.sharepoint.com/:f:/g/personal/xxiaoming2-c_my_cityu_edu_hk/EoBm1drRIphMgC-YE6j0ldYB3tm3ZSthZtI6JuRMIsHJuw?e=eZ0vci
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “How to Utilize Optimization Experience? Revisiting
% Evolutionary Sequential Transfer Optimization", Submitted for Peer Review.

clc,clear
warning off;
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % eight task families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
generation_schemes = {'C','U'}; % constrained and unconstrained generations
xis = [0 0.1 0.3 0.7 1]; % the parameter xi that governs optimum coverage
ds = [5 10 20]; % problem dimensions
k = 1000; % the number of solved source tasks
optimizer = 'ea'; % evolutionary optimizer
popsize = 20; % population size
FEsMax = 1000; % the number of function evaluations available
opts_sesto.metrics = {'N','R','C','M1','KLD','WD','OC','SA'}; % similarity metrics
opts_sesto.adaptations = {'M1-P','M1-R','M1-M','M2-A','SA-L','OC-L','OC-A','OC-K','OC-N'}; % adaptation models
opts_sesto.gen_trans  =1; % the generation gap of periodically triggering the knowledghe transfer
opts_sesto.gen_save = 5; % the specified generation at which the correlation data are collected
method_list = [4 1 1 1 5 2;5 1 1 1 5 2]; %similarity_metric-family-scenario-generation-xi-d
h=waitbar(0,'Starting'); % process monitor
runs_total = size(method_list,1);
count = 0;

for i =1:size(method_list,1)
    % import the black-box STO problem to be solved
    stop_tbo = STOP('func_target',problem_families{method_list(i,2)},'trans_sce',...
        transfer_scenarios{method_list(i,3)},'gen_scheme',generation_schemes{method_list(i,4)},...
        'xi',xis(method_list(i,5)),'dim',ds(method_list(i,6)),'mode','opt');
    target_task = stop_tbo.target_problem;
    knowledge_base = stop_tbo.knowledge_base;
    problem.fnc = target_task.fnc;
    problem.lb = target_task.lb;
    problem.ub = target_task.ub;

    % parameter configurations of the sesto solver
    opts_sesto.algorithm_id = [method_list(i,1),0]; % selection-based S-ESTO
    opts_sesto.knowledge_base = knowledge_base;
    [~,~,similarity_values,candidates_quality] = sesto_optimizer_corr(problem,popsize,...
        FEsMax,optimizer,opts_sesto);
    count = count + 1;
    waitbar(count/runs_total,h,sprintf('Optimization in progress: %.2f%%',count/runs_total*100));

    % save the results
    save(['.\experimental studies\results-rq2\corrs\',problem_families{method_list(i,2)},'-',...
        transfer_scenarios{method_list(i,3)},'-',generation_schemes{method_list(i,4)},'-x',...
        num2str(xis(method_list(i,5))),'-d',num2str(ds(method_list(i,6))),'-k',num2str(k),...
        '-S',num2str(method_list(i,1)),'+A0-corr-gen',num2str(opts_sesto.gen_save),'.mat'],...
        'similarity_values','candidates_quality');
end