function GLCMs = GLCM(images, r, c, offsets, k)
GLCMs = cell(3);

for j = 1:size(offsets,2)
    GLCMs{j} = [];
end

for i = 1:size(images,2)
        im = reshape(images(:,i),r,c);
    for j = 1:size(offsets,2)
        GLCMs{j} =  [GLCMs{j} GHelper(im, offsets(:,j),k)];
    end
end

end

function G = GHelper(im, offset, k)
%Uses periodic boundary conditions, which is logical for textures
%Textures repeat!

G = zeros(k,k);

shifted = CircularShift(im, offset);
for i = 1:k
    for j = 1:k
        G(i,j) = nnz(im == i & shifted == j);
    end
end

%Stack the results.
G = reshape(G, k*k, 1);

%Scale so the entries sum to 1;
G = G / sum(G);

end

function shifted = CircularShift(X, offset)

x = offset(1);
y = offset(2);

xStart = 1+x;
if(xStart > size(X,2))
    xStart = xStart - size(X,2);
end
    
yStart = 1+y;
if(xStart > size(X,1))
    yStart = yStart - size(X,1); 
end

if(x ~= 0)
    shifted = [X(xStart:end, :);  X(1:xStart-1, :)];
else
    shifted = X;
end

if(y ~= 0)
    shifted = [shifted(:, yStart:end)  shifted(:,1:yStart-1)];
end


end