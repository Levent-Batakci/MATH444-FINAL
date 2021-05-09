function images = DiscreteGrayScale(discretizedImages,k)
%Recovers images from discrete version

spacing = 255/k;
images = floor( ((discretizedImages*spacing)+ spacing) /2 );
end

