%Levent Batakci
    %MATH444 - Final
%Classifies textures from the Okazaki Synthetic Texture Images database.

clear all

%Load the images
%The data consists of 409 128x128 grayscale images.
%The columns represent the images, so the data is stored in a 16384x409
%matrix
%The entries are between 0 and 255, inclusive
load TestImages.mat
X = X* 255;

%Select num random images
p = size(X,2);
num = 200;
sample = sort(randsample(1:p, num));
Xsample = X(:, sample);
Isample = I(sample);

%Parameters
k = 12; % # of gray levels
n=128; % image dimension
offsets(:,1) = [2 0]';
offsets(:,2) = [0 2]';
offsets(:,3) = [2 2]';
r=4; %PCs

%Process the images
[G, discretizedImages] = ProcessImages(Xsample, k, n, offsets);

%TEST WHAT THE DISCRETIZATION LOOKS LIKE
Xdisc = DiscreteGrayScale(discretizedImages,k);
clf(figure(1))
figure(1)
show(Xdisc(:,2), n, n);
clf(figure(2))
figure(2)
show(Xsample(:,2), n, n);
%Works well.

%Compute the principal components!
[Z, features] = PCA_r(G, r);

colors = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 0 1 1; 1 0 1; 1 0.5 0.2; 0 0 0];
clf(figure(3))
figure(3)
hold on
for i = 1:r
    for j = i+1:r
        subplot(r,r, 4*(i-1) + j-1);
        hold on
        for c = unique(I)
            Z_ = Z(:, Isample==c);
            scatter(Z_(i,:), Z_(j,:), "MarkerEdgeColor", "k", "MarkerFaceColor", colors(c,:));
        end
        xlabel("PC " + i)
        ylabel("PC " + j)
    end
end
legend("Class 1", "Class 2", "Class 3", "Class 4", "Class 5");

%LDA
% [~, Z] = LDA(G, I);
% clf(figure(4))
% figure(4)
% for i = unique(I)
%     Z_ = Z(:, I==i);
%     s = scatter(Z_(1,:), Z_(2,:),"MarkerEdgeColor", "k", "MarkerFaceColor", colors(i,:));
%     hold on 
% end
% 
% legend("1", "2", "3", "4", "5");
% xlabel("Projection on first separator");
% set(gca,'FontSize',15);
% ylabel("Projection on second separator");
% sgtitle("Clusters Separated by LDA on GLCMs", 'FontSize', 15);

disp("MAKING MAXIMAL TREE"); %ON PCA!
[root, Nodes, Leaves] = MaximalTree(Z, Isample);
disp("MAXIMAL TREE COMPLETED");

%Test maximal tree on the remaining data points
%We have to process the data again..
G = ProcessImages(X, k, n, offsets);
Gc = G - sum(G,2) / size(G,2);
Zfull = features' * Gc;

%Sanity check, should be 100% correct
percentCorrect = 0;
count=0;
for i = 1:num
    atr = Z(:, i);
    c = Isample(i);
    percentCorrect = percentCorrect + ((classify(root, atr) == c)/num);
end
percentCorrect
%WORKS!

%Test on untested set
percentCorrect = 0;
for i = 1:p
    atr = features' * Gc(:,i);
    c = I(i);
    percentCorrect = percentCorrect + ((classify(root, atr) == c)/p);
end
percentCorrect