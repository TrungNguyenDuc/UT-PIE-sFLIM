function [spectra_tiff,spectra_G_l,spectra_S_l,spectra_intensity_mask] = visualize_filter_spectra_phasor_3_emissions(image_channels_matrix,image_size,file_temp,image_for_spectra_phasor)
prompt = {'Filter Type:','Filter threshold','Intensity threshold'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'no','0.8','0.3'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
filter_threshold = str2double(answer{2});
ITrel = str2double(answer{3});
filter = answer(1);

spectra_matrix= sum(image_channels_matrix,3);
spectra_matrix_size = size(spectra_matrix);
spectra_matrix = reshape(spectra_matrix,[spectra_matrix_size(1) spectra_matrix_size(2) spectra_matrix_size(4)]);
spectra_tiff = sum(spectra_matrix,3); %summ all channel,sum all time bin
figure()
imagesc(spectra_tiff)
%ITrel = 0.9;
intensity_threshold=ceil(quantile(spectra_tiff(:),.90)*ITrel); 
% increase the 0.9 to 0.95 will reduce the intensity threshold
spectra_intensity_mask = spectra_tiff >= intensity_threshold;
figure()
imagesc(spectra_intensity_mask)

spectra_matrix= bsxfun(@times, spectra_matrix, cast(spectra_intensity_mask, 'like', spectra_matrix));
spectra_tiff_masked = sum(spectra_matrix,3);
figure()
imagesc(spectra_tiff_masked)

filter = answer(1);
if strcmp(filter, 'gauss')
    spectra_matrix_gauss = imgaussfilt(spectra_matrix,filter_threshold);
elseif strcmp(filter, 'median')
    for i = 1:size(spectra_matrix,3)
        spectra_matrix_gauss(:,:,i) = medfilt2(spectra_matrix(:,:,i), [filter_threshold filter_threshold]);
    end
    spectra_matrix_gauss = imgaussfilt(spectra_matrix_gauss,0.5);
else
    spectra_matrix_gauss = spectra_matrix;
end

[spectra_G_l, spectra_S_l,spectra_omega] = get_spectra_phasor_points(spectra_matrix_gauss,image_size);
spectra_phasor=(spectra_S_l./spectra_G_l)/spectra_omega;


 
        fig_spectra_phasor_plot = draw_spectra_phasor_points(spectra_G_l,spectra_S_l);
    
spectra_phasor_plot_savefile = strcat(file_temp,'spectra_phasor_plot.png');
saveas(fig_spectra_phasor_plot,spectra_phasor_plot_savefile);
end