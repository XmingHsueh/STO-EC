% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% The TEA search engine that consists of the plain evolutionary optimizer and
% the solution transfer module.
%
% ------------
% Inputs:
% ------------
% problem--->the target task to be optimized
% popsize--->the population size
% FEsMax--->% the number of function evaluations available
% optimizer--->the name of evolutionary optimizer
% paras--->the parameters or data related to the TEA solver
%
% ------------
% Outputs:
% ------------
% solutions--->solutions for the 1st generation to the last generation
% objs---->objs values of the solutions
%
% ------------
% Reference:
% ------------
% X. Xue, C. Yang, L. Feng, et al. "Solution Transfer in Evolutionary Optimization: An 
% Empirical Study on Sequential Transfer", Submitted for Peer Review.

function [solutions,objs,extras] = transfer_evolutionary_search(problem,popsize,FEsMax,optimizer,paras)

% initialization
fun = problem.fnc;
lb = problem.lb;
ub = problem.ub;
transfer_mode = paras.transfer_mode;
metrics = paras.metrics; % what to transfer
evaluators = paras.evaluators; % when to transfer
adaptations = paras.adaptations; % how to transfer
gen_trans = paras.gen_trans; % the transfer interval in what to transfer and how to transfer
algorithm_id = paras.algorithm_id;
knowledge_base = paras.knowledge_base; % the database containing the evaluated solutions of k source tasks
num_sources = length(knowledge_base); % the number of solved source tasks

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
    repmat(lb,popsize,1)); % convert the solutions into the unified search space
objs{gen} = obj_pop;

% extra output information
switch(transfer_mode)
    case 'When'
        no_trans = round(num_sources/(FEsMax/popsize));
        extras.states = zeros(round((FEsMax/popsize))-1,no_trans);
        extras.gains = zeros(round((FEsMax/popsize))-1,no_trans);
    case 'How'
        extras.qualities = zeros(round((FEsMax/popsize))-1,3);
        sequence = randperm(num_sources);
end

while FEsCount < FEsMax
    
    % offspring generation using the specified operator
    population_parent = population;
    obj_parent = obj_pop;
    offspring_generation_command = ['population_child = ',optimizer,...
        '_generator(population_parent,lb,ub);'];
    eval(offspring_generation_command);
    
    % knowledge transfer
    switch(transfer_mode)
        case 'What'
            if mod(gen,gen_trans) == 0
                metric = metrics{algorithm_id};
                solution_transfer = transferability_prioritization(population_parent,obj_parent,...
                    lb,ub,gen,knowledge_base,metric);
                if ~isempty(solution_transfer)
                    population_child(randi(popsize),:) = solution_transfer;
                end
            end
        case 'When'
            evaluator = evaluators{algorithm_id};
            sequence_trans = randperm(popsize);
            for i = 1:no_trans
                idx_source = (gen-1)*no_trans+i;
                [solution_transfer,state] = transferability_assessment(population_parent,obj_parent,...
                    lb,ub,gen,knowledge_base,idx_source,evaluator);
                extras.states(gen,i) = state;
                idx = sequence_trans(i);
                extras.gains(gen,i) = (-1)*(fun(population_child(idx,:))<=fun(solution_transfer))+...
                    1*(fun(population_child(idx,:))>fun(solution_transfer));
                if state == 1
                    population_child(idx,:) = solution_transfer;
                end
            end
        case 'How'
            if mod(gen,gen_trans) == 0
                adaptation = adaptations{algorithm_id};
                idx_source = sequence(gen);
                solution_unadapted_normalized = knowledge_base(idx_source).solutions{end}(randi(popsize),:);
                solution_transfer = transferability_enhancement(population_parent,obj_parent,lb,...
                    ub,gen,knowledge_base(idx_source),solution_unadapted_normalized,adaptation);
                if ~isempty(solution_transfer)
                    idx = randi(popsize);
                    extras.qualities(gen,:) = [fun(lb+solution_unadapted_normalized.*(ub-lb)), ...
                        fun(solution_transfer), fun(population_child(idx,:))];
                    population_child(idx,:) = solution_transfer;
                end
            end
    end
    
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
    
    % update the record
    solutions{gen} = (population-repmat(lb,popsize,1))./(repmat(ub,popsize,1)-...
        repmat(lb,popsize,1));
    objs{gen} = obj_pop;
    
end
