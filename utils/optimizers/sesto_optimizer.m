% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% The S-ESTO optimizer containing the plain evolutionary optimizer and a
% S-ESTO transfer module.
%
% ------------
% Inputs:
% ------------
% problem--->the target task to be optimized
% popsize--->the population size
% FEsMax--->% the number of function evaluations available
% optimizer--->the name of evolutionary optimizer
% paras--->the parameters or data related to S-ESTO solver
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
% X. Xue, Y. Hu, C. Yang, et al. “How to Utilize Optimization Experience? Revisiting
% Evolutionary Sequential Transfer Optimization", Submitted for Peer Review.

function [solutions,fitnesses] = sesto_optimizer(problem,popsize,FEsMax,optimizer,paras)

% Initialization
metrics = paras.metrics; % the list of similarity metrics in solution selection
adaptations = paras.adaptations; % the list of adaptation models in solution adaptation
gen_trans = paras.gen_trans; % the generation gap of periodically triggering the knowledghe transfer
algorithm_id = paras.algorithm_id; % the S-ESTO algorithm, idxS+idxA
knowledge_base = paras.knowledge_base; % the knowledge base containing the evaluated solutions of k sources
fun = problem.fnc;
lb = problem.lb;
ub = problem.ub;

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

num_sources = length(knowledge_base); % the number of solved source tasks

while FEsCount < FEsMax
    
    % offspring generation using the specified operator
    population_old = population;
    fitness_old = fitness;
    [~,idx] = sort(fitness);
    offspring_generation_command = ['population = ',optimizer,...
        '_generator(population(idx,:),lb,ub);'];
    eval(offspring_generation_command);
    
    % S-ESTO module
    if mod(gen,gen_trans) == 0
        solution_transfer = [];
        if algorithm_id(1)~= 0 && algorithm_id(2)== 0 % similarity-driven S-ESTOs
            metric = metrics{algorithm_id(1)};
            solution_transfer = solution_selection(population_old,fitness_old,lb,ub,gen,...
                knowledge_base,metric);
        elseif algorithm_id(1)== 0 && algorithm_id(2)~= 0 % adaptation-driven S-ESTOs
            adaptation = adaptations{algorithm_id(2)};
            idx_source = randi(num_sources); % randomly select one source task
            solution_unadapted_normalized = knowledge_base(idx_source).solutions{end}...
                (randi(popsize),:);
            solution_transfer = solution_adaptation(population_old,fitness_old,lb,ub,gen,...
                knowledge_base(idx_source),solution_unadapted_normalized,adaptation);
        elseif algorithm_id(1)~= 0 && algorithm_id(2)~= 0 % integration-driven S-ESTOs
            metric = metrics{algorithm_id(1)};
            [solution_unadapted,idx_source]= solution_selection(population_old,fitness_old,...
                lb,ub,gen,knowledge_base,metric);
            adaptation = adaptations{algorithm_id(2)};
            solution_unadapted_normalized = (solution_unadapted-lb)./(ub-lb);
            solution_transfer = solution_adaptation(population_old,fitness_old,lb,ub,gen,...
                knowledge_base(idx_source),solution_unadapted_normalized,adaptation);
        end
        if ~isempty(solution_transfer)
            population(randi(popsize),:) = solution_transfer;
        end
    end
    
    % offspring evaluation
    for i=1:popsize
        fitness(i) = fun(population(i,:));
    end
    FEsCount = FEsCount+popsize;
    gen = gen+1;
    
    % selection phase
    selection_command = ['[population,fitness]=',optimizer,...
        '_selector(population_old,fitness_old,population,fitness);'];
    eval(selection_command)
    
    % update the records
    solutions{gen} = (population-repmat(lb,popsize,1))./(repmat(ub,popsize,1)-...
        repmat(lb,popsize,1));
    fitnesses{gen} = fitness;
    
end