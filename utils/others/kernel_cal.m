function K = kernel_cal(populationa,populationb)

[na,~] = size(populationa);
[nb,~] = size(populationb);
K = zeros(na,nb);
b = 0.1;
d = 5;
for i = 1:na
    for j = i:nb
        K(i,j) = (populationa(i,:)*populationb(j,:)'+b)^d;
    end
end