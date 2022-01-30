function [solutions,fitnesses] = evolutionary_search(problem,popsize,FEsMax,optimizer)

% Initialization
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

while FEsCount < FEsMax
    
    % Offspring Generation
    population_old = population;
    fitness_old = fitness;
    [~,idx] = sort(fitness);
    offspring_generation_command = ['population = ',optimizer,'_generator(population(idx,:),lb,ub);'];
    eval(offspring_generation_command); % Generate child population using the specified operator
    
    % Offspring Evaluation
    for i=1:popsize
        fitness(i) = fun(population(i,:));
    end
    FEsCount = FEsCount+popsize;
    gen = gen+1;
    
    % Selection
    selection_command = ['[population,fitness]=',optimizer,'_selector(population_old,fitness_old,population,fitness);'];
    eval(selection_command)
    
    % Update the records
    solutions{gen} = (population-repmat(lb,popsize,1))./(repmat(ub,popsize,1)-repmat(lb,popsize,1));
    fitnesses{gen} = fitness;
    
    %     S = ['Algorithm: ',optimizer,', FEs: %d, average fitness: %.2f\n'];
    %     fprintf(S,FEsCount,y_best);
    
end