% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% The traditional evolutionary search engine without knowledge transfer.
%
% ------------
% Inputs:
% ------------
% problem--->the problem to be optimized
% FEsMax--->% the number of function evaluations available
% optimizer--->the name of population-based optimizer
%
% ------------
% Outputs:
% ------------
% solutions--->solutions for the 1st generation to the last generation
% objs---->objective values of the solutions 

function [solutions,objs] = evolutionary_search(problem,FEsMax,optimizer)

% initialization
popsize = 50;
fun = problem.fnc;
lb = problem.lb;
ub = problem.ub;
solutions = cell(FEsMax/popsize,1);
objs = cell(FEsMax/popsize,1);
population = lhsdesign_modified(popsize,lb,ub); % build an initial population using the LHS sampling
obj_pop = zeros(popsize,1);
for i=1:popsize % function evaluation
    obj_pop(i) = fun(population(i,:));
end
FEsCount = popsize;
gen = 1; % the generation count
solutions{gen} = (population-repmat(lb,popsize,1))./(repmat(ub,popsize,1)-...
    repmat(lb,popsize,1)); % convert the solutions into the common search space
objs{gen} = obj_pop;

while FEsCount < FEsMax
    
    % offspring generation using the specified operator
    population_parent = population;
    obj_parent = obj_pop;
    offspring_generation_command = ['population_child = ',optimizer,...
        '_generator(population_parent,lb,ub);'];
    eval(offspring_generation_command);
    
    % offspring evaluation
    obj_child = zeros(popsize,1);
    for i=1:popsize
        obj_child(i) = fun(population_child(i,:));
    end
    FEsCount = FEsCount+popsize;
    gen = gen+1;
    
    % selection phase
    selection_command = ['[population,obj_pop]=',optimizer,...
        '_selector(population_parent,obj_parent,population_child,obj_child);'];
    eval(selection_command)
    
    % update the records
    solutions{gen} = (population-repmat(lb,popsize,1))./(repmat(ub,popsize,1)-...
        repmat(lb,popsize,1));
    objs{gen} = obj_pop;
    
end