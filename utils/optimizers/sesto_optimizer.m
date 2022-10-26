% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% The S-ESTO optimizer that consists of the plain evolutionary optimizer and
% the solution transfer module.
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
% X. Xue, C. Yang, L. Feng, et al. ¡°How to Exploit Optimization Experience? Revisiting Evolutionary 
% Sequential Transfer Optimization: Part B - Empirical Studies", Submitted for Peer Review.

function [solutions,fitnesses] = sesto_optimizer(problem,popsize,FEsMax,optimizer,paras)

% initialization
fun = problem.fnc;
lb = problem.lb;
ub = problem.ub;
metrics = paras.metrics; % the list of similarity metrics in solution selection
adaptations = paras.adaptations; % the list of adaptation models in solution adaptation
gen_trans = paras.gen_trans; % the generation gap of periodically triggering the knowledghe transfer
algorithm_id = paras.algorithm_id; % the S-ESTO algorithm, idxS+idxA
knowledge_base = paras.knowledge_base; % the knowledge base containing the evaluated solutions of k source tasks
num_sources = length(knowledge_base); % the number of solved source tasks

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

    % the S-ESTO module
    if mod(gen,gen_trans) == 0
        solution_transfer = [];
        if algorithm_id(1)~= 0 && algorithm_id(2)== 0 % selection-based S-ESTO algorithms
            metric = metrics{algorithm_id(1)};
            solution_transfer = solution_selection(population_parent,fitness_parent,lb,ub,gen,...
                knowledge_base,metric);
        elseif algorithm_id(1)== 0 && algorithm_id(2)~= 0 % adaptation-based S-ESTO algorithms
            adaptation = adaptations{algorithm_id(2)};
            idx_source = randi(num_sources); % randomly select one source task
            solution_unadapted_normalized = knowledge_base(idx_source).solutions{end}...
                (randi(popsize),:); % a randomly selected elite source solution
            solution_transfer = solution_adaptation(population_parent,fitness_parent,lb,ub,gen,...
                knowledge_base(idx_source),solution_unadapted_normalized,adaptation);
        elseif algorithm_id(1)~= 0 && algorithm_id(2)~= 0 % integration-based S-ESTO algorithms (S+A)
            metric = metrics{algorithm_id(1)};
            [solution_unadapted,idx_source]= solution_selection(population_parent,fitness_parent,...
                lb,ub,gen,knowledge_base,metric);
            adaptation = adaptations{algorithm_id(2)};
            solution_transfer = solution_adaptation(population_parent,fitness_parent,lb,ub,gen,...
                knowledge_base(idx_source),(solution_unadapted-lb)./(ub-lb),adaptation);
        end
        if ~isempty(solution_transfer)
            population_child(randi(popsize),:) = solution_transfer;
        end
    end

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