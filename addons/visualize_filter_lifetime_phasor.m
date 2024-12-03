function [mask_combine,G_t,S_t,total_top_tiff,fig_phasor_plot,n_time_bin]= visualize_filter_lifetime_phasor(top_matrix,color,left,right,image_size,path,gate)
prompt = {'Filter Type:','Filter threshold','Intensity threshold'};
dlgtitle = 'Input';
dims = [1 35];
%definput = {'gauss','0.8','100'};
definput = {'median','3','20'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
filter_threshold = str2double(answer{2});
intensity_threshold = str2double(answer{3});
filter = answer(1);
%variable need to be define
mkdir(fullfile(path,color));
file_temp = fullfile(path,color,color);
file_temp = strcat(file_temp,'_');
model.top_left = left;
model.top_right = right;
top_matrix_adjust_peak = matrix_peak_reshape(top_matrix,model.top_left,model.top_right);
input_matrix_size = size(top_matrix_adjust_peak);


[top, top_decay, total_top_tiff] = visualize_time_decay_image(top_matrix_adjust_peak,color);

top_intensity_mask = total_top_tiff >= intensity_threshold;
top_matrix_adjust_peak = bsxfun(@times, top_matrix_adjust_peak, cast(top_intensity_mask, 'like', top_matrix_adjust_peak));
[top, top_decay, top_tiff] = visualize_time_decay_image(top_matrix_adjust_peak,color);



if strcmp(filter, 'gauss')
    top_matrix_gauss = imgaussfilt(top_matrix_adjust_peak,filter_threshold);
    
elseif strcmp(filter, 'median')
    for i = 1:size(top_matrix_adjust_peak,3)
        top_matrix_gauss(:,:,i) = medfilt2(top_matrix_adjust_peak(:,:,i), [filter_threshold filter_threshold]);
    end
else
    top_matrix_gauss = top_matrix_adjust_peak;
end

%intentionally  show the phasor plot without threshold
[G_t, S_t, omega] = get_lifetime_phasor_points(top_matrix_gauss,image_size,1,input_matrix_size(3));
phasor_lifetime =(S_t./G_t)/omega;


% % adjust phase and mod
% %experiment location for 60x
% S = 0.4397;
% G = 0.2120;
% % correct location
% s = 0.4337;
% g = 0.2518;
% 
% % % adjust phase and mod
% % %experiment location for 20x
% % S = 0.150;
% % G = 0.035;
% % % correct location
% % s = 0.435;
% % g = 0.255;
% %%
% phasediff=atan2(s,g)-atan2(S,G);
% modfac=sqrt((s*s)+(g*g))/sqrt((S*S)+(G*G));
% 
% 
% pha=atan2(S_t,G_t)+phasediff;
% modu=sqrt((S_t.*S_t)+(G_t.*G_t))*modfac;
% S_t=modu.*sin(pha); % calibration for ST- repeate for each channel
% G_t=modu.*cos(pha); % calibration for GT- repeate for each channel

prompt = {'Circle radius:','Number of points:','Ellipse? (Y/N)'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'0.015','2','Y'};
repeat = 1;
n_time_bin = input_matrix_size(3);
while repeat ==1
    
    fig_phasor_plot = draw_phasor_points(G_t,S_t,1,input_matrix_size(3));
    
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
            close(fig_phasor_plot);
    end
end
phasor_plot_savefile = strcat(file_temp,gate,'_phasor_plot.png');
saveas(fig_phasor_plot,phasor_plot_savefile);
mask_collection = cell(str2double(answer(2)),1);
for i = 1:str2double(answer(2))
    sz = image_size;
    if strcmp(lower(answer(3)), 'n')
        phasor_lifetime_masked = circle_mask(G_t, S_t,[x(i) y(i)],radius,sz);
        % show the mask here/not included the intensity threshold
    else
        phasor_lifetime_masked = ellipse_mask(G_t, S_t,ellipse_paras(i,1),ellipse_paras(i,2),ellipse_paras(i,3),ellipse_paras(i,4),ellipse_paras(i,5),sz);
        % show the mask here/not included the intensity threshold
    end

    if intensity_threshold >0
        %mask for G_t and S_t:
        phasor_lifetime_masked = phasor_lifetime_masked.*top_intensity_mask;
        %important to include intensity_threshold

    end
    mask_collection{i}=phasor_lifetime_masked;
    phasor_lifetime_filtered = phasor_lifetime.*phasor_lifetime_masked;

    matrix_masked = bsxfun(@times, top_matrix, cast(phasor_lifetime_masked, 'like', top_matrix));
    [top, top_decay, top_tiff] = visualize_time_decay_image(matrix_masked,color);

    hist_fig = figure();
    histogram(phasor_lifetime_filtered(phasor_lifetime_filtered>0),30);
    axis square;

    average_lifetime = mean(phasor_lifetime_filtered(phasor_lifetime_filtered>0),'all');
    if strcmp(lower(answer(3)), 'n')
        fprintf('Group %d (center x: %d y: %d) average lifetime: %d ns\n',i,x(i),y(i),average_lifetime);
    else
        fprintf('Group %d (center x: %d y: %d) average lifetime: %d ns\n',i,ellipse_paras(i,1),ellipse_paras(i,2),average_lifetime);
    end

    figure();
    imagesc(phasor_lifetime_filtered)
    colorbar
    axis square

    if strcmp(lower(answer(3)), 'n')
        phasor_lifetime_filtered_tifffile = strcat(file_temp,gate,'_phasor_lifetime-',string(i),'-',string(x(i)),'-',string(y(i)),'.tif');
        imwrite(uint16(phasor_lifetime_filtered.*10000),phasor_lifetime_filtered_tifffile);

        combine_top_savefile = strcat(file_temp,gate,'_phasor_lifetime-',string(i),'-',string(x(i)),'-',string(y(i)),'-combine.png');
        saveas(top, combine_top_savefile);
        combine_top_tifffile = strcat(file_temp,gate,'_phasor_lifetime-',string(i),'-',string(x(i)),'-',string(y(i)),'-combine.tif');
        imwrite(uint16(top_tiff),combine_top_tifffile);
    else
        phasor_lifetime_filtered_tifffile = strcat(file_temp,gate,'_phasor_lifetime-',string(i),'-',string(ellipse_paras(i,1)),'-',string(ellipse_paras(i,2)),'.tif');
        imwrite(uint16(phasor_lifetime_filtered.*10000),phasor_lifetime_filtered_tifffile);

        combine_top_savefile = strcat(file_temp,gate,'_phasor_lifetime-',string(i),'-',string(ellipse_paras(i,1)),'-',string(ellipse_paras(i,2)),'-combine.png');
        saveas(top, combine_top_savefile);

        hist_fig_savefile = strcat(file_temp,gate,'_hist_phasor_lifetime-',string(i),'-',string(ellipse_paras(i,1)),'-',string(ellipse_paras(i,2)),'.png');
        saveas(hist_fig, hist_fig_savefile);
        
        combine_top_tifffile = strcat(file_temp,gate,'_phasor_lifetime-',string(i),'-',string(ellipse_paras(i,1)),'-',string(ellipse_paras(i,2)),'-combine.tif');
        imwrite(uint16(top_tiff),combine_top_tifffile);
    end

end
clear x;
clear y;

% get the mask for total combine intensity image
mask_combine = zeros(size(mask_collection{1}));
for i = 1:length(mask_collection)
    mask_combine = mask_combine+mask_collection{i};
end
mask_combine(mask_combine>0)=1;
mask_combine = 1-mask_combine;
figure();
imagesc(mask_combine)
axis square

total_top_tifffile = strcat(file_temp,gate,'_total_intensity.tif');
imwrite(uint16(total_top_tiff),total_top_tifffile);

G_csvfile = strcat(file_temp,gate,'_G.csv');
writematrix(flipud(G_t),G_csvfile);

S_csvfile = strcat(file_temp,gate,'_S.csv');
writematrix(flipud(S_t),S_csvfile);

total_top_inverse_masked_tiff =  total_top_tiff.*mask_combine;
total_top_inverse_masked_tifffile = strcat(file_temp,gate,'_total_intensity_inverse_masked.tif');
imwrite(uint16(total_top_inverse_masked_tiff),total_top_inverse_masked_tifffile);


phasor_lifetime_tifffile = strcat(file_temp,gate,'_phasor_lifetime.tif');
imwrite(uint16(phasor_lifetime.*10000),phasor_lifetime_tifffile);

phasor_lifetime_inverse_masked_tiff = phasor_lifetime.*mask_combine;
phasor_lifetime_inverse_masked_tifffile = strcat(file_temp,gate,'_phasor_lifetime_inverse_masked.tif');
imwrite(uint16(phasor_lifetime_inverse_masked_tiff.*10000),phasor_lifetime_inverse_masked_tifffile);

phasor_lifetime_figure = figure();
imagesc(phasor_lifetime);
colorbar
axis square
phasor_lifetime_png = strcat(file_temp,gate,'_phasor_lifetime.png');
saveas(phasor_lifetime_figure, phasor_lifetime_png);

phasor_lifetime_histogram_figure = figure();
histogram(phasor_lifetime);
axis square
phasor_lifetime_png = strcat(file_temp,gate,'_phasor_lifetime_histogram.png');
saveas(phasor_lifetime_histogram_figure, phasor_lifetime_png);
end