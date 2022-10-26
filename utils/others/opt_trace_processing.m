% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is a post-processing function that converts the optimization
% data into vectorial optimization trace.
%
% ------------
% Inputs:
% ------------
% opt_history--->all the solutions and their fitness values from 1st generation to the last generation
% 
% ------------
% Outputs:
% ------------
% FEs--->function evaluations consumed, size: GÃ—1, where G denotes the maximum generation
% Fits--->the best fitness values ever found, size: GÃ—R, where R is the number of independent runs
%
% ------------
% Reference:
% ------------
% X. Xue, C. Yang, L. Feng, et al. ¡°How to Exploit Optimization Experience? Revisiting Evolutionary 
% Sequential Transfer Optimization: Part B - Empirical Studies", Submitted for Peer Review.

function [FEs,Fits] = opt_trace_processing(opt_history)
num_runs = length(opt_history);
gen_max = length(opt_history(1).solutions);
popsize = size(opt_history(1).solutions{1},1);
FEs = transpose(popsize:popsize:gen_max*popsize);
Fits = zeros(gen_max,num_runs);
for r = 1:num_runs
    solutions = opt_history(r).solutions;
    fitnesses = opt_history(r).fitnesses;
    fit_best = inf;
    for g = 1:length(solutions)
        fit_best_gen = min(fitnesses{g});
        if fit_best_gen < fit_best
            fit_best = fit_best_gen;
        end
        Fits(g,r) = fit_best;
    end
end