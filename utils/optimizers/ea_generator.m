function [Child,extras] = ea_generator(Parent,lb,ub)
popsize = size(Parent,1);
dim = size(Parent,2);
population = (Parent-repmat(lb,popsize,1))./(repmat(ub,popsize,1)-repmat(lb,popsize,1));
mu = 15;     % index of Simulated Binary Crossover (tunable)
mum = 15;    % index of polynomial mutation
probswap = 0.5; % probability of variable swap

indorder = randperm(popsize);
Child = zeros(popsize,dim);

% Offspring generation
for i=1:popsize/2
    
    p1 = indorder(i); % Parent 1
    p2 = indorder(i+(popsize/2)); % Parent 2
    
    u = rand(1,dim);
    cf = zeros(1,dim);
    cf(u<=0.5)=(2*u(u<=0.5)).^(1/(mu+1));
    cf(u>0.5)=(2*(1-u(u>0.5))).^(-1/(mu+1));
    
    % Crossover
    pp1 = population(p1,:);
    pp2 = population(p2,:);
    child1 = 0.5*((1+cf).*pp1 + (1-cf).*pp2);
    child1(child1<0) = 0;
    child1(child1>1) = 1;
    pp1 = population(p2,:);
    pp2 = population(p1,:);
    child2 = 0.5*((1+cf).*pp1 + (1-cf).*pp2);
    child2(child2<0) = 0;
    child2(child2>1) = 1;
    
    % Mutation
    temp1 = child1;
    for j=1:dim
        if rand(1)<1/dim
            u=rand(1);
            if u <= 0.5
                del=(2*u)^(1/(1+mum)) - 1;
                temp1(j)=child1(j) + del*(child1(j));
            else
                del= 1 - (2*(1-u))^(1/(1+mum));
                temp1(j)=child1(j) + del*(1-child1(j));
            end
        end
    end

    child1 = temp1;
    child1(child1<0) = 0;
    child1(child1>1) = 1;
    temp2 = child2;
    for j=1:dim
        if rand(1)<1/dim
            u=rand(1);
            if u <= 0.5
                del=(2*u)^(1/(1+mum)) - 1;
                temp2(j)=child2(j) + del*(child2(j));
            else
                del= 1 - (2*(1-u))^(1/(1+mum));
                temp2(j)=child2(j) + del*(1-child2(j));
            end
        end
    end
    child2 = temp2;
    child2(child2<0) = 0;
    child2(child2>1) = 1;
    
    % variable swap (uniform X)
    swap_indicator = (rand(1,dim) >= probswap);
    temp = child2(swap_indicator);
    child2(swap_indicator) = child1(swap_indicator);
    child1(swap_indicator) = temp;
    
    Child(i,:) = lb+child1.*(ub-lb);
    Child(i+popsize/2,:) = lb+child2.*(ub-lb);
end
extras = [];