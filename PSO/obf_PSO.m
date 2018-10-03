function f=obf_PSO(x)
global X nn K_gram;
rbf_var=x;
K=zeros(nn,nn);
for i=1:nn
  for j=i:nn
    K(i,j) = exp(-norm(X(i,:)-X(j,:))^2/rbf_var);
    K(j,i) = K(i,j);
  end
end
f=-corr2(K_gram,K);