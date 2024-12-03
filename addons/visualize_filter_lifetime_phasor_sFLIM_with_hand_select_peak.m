function [G_t,S_t,total_top_tiff,n_time_bin,omega,top_matrix_gauss,fig_phasor_plot,top_intensity_mask]= visualize_filter_lifetime_phasor_sFLIM_with_hand_select_peak(top_matrix,color,left,right,image_size,path,gate,is_adjust,is_peak)
prompt = {'Filter Type:','Filter threshold','Intensity threshold'};
dlgtitle = 'Input';
dims = [1 35];
%definput = {'gauss','0.8','100'};
definput = {'no','3','0.1'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
filter_threshold = str2double(answer{2});
%intensity_threshold = str2double(answer{3});
ITrel = str2double(answer{3});
filter = answer(1);
%variable need to be define
mkdir(fullfile(path,color));
file_temp = fullfile(path,color,color);
file_temp = strcat(file_temp,'_');
if is_peak == 1
    model.top_left = left;
    model.top_right = right;
    top_matrix_adjust_peak = matrix_peak_reshape(top_matrix,model.top_left,model.top_right);
else
    top_matrix_adjust_peak = top_matrix;
end

input_matrix_size = size(top_matrix_adjust_peak);
figs_to_save = cell(16,1);

%draw total tif
[top, top_decay, total_top_tiff] = visualize_time_decay_image_FLIO(top_matrix_adjust_peak,color);

top_fig_savefile = strcat(file_temp,'total_intensity.png');
saveas(top, top_fig_savefile);

figs_to_save{1} = top;

%ITrel = 0.9;
intensity_threshold=ceil(quantile(total_top_tiff(:),.90)*ITrel); 

%draw tif after intensity threshold
top_intensity_mask = total_top_tiff >= intensity_threshold;
top_matrix_adjust_peak = bsxfun(@times, top_matrix_adjust_peak, cast(top_intensity_mask, 'like', top_matrix_adjust_peak));
[top, top_decay, top_tiff] = visualize_time_decay_image_FLIO(top_matrix_adjust_peak,color);
figs_to_save{2} = top;
filter_fig_savefile = strcat(file_temp,'filtered_intensity.png');
saveas(top, filter_fig_savefile);

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
[G_t, S_t, omega] = get_lifetime_phasor_points(top_matrix_gauss,image_size,1,input_matrix_size(3),0);
%[S_t,G_t] = phasorSmooth(S_t,G_t,3,filter_threshold,0);
%[S_t,G_t] = phasorSmooth(S_t,G_t,3,1,0);
%% nucspot
% if is_adjust == 1
%     if is_peak ==0
%         % adjust phase and mod
%         %experiment location for 60x
%         S = 0.4805;
%         G = -0.3127;
%         % correct location
%         s = 0.4871;
%         g = 0.3885;
%     else
% 
%         %experiment location for 60x
%         S = 0.3742;
%         G = 0.1466;
%         % correct location
%         s = 0.3833;
%         g = 0.1792;
%     end
%% fluorescein
if is_adjust == 1
    if is_peak ==0
        % adjust phase and mod
        %experiment location for 60x
        S = 0.4805;
        G = -0.3127;
        % correct location
        s = 0.4871;
        g = 0.3885;
    else

        %experiment location for 60x
        if strcmp(color,'green')
        S = 0.4437;
        G = 0.2175;
        elseif strcmp(color,'yellow')
        S = 0.4892;
        G = 0.2207;
%         S = 0.5781;
%         G = 0.3847;
        else
            %for atto 633 3.3ns
%         S = 0.4477;
%         G = 0.2499;
        %for golgi ht7 3.8 ns
        S = 0.4545;
        G = 0.2200;
        end
        if strcmp(color,'red')
        % correct location
        %for atto 633 3.3 ns
%         s = 0.4695;
%         g = 0.3291;
%       for golgi ht7 3.8 ns
        s = 0.4442;
        g = 0.2711;
        else
        s = 0.4337;
        g = 0.2518;
        end
    end

    phasediff=atan2(s,g)-atan2(S,G);
    modfac=sqrt((s*s)+(g*g))/sqrt((S*S)+(G*G));


    pha=atan2(S_t,G_t)+phasediff;
    modu=sqrt((S_t.*S_t)+(G_t.*G_t))*modfac;
    S_t=modu.*sin(pha); % calibration for ST- repeate for each channel
    G_t=modu.*cos(pha); % calibration for GT- repeate for each channel

end

%%
phasor_lifetime =(S_t./G_t)/omega;
n_time_bin = input_matrix_size(3);
phasor_lifetime_figure = figure();
imagesc(phasor_lifetime);
colorbar
axis square
%%
fig_phasor_plot = draw_phasor_points(G_t,S_t,1,input_matrix_size(3));
phasor_plot_savefile = strcat(file_temp,gate,'_phasor_plot.png');
saveas(fig_phasor_plot,phasor_plot_savefile);


end