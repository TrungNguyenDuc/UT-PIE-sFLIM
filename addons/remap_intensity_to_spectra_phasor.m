function remap_intensity_to_spectra_phasor(spectra_tiff,spectra_G_l,spectra_S_l,image_size)
figure()
imagesc(spectra_tiff); 
axis square
prompt = {'Circle radius:','Number of points:','Ellipse? (Y/N)'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'10','1','Y'};
repeat = 1;
while repeat ==1
    
    fig_for_select = figure(); 
    imagesc(spectra_tiff); 
    axis square
    hold on;
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
            close(fig_for_select);
    end
end

for i = 1:str2double(answer(2))
    sz = image_size;
    if strcmp(lower(answer(3)), 'n')
        phasor_lifetime_masked = circle_mask_intensity([x(i) y(i)],radius,sz);
        fig_spectra_phasor_plot = draw_spectra_phasor_points(spectra_G_l,spectra_S_l);
        % show the mask here/not included the intensity threshold
        for index_x = 1:sz
            for  index_y= 1:sz
            if phasor_lifetime_masked(index_x,index_y) == 1
                plot(spectra_G_l(index_x,index_y),spectra_S_l(index_x,index_y),'.','Color','red')
%                 index_x
%                 index_y
            end
            end
        end
    else
        phasor_lifetime_masked = ellipse_mask_intensity(ellipse_paras(i,1),ellipse_paras(i,2),ellipse_paras(i,3),ellipse_paras(i,4),ellipse_paras(i,5),sz)
        fig_spectra_phasor_plot = draw_spectra_phasor_points(spectra_G_l,spectra_S_l);
        % show the mask here/not included the intensity threshold
        for index_x = 1:sz
            for  index_y= 1:sz
            if phasor_lifetime_masked(index_x,index_y) == 1
                plot(spectra_G_l(index_x,index_y),spectra_S_l(index_x,index_y),'.','Color','red')
%                 index_x
%                 index_y
            end
            end
        end
    end

end

clear x;
clear y;
end