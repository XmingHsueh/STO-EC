% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% The optimizer that monitors the correlation information between 
% similarity and transferability.
%
% ------------
% Inputs:
% ------------
% problem--->the target task to be optimized
% popsize--->the population size
% FEsMax--->% the number of function evaluations available
% optimizer--->the name of evolutionary optimizer
% paras--->the parameters or data related to the S-ESTO solver
%
% ------------
% Outputs:
% ------------
% solutions--->solutions for the 1st generation to the last generation
% fitnesses---->fitness values of the solutions
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “How to Exploit Experience? Revisiting Evolutionary
% Sequential Transfer Optimization: Part B", Submitted for Peer Review.

function [solutions,fitnesses,corr_history] = optimizer_ccc(problem,popsize,FEsMax,optimizer,paras)

% initialization
fun = problem.fnc;
lb = problem.lb;
ub = problem.ub;
metrics = paras.metrics; % the list of similarity metrics in solution selection
gen_trans = paras.gen_trans; % the generation gap of periodically triggering the knowledghe transfer
algorithm_id = paras.algorithm_id; % the S-ESTO algorithm, idxS+idxA
knowledge_base = paras.knowledge_base; % the knowledge base containing the evaluated solutions of k source tasks
num_sources = length(knowledge_base); % the number of solved source tasks
corr_history = [];

solutions = cell(FEsMax/popsize,1);
fitnesses = cell(FEsMax/popsize,1);
population = lhsdesign_modified(popsize,lb,ub); % build an initial population using the LHS sampling
fitness = zeros(popsize,1);
for i=1:popsize % function evaluation
    fitness(i) = fun(population(i,:));
end
FEsCount = popsize;
gen = 1; % the generation count
solutions{gen} = (population-repmat(lb,popsize,1))./(repmat(ub,popsize,1)-...
    repmat(lb,popsize,1)); % convert the solutions into the unified search space
fitnesses{gen} = fitness;

while FEsCount < FEsMax

    % offspring generation using the specified operator
    population_parent = population;
    fitness_parent = fitness;
    offspring_generation_command = ['population_child = ',optimizer,...
        '_generator(population_parent,lb,ub);'];
    eval(offspring_generation_command);

    % calculate the correlation between similarity and transferability
    if mod(gen,gen_trans) == 0
        metric = metrics{algorithm_id(1)};
        [~,~,candidates_transfer,similarity_values] = solution_selection(population_parent,...
            fitness_parent,lb,ub,gen,knowledge_base,metric);
    end
    fit_candidates_tran = zeros(num_sources,1); % fitness values of selected solutions on the target task
    candidates_quality = zeros(num_sources,1); % quality of selected solutions
    for i = 1:num_sources
        fit_candidates_tran(i) = fun(lb+(ub-lb).*candidates_transfer(i,:));
    end
    for i = 1:num_sources
        candidates_quality(i) = length(find(fit_candidates_tran>fit_candidates_tran(i)));
    end
    corr_history = [corr_history;corr(similarity_values,candidates_quality)];

    % offspring evaluation
    fitness_child = zeros(popsize,1);
    for i=1:popsize
        fitness_child(i) = fun(population_child(i,:));
    end
    FEsCount = FEsCount+popsize;
    gen = gen+1;

    % selection phase
    selection_command = ['[population,fitness]=',optimizer,...
        '_selector(population_parent,fitness_parent,population_child,fitness_child);'];
    eval(selection_command)

    % update the records
    solutions{gen} = (population-repmat(lb,popsize,1))./(repmat(ub,popsize,1)-...
        repmat(lb,popsize,1));
    fitnesses{gen} = fitness;

end