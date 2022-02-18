function solution_adapted = solution_adaptation(target_population,target_fitness,lb,ub,gen,source_instance,solution_unadapted,method)

[popsize,dim] = size(target_population);
target_population_normalized = (target_population-repmat(lb,popsize,1))./(repmat(ub,popsize,1)-repmat(lb,popsize,1));
source_population_normalized = source_instance.solutions{gen};
source_fitness = source_instance.fitnesses{gen};

switch(method)
    case 'M1-P'
        percentage = 0.4;
        num_estimate = ceil(percentage*popsize);
        [~,idxs] = sort(source_fitness);
        moment1_source = mean(source_population_normalized(idxs(1:num_estimate),:));
        [~,idxt] = sort(target_fitness);
        moment1_target = mean(target_population_normalized(idxt(1:num_estimate),:));
        solution_adapted_normalized = solution_unadapted+(moment1_target-moment1_source);
    case 'M1-R'
        num_front = 5;
        [~,idxs] = sort(source_fitness);
        moment1_source = source_population_normalized(idxs(randi(num_front)),:);
        [~,idxt] = sort(target_fitness);
        moment1_target = target_population_normalized(idxt(randi(num_front)),:);
        solution_adapted_normalized = solution_unadapted+(moment1_target-moment1_source);
    case 'M1-M'
        moment1_source = mean(source_population_normalized);
        moment1_target = mean(target_population_normalized);
        solution_adapted_normalized = solution_unadapted+(moment1_target-moment1_source);
    case 'M2-A'
        mu_s = mean(source_population_normalized);
        mu_t = mean(target_population_normalized);
        sigma_s = diag(diag(cov(source_population_normalized)))+eye(dim)*1e-5;
        sigma_t = diag(diag(cov(target_population_normalized)))+eye(dim)*1e-5;
        Lsi_l  = chol(inv(sigma_s));
        Lci_l = chol(inv(sigma_t));
        Am_l = inv(Lci_l')*Lsi_l;
        bm_l = mu_t'-Am_l*mu_s';
        solution_adapted_normalized = transpose(Am_l*solution_unadapted'+bm_l);
    case 'SA-L'
        d = ceil(dim/2);
        coeff_source = pca(source_population_normalized);
        coeff_target = pca(target_population_normalized);
        As = coeff_source(:,1:d);
        At = coeff_target(:,1:d);
        R = diag(rand(1,d));
        M = As*As'*At*R*At';
        solution_adapted_normalized = solution_unadapted*M;
    case 'OC-L'
        [~,idxs] = sort(source_fitness);
        source_population_normalized_sort = source_population_normalized(idxs,:);
        [~,idxt] = sort(target_fitness);
        target_population_normalized_sort = target_population_normalized(idxt,:);
        M = source_population_normalized_sort\target_population_normalized_sort;
        solution_adapted_normalized = solution_unadapted*M;
    case 'OC-A'
        [~,idxs] = sort(source_fitness);
        source_population_normalized_sort = source_population_normalized(idxs,:);
        [~,idxt] = sort(target_fitness);
        target_population_normalized_sort = target_population_normalized(idxt,:);
        source_population_normalized_sort_aug = [source_population_normalized_sort ones(popsize,1)];
        M = source_population_normalized_sort_aug\target_population_normalized_sort;
        solution_unadapted_aug = [solution_unadapted 1];
        solution_adapted_normalized = solution_unadapted_aug*M;
    case 'OC-K'
        [~,idxs] = sort(source_fitness);
        source_population_normalized_sort = source_population_normalized(idxs,:);
        [~,idxt] = sort(target_fitness);
        target_population_normalized_sort = target_population_normalized(idxt,:);
        source_kernel = kernel_cal(source_population_normalized_sort,source_population_normalized_sort);
        Mk = source_kernel\target_population_normalized_sort;
        transfer_kernel = kernel_cal(solution_unadapted,source_population_normalized_sort);
        solution_adapted_normalized = transfer_kernel*Mk;
    case 'OC-N'
        [~,idxs] = sort(source_fitness);
        source_population_normalized_sort = source_population_normalized(idxs,:);
        [~,idxt] = sort(target_fitness);
        target_population_normalized_sort = target_population_normalized(idxt,:);
        f_activate=@(x)1./(1+exp(-x));
        num_hiddens = dim*2;
        source_inputs = [source_population_normalized_sort ones(popsize,1)];
        target_inputs = target_population_normalized_sort;
        W_ih = rand(size(source_inputs,2),num_hiddens);
        H = f_activate(source_inputs*W_ih);
        W_ho = H\target_inputs;
        f_mapping = @(x)f_activate(x*W_ih)*W_ho;
        solution_adapted_normalized = f_mapping([solution_unadapted 1]);
end
solution_adapted_normalized(solution_adapted_normalized<0) = 0;
solution_adapted_normalized(solution_adapted_normalized>1) = 1;
solution_adapted = lb+(ub-lb).*solution_adapted_normalized;