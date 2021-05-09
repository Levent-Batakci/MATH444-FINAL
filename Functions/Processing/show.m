function im = show(image, r, c)
im = reshape(image, r, c);
imshow(im, 'Colormap', gray);
end

