function discretizedImages = DiscretizeGrayLevels(images, k)
%images will be discretized
%k>=2 is the number of discrete gray levels

%Fast, smart computation :)
spacing = 256/k;
discretizedImages = floor(images / spacing)+1;

%1(1:k) * spacing


end

