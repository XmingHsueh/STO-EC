% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is the script of generating the 480 black-box STO problems used in the
% following paper. Alternatively, these problems can be downloaded from the
% following sharepoint: 
% https://portland-my.sharepoint.com/:f:/g/personal/xxiaoming2-c_my_cityu_edu_hk/EkZxYos34ppGoUsaqPsnxgUB5XkMhoMtY1s3_7FYTkP1Sg?e=6iYYdR
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. ¡°How to Utilize Optimization Experience? Revisiting
% Evolutionary Sequential Transfer Optimization", Submitted for Peer Review.

clc,clear
problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'}; % eight task families
transfer_scenarios = {'A','E'}; % intra-family and inter-family transfers
generation_schemes = {'C','U'}; % constrained and unconstrained generations
xis = [0 0.1 0.3 0.7 1]; % the parameter xi that governs optimum coverage
ds = [5 10 20]; % problem dimensions
k = 1000; % the number of solved source tasks
count = 0; % the number of available STO problems

for p = 1:length(problem_families)
    for t = 1:length(transfer_scenarios)
        for s = 1:length(generation_schemes)
            for xi = xis
                for d = ds
                    STOP('func_target',problem_families{p},'trans_sce',transfer_scenarios{t},'gen_scheme',generation_schemes{s},'xi',xi,'dim',d,'mode','gen');
                    count = count+1;
                    fprintf('#%d of the 480 problems is ready!\n',count);
                end
            end
        end
    end
end