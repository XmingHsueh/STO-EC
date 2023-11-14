function fit_ranks = fit_relax(fits,num_classes)

num_samples = length(fits);
class_labels = 1:num_classes;
[~,ind] = sort(fits);
group_less = floor(num_samples/num_classes);
fit_ranks = zeros(num_samples,1);
for i = 1:num_classes-1
    range = (i-1)*group_less+1:i*group_less;
    fit_ranks(ind(range)) = class_labels(i);
end
range = (num_classes-1)*group_less+1:num_samples;
fit_ranks(ind(range)) = class_labels(num_classes);
