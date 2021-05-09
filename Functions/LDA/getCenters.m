function C = getCenters(X, I, k)
%GETCENTERS gets the centers of each annotated group
    
    n = size(X,1);
    C = zeros(n, k);
    for i = 1:k
        group = X(:, I==i);
        C(:, i) = sum(group, 2) / size(group,2);
    end

end

