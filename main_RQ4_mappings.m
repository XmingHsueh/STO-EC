% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is the script of graphically comparing the mapping behaviors of
% eight adaptation models in the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, C. Yang, L. Feng, et al. ¡°How to Exploit Optimization Experience? Revisiting Evolutionary 
% Sequential Transfer Optimization: Part B - Empirical Studies", Submitted for Peer Review.

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
[~,idxs_r] = sort(fitness_s);
[~,idxt_r] = sort(fitness_t);

%% solution adaptation phase
figure3 = figure('color',[1 1 1],'position',[654.3333   50.3333  608.0000  938.0000]);
x_lim = 1.5;
x_delta = 0.01; % compensation at the x direction used for text annotation
y_delta = 0.02; % compensation at the y direction used for text annotation
for i = 0:0.5:7.5 % reference line
    plot([0 x_lim],[i i],'k-','linewidth',1);hold on;
end
num_mapping = 30; % the number of source solutions to be adapted
tm = linspace(0,0.5,num_mapping);

% A-M1-Am
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
axis([0 x_lim 0 8])
box off;
fill([0 x_lim x_lim 0 0],[0 0 0.75 0.75 0],'k','facealpha',0.1,'edgecolor','none')
text(x_lim+x_delta,0+y_delta,'$x_s$','interpret','latex','fontsize',18);
text(x_lim+x_delta,0.5+y_delta,'$x_t$','interpret','latex','fontsize',18);
text(0.03,0.5+0.1,'A-M1-Tm','interpret','latex','fontsize',12);

% A-M1-Ar
num_front = 10;
[~,idxs] = sort(fitness_s);
[~,idxt] = sort(fitness_t);
adap_m1r = tm+(train_t(idxs(randi(num_front)))-train_s(idxt(randi(num_front))));
plot([0 0.5],[1 1],'r-','linewidth',3);hold on;
plot([0.5 1],[1.5 1.5],'b-','linewidth',3);
for i = 1:num_mapping
    if i==round(num_mapping/2)
        plot([tm(i) adap_m1r(i)],[1,1.5],'k-','linewidth',2);
    else
        plot([tm(i) adap_m1r(i)],[1,1.5],'k-.','linewidth',0.5);
    end
end
axis([0 x_lim 0 8])
box off;
fill([0 x_lim x_lim 0 0],[1 1 1.75 1.75 1],'r','facealpha',0.1,'edgecolor','none')
text(x_lim+x_delta,1+y_delta,'$x_s$','interpret','latex','fontsize',18);
text(x_lim+x_delta,1.5+y_delta,'$x_t$','interpret','latex','fontsize',18);
text(0.03,1.5+0.1,'A-M1-Tr','interpret','latex','fontsize',12);

% A-M1-M
n = 2;
ns = randi(n);
nt = randi(n);
epsilon = 1e-6;
[~,idxs] = sort(fitness_s);
[~,idxt] = sort(fitness_t);
adap_m1m = tm*(mean(train_t(idxt(1:nt),:))/mean(train_s(idxt(1:nt),:)));
plot([0 0.5],[2 2],'r-','linewidth',3);hold on;
plot([0.5 1],[2.5 2.5],'b-','linewidth',3);
for i = 1:num_mapping
    if i==round(num_mapping/2)
        plot([tm(i) adap_m1m(i)],[2,2.5],'k-','linewidth',2);
    else
        plot([tm(i) adap_m1m(i)],[2,2.5],'k-.','linewidth',0.5);
    end
end
axis([0 x_lim 0 8])
box off;
fill([0 x_lim x_lim 0 0],[2 2 2.75 2.75 2],'b','facealpha',0.1,'edgecolor','none')
text(x_lim+x_delta,2+y_delta,'$x_s$','interpret','latex','fontsize',18);
text(x_lim+x_delta,2.5+y_delta,'$x_t$','interpret','latex','fontsize',18);
text(0.03,2.5+0.1,'A-M1-M','interpret','latex','fontsize',12);

% A-OC-L
train_s_sort = train_s(idxs_r);
train_t_sort = train_t(idxt_r);
Ml = train_s_sort\train_t_sort;
adap_l = tm*Ml;
plot([0 0.5],[3 3],'r-','linewidth',3);hold on;
plot([0.5 1],[3.5 3.5],'b-','linewidth',3);
for i = 1:num_mapping
    if i==round(num_mapping/2)
        plot([tm(i) adap_l(i)],[3,3.5],'k-','linewidth',2);
    else
        plot([tm(i) adap_l(i)],[3,3.5],'k-.','linewidth',0.5);
    end
end
fill([0 x_lim x_lim 0 0],[3 3 3.75 3.75 3],'g','facealpha',0.1,'edgecolor','none')
text(x_lim+x_delta,3+y_delta,'$x_s$','interpret','latex','fontsize',18);
text(x_lim+x_delta,3.5+y_delta,'$x_t$','interpret','latex','fontsize',18);
text(0.03,3.5+0.1,'A-OC-L','interpret','latex','fontsize',12);

% A-OC-A
Ma = [train_s_sort ones(num_solutions,1)]\train_t_sort;
adap_a = [tm' ones(num_mapping,1)]*Ma;
plot([0 0.5],[4 4],'r-','linewidth',3);hold on;
plot([0.5 1],[4.5 4.5],'b-','linewidth',3);
for i = 1:num_mapping
    if i==round(num_mapping/2)
        plot([tm(i) adap_a(i)],[4,4.5],'k-','linewidth',2);
    else
        plot([tm(i) adap_a(i)],[4,4.5],'k-.','linewidth',0.5);
    end
end
fill([0 x_lim x_lim 0 0],[4 4 4.75 4.75 4],[0 125 255]/255,'facealpha',0.1,'edgecolor','none')
text(x_lim+x_delta,4+y_delta,'$x_s$','interpret','latex','fontsize',18);
text(x_lim+x_delta,4.5+y_delta,'$x_t$','interpret','latex','fontsize',18);
text(0.03,4.5+0.1,'A-OC-A','interpret','latex','fontsize',12);

% A-OC-K
source_kernel = kernel_cal(train_s_sort,train_s_sort);
Mk = source_kernel\train_t_sort;
transfer_kernel = kernel_cal(tm',train_s_sort);
adap_k = transfer_kernel*Mk;
plot([0 0.5],[5 5],'r-','linewidth',3);hold on;
plot([0.5 1],[5.5 5.5],'b-','linewidth',3);
for i = 1:num_mapping
    if i==round(num_mapping/2)
        plot([tm(i) adap_k(i)],[5,5.5],'k-','linewidth',2);
    else
        plot([tm(i) adap_k(i)],[5,5.5],'k-.','linewidth',0.5);
    end
end
fill([0 x_lim x_lim 0 0],[5 5 5.75 5.75 5],[125 0 255]/255,'facealpha',0.1,'edgecolor','none')
text(x_lim+x_delta,5+y_delta,'$x_s$','interpret','latex','fontsize',18);
text(x_lim+x_delta,5.5+y_delta,'$x_t$','interpret','latex','fontsize',18);
text(0.03,5.5+0.1,'A-OC-K','interpret','latex','fontsize',12);

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
plot([0 0.5],[6 6],'r-','linewidth',3);hold on;
plot([0.5 1],[6.5 6.5],'b-','linewidth',3);
for i = 1:num_mapping
    if i==round(num_mapping/2)
        plot([tm(i) adap_n(i)],[6,6.5],'k-','linewidth',2);
    else
        plot([tm(i) adap_n(i)],[6,6.5],'k-.','linewidth',0.5);
    end
end
fill([0 x_lim x_lim 0 0],[6 6 6.75 6.75 6],[255 125 0]/255,'facealpha',0.1,'edgecolor','none')
text(x_lim+x_delta,6+y_delta,'$x_s$','interpret','latex','fontsize',18);
text(x_lim+x_delta,6.5+y_delta,'$x_t$','interpret','latex','fontsize',18);
text(0.03,6.5+0.1,'A-OC-N','interpret','latex','fontsize',12);

% A-ROC-L
num_ranklabels = 3;
X_s = train_s;
X_t = train_t;
y_s = fit_relax(fitness_s,num_ranklabels);
y_t = fit_relax(fitness_t,num_ranklabels);
[X_sn,means,stds] = zscore(X_s);
[X_tn,meant,stdt] = zscore(X_t);
X_sa = X_sn';
X_ta = X_tn';
[ds,ns] = size(X_sa);
[dt,nt] = size(X_ta);
alpha = 0.1;
d_low = 1;
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
adap_roc = zeros(num_mapping,1);
for i = 1:num_mapping
    xs = (tm(i)-means)./stds;
    adap_roc(i) = transpose((Pt1*Pt1')\Pt1*(Ps1'*xs')).*stdt+meant;
end
plot([0 0.5],[7 7],'r-','linewidth',3);hold on;
plot([0.5 1],[7.5 7.5],'b-','linewidth',3);
for i = 1:num_mapping
    if i==round(num_mapping/2)
        plot([tm(i) adap_roc(i)],[7,7.5],'k-','linewidth',2);
    else
        plot([tm(i) adap_roc(i)],[7,7.5],'k-.','linewidth',0.5);
    end
end
fill([0 x_lim x_lim 0 0],[7 7 7.75 7.75 7],[255 0 125]/255,'facealpha',0.1,'edgecolor','none')
text(x_lim+x_delta,7+y_delta,'$x_s$','interpret','latex','fontsize',18);
text(x_lim+x_delta,7.5+y_delta,'$x_t$','interpret','latex','fontsize',18);
text(0.03,7.5+0.1,'A-ROC-L','interpret','latex','fontsize',12);

set(gca,'yticklabel',{'','','','','','','','','','',''},'ytick',[],'fontsize',12);
ax1 = gca;
ax1.YAxis.Visible = 'off';   % remove y-axis