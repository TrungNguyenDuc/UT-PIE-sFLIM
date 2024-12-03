function  phasor_lifetime_masked = draw_phasor_points_with_select(G_t,S_t,gate,n_time_bin)
fig = figure();
plot_PhasorCircle_with_reference_lifetime(gate,n_time_bin);
%scatplot(reshape(G_t,1,[]),reshape(S_t,1,[]));
%scatter_kde(reshape(G_t,1,[]),reshape(S_t,1,[]));
%scatterC(reshape(G_t,1,[]),reshape(S_t,1,[]));

%scatter(reshape(G_t,1,[]),reshape(S_t,1,[]),'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',.01,'MarkerEdgeAlpha',.01);

%scatter(reshape(G_t,1,[]),reshape(S_t,1,[]),'MarkerEdgeColor','r','MarkerEdgeAlpha',.01);


G_a = reshape(G_t,1,[]);
S_a = reshape(S_t,1,[]);
G_S = [G_a', S_a'];
G_S = unique(G_S,'rows');
%scatplot(G_S(:,1),G_S(:,2));
scatplot(G_S(:,1),G_S(:,2),'circles');

% 

axis equal

% xlim([min(G_a) max(G_a)*1.1])
% ylim([min(S_a) max(S_a)*1.1])

% set(gca,'xtick',[])
% set(gca,'xticklabel',[])
% set(gca,'ytick',[])
% set(gca,'yticklabel',[])

prompt = {'Circle radius:','Number of points:','Ellipse? (Y/N)'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'0.015','2','Y'};
repeat = 1;

while repeat ==1
    
    fig_phasor_plot = draw_phasor_points(G_t,S_t,1,n_time_bin);
    
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
            midX = mean([x(1), x(2)])
            midY = mean([y(1), y(2)])
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
mask_collection = cell(str2double(answer(2)),1);
for i = 1:str2double(answer(2))
    sz = size(G_t);
    if strcmp(lower(answer(3)), 'n')
        phasor_lifetime_masked{i} = circle_mask(G_t, S_t,[x(i) y(i)],radius,sz(1));
        % show the mask here/not included the intensity threshold
    else
        phasor_lifetime_masked{i} = ellipse_mask(G_t, S_t,ellipse_paras(i,1),ellipse_paras(i,2),ellipse_paras(i,3),ellipse_paras(i,4),ellipse_paras(i,5),sz(1));
        % show the mask here/not included the intensity threshold
    end
end
end


