% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% The solution selection function in S-ESTO.
%
% ------------
% Inputs:
% ------------
% target_population--->the target population at the current generation
% target_fitness--->the fitness values of the current individuals
% lb--->the lower bound of the target task
% ub--->the upper bound of the target task
% gen--->the current generation
% knowledge_base--->the knowledge base containing the evaluated solutions of k source tasks
% method--->the solution selection method
%
% ------------
% Outputs:
% ------------
% solution_sel--->the selected solution to be adapted or transferred
% idx_source--->the index of the selected source task
% candidates_transfer--->the candidate transferrable solutions provided by k source tasks
% simlarity_values--->the similarity values between k source tasks and the target task
%
% ------------
% Reference:
% ------------
% X. Xue, C. Yang, L. Feng, et al. ¡°How to Exploit Optimization Experience? Revisiting Evolutionary 
% Sequential Transfer Optimization: Part B - Empirical Studies", Submitted for Peer Review.

function [solution_sel,idx_source,candidates_transfer,simlarity_values] = ...
    solution_selection(target_population,target_fitness,lb,ub,gen,knowledge_base,method)

num_sources = length(knowledge_base);
[popsize,dim] = size(target_population);
target_population_normalized = (target_population-repmat(lb,popsize,1))./...
    (repmat(ub,popsize,1)-repmat(lb,popsize,1));

if strcmp(method,'N') % no transfer
    solution_sel = [];
    idx_source= [];
    return;
end

if strcmp(method,'R') % random transfer
    solution_sel = lb+(ub-lb).*knowledge_base(randi(num_sources)).solutions{end}(randi(popsize),:);
    idx_source= [];
    return;
end

simlarity_values = zeros(num_sources,1);
candidates_transfer = zeros(num_sources,dim);
for i = 1:num_sources
    source_solutions = knowledge_base(i).solutions;
    source_fitnesses = knowledge_base(i).fitnesses;
    gen_max_source = length(source_solutions);
    source_population_normalized = source_solutions{gen};
    source_fitness = source_fitnesses{gen};
    switch(method)
        case 'C'
            source_solutions_archived = zeros(gen_max_source,dim);
            for j = 1:gen_max_source
                idx = find(source_fitnesses{j}==min(source_fitnesses{j}));
                source_solutions_archived(j,:) = source_solutions{j}(idx(randi(length(idx))),:);
            end
            idx = find(target_fitness==min(target_fitness));
            target_best_normalized = target_population_normalized(idx(randi(length(idx))),:);
            distances = sum(abs(source_solutions_archived-repmat(target_best_normalized,...
                gen_max_source,1)),2);
            simlarity_values(i) = 1/min(distances);
            idx = find(distances==min(distances));
            candidates_transfer(i,:) = source_solutions_archived(idx(randi(length(idx))),:);
        case 'M1'
            source_mean = mean(source_population_normalized);
            target_mean = mean(target_population_normalized);
            simlarity_values(i) = 1/norm(source_mean-target_mean);
            candidates_transfer(i,:) = source_solutions{end}(randi(popsize),:);
        case 'WD'
            source_mean = mean(source_population_normalized);
            source_std = std(source_population_normalized);
            target_mean = mean(target_population_normalized);
            target_std = std(target_population_normalized);
            simlarity_values(i) = 1/sqrt(norm(source_mean-target_mean)+...
                norm(source_std-target_std));
            candidates_transfer(i,:) = source_solutions{end}(randi(popsize),:);
        case 'OC'
            [~, idxs] = sort(source_fitness);
            [~, idxt] = sort(target_fitness);
            simlarity_values(i) = 1/sum(sum(abs(source_population_normalized(idxs,:)-...
                target_population_normalized(idxt,:))));
            candidates_transfer(i,:) = source_solutions{end}(randi(popsize),:);
        case 'ROC'
            num_clusters = 3;
            [~, idxs] = sort(source_fitness);
            [~, idxt] = sort(target_fitness);
            c_interval = floor(popsize/num_clusters);
            sim = 0;
            for p = 1:popsize
                if ceil(p/c_interval)<num_clusters
                    c_start = (ceil(p/c_interval)-1)*c_interval+1;
                    c_end = ceil(p/c_interval)*c_interval;
                else
                    c_start = (ceil(p/c_interval)-1)*c_interval+1;
                    c_end = popsize;
                end
                sim = sim+norm(repmat(source_population_normalized(idxs(p),:),c_end-c_start+1,...
                    1)-target_population_normalized(idxt(c_start:c_end),:),1)/c_interval/popsize;
            end
            simlarity_values(i) = 1/sim;
            candidates_transfer(i,:) = source_solutions{end}(randi(popsize),:);
        case 'KLD'
            source_mean = mean(source_population_normalized);
            source_cov = cov(source_population_normalized);
            target_mean = mean(target_population_normalized);
            target_cov = cov(target_population_normalized);
            KLD = 0.5*(trace(inv(source_cov)*target_cov)+(source_mean-target_mean)*...
                source_cov*(source_mean-target_mean)'...
                -length(source_mean)+log(det(source_cov)/det(target_cov)));
            simlarity_values(i) = 1/KLD;
            candidates_transfer(i,:) = source_solutions{end}(randi(popsize),:);
        case 'SA'
            dl = ceil(dim/2);
            coeff_source = pca(source_population_normalized);
            coeff_target = pca(target_population_normalized);
            As = coeff_source(:,1:dl);
            At = coeff_target(:,1:dl);
            simlarity_values(i) = 1/norm(As-At,'fro');
            candidates_transfer(i,:) = source_solutions{end}(randi(popsize),:);
    end
end
[~,idx_source] = max(simlarity_values);
solution_sel = lb+(ub-lb).*candidates_transfer(idx_source,:);