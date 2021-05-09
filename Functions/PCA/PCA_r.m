function [Z, Ur] = PCA_r(X, r)
%Returns the results of the PCA on X
%Centers X.

[~,p] = size(X);

Xc = X - sum(X,2) / p;

[U,~,~] = svd(Xc);

Ur = U(:,1:r);

Z = Ur' * Xc;

end

