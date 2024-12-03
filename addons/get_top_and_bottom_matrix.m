function [image_combine, fig_combine,top_color_matrix, bottom_color_matrix,decay_combine] = get_top_and_bottom_matrix(image_channels_matrix,color_combine,gate1,gate2,set_threshold,threshold_percent,file_temp,rgb_colormap_resolution)
% color channel
channel_color = linspace(500,700,16); 
color=spectrumRGB(channel_color(color_combine(1)),'1931_FULL');
[image_combine, fig_combine, decay_combine] = combine_multi_channels_matrix(image_channels_matrix,color_combine(1),color_combine(2),color);

color_image_combine = image_combine;


% gate
[top_color_matrix, bottom_color_matrix] = time_decay_gate(image_combine, gate1(1), gate1(2), gate2(1), gate2(2));

[color_top, color_top_decay, color_top_tiff] = visualize_time_decay_image(top_color_matrix,color);
[color_bottom, color_bottom_decay, color_bottom_tiff] = visualize_time_decay_image(bottom_color_matrix,color);


if set_threshold == true
    color_top_mask = color_top_tiff >= max(color_top_tiff, [], 'all')*threshold_percent;
    top_color_matrix_masked = bsxfun(@times, top_color_matrix, cast(color_top_mask, 'like', top_color_matrix));
    [color_top, color_top_decay, color_top_tiff] = visualize_time_decay_image(top_color_matrix_masked,color);

    color_bottom_mask = color_bottom_tiff >= max(color_bottom_tiff, [], 'all')*threshold_percent;
    bottom_color_matrix_masked = bsxfun(@times, bottom_color_matrix, cast(color_bottom_mask, 'like', bottom_color_matrix));
    [color_bottom, color_bottom_decay, color_bottom_tiff] = visualize_time_decay_image(bottom_color_matrix_masked,color);
end
file_temp = strcat(file_temp,string(color_combine(1)),'_',string(color_combine(2)));
color_combine_savefile = strcat(file_temp,'_combine.png');
color_combine_top_savefile = strcat(file_temp,'_combine_gate1.png');
color_combine_bottom_savefile = strcat(file_temp,'_combine_gate2.png');
saveas(fig_combine, color_combine_savefile);
saveas(color_top, color_combine_top_savefile);
saveas(color_bottom, color_combine_bottom_savefile);

color_combine_top_tifffile = strcat(file_temp,'_combine_gate1.tif');
color_combine_bottom_tifffile = strcat(file_temp,'_combine_gate2.tif');
imwrite(uint16(color_top_tiff),color_combine_top_tifffile);
imwrite(uint16(color_bottom_tiff),color_combine_bottom_tifffile);


% Important to for display
cMAP = cmap(color,rgb_colormap_resolution,5,5);
% Important to for display


color_top_rgb_tifffile = strcat(file_temp,'_combine_gate1_rgb.tif');
color_bottom_rgb_tifffile = strcat(file_temp,'_combine_gate2_rgb.tif');

norm_color_top_tiff = round(normalize_2D(color_top_tiff)*rgb_colormap_resolution);
%hist(norm_color_top_tiff)
color_top_rgb = ind2rgb(norm_color_top_tiff,cMAP);
figure();
imagesc(color_top_rgb);
axis square;
imwrite(color_top_rgb,color_top_rgb_tifffile);

norm_color_bottom_tiff = round(normalize_2D(color_bottom_tiff)*rgb_colormap_resolution);
%hist(norm_color_bottom_tiff)
color_bottom_rgb = ind2rgb(norm_color_bottom_tiff,cMAP);
figure();
imagesc(color_bottom_rgb);
axis square;
imwrite(color_bottom_rgb,color_bottom_rgb_tifffile);


% save decay curve to csv file
X_color_top = (gate1(1):gate1(2))*(50/256);
Y_color_top = normalize(color_top_decay,'range');
color_top_csv = [X_color_top;Y_color_top];
color_top_csv = color_top_csv';

X_color_bottom = (gate2(1):gate2(2))*(50/256);
Y_color_bottom = normalize(color_bottom_decay,'range');
color_bottom_csv = [X_color_bottom;Y_color_bottom];
color_bottom_csv = color_bottom_csv';

color_combine_top_csv = strcat(file_temp,'_combine_gate1.csv');
color_combine_bottom_csv = strcat(file_temp,'_combine_gate2.csv');

writematrix(color_top_csv,color_combine_top_csv);
writematrix(color_bottom_csv,color_combine_bottom_csv);
end