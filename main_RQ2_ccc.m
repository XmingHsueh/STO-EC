% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is the entry point of experimentally investigating the
% comprehensive correlation coefficients obtained by six similarity-driven S-ESTOs.
% Alternatively, the results of this script can be downloaded from the
% following sharepoint:
% https://portland-my.sharepoint.com/:f:/g/personal/xxiaoming2-c_my_cityu_edu_hk/EuGmdbJ7ewtOgZfgZ6XbKtkB-4gTt1thQrAmyV7ZggAo-g?e=DxxIKk
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization”, Submitted for Peer Review.

clc,clear
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % eight task families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
source_generation = 'C'; % constrained source generation
xi = 1; % the parameter xi that governs optimum coverage
d = 10; % the problem dimension
k = 1000; % the number of source tasks
optimizer = 'ea'; % evolutionary optimizer
popsize = 20; % population size
FEsMax = 1000; % the number of function evaluations available
runs = 30; % the number of independent runs
opts_sesto.metrics = {'C','M1','KLD','WD','OC','SA'}; % similarity metrics
opts_sesto.adaptations = {'M1-P','M1-R','M1-M','M2-A','SA-L','OC-L','OC-A','OC-K','OC-N'}; % adaptation models
opts_sesto.gen_trans  =1; % the generation gap for periodically triggering the knowledghe transfer
algorithm_list = [transpose(1:length(opts_sesto.metrics)),zeros(length(opts_sesto.metrics),1)]; % similarty-driven S-ESTOs
% [algorithm naming rule: idxS-idxA, while 0 denotes random selection or no adaptation]
% examples: [4 0] denotes a similarity-driven S-ESTO equipped with the metric S-M1
% [0 4] denotes an adaptation-driven S-ESTO equipped with the adaptation A-M2-A
% [6 7] denotes an integration-driven S-ESTO equipped with S-WD and A-OC-A
h=waitbar(0,'Starting'); % process monitor
runs_total = size(algorithm_list,1)*length(problem_families)*length(transfer_scenarios)*runs;
count = 0;

for a = 1:size(algorithm_list,1)
    for p = 1:length(problem_families)
        for t = 1:length(transfer_scenarios)
            results_ccc = struct;
            for r = 1:runs
                % import the sesto problem to be optimized
                sestop_tbo = SESTOP('func_target',problem_families{p},'trans_sce',...
                    transfer_scenarios{t},'source_gen',source_generation,'xi',xi,'dim',d,'mode','opt');
                target_task = sestop_tbo.target_problem;
                knowledge_base = sestop_tbo.knowledge_base;
                problem.fnc = target_task.fnc;
                problem.lb = target_task.lb;
                problem.ub = target_task.ub;

                % parameter configurations of the sesto solver
                opts_sesto.algorithm_id = algorithm_list(a,:);
                opts_sesto.knowledge_base = knowledge_base;
                [~,~,ccc_run] = sesto_optimizer_ccc(problem,popsize,...
                    FEsMax,optimizer,opts_sesto);
                results_ccc(r).ccc = ccc_run;
                count = count + 1;
                
                waitbar(count/runs_total,h,sprintf('Optimization in progress: %.2f%%',...
                    count/runs_total*100));
            end
            % save the results
            save(['.\experimental studies\results-rq2\cccs\',problem_families{p},'-',...
                transfer_scenarios{t},'-',source_generation,'-x',num2str(xi),'-d',num2str(d),...
                '-k',num2str(k),'-S',num2str(algorithm_list(a,1)),'+A0-coe.mat'],'results_ccc');
        end
    end
end