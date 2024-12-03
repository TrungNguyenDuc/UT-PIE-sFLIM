function color_rgb = convert_to_rgb(color_matrix,rgb_colormap_resolution,color) 
cMAP = cmap(color,rgb_colormap_resolution,5,5);
color_top_tiff = sum(color_matrix,3);
norm_color_top_tiff = round(normalize_2D(color_top_tiff)*rgb_colormap_resolution);
%hist(norm_color_top_tiff)
color_rgb = ind2rgb(norm_color_top_tiff,cMAP);
figure();
imagesc(color_rgb);
axis square;
