function [Z, Ur] = PCA_tol(X, tol)
%Returns the results of the PCA on X
%Centers X.
%Tolerance should be between 0 and 1, ideally close to 0.

[n,p] = size(X);

Xc = X - sum(X,2) / p;

[U,V,~] = svd(Xc);

SVs = diag(V);
%Find the break-point
r = 1;
m = min([n p]);
while r < m && SVs(r) >= SVs(1) * tol
    r = r+1;
end

Ur = U(:,1:r-1);
Z = Ur' * Xc;

end

