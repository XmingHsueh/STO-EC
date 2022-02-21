% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is the script of graphically comparing the mapping behaviors of 
% five adaptation models. The corresponding figure is shown as Fig. 19 
% in the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization”, Submitted to IEEE Transactions on Evolutionary Computation.

%% initialize the source and target problems
clc,clear
rand('state',11);
randn('state',11);
funs = @(x)(x+6).^2-10*cos(2*pi*(x+6))+10; % the source problem
lbs = -12; % the lower bound of the source instance
ubs = 12; % the upper bound of the source instance
funt = @(x)(x-7).^2; % the target problem
lbt = -14; % the lower bound of the target instance
ubt = 14; % the upper bound of the target instance
num_plot = 200; % the number of points used for plotting the source-target landscapes
ts = linspace(0,0.5,num_plot); % source solutions used for plotting the landscape
tt = linspace(0.5,1,num_plot); % target solutions used for plotting the landscape
fs = zeros(num_plot,1); % fitness values of the source solutions
ft = zeros(num_plot,1); % fitness values of the target solutions
for i = 1:num_plot % function evaluation
    fs(i) = funs(lbs+(ubs-lbs)*ts(i));
    ft(i) = funt(lbt+(ubt-lbt)*tt(i));
end
num_solutions = 200; % the number of solutions to be evaluated and used for learning the source-target mapping
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
[~,idxs_r] = sort(fitness_s);
[~,idxt_r] = sort(fitness_t);

%% solution adaptation phase
figure3 = figure('color',[1 1 1],'position',[553.6667  169.0000  574.0000  698.0000]);
x_lim = 1.5;
x_delta = 0.01; % compensation at the x direction used for text annotation
y_delta = 0.02; % compensation at the y direction used for text annotation
for i = 0:0.5:4.5 % reference line
    plot([0 x_lim],[i i],'k-','linewidth',1);hold on;
end
num_mapping = 30; % the number of source solutions to be adapted
tm = linspace(0,0.5,num_mapping);

% A-M1-M
adap_m1 = tm+(mean(train_t)-mean(train_s));
plot([0 0.5],[0 0],'r-','linewidth',3);hold on;
plot([0.5 1],[0.5 0.5],'b-','linewidth',3);
for i = 1:num_mapping
    if i==round(num_mapping/2)
        plot([tm(i) adap_m1(i)],[0,0.5],'k-','linewidth',2);
    else
        plot([tm(i) adap_m1(i)],[0,0.5],'k-.','linewidth',0.5);
    end
end
axis([0 x_lim 0 5])
box off;
fill([0 x_lim x_lim 0 0],[0 0 0.75 0.75 0],'k','facealpha',0.1,'edgecolor','none')
text(x_lim+x_delta,0+y_delta,'$x_s$','interpret','latex','fontsize',18);
text(x_lim+x_delta,0.5+y_delta,'$x_t$','interpret','latex','fontsize',18);
text(0.03,0.5+0.1,'A-M1-M','interpret','latex','fontsize',18);

% A-OC-L
train_s_sort = train_s(idxs_r);
train_t_sort = train_t(idxt_r);
Ml = train_s_sort\train_t_sort;
adap_l = tm*Ml;
plot([0 0.5],[1 1],'r-','linewidth',3);hold on;
plot([0.5 1],[1.5 1.5],'b-','linewidth',3);
for i = 1:num_mapping
    if i==round(num_mapping/2)
        plot([tm(i) adap_l(i)],[1,1.5],'k-','linewidth',2);
    else
        plot([tm(i) adap_l(i)],[1,1.5],'k-.','linewidth',0.5);
    end
end
fill([0 x_lim x_lim 0 0],[1 1 1.75 1.75 1],[125 0 255]/255,'facealpha',0.1,'edgecolor','none')
text(x_lim+x_delta,1+y_delta,'$x_s$','interpret','latex','fontsize',18);
text(x_lim+x_delta,1.5+y_delta,'$x_t$','interpret','latex','fontsize',18);
text(0.03,1.5+0.1,'A-OC-L','interpret','latex','fontsize',18);

% A-OC-A
Ma = [train_s_sort ones(num_solutions,1)]\train_t_sort;
adap_a = [tm' ones(num_mapping,1)]*Ma;
plot([0 0.5],[2 2],'r-','linewidth',3);hold on;
plot([0.5 1],[2.5 2.5],'b-','linewidth',3);
for i = 1:num_mapping
    if i==round(num_mapping/2)
        plot([tm(i) adap_a(i)],[2,2.5],'k-','linewidth',2);
    else
        plot([tm(i) adap_a(i)],[2,2.5],'k-.','linewidth',0.5);
    end
end
fill([0 x_lim x_lim 0 0],[2 2 2.75 2.75 2],[255 125 0]/255,'facealpha',0.1,'edgecolor','none')
text(x_lim+x_delta,2+y_delta,'$x_s$','interpret','latex','fontsize',18);
text(x_lim+x_delta,2.5+y_delta,'$x_t$','interpret','latex','fontsize',18);
text(0.03,2.5+0.1,'A-OC-A','interpret','latex','fontsize',18);

% A-OC-K
source_kernel = kernel_cal(train_s_sort,train_s_sort);
Mk = source_kernel\train_t_sort;
transfer_kernel = kernel_cal(tm',train_s_sort);
adap_k = transfer_kernel*Mk;
plot([0 0.5],[3 3],'r-','linewidth',3);hold on;
plot([0.5 1],[3.5 3.5],'b-','linewidth',3);
for i = 1:num_mapping
    if i==round(num_mapping/2)
        plot([tm(i) adap_k(i)],[3,3.5],'k-','linewidth',2);
    else
        plot([tm(i) adap_k(i)],[3,3.5],'k-.','linewidth',0.5);
    end
end
fill([0 x_lim x_lim 0 0],[3 3 3.75 3.75 3],[255 0 125]/255,'facealpha',0.1,'edgecolor','none')
text(x_lim+x_delta,3+y_delta,'$x_s$','interpret','latex','fontsize',18);
text(x_lim+x_delta,3.5+y_delta,'$x_t$','interpret','latex','fontsize',18);
text(0.03,3.5+0.1,'A-OC-K','interpret','latex','fontsize',18);

% A-OC-N
f_activate=@(x)1./(1+exp(-x));
num_hiddens = 4;
source_inputs = [train_s_sort ones(num_solutions,1)];
target_inputs = train_t_sort;
W_ih = rand(size(source_inputs,2),num_hiddens);
H = f_activate(source_inputs*W_ih);
W_ho = H\target_inputs;
f_mapping = @(x)f_activate(x*W_ih)*W_ho;
adap_n = zeros(num_mapping,1);
for i = 1:num_mapping
    adap_n(i) = f_mapping([tm(i) 1]);
end
plot([0 0.5],[4 4],'r-','linewidth',3);hold on;
plot([0.5 1],[4.5 4.5],'b-','linewidth',3);
for i = 1:num_mapping
    if i==round(num_mapping/2)
        plot([tm(i) adap_n(i)],[4,4.5],'k-','linewidth',2);
    else
        plot([tm(i) adap_n(i)],[4,4.5],'k-.','linewidth',0.5);
    end
end
fill([0 x_lim x_lim 0 0],[4 4 4.75 4.75 4],[0 125 255]/255,'facealpha',0.1,'edgecolor','none')
text(x_lim+x_delta,4+y_delta,'$x_s$','interpret','latex','fontsize',18);
text(x_lim+x_delta,4.5+y_delta,'$x_t$','interpret','latex','fontsize',18);
text(0.03,4.5+0.1,'A-OC-N','interpret','latex','fontsize',18);

set(gca,'yticklabel',{'','','','','','','','','','',''},'ytick',[],'fontsize',12);
ax1 = gca;
ax1.YAxis.Visible = 'off';   % remove y-axis