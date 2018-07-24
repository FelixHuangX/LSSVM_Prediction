function x_f_after_PCA = pca_fea_34(x,fs,I,Nstd,NR,MaxIter)

N = length(x);
M = floor(N/I);  %round up to an integer
x_r = [];
for i = 1:1:M
    x_r(i,:) = x(I*(i-1)+1:I*i);
end

x_f = [];
[m,n] = size(x_r);
for j = 1:1:m
    x_f(j,:) = get_features_34(x_r(j,:),fs,Nstd,NR,MaxIter);
    j
end
index1 = find(isnan(x_f));
x_f(index1) = 0;
[COEFF, SCORE, LATENT] = pca(x_f);
tran = COEFF(:,1);
x_f = bsxfun(@minus,x_f,mean(x_f,1));
x_f_after_PCA= x_f*tran;

end