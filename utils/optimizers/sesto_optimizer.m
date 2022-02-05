function [solutions,fitnesses] = sesto_optimizer(problem,popsize,FEsMax,optimizer,paras)

% Initialization
metrics = paras.metrics;
adaptations = paras.adaptations;
gen_trans = paras.gen_trans;
n_trans = paras.n_trans;
algorithm_id = paras.algorithm_id;
knowledge_base = paras.knowledge_base;
fun = problem.fnc;
lb = problem.lb;
ub = problem.ub;

solutions = cell(FEsMax/popsize,1);
fitnesses = cell(FEsMax/popsize,1);
population = lhsdesign_modified(popsize,lb,ub); % LHS sampling for initial population
fitness = zeros(popsize,1);
for i=1:popsize
    fitness(i) = fun(population(i,:)); % evaluate the samples
end
FEsCount = popsize;
gen = 1;
solutions{gen} = (population-repmat(lb,popsize,1))./(repmat(ub,popsize,1)-repmat(lb,popsize,1));
fitnesses{gen} = fitness;

num_sources = length(knowledge_base); % the number of source problems

while FEsCount < FEsMax
    
    %% Offspring Generation
    population_old = population;
    fitness_old = fitness;
    [~,idx] = sort(fitness);
    offspring_generation_command = ['population = ',optimizer,'_generator(population(idx,:),lb,ub);'];
    eval(offspring_generation_command); % Generate child population using the specified operator
    
    %% S-ESTO Unit
    if mod(gen,gen_trans) == 0
        
        solution_transfer = [];
        if algorithm_id(1)~= 0 && algorithm_id(2)== 0 % similarity-driven S-ESTOs
            metric = metrics{algorithm_id(1)};
            solution_transfer = solution_selection(population_old,fitness_old,lb,ub,gen,knowledge_base,metric);
        elseif algorithm_id(1)== 0 && algorithm_id(2)~= 0 % adaptation-driven S-ESTOs
            adaptation = adaptations{algorithm_id(2)};
            idx_source = randi(num_sources);
            solution_unadapted = lb+(ub-lb).*knowledge_base(idx_source).solutions{end}(randi(popsize),:);
            solution_transfer = solution_adaptation(population_old,fitness_old,lb,ub,gen,knowledge_base(idx_source),solution_unadapted,adaptation);
        elseif algorithm_id(1)~= 0 && algorithm_id(2)~= 0 % integration of solution selection and solution adaptation
            metric = metrics{algorithm_id(1)};
            [solution_unadapted,idx_source]= solution_selection(population_old,fitness_old,lb,ub,gen,knowledge_base,metric);
            adaptation = adaptations{algorithm_id(2)};
            solution_transfer = solution_adaptation(population_old,fitness_old,lb,ub,gen,knowledge_base(idx_source),solution_unadapted,adaptation);
        end
        
        if ~isempty(solution_transfer)
            population(randi(popsize),:) = solution_transfer;
        end
        
    end
    
    %% Offspring Evaluation
    for i=1:popsize
        fitness(i) = fun(population(i,:));
    end
    FEsCount = FEsCount+popsize;
    gen = gen+1;
    
    %% Selection
    selection_command = ['[population,fitness]=',optimizer,'_selector(population_old,fitness_old,population,fitness);'];
    eval(selection_command)
    
    %% Update the records
    solutions{gen} = (population-repmat(lb,popsize,1))./(repmat(ub,popsize,1)-repmat(lb,popsize,1));
    fitnesses{gen} = fitness;
    
    %     S = ['Algorithm: ',optimizer,', FEs: %d, average fitness: %.2f\n'];
    %     fprintf(S,FEsCount,y_best);
    
end