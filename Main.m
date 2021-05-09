%Levent Batakci
%MATH444 - Final
%Classifies textures from the Okazaki Synthetic Texture Images database.

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
Xfull = X;
X = X(:,1:200);
Ifull = I';
I = I(:,1:200);

%Parameters
k = 16;
n=128;
offsets(:,1) = [0 1]';
offsets(:,2) = [1 3]';
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
[Z, features] = PCA_r(G, r);
%Colored scatterplot!

colors = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 0 1 1; 1 0 1; 1 0.5 0.2; 0 0 0];
clf(figure(3))
figure(3)
hold on
for i = I
    Z_ = Z(:, I==i);
    scatter(Z_(1,:), Z_(2,:));
end
%Well, that didn't work.

%LDA
[~, Z] = LDA(G, I);
clf(figure(4))
figure(4)
for i = I
    Z_ = Z(:, I==i);
    s = scatter(Z_(1,:), Z_(2,:));
    s.MarkerFaceColor = colors(i,:);
    hold on 
end

