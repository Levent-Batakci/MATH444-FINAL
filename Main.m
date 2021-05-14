%Levent Batakci
    %MATH444 - Final
%Classifies black and white textures.

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
k = 6; % # of gray levels
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
ct = 1;
for i = 1:r
    for j = i+1:r
        subplot(2,3, ct);
        ct = ct + 1;
        hold on
        for c = unique(I)
            Z_ = Z(:, Isample==c);
            scatter(Z_(i,:), Z_(j,:), "MarkerEdgeColor", "k", "MarkerFaceColor", colors(c,:));
        end
        xlabel("PC " + i);
        ylabel("PC " + j);
        set(gca,"FontSize", 15);
    end
end
legend("Class 1", "Class 2", "Class 3", "Class 4", "Class 5");

%LDA
[Q, Zlda] = LDA(Z, Isample);
clf(figure(4))
figure(4)
for i = unique(I)
    Z_ = Zlda(:, Isample==i);
    s = scatter(Z_(1,:), Z_(2,:),"MarkerEdgeColor", "k", "MarkerFaceColor", colors(i,:));
    hold on 
end

legend("Class 1", "Class 2", "Class 3", "Class 4", "Class 5");
xlabel("Projection on first separator");
set(gca,'FontSize',15);
ylabel("Projection on second separator");

disp("MAKING MAXIMAL TREE"); %ON PCA!
[root, Nodes, Leaves] = MaximalTree(Z, Isample);
[LDAroot,~,LDAleaves] = MaximalTree(Zlda, Isample);
disp("MAXIMAL TREE COMPLETED");

%Test maximal tree on the remaining data points
%We have to process the data again..
G = ProcessImages(X, k, n, offsets);
Gc = G - sum(G,2) / size(G,2);
Zfull = features' * Gc;
Zlda_full = Q' * Zfull;

%Test on untested set
percentCorrect = 0;
percentCorrectLDA = 0;
for i = 1:p
    if(nnz(sample-i) == num) %not in sample
        atr = Zfull(:,i);
        LDAatr = Zlda_full(:,i);
        c = I(i);
        percentCorrect = percentCorrect + ((classify(root, atr) == c)/(p-num));
        percentCorrectLDA = percentCorrectLDA + ((classify(LDAroot, LDAatr) == c)/(p-num));
    end
end
percentCorrect
percentCorrectLDA