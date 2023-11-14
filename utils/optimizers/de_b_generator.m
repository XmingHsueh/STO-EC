function population_child = de_b_generator(population_parent,objs_parent,lb,ub)

[popsize,dim] = size(population_parent);
population = (population_parent-repmat(lb,popsize,1))./(repmat(ub,popsize,1)-repmat(lb,popsize,1));
CR = 0.8;
F = 0.5;
population_child = zeros(popsize,dim);
[~,idx] = min(objs_parent);
individual_best = population(idx,:);

for i = 1:popsize
    % mutation
    r1 = randi([1,popsize]);
    while(r1==i)
        r1=randi([1,popsize]);
    end
    r2 = randi([1,popsize]);
    while (r2==i) || (r2==r1)
        r2 = randi([1,popsize]);
    end
    v_mutation = individual_best+F*(population(r1,:)-population(r2,:)); % DE/best/1
    
    % crossover
    individual_offspring = zeros(1,dim);
    p = randi([1,dim]);
    for j = 1:dim
        cr = rand;
        if cr<=CR || j==p
            individual_offspring(j) = v_mutation(j);
        else
            individual_offspring(j) = population(i,j);
        end
    end
    
    % boundary check
    individual_offspring(individual_offspring<0) = 0;
    individual_offspring(individual_offspring>1) = 1;
    population_child(i,:) = lb+individual_offspring.*(ub-lb);
end
