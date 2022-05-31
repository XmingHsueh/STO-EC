% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% The solution adaptation function in S-ESTO.
%
% ------------
% Inputs:
% ------------
% target_population--->the target population at the current generation
% target_fitness--->the fitness values of the current individuals
% lb--->the lower bound of the target task
% ub--->the upper bound of the target task
% gen--->the current generation
% source_task--->the source task
% solution_unadapted--->the source solution to be adapted
% method--->the solution adaptation method
%
% ------------
% Outputs:
% ------------
% solution_adapted--->the adapted solution to be transferred
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “How to Exploit Experience? Revisiting Evolutionary
% Sequential Transfer Optimization: Part B", Submitted for Peer Review.

function solution_adapted = solution_adaptation(target_population,target_fitness,...
    lb,ub,gen,source_task,solution_unadapted,method)

[popsize,dim] = size(target_population);
target_population_normalized = (target_population-repmat(lb,popsize,1))./...
    (repmat(ub,popsize,1)-repmat(lb,popsize,1));
source_population_normalized = source_task.solutions{gen}; % the source population at the current generation
source_fitness = source_task.fitnesses{gen}; %the fitness values of the current source individuals

switch(method)
    case 'M1-Ap'
        percentage = 0.4;
        num_estimate = ceil(percentage*popsize);
        [~,idxs] = sort(source_fitness);
        moment1_source = mean(source_population_normalized(idxs(1:num_estimate),:));
        [~,idxt] = sort(target_fitness);
        moment1_target = mean(target_population_normalized(idxt(1:num_estimate),:));
        solution_adapted_normalized = solution_unadapted+(moment1_target-moment1_source);
    case 'M1-Ar'
        num_front = 5;
        [~,idxs] = sort(source_fitness);
        moment1_source = source_population_normalized(idxs(randi(num_front)),:);
        [~,idxt] = sort(target_fitness);
        moment1_target = target_population_normalized(idxt(randi(num_front)),:);
        solution_adapted_normalized = solution_unadapted+(moment1_target-moment1_source);
    case 'M1-Am'
        moment1_source = mean(source_population_normalized);
        moment1_target = mean(target_population_normalized);
        solution_adapted_normalized = solution_unadapted+(moment1_target-moment1_source);
    case 'M1-M'
        n = 2;
        ns = randi(n);
        nt = randi(n);
        epsilon = 1e-6;
        [~,idxs] = sort(source_fitness);
        moment1_source = mean(source_population_normalized(idxs(1:ns),:));
        [~,idxt] = sort(target_fitness);
        moment1_target = mean(target_population_normalized(idxt(1:nt),:));
        mapping_multiplication = (moment1_target+epsilon)./(moment1_source+epsilon);
        solution_adapted_normalized = solution_unadapted.*(mapping_multiplication);
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
        source_population_normalized_sort_aug = [source_population_normalized_sort,...
            ones(popsize,1)];
        M = source_population_normalized_sort_aug\target_population_normalized_sort;
        solution_unadapted_aug = [solution_unadapted 1];
        solution_adapted_normalized = solution_unadapted_aug*M;
    case 'OC-K'
        [~,idxs] = sort(source_fitness);
        source_population_normalized_sort = source_population_normalized(idxs,:);
        [~,idxt] = sort(target_fitness);
        target_population_normalized_sort = target_population_normalized(idxt,:);
        source_kernel = kernel_cal(source_population_normalized_sort,...
            source_population_normalized_sort);
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
    case 'ROC-L'
        num_ranklabels = 2;
        X_s = source_population_normalized;
        X_t = target_population_normalized;
        y_s = fit_relax(source_fitness,num_ranklabels);
        y_t = fit_relax(target_fitness,num_ranklabels);
        [X_sn,means,stds] = zscore(X_s);
        [X_tn,meant,stdt] = zscore(X_t);
        X_sa = X_sn';
        X_ta = X_tn';
        [ds,ns] = size(X_sa);
        [dt,nt] = size(X_ta);
        
        alpha = 0.1;
        d_low = 3;
        T_max = 100;
        tol = 1e-9;
        T = 1;
        floss_old = 100;
        X_total = [X_sa zeros(ds,nt);zeros(dt,ns) X_ta];
        A = [X_sa*X_sa'/ns zeros(ds,dt);zeros(dt,ds) -X_ta*X_ta'/nt];
        Ls = laplacian_matrix(y_s,y_t);
        B = X_total*(alpha*Ls)*X_total';
        [Vb,Db] = eig(B);
        [~,indb] = sort(diag(Db));
        P = real(Vb(:,indb(1:d_low)));
        while T<T_max
            floss = norm(P'*A*P,'fro')+trace(P'*B*P);
            if norm(floss-floss_old,2)<tol*floss
                break;
            end
            M = A*P*P'*A+1/2*B;
            [Vm,Dm] = eig(M);
            [~,indm] = sort(diag(Dm));
            floss_old = floss;
            P = real(Vm(:,indm(1:d_low)));
            T = T+1;
        end
        Ps1 = P(1:ds,:);
        Pt1 = P(ds+1:end,:);
        xs = (solution_unadapted-means)./stds;
        solution_adapted_normalized = transpose((Pt1*Pt1')\Pt1*(Ps1'*xs')).*stdt+meant;
    case 'SA-L'
        d = ceil(dim/2);
        coeff_source = pca(source_population_normalized);
        coeff_target = pca(target_population_normalized);
        As = coeff_source(:,1:d);
        At = coeff_target(:,1:d);
        R = diag(rand(1,d));
        M = As*As'*At*R*At';
        solution_adapted_normalized = solution_unadapted*M;
end
solution_adapted_normalized(solution_adapted_normalized<0) = 0;
solution_adapted_normalized(solution_adapted_normalized>1) = 1;
solution_adapted = lb+(ub-lb).*solution_adapted_normalized;