%Levent
%Show the 5 categories
clear all

load TestImages.mat
X = X* 255;

n=128;
k=6;
clf(figure(1));
figure(1)
for i = 1:5
    %discIms = DiscretizeGrayLevels(X, k);
    %im = DiscreteGrayScale(discIms(:,1),k);
    ims = X(:,I==i);
    im = ims(:, 1);
    subplot(2,3, i)
    show(im,n,n);
    title("Class " + i);
    set(gca, "FontSize", 20);
end

figure(2)
for i = 1:5
    discIms = DiscretizeGrayLevels(X(:,I==i), k);
    im = DiscreteGrayScale(discIms(:,1),k);
    subplot(2,3, i)
    show(im,n,n);
    title("Coarsified Class " + i);
    set(gca, "FontSize", 15);
end