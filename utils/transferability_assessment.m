function [solution_eva,transfer_state] = ...
    transferability_assessment(target_population,target_obj,lb,ub,gen,knowledge_base,idx_source,method)

    [popsize,dim] = size(target_population);
    target_population_normalized = (target_population-repmat(lb,popsize,1))./...
        (repmat(ub,popsize,1)-repmat(lb,popsize,1));
    solution_eva = lb+(ub-lb).*knowledge_base(idx_source).solutions{end}(randi(popsize),:);
    transfer_state= -1;

    r = rand;
    switch(method)
        case 'N'
            transfer_state= -1;
        case 'Re'
            if r < 0.5
                transfer_state = 1;
            end
        case 'F-1'
            if mod(gen,1) == 0
                transfer_state = 1;
            end
        case 'F-5'
            if mod(gen,5) == 0
                transfer_state = 1;
            end
        case 'F-10'
            if mod(gen,10) == 0
                transfer_state = 1;
            end
        case 'D-M'
            nrandsamples = floor(0.1*popsize);
            randMat = rand(nrandsamples,dim);
            source_data = knowledge_base(idx_source).solutions{gen};
            target_data = target_population_normalized;
            source_mean = mean([source_data;randMat]);
            source_stdev = std([source_data;randMat]);
            target_mean = mean([target_data;randMat]);
            target_stdev = std([target_data;randMat]);
            source_probmatrix = ones(popsize,2);
            target_probmatrix = ones(popsize,2);
            for k = 1:popsize
                for l = 1:dim
                    source_probmatrix(k,1) = source_probmatrix(k,1)*pdf('Normal',source_data(k,l),...
                        source_mean(l),source_stdev(l));
                    source_probmatrix(k,2) = source_probmatrix(k,2)*pdf('Normal',source_data(k,l),...
                        target_mean(l),target_stdev(l));
                    target_probmatrix(k,1) = target_probmatrix(k,1)*pdf('Normal',target_data(k,l),...
                        source_mean(l),source_stdev(l));
                    target_probmatrix(k,2) = target_probmatrix(k,2)*pdf('Normal',target_data(k,l),...
                        target_mean(l),target_stdev(l));
                end
            end
            rmp = min(max([0,fminbnd(@(x)loglik(x,source_probmatrix,target_probmatrix,2),0,1)...
                +normrnd(0,0.01)]),1);
            if r < rmp
                transfer_state = 1;
            end
        case 'D-G'
            source_data = knowledge_base(idx_source).solutions{gen};
            target_data = target_population_normalized;
            source_mean = mean(source_data);
            source_stdev = std(source_data);
            target_mean = mean(target_data);
            target_stdev = std(target_data);
            f = (sum(abs(source_stdev))+sum(abs(target_stdev))-sum(abs(source_mean-...
                target_mean)))/dim;
            beta = 5;
            rmp  = 1/(1+exp(-beta*f));
            if r < rmp
                transfer_state = 1;
            end
        case 'D-P'
            source_population_normalized = knowledge_base(idx_source).solutions{gen};
            source_obj = knowledge_base(idx_source).objs{gen};
            Rfs = zeros(1,popsize);
            Rft = zeros(1,popsize);
            for j = 1:popsize
                Rfs(j) = sum(source_obj<source_obj(j))+1;
                Rft(j) = sum(target_obj<target_obj(j))+1;
            end
            [~,idx_best_s] = min(source_obj);
            [~,idx_best_t] = min(target_obj);
            dis_ss = zeros(1,popsize);dis_st = zeros(1,popsize);
            dis_tt = zeros(1,popsize);dis_ts = zeros(1,popsize);
            dis_rank_ss = zeros(1,popsize);dis_rank_st = zeros(1,popsize);
            dis_rank_tt = zeros(1,popsize);dis_rank_ts = zeros(1,popsize);
            for j = 1:popsize
                dis_ss(j) = norm(source_population_normalized(j,:)-source_population_normalized(idx_best_s,:),2);
                dis_st(j) = norm(source_population_normalized(j,:)-target_population_normalized(idx_best_t,:),2);
                dis_tt(j) = norm(target_population_normalized(j,:)-target_population_normalized(idx_best_t,:),2);
                dis_ts(j) = norm(target_population_normalized(j,:)-source_population_normalized(idx_best_s,:),2);
            end
            for j = 1:popsize
                dis_rank_ss(j) = sum(dis_ss<dis_ss(j))+1;
                dis_rank_st(j) = sum(dis_st<dis_st(j))+1;
                dis_rank_tt(j) = sum(dis_tt<dis_tt(j))+1;
                dis_rank_ts(j) = sum(dis_ts<dis_ts(j))+1;
            end
            sim_st = sum(abs(Rfs-dis_rank_ss))/sum(abs(Rfs-dis_rank_st));
            sim_ts = sum(abs(Rft-dis_rank_tt))/sum(abs(Rft-dis_rank_ts));
            rmp = (sim_st+sim_ts)/2;
            if r < rmp
                transfer_state = 1;
            end
    end
end

function f = loglik(rmp,source,target,ntasks)
    f = 0;
    popdata(1).probmatrix = source;
    popdata(2).probmatrix = target;
    for i = 1:ntasks
        for j = 1:ntasks
            if i == j
                popdata(i).probmatrix(:,j) = popdata(i).probmatrix(:,j)*(1-(0.5*(ntasks-1)*rmp/ntasks));
            else
                popdata(i).probmatrix(:,j) = popdata(i).probmatrix(:,j)*0.5*(ntasks-1)*rmp/ntasks;
            end
        end
        f = f + sum(-log(sum(popdata(i).probmatrix,2)));
    end
end
