% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% This file is the script of showing the estimated similarity distributions
% of sources from the constrained generation, which are presented in the
% supplementary document accompaning the following paper.
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. ¡°Does Experience Always Help? Revisiting
% Evolutionary Sequential Transfer Optimization¡±, Submitted for Peer Review.

clc,clear
ds = [5 20 50]; % Problem dimensions
xi_list = [0.1, 0.3, 0.5, 0.7, 1]; % The parameter xi of governing the optimum coverage
k = 10000; % The number of generated source instances
colors = {'r','b','k'};
colors_rgb = [141,29,88;0,165,181;0 0 0]/255;
markers = {'^','o','s'};

for i = 1:5
    xi = xi_list(i);
    sim = zeros(1,k);
    figurex = figure('color',[1 1 1],'position',[616.3333  292.3333  372.0000  315.3333]);
    for l = 1:length(ds)
        d = ds(l);
        ot = rand(1,d);
        for j = 1:k % unconstrained source generation
            os = (1-xi)*ot+xi*rand(1,d);
            sim(j) = 1-norm(ot-os,1)/d;
        end
        [f,xt] = ksdensity(sim,'NumPoints',20);
        plot(xt,f,'linewidth',1,'color',colors_rgb(l,:),'marker',markers{l},'markerfacecolor',colors_rgb(l,:));hold on;
    end
    set(gca,'linewidth',1,'box','off');
    xlabel('$\mathcal{S}$','interpret','latex','fontsize',14);
    ylabel('$p\left(\mathcal{S}\right)$','interpret','latex','fontsize',14);
    hl=legend('$d=5$','$d=20$','$d=50$');
    set(hl,'fontsize',14,'box','off','edgecolor','none','interpret','latex','location','northwest');
    title(['$\mathcal{G}=U,\,\xi=',num2str(xi),'$'],'fontsize',14,'interpret','latex');
    axis([0.2,1,0,max(f)*1.1])
end

