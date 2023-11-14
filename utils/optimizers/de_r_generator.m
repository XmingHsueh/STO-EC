function population_child = de_r_generator(population_parent,objs_parent,lb,ub)

[popsize,dim] = size(population_parent);
population = (population_parent-repmat(lb,popsize,1))./(repmat(ub,popsize,1)-repmat(lb,popsize,1));
CR = 0.8;
F = 0.5;
population_child = zeros(popsize,dim);

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
    r3 = randi([1,popsize]);
    while (r3==i) || (r3==r1) || (r3==r2)
        r3 = randi([1,popsize]);
    end
    v_mutation = population(r1,:)+F*(population(r2,:)-population(r3,:)); % DE/rand/1
    
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