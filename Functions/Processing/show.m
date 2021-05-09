function im = show(image, r, c)
im = double(reshape(image, r, c))/255;
imshow(im, 'Colormap', gray);
end

