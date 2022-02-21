% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is the script of generating the optimization mapping of an
% interval coverage problem in the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. ¡°Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization¡±, Submitted to IEEE Transactions on Evolutionary Computation.

clc,clear
num_nodes = 21; % the number of sampling points along each representational dimension
l = linspace(0,1,num_nodes);
problems = cell(num_nodes,num_nodes); % all the problems

% mark the problems with gradually varied colors
colors = cell(num_nodes,num_nodes);
c_start = [0 255 0]/255;
c_end = [0 0 255]/255;
for i = 1:num_nodes
    for j = 1:num_nodes
        problems{i,j} = [l(i) l(j)];
        colors{i,j} = c_start+(c_end-c_start)*(i+j)/2/num_nodes;
        colors{i,j}(colors{i,j}<0) = 0;
        colors{i,j}(colors{i,j}>1) = 1;
    end
end

% solve the problems using the grid search
optima = cell(num_nodes,num_nodes);
weights = [1.2 1];
for l1 = 1:num_nodes
    for l2 = 1:num_nodes
        obj_best = [inf inf];
        for x1 = 1:num_nodes
            for x2 = 1:num_nodes
                obj = fun_eval_coverage(l(l1),l(l2),l(x1),l(x2)); % evaluate the fitness of solution [l(x1),l(x2)] for the problem with representation [l(l1),l(l2)]
                if sum(obj.*weights)<sum(obj_best.*weights)
                    obj_best = obj;
                    optima{l1,l2} = [l(x1),l(x2)];
                end
            end
        end
    end
end

% visualize the obtained optimization mapping
figure1 = figure('color',[1 1 1],'position',[0.7183    0.3423    1.1080    0.4813]*1e3);
for i = 1:num_nodes
    for j = 1:num_nodes
            plot(problems{i,j}(1)-1.5,problems{i,j}(2),'s','color',colors{i,j},'markerfacecolor',colors{i,j});hold on;
            plot(optima{i,j}(1)+0.5,optima{i,j}(2),'s','color',colors{i,j},'markerfacecolor',colors{i,j});
            % A parabola that travels through representation, reference point (0, 0.5), and optimum is constructed to represent the optimization mapping
            X = [(problems{i,j}(1)-1.5)^2 (problems{i,j}(1)-1.5) 1;(optima{i,j}(1)+0.5)^2 (optima{i,j}(1)+0.5) 1;0 0 1];
            y = [problems{i,j}(2);optima{i,j}(2);0.5];
            coe = X\y;
            t = linspace(problems{i,j}(1)-1.5,optima{i,j}(1)+0.5,20);
            Xt = [t'.^2 t' ones(20,1)];
            yt = Xt*coe;
            plot(t,yt,'-.','color',colors{i,j})
    end
end
axis off;
fill([-1.5 -0.5 -0.5 -1.5],[0 0 1 1],[	255,255,0]/255,'facealpha',0.2,'edgealpha',0);
fill([0.5 1.5 0.5],[0 0 1],[0 255 0]/255,'facealpha',0.2,'edgealpha',0);
fill([0.5 1.5 1.5 0.5],[0 0 1 1],[0,0,255]/255,'facealpha',0.2,'edgealpha',0);
fill([0.5 1.5 1.5 1.8 1.8 1.5 0.5],[1 1 0 0 1.3 1.3 1.3],[255,0,0]/255,'facealpha',0.2,'edgealpha',0);