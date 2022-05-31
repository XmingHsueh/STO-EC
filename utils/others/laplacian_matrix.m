function [L,Ld] =  laplacian_matrix(ys,yt)
ns = length(ys);
nt = length(yt);
Wst = zeros(ns,nt);
for i = 1:ns
    for j = 1:nt
        if ys(i)==yt(j)
            Wst(i,j) = 1;
        end
    end
end
Ws = 1/ns/nt*[zeros(ns,ns) Wst;Wst' zeros(nt,nt)];
Wd = 1/ns/nt*[zeros(ns,ns) ones(size(Wst))-Wst;ones(size(Wst'))-Wst' zeros(nt,nt)];
L = diag(sum(Ws))-Ws;
Ld = diag(sum(Wd))-Wd;