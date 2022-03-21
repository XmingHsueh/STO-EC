% Author: Xiaoming Xue
% Email: xminghsueh@gmail.com
%
% ------------
% Description:
% ------------
% The function of configuring the optima of source and target tasks.
%
% ------------
% Inputs:
% ------------
% xi--->the parameter of controlling optimum coverage
% num_tasks--->the number of source tasks
% d--->the problem dimension
% scheme--->the generation scheme of optima
%
% ------------
% Outputs:
% ------------
% target_opt--->the optimum of the target task
% source_opt--->the optima of the source tasks
% lb_image--->the lower bound of the image in decison space
% ub_image--->the upper bound of the image in decison space
%
% ------------
% Reference:
% ------------
% X. Xue, Y. Hu, C. Yang, et al. “How to Utilize Optimization Experience? Revisiting
% Evolutionary Sequential Transfer Optimization", Submitted for Peer Review.

function [target_opt,source_opt,lb_image,ub_image] = opt_config(xi,num_tasks,d,scheme)
source_opt = zeros(num_tasks,d);
lb_image = zeros(1,d);
ub_image = zeros(1,d);

for i = 1:d % a randomly generated box-constrained image of the optimization mapping
    lb_image(i) = rand*(1-xi);
    ub_image(i) = lb_image(i)+xi;
end

if strcmp(scheme,'U') % the unconstrained generation
    target_opt = lb_image+(ub_image-lb_image).*rand(1,d);
    for i = 1:num_tasks
        source_opt(i,:) = lb_image+(ub_image-lb_image).*rand(1,d);
    end
else % the constrained generation
    target_opt = lb_image+(ub_image-lb_image).*rand(1,d);
    tao = linspace(0,1,num_tasks);
    for i = 1:num_tasks
        source_ori = lb_image+(ub_image-lb_image).*rand(1,d);
        source_opt(i,:) = target_opt*(1-tao(i))+source_ori*tao(i);
    end
end