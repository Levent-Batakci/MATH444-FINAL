%Levent Batakci
    %MATH444 - Final
%Classifies textures from the Okazaki Synthetic Texture Images database.

clear all

%Load the images
%The data consists of 409 128x128 grayscale images.
%The columns represent the images, so the data is stored in a 16384x409
%matrix
%The entries are between 0 and 255, inclusive
load OSTI.mat
c = unique(annotation);
for i = 1:size(X,2)
    for j = 1: size(c,1)
        if(strcmp(c{j}, annotation{i}))
            I(i) = j;
        end
    end
end

%Select the first 200
p = size(X,2);
num = 200;
sample = randsample(1:p, num);
Xfull = X;
X = X(:,sample);
Ifull = I';
I = I(:, sample);

%Parameters
k = 11;
n=128;
offsets(:,1) = [1 2]';
offsets(:,2) = [2 1]';
offsets(:,3) = [2 2]';
r=4;

%Make the images entries doubles
Xd = double(X);

%Discretize the images
discretizedImages = DiscretizeGrayLevels(Xd, k);

%TEST WHAT THE DISCRETIZATION LOOKS LIKE
Xdisc = DiscreteGrayScale(discretizedImages,k);
clf(figure(1))
figure(1)
show(Xdisc(:,2), n, n);
clf(figure(2))
figure(2)
show(X(:,2), n, n);
%Works well.

%Compute GLCMS
GLCMs = GLCM(discretizedImages, n, n, offsets, k);

%Stack them!
G = [];
for i = 1:size(offsets,2)
   G = [G; GLCMs{i}];
end

%Compute the principal components!
%[Z, features] = PCA_r(G, r);
%Colored scatterplot!

colors = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 0 1 1; 1 0 1; 1 0.5 0.2; 0 0 0];
% clf(figure(3))
% figure(3)
% hold on
% for i = 1:r
%     for j = i+1:r
%         subplot(r,r, 4*(i-1) + j-1);
%         hold on
%         for c = I
%             Z_ = Z(:, I==c);
%             scatter(Z_(i,:), Z_(j,:));
%         end
%         xlabel("PC " + i)
%         ylabel("PC " + j)
%     end
% end
% 
% legend("bark", "fabric", "fur", "leather", "sand", "stone", "water", "wood");
%Well, that didn't work.

%LDA
[Q, Z] = LDA(G, I);
clf(figure(4))
figure(4)
for i = unique(I)
    Z_ = Z(:, I==i);
    s = scatter(Z_(1,:), Z_(2,:),"MarkerEdgeColor", "k", "MarkerFaceColor", colors(i,:));
    hold on 
end

legend("bark", "fabric", "fur", "leather", "sand", "stone", "water", "wood");
xlabel("Projection on first separator");
set(gca,'FontSize',15);
ylabel("Projection on second separator");
sgtitle("Clusters Separated by LDA on GLCMs", 'FontSize', 15);

disp("MAKING MAXIMAL TREE");
[root, Nodes, Leaves] = MaximalTree(Z(1:2,:), I);
disp("MAXIMAL TREE COMPLETED");

%Test maximal tree on the remaining data points

%We have to process the data again..
%Make the images entries doubles
Xd = double(Xfull);
%Discretize the images
discretizedImages = DiscretizeGrayLevels(Xd, k);
%Compute GLCMS
GLCMs = GLCM(discretizedImages, n, n, offsets, k);
%Stack them!
G = [];
for i = 1:size(offsets,2)
   G = [G; GLCMs{i}];
end
Z = Q' * G;

p = size(Xfull,2);
clf(figure(5))
figure(5)
for i = unique(I)
    Z_ = Z(:, Ifull==i);
    s = scatter(Z_(1,:), Z_(2,:),"MarkerEdgeColor", "k", "MarkerFaceColor", colors(i,:));
    hold on 
end

percentCorrect = 0;
for i = 1:p
    if(nnz(sample-i) == nnz(sample))
        atr = Z(1:2, i);
        c = Ifull(i);
        percentCorrect = percentCorrect + ((classify(root, atr) == c)/(p-num));
    end
end
percentCorrect