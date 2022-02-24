% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is the script of demonstrating the chaotic matching. The
% corresponding figures are shown as Fig. 18 in the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization”, Submitted for Peer Review.

%% initialize the source and target problems
clc,clear
rand('state',11);
randn('state',11);
funs = @(x)(x+6).^2-10*cos(2*pi*(x+6))+10; % the source task
lbs = -12; % the lower bound of the source task
ubs = 12; % the upper bound of the source task
funt = @(x)(x-7).^2; % the target task
lbt = -14; % the lower bound of the target task
ubt = 14; % the upper bound of the target task
num_plot = 200; % the number of points used for plotting the source-target landscapes
ts = linspace(0,0.5,num_plot); % source solutions used for plotting the landscape
tt = linspace(0.5,1,num_plot); % target solutions used for plotting the landscape
fs = zeros(num_plot,1); % fitness values of the source solutions
ft = zeros(num_plot,1); % fitness values of the target solutions
for i = 1:num_plot % function evaluation
    fs(i) = funs(lbs+(ubs-lbs)*ts(i));
    ft(i) = funt(lbt+(ubt-lbt)*tt(i));
end

%% plot the source-target landscapes
figure1 = figure('color',[1 1 1],'position',[321.0000  365.6667  560.0000  420.0000]);
plot(ts,fs,'r-','linewidth',1);hold on;
plot(tt,ft,'b-','linewidth',1);
num_solutions = 200; % the number of solutions to be evaluated and used for learning the source-to-target mapping
train_s = lhsdesign_modified(num_solutions,0,0.5); % sample the source solutions using the LHS sampling
train_t = lhsdesign_modified(num_solutions,0.5,1); % sample the target solutions using the LHS sampling
fitness_s = zeros(num_solutions,1); % fitness values of source solutions
fitness_t = zeros(num_solutions,1); % fitness values of target solutions
for i = 1:num_solutions
    fitness_s(i) = funs(lbs+(ubs-lbs)*train_s(i));
    fitness_t(i) = funt(lbt+(ubt-lbt)*train_t(i));
end
fitness_rank_s = zeros(num_solutions,1); % fitness rankss of source solutions
fitness_rank_t = zeros(num_solutions,1); % fitness rankss of target solutions
for i = 1:num_solutions
    fitness_rank_s(i) = length(find(fitness_s<fitness_s(i)))+1;
    fitness_rank_t(i) = length(find(fitness_t<fitness_t(i)))+1;
end
for i = 1:num_solutions % match the source and target solutions with the same fitness rank
    idxs = find(fitness_rank_s==i);idxt = find(fitness_rank_t==i);
    plot(train_s(idxs),fitness_s(idxs),'rs','markerfacecolor','r','markersize',4+i/num_solutions*4);
    plot(train_t(idxt),fitness_t(idxt),'bo','markerfacecolor','b','markersize',4+i/num_solutions*4);
    plot([train_s(idxs) train_t(idxt)],[fitness_s(idxs) fitness_t(idxt)],'k-.');
end
xlabel('$x$','fontsize',18,'interpret','latex');
ylabel('$y$','fontsize',18,'interpret','latex');
set(gca,'linewidth',1);
title('Source and Target Instances','interpret','latex','fontsize',16);

%% plot the resultant mapping to be learned
figure2 = figure('color',[1 1 1],'position',[881.6667  365.0000  560.0000  420.0000]);
[~,idxs_r] = sort(fitness_s);
[~,idxt_r] = sort(fitness_t);
solution_s_sort = train_s(idxs_r); % sort the source solutions according to their fitness values
solution_t_sort = train_t(idxt_r); % sort the target solutions according to their fitness values
[~,indxsss] = sort(solution_s_sort);
plot(solution_s_sort(indxsss),solution_t_sort(indxsss),'k-','linewidth',1);
xlabel('$x_s$','fontsize',18,'interpret','latex');
ylabel('$x_t$','fontsize',18,'interpret','latex');
set(gca,'linewidth',1);
title('Source-Target Mapping to be Learned','interpret','latex','fontsize',16);