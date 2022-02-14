function [solutions,fitnesses,similarity_values,candidates_quality,ccc] = sesto_optimizer_coe(problem,popsize,FEsMax,optimizer,paras)

% Initialization
metrics = paras.metrics;
gen_trans = paras.gen_trans;
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
ccc = []; %comprehensive correlation coefficient

num_sources = length(knowledge_base); % the number of source problems

while FEsCount < FEsMax

    %% Offspring Generation
    population_old = population;
    fitness_old = fitness;
    [~,idx] = sort(fitness);
    offspring_generation_command = ['population = ',optimizer,'_generator(population(idx,:),lb,ub);'];
    eval(offspring_generation_command); % Generate child population using the specified operator

    %% Similarity-Transferability Correlation
    if mod(gen,gen_trans) == 0
        metric = metrics{algorithm_id(1)};
        [~,~,candidates_transfer,similarity_values] = solution_selection(population_old,fitness_old,lb,ub,gen,knowledge_base,metric);
    end
    fit_candidates_tran = zeros(num_sources,1);
    candidates_quality = zeros(num_sources,1);
    for i = 1:num_sources
        fit_candidates_tran(i) = fun(lb+(ub-lb).*candidates_transfer(i,:));
    end
    for i = 1:num_sources
        candidates_quality(i) = length(find(fit_candidates_tran>fit_candidates_tran(i)));
    end
    ccc_g = corr(similarity_values,candidates_quality);
    ccc = [ccc;ccc_g];

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

end