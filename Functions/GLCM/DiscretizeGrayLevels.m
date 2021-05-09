function discretizedImages = DiscretizeGrayLevels(images, k)
%images will be discretized
%k>=2 is the number of discrete gray levels

%Fast, smart computation :)
discretizedImages = (ceil(images / (k+1)) + floor(images / (k+1))) / 2;


end

