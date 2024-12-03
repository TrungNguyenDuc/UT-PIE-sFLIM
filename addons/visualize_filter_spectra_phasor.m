
function [spectra_mask_combine,spectra_tiff,spectra_G_l,spectra_S_l] = visualize_filter_spectra_phasor(image_channels_matrix,image_size,file_temp,image_for_spectra_phasor)
prompt = {'Filter Type:','Filter threshold','Intensity threshold'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'gauss','0.8','0'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
filter_threshold = str2double(answer{2});
intensity_threshold = str2double(answer{3});
filter = answer(1);

spectra_matrix= sum(image_channels_matrix,3);
spectra_matrix_size = size(spectra_matrix);
spectra_matrix = reshape(spectra_matrix,[spectra_matrix_size(1) spectra_matrix_size(2) spectra_matrix_size(4)]);
spectra_tiff = sum(spectra_matrix,3); %summ all channel,sum all time bin
figure()
imagesc(spectra_tiff)

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


prompt = {'Circle radius:','Number of points:','Ellipse? (Y/N)'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'0.015','2','Y'};
repeat = 1;

while repeat ==1
 
        fig_spectra_phasor_plot = draw_spectra_phasor_points(spectra_G_l,spectra_S_l);
    
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    radius = str2double(answer(1));
    if strcmp(lower(answer(3)), 'n')
        for i = 1:str2double(answer(2))
            sz = image_size;
            [x(i),y(i)] = ginput(1);
            center = [x(i) y(i)];
            viscircles(center,radius)

        end

        %len = size(x);
    else
        ellipse_paras = zeros(str2double(answer(2)),5);
        for i = 1:str2double(answer(2))
            [x,y] = ginput(2);

            plot([x(1) x(2)], [y(1) y(2)],'-','Color','red')

            % Find midpoint
            midX = mean([x(1), x(2)]);
            midY = mean([y(1), y(2)]);
            hold on;
            plot(midX, midY, 'r*');
            % Get the slope
            slope = (y(2) - y(1)) ./ (x(2) - x(1));
            % For perpendicular line, slope = -1/slope
            p_slope = -1/slope;
            p_o_slope = -p_slope;

            [x3,y3] =ginput(1);


            a = norm([x(2) y(2)] - [midX midY]); % major semi-axis
            b = norm([x3 y3] - [midX midY]); % minor semi-axis
            angle = atand(slope);
            p_angle = atand(p_slope);

            p_theta = (p_angle)*pi/180;             % angle of inclination
            % starting point

            x_e=midX + b* cos(p_theta);
            y_e=midY + b* sin(p_theta);

            if angle<0
                p_o_theta = (angle - 90)*pi/180;             % angle of inclination
            else
                p_o_theta = (angle + 90)*pi/180;             % angle of inclination
            end

            x_o_e=midX + b* cos(p_o_theta);
            y_o_e=midY + b* sin(p_o_theta);

            plot([midX x_e], [midY y_e],'-','Color','red')
            plot([midX x_o_e], [midY y_o_e],'-','Color','red')

            theta = angle * pi / 180; %

            % plot the ellipse boundary
            plot_ellipse(midX, midY, a, b, theta,1,'red'); hold on
            ellipse_paras(i,:) = [midX, midY,a,b,theta];

        end
        %len = size(ellipse_paras);

    end

    answer1 = questdlg('Ok with the points?','Yes/No','Yes','No','No');
    % Handle response
    switch answer1
        case 'Yes'
            repeat = 0;
        case 'No'
            repeat = 1;
            close(fig_spectra_phasor_plot);
    end
end
spectra_phasor_plot_savefile = strcat(file_temp,'spectra_phasor_plot.png');
saveas(fig_spectra_phasor_plot,spectra_phasor_plot_savefile);
spectra_mask_collection = cell(str2double(answer(2)),1);
for i = 1:str2double(answer(2))
    sz = image_size;
    if strcmp(lower(answer(3)), 'n')
        spectra_phasor_masked = circle_mask(spectra_G_l, spectra_S_l,[x(i) y(i)],radius,sz);
        % show the mask here/not included the intensity threshold
    else
        spectra_phasor_masked = ellipse_mask(spectra_G_l, spectra_S_l,ellipse_paras(i,1),ellipse_paras(i,2),ellipse_paras(i,3),ellipse_paras(i,4),ellipse_paras(i,5),sz);
        % show the mask here/not included the intensity threshold
    end
    %     spectra_G_l_mask = spectra_G_l.*spectra_intensity_mask;
    %     spectra_S_l_mask = spectra_S_l.*spectra_intensity_mask;
    if intensity_threshold >0
        %mask for green_G_t and green_S_t:
        spectra_phasor_masked = spectra_phasor_masked.*spectra_intensity_mask;

    end

    spectra_mask_collection{i}=spectra_phasor_masked;
    spectra_phasor_filtered = spectra_phasor.*spectra_phasor_masked;

    green_spectra_matrix_masked = bsxfun(@times, image_for_spectra_phasor{1}, cast(spectra_phasor_masked, 'like', image_for_spectra_phasor{1}));
    [green_top, green_top_decay, green_top_tiff] = visualize_time_decay_image(green_spectra_matrix_masked,'green');
    green_combine_top_savefile = strcat(file_temp,'spectra_phasor_',string(i),'_green_combine_gate1.png');
    saveas(green_top, green_combine_top_savefile);
    green_combine_top_tifffile = strcat(file_temp,'spectra_phasor_',string(i),'_green_combine_gate1.tif');
    imwrite(uint16(green_top_tiff),green_combine_top_tifffile);

    yellow_spectra_matrix_masked = bsxfun(@times, image_for_spectra_phasor{2}, cast(spectra_phasor_masked, 'like', image_for_spectra_phasor{2}));
    [yellow_top, yellow_top_decay, yellow_top_tiff] = visualize_time_decay_image(yellow_spectra_matrix_masked,'yellow');
    yellow_combine_top_savefile = strcat(file_temp,'spectra_phasor_',string(i),'_yellow_combine_gate1.png');
    saveas(yellow_top, yellow_combine_top_savefile);
    yellow_combine_top_tifffile = strcat(file_temp,'spectra_phasor_',string(i),'_yellow_combine_gate1.tif');
    imwrite(uint16(yellow_top_tiff),yellow_combine_top_tifffile);


    orange_spectra_matrix_masked = bsxfun(@times, image_for_spectra_phasor{3}, cast(spectra_phasor_masked, 'like', image_for_spectra_phasor{3}));
    [orange_top, orange_top_decay, orange_top_tiff] = visualize_time_decay_image(orange_spectra_matrix_masked,'orange');
    orange_combine_top_savefile = strcat(file_temp,'spectra_phasor_',string(i),'_orange_combine_gate1.png');
    saveas(orange_top, orange_combine_top_savefile);
    orange_combine_top_tifffile = strcat(file_temp,'spectra_phasor_',string(i),'_orange_combine_gate1.tif');
    imwrite(uint16(orange_top_tiff),orange_combine_top_tifffile);


    orange_bottom_spectra_matrix_masked = bsxfun(@times, image_for_spectra_phasor{4}, cast(spectra_phasor_masked, 'like', image_for_spectra_phasor{4}));
    [orange_bottom, orange_bottom_decay, orange_bottom_tiff] = visualize_time_decay_image(orange_bottom_spectra_matrix_masked,'orange');
    orange_combine_bottom_savefile = strcat(file_temp,'spectra_phasor_',string(i),'_orange_combine_gate2.png');
    saveas(orange_bottom, orange_combine_bottom_savefile);
    orange_combine_bottom_tifffile = strcat(file_temp,'spectra_phasor_',string(i),'_orange_combine_gate2.tif');
    imwrite(uint16(orange_bottom_tiff),orange_combine_bottom_tifffile);

    red_spectra_matrix_masked = bsxfun(@times, image_for_spectra_phasor{5}, cast(spectra_phasor_masked, 'like', image_for_spectra_phasor{5}));
    [red_top, red_top_decay, red_top_tiff] = visualize_time_decay_image(red_spectra_matrix_masked,'red');
    red_combine_top_savefile = strcat(file_temp,'spectra_phasor_',string(i),'_red_combine_gate1.png');
    saveas(red_top, red_combine_top_savefile);
    red_combine_top_tifffile = strcat(file_temp,'spectra_phasor_',string(i),'_red_combine_gate1.tif');
    imwrite(uint16(red_top_tiff),red_combine_top_tifffile);

    red_bottom_spectra_matrix_masked = bsxfun(@times, image_for_spectra_phasor{6}, cast(spectra_phasor_masked, 'like', image_for_spectra_phasor{6}));
    [red_bottom, red_bottom_decay, red_bottom_tiff] = visualize_time_decay_image(red_bottom_spectra_matrix_masked,'red');
    red_combine_bottom_savefile = strcat(file_temp,'spectra_phasor_',string(i),'_red_combine_gate2.png');
    saveas(red_bottom, red_combine_bottom_savefile);
    red_combine_bottom_tifffile = strcat(file_temp,'spectra_phasor_',string(i),'_red_combine_gate2.tif');
    imwrite(uint16(red_bottom_tiff),red_combine_bottom_tifffile);


    %     figure()
    %     histogram(spectra_phasor_lifetime_filtered(spectra_phasor_lifetime_filtered>0),10);
    %     axis square;
    %     colorbar;
    %     average_lifetime = mean(spectra_phasor_lifetime_filtered(spectra_phasor_lifetime_filtered>0),'all');
    %     fprintf('Group %d average lifetime: %d ns\n',i,average_lifetime);
    %fprintf('Group %d (center x: %d y: %d)\n',i,x(i),y(i));


end
clear x;
clear y;

% get the mask for total combine intensity image
spectra_mask_combine = zeros(size(spectra_mask_collection{1}));
for i = 1:length(spectra_mask_collection)
    spectra_mask_combine = spectra_mask_combine+spectra_mask_collection{i};
end
spectra_mask_combine(spectra_mask_combine>0)=1;
spectra_mask_combine = 1-spectra_mask_combine;
figure();
imagesc(spectra_mask_combine)
axis square

spectra_tiff_masked_tifffile = strcat(file_temp,'spectra_intensity.tif');
imwrite(uint16(spectra_tiff_masked),spectra_tiff_masked_tifffile);

spectra_intensity_masked_tiff =  spectra_tiff_masked.*spectra_mask_combine;
spectra_intensity_masked_tifffile = strcat(file_temp,'_spectra_intensity_inverse_masked.tif');
imwrite(uint16(spectra_intensity_masked_tiff),spectra_intensity_masked_tifffile);
% figure()
% imagesc(spectra_phasor)
% colorbar
% axis square
% 
% figure()
% histogram(spectra_phasor)

end