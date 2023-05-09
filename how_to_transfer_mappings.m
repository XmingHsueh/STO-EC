% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is the script of graphically comparing the mapping behaviors of
% ten adaptation models in the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, C. Yang, L. Feng, et al. "Does Optimized Solution Always Help? A
% Comprehensive Investigation of Transfer Evolutionary Algorithms", Submitted for Peer Review.

clc,clear
fig_width = 700;
fig_height = 700;
screen_size = get(0,'ScreenSize');
figure1 = figure('color',[1 1 1],'position',[(screen_size(3)-fig_width)/2, (screen_size(4)-...
    fig_height)/2,fig_width, fig_height]);
plot([0 0],[1 1],'w.');hold on;
tt = linspace(0,2*pi,11);
thetas = tt(1:end-1);
r_max = 1.5;
r_upper = 1;
r_lower = 0.5;
r_opt = 0.75;
x_shade = [];
y_shade = [];
for i = 1:length(thetas)
    x_shade = [x_shade r_upper*cos(thetas(i))];
    y_shade = [y_shade r_upper*sin(thetas(i))];
end
x_shade = [x_shade x_shade(1)];
y_shade = [y_shade y_shade(1)];
fill(x_shade,y_shade,[0.8 0.8 0.8],'facealpha',0.5,'edgecolor','none');
x_shade = [];
y_shade = [];
for i = 1:length(thetas)
    x_shade = [x_shade r_lower*cos(thetas(i))];
    y_shade = [y_shade r_lower*sin(thetas(i))];
end
x_shade = [x_shade x_shade(1)];
y_shade = [y_shade y_shade(1)];
fill(x_shade,y_shade,[1 1 1],'edgecolor','none');
for i = 1:length(thetas)
        quiver(0,0,r_max*cos(thetas(i)),r_max*sin(thetas(i)),'k-','linewidth',1,'MaxHeadSize',0.1);
end
axis equal;
axis off;
for i = 1:length(thetas)
    if i<length(thetas)
        plot([r_opt*cos(thetas(i)),r_opt*cos(thetas(i+1))],[r_opt*sin(thetas(i)),r_opt*sin(thetas(i+1))],'k-.','linewidth',0.5);
    else
        plot([r_opt*cos(thetas(i)),r_opt*cos(thetas(1))],[r_opt*sin(thetas(i)),r_opt*sin(thetas(1))],'k-.','linewidth',0.5);
    end
end

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
fs = zeros(num_plot,1); % objective values of the source solutions
ft = zeros(num_plot,1); % objective values of the target solutions
for i = 1:num_plot % function evaluation
    fs(i) = funs(lbs+(ubs-lbs)*ts(i));
    ft(i) = funt(lbt+(ubt-lbt)*tt(i));
end
num_solutions = 200; % the number of solutions to be evaluated and used for learning the source-to-target mapping
train_s = lhsdesign_modified(num_solutions,0,0.5); % sample the source solutions using the LHS sampling
train_t = lhsdesign_modified(num_solutions,0.5,1); % sample the target solutions using the LHS sampling
obj_s = zeros(num_solutions,1); % objective values of source solutions
obj_t = zeros(num_solutions,1); % objective values of target solutions
for i = 1:num_solutions
    obj_s(i) = funs(lbs+(ubs-lbs)*train_s(i));
    obj_t(i) = funt(lbt+(ubt-lbt)*train_t(i));
end
obj_rank_s = zeros(num_solutions,1); % obj ranks of source solutions
obj_rank_t = zeros(num_solutions,1); % obj ranks of target solutions
for i = 1:num_solutions
    obj_rank_s(i) = length(find(obj_s<obj_s(i)))+1;
    obj_rank_t(i) = length(find(obj_t<obj_t(i)))+1;
end
[~,idxs_r] = sort(obj_s);
[~,idxt_r] = sort(obj_t);

num_mapping = 15; % the number of source solutions to be adapted
tm = linspace(0,0.5,num_mapping);
m_size = 7;


%M1-Te
prop = 0.4;
[~,idxs] = sort(obj_s);
[~,idxt] = sort(obj_t);
r_m1te = tm+(mean(train_t(idxs(1:prop*num_mapping)))-mean(train_s(idxt(1:prop*num_mapping))));
for i = 1:length(r_m1te)
    if i == round(num_mapping/2)
        plot(r_m1te(i)*cos(thetas(1)),r_m1te(i)*sin(thetas(1)),'ko','linewidth',1,'markerfacecolor','k','markersize',m_size);
    else
        plot(r_m1te(i)*cos(thetas(1)),r_m1te(i)*sin(thetas(1)),'ko','linewidth',1,'markersize',m_size);
    end
end

%M1-Tr
[~,idxs] = sort(obj_s);
[~,idxt] = sort(obj_t);
r_m1tr = tm+(train_t(idxs(randi(3)))-train_s(idxt(randi(3))));
for i = 1:length(r_m1tr)
    if i == round(num_mapping/2)
        plot(r_m1tr(i)*cos(thetas(2)),r_m1tr(i)*sin(thetas(2)),'ko','linewidth',1,'markerfacecolor','k','markersize',m_size);
    else
        plot(r_m1tr(i)*cos(thetas(2)),r_m1tr(i)*sin(thetas(2)),'ko','linewidth',1,'markersize',m_size);
    end
end

%M1-Tm
r_m1tm = tm+(mean(train_t)-mean(train_s));
for i = 1:length(r_m1tm)
    if i == round(num_mapping/2)
        plot(r_m1tm(i)*cos(thetas(3)),r_m1tm(i)*sin(thetas(3)),'ko','linewidth',1,'markerfacecolor','k','markersize',m_size);
    else
        plot(r_m1tm(i)*cos(thetas(3)),r_m1tm(i)*sin(thetas(3)),'ko','linewidth',1,'markersize',m_size);
    end
end

%M1-M
n = 2;
ns = randi(n);
nt = randi(n);
epsilon = 1e-6;
[~,idxs] = sort(obj_s);
[~,idxt] = sort(obj_t);
r_m1m = tm*(mean(train_t(idxt(1:nt),:))/mean(train_s(idxt(1:nt),:)));
for i = 1:length(r_m1m)
    if r_m1m(i)>r_max-0.1
        continue;
    end
    if i == round(num_mapping/2)
        plot(r_m1m(i)*cos(thetas(4)),r_m1m(i)*sin(thetas(4)),'ko','linewidth',1,'markerfacecolor','k','markersize',m_size);
    else
        plot(r_m1m(i)*cos(thetas(4)),r_m1m(i)*sin(thetas(4)),'ko','linewidth',1,'markersize',m_size);
    end
end

%M2-A
r_m2a = mean(train_t)+(tm-mean(train_s))*var(train_s)/var(train_t);
for i = 1:length(r_m2a)
    if r_m2a(i)>r_max-0.1
        continue;
    end
    if i == round(num_mapping/2)
        plot(r_m2a(i)*cos(thetas(5)),r_m2a(i)*sin(thetas(5)),'ko','linewidth',1,'markerfacecolor','k','markersize',m_size);
    else
        plot(r_m2a(i)*cos(thetas(5)),r_m2a(i)*sin(thetas(5)),'ko','linewidth',1,'markersize',m_size);
    end
end

%OC-L
train_s_sort = train_s(idxs_r);
train_t_sort = train_t(idxt_r);
Ml = train_s_sort\train_t_sort;
r_ocl = tm*Ml;
for i = 1:length(r_ocl)
    if r_ocl(i)>r_max-0.1
        continue;
    end
    if i == round(num_mapping/2)
        plot(r_ocl(i)*cos(thetas(6)),r_ocl(i)*sin(thetas(6)),'ko','linewidth',1,'markerfacecolor','k','markersize',m_size);
    else
        plot(r_ocl(i)*cos(thetas(6)),r_ocl(i)*sin(thetas(6)),'ko','linewidth',1,'markersize',m_size);
    end
end

%OC-A
Ma = [train_s_sort ones(num_solutions,1)]\train_t_sort;
r_oca = [tm' ones(num_mapping,1)]*Ma;
for i = 1:length(r_oca)
    if r_oca(i)>r_max-0.1
        continue;
    end
    if i == round(num_mapping/2)
        plot(r_oca(i)*cos(thetas(7)),r_oca(i)*sin(thetas(7)),'ko','linewidth',1,'markerfacecolor','k','markersize',m_size);
    else
        plot(r_oca(i)*cos(thetas(7)),r_oca(i)*sin(thetas(7)),'ko','linewidth',1,'markersize',m_size);
    end
end

%OC-K
source_kernel = kernel_cal(train_s_sort,train_s_sort);
Mk = source_kernel\train_t_sort;
transfer_kernel = kernel_cal(tm',train_s_sort);
r_ock = transfer_kernel*Mk;
for i = 1:length(r_ock)
    if r_ock(i)>r_max-0.1
        continue;
    end
    if i == round(num_mapping/2)
        plot(r_ock(i)*cos(thetas(8)),r_ock(i)*sin(thetas(8)),'ko','linewidth',1,'markerfacecolor','k','markersize',m_size);
    else
        plot(r_ock(i)*cos(thetas(8)),r_ock(i)*sin(thetas(8)),'ko','linewidth',1,'markersize',m_size);
    end
end

%OC-N
f_activate=@(x)1./(1+exp(-x));
num_hiddens = 4;
source_inputs = [train_s_sort ones(num_solutions,1)];
target_inputs = train_t_sort;
W_ih = rand(size(source_inputs,2),num_hiddens);
H = f_activate(source_inputs*W_ih);
W_ho = H\target_inputs;
f_mapping = @(x)f_activate(x*W_ih)*W_ho;
r_ocn = zeros(num_mapping,1);
for i = 1:num_mapping
    r_ocn(i) = f_mapping([tm(i) 1]);
end
for i = 1:length(r_ocn)
    if r_ocn(i)>r_max-0.1
        continue;
    end
    if i == round(num_mapping/2)
        plot(r_ocn(i)*cos(thetas(9)),r_ocn(i)*sin(thetas(9)),'ko','linewidth',1,'markerfacecolor','k','markersize',m_size);
    else
        plot(r_ocn(i)*cos(thetas(9)),r_ocn(i)*sin(thetas(9)),'ko','linewidth',1,'markersize',m_size);
    end
end

%ROC-L
num_ranklabels = 3;
X_s = train_s;
X_t = train_t;
y_s = fit_relax(obj_s,num_ranklabels);
y_t = fit_relax(obj_t,num_ranklabels);
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
r_rocl = zeros(num_mapping,1);
for i = 1:num_mapping
    xs = (tm(i)-means)./stds;
    r_rocl(i) = transpose((Pt1*Pt1')\Pt1*(Ps1'*xs')).*stdt+meant;
end
for i = 1:length(r_rocl)
    if r_rocl(i)>r_max-0.1
        continue;
    end
    if i == round(num_mapping/2)
        plot(r_rocl(i)*cos(thetas(10)),r_rocl(i)*sin(thetas(10)),'ko','linewidth',1,'markerfacecolor','k','markersize',m_size);
    else
        plot(r_rocl(i)*cos(thetas(10)),r_rocl(i)*sin(thetas(10)),'ko','linewidth',1,'markersize',m_size);
    end
end

text_str = {'M1-Te','M1-Tr','M1-Tm','M1-M','M2-A','OC-L','OC-A','OC-K','OC-N','ROC-L'};
delta_r = 0.02;
for i = 1:length(thetas)
    text((r_max+delta_r)*cos(thetas(i)),(r_max+delta_r)*sin(thetas(i)),text_str{i},'interpret','latex','fontsize',16);
end
