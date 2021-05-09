function images = DiscreteGrayScale(discretizedImages)
%Recovers images from discrete version

spacing = 255/k;
images = floor( (floor(discretizedImages * spacing)+ceil(discretizedImages*spacing)) /2 );
end

