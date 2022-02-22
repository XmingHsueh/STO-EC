% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% The class of S-ESTO problems. The properties that can be arbitrarily
% specified include: 1. the target function; 2. transfer scenario; 3.
% source generation; 4. the parameter that governs optimum coverage; 5. the
% problem dimension.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization”, Submitted for Peer Review.

classdef SESTOP

    % SESTOP properties:
    % func_target---the target function with configurable optimum
    % trans_sce--->transfer scenario: intra-family transfer (A) or inter-family transfer (E)
    % source_gen--->source generation scheme: constrained generation (C) or unconstrained generation (U)
    % xi--->the parameter that governs optimum coverage: xi∈[0,1]
    % dim--->the problem dimension of source-target instances, a positive integer
    % mode--->the mode of problem call, problem generation (gen) or s-esto optimization (opt)
    % target_problem--->the instantiated target problem
    % knowledge_base--->the knowledge base containing the evaluated solutions of k sources
    % problem_families---<read-only>the list of available problem families
    % k---<read-only>the number of sources, a positive integer
    % optimizer---<read-only>the optimizer used for solving the source and target problems
    % popsize---<read-only>the population size, N>0
    % FEsMax---<read-only>the maximum function evaluations (FEs) available
    % gen_trans---<read-only>the generation gap for periodically triggering the knowledghe transfer
    % state_knowledgebase---<read-only>the availability of the specified S-ESTO problem: 1->available; 0->unavailable
    % source_problems---<read-only>the instantiated source problems

    properties
        func_target = 'Sphere';
        trans_sce = 'A';
        source_gen = 'C';
        xi = 1;
        dim = 10;
        mode = 'opt';
        target_problem;
        knowledge_base = struct;
    end

    properties(SetAccess = protected)
        problem_families = {'Sphere','Ellipsoid','Schwefel','Quartic','Ackley','Rastrigin','Griewank','Levy'};
        k = 1000;
        optimizer = 'ea';
        popsize = 20;
        FEsMax = 1000;
        gen_trans  =1;
        state_knowledgebase;
        source_problems;
    end

    methods

        function obj = SESTOP(varargin) % initialization
            isStr = find(cellfun(@ischar,varargin(1:end-1))&~cellfun(@isempty,varargin(2:end)));
            for i = isStr(ismember(varargin(isStr),{'func_target','trans_sce','source_gen','xi','dim','mode'}))
                obj.(varargin{i}) = varargin{i+1};
            end
            % examine the availability of the specified S-ESTO problem
            dir_sesto = ['.\SESTOPs\',obj.func_target,'-',obj.trans_sce,'-',obj.source_gen,'-x',...
                num2str(obj.xi),'-d',num2str(obj.dim),'-k',num2str(obj.k),'.mat'];
            obj.state_knowledgebase = sign(exist(dir_sesto,'file'));
            if obj.state_knowledgebase == 1 && strcmp(obj.mode,'opt') % will not load the data in the generation mode
                load(['.\SESTOPs\',obj.func_target,'-',obj.trans_sce,'-',obj.source_gen,'-x',...
                    num2str(obj.xi),'-d',num2str(obj.dim),'-k',num2str(obj.k),'.mat']);
                obj.target_problem = target;
                obj.source_problems = sources;
                for i = 1:obj.k
                    obj.knowledge_base(i).solutions = knowledge(i).solutions;
                    obj.knowledge_base(i).fitnesses = knowledge(i).fitnesses;
                end
            elseif obj.state_knowledgebase == 0
                obj = obj.Configuration(); % generate the problem since it does not exist
            end
        end

        function obj = Configuration(obj) % problem constructor
            opt_target = rand(1,obj.dim); % configure the target problem
            for  i = 1:obj.k % configure the source problems
                idx_target = find(strcmp(obj.problem_families,obj.func_target));
                if strcmp(obj.trans_sce,'A') % intra-family transfer
                    idx_source = idx_target;
                    obj.source_problems(i).func = obj.problem_families{idx_source};
                else % inter-family transfer
                    idx_source = randi(length(obj.problem_families));
                    while idx_source==idx_target
                        idx_source = randi(length(obj.problem_families));
                    end
                    obj.source_problems(i).func = obj.problem_families{idx_source};
                end
                if strcmp(obj.source_gen,'U') % unconstrained source generation
                    obj.source_problems(i).opt = (1-obj.xi)*opt_target+obj.xi*rand(1,obj.dim);
                else % constrained source generation
                    xi_c = i/obj.k*obj.xi;
                    obj.source_problems(i).opt = (1-xi_c)*opt_target+xi_c*rand(1,obj.dim);
                end
            end
            h=waitbar(0,'Starting');
            for i = 1:obj.k % configure the knowledge base
                problem = problem_family(find(strcmp(obj.problem_families,...
                    obj.source_problems(i).func)),obj.source_problems(i).opt);
                [solutions,fitnesses] = evolutionary_search(problem,obj.popsize,...
                    obj.FEsMax,obj.optimizer);
                obj.knowledge_base(i).solutions = solutions;
                obj.knowledge_base(i).fitnesses = fitnesses;
                waitbar(i/obj.k,h,sprintf('SESTOP generation in progress: %.2f%%',i/obj.k*100));
            end
            close(h);
            % save the problem
            target = problem_family(find(strcmp(obj.problem_families,obj.func_target)),opt_target);
            obj.target_problem = target;
            for i = 1:obj.k
                sources(i) = problem_family(find(strcmp(obj.problem_families,...
                    obj.source_problems(i).func)),obj.source_problems(i).opt);
                knowledge(i).solutions = obj.knowledge_base(i).solutions;
                knowledge(i).fitnesses = obj.knowledge_base(i).fitnesses;
            end
            obj.source_problems = sources;
            save(['.\SESTOPs\',obj.func_target,'-',obj.trans_sce,'-',obj.source_gen,'-x',...
                num2str(obj.xi),'-d',num2str(obj.dim),'-k',num2str(obj.k),'.mat'],...
                'target','sources','knowledge');
        end

    end

end