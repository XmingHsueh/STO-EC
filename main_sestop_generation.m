% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is the script of generating the 480 S-ESTO problems used in the
% following paper. Alternatively, these problems can be downloaded from the
% following sharepoint: 
% https://portland-my.sharepoint.com/:f:/g/personal/xxiaoming2-c_my_cityu_edu_hk/EkZxYos34ppGoUsaqPsnxgUB5XkMhoMtY1s3_7FYTkP1Sg?e=audj0S
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. ¡°Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization¡±, Submitted to IEEE Transactions on Evolutionary Computation.

clc,clear
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % the eight problem families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
source_generations = {'U','C'}; % unconstrained and constrained source generations
xis = [0 0.1 0.3 0.7 1]; % the parameter xi that governs the optimum coverage
ds = [5 10 20]; % the problem dimensions
k = 1000; % the number of source instances
count = 0; % the number of available S-ESTO problems

for p = 1:length(problem_families)
    for t = 1:length(transfer_scenarios)
        for s = 1:length(source_generations)
            for xi = xis
                for d = ds
                    SESTOP('func_target',problem_families{p},'trans_sce',transfer_scenarios{t},'source_gen',source_generations{s},'xi',xi,'dim',d,'mode','gen');
                    count = count+1;
                    fprintf('#%d of the 480 S-ESTO problems is ready!\n',count);
                end
            end
        end
    end
end