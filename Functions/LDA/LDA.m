function [Q, Sw_eps, Sb, eps] = LDA(X, I)
%LDA returns the leading directions to project the data

    %Get the dimensions and labels
    [n, p] = size(X);
    labels = unique(I);
    k = numel(labels);
    
    P = zeros(1,k); %Number of elements per cluster
    for i = 1:k
        g = labels(i);
        P(1,i) = nnz(I == g);
    end

    %Compute the group centers
    C = getCenters(X, I, k);
    c0 = sum(X, 2) / p; %Get the overall center
    
    %Compute the within cluster scatter
    Sw = zeros(n, n); %Within cluster scatter
    for i = 1:k
        Xi = X(:, I==i) - C(:,i) * ones(1, nnz(I==i));
        Sw = Sw + Xi*Xi';
    end
    
    %Adjust Sw
    E = eigs(Sw);
    d1 = E(1);
    tau = 10^-10; 
    eps = tau*(d1^2);
    Sw_eps = Sw + eps.*eye(n,n);
 
    
    %Compute Sb, the between-cluster scatter matrix
    Sb = zeros(n,n);
    for i = 1:k
        c_ = C(:,i)-c0;
        Sb = Sb + P(1,i) * c_*(c_');
    end
    
    %Compute the Cholesky factorization of Sw,eps
    K = chol(Sw_eps);
    
   [W, E] = eigs((K'\Sb)/K, k-1);
   
   Q = K \ W;
end

