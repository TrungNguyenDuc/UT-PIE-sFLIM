function [G_t,S_t,total_top_tiff,n_time_bin,omega,top_matrix_gauss]= visualize_filter_lifetime_phasor_sFLIM_without_hand_select_peak(top_matrix,color,left,right,image_size,path,gate,is_adjust,is_peak)
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
[G_t, S_t, omega] = get_lifetime_phasor_points(top_matrix_gauss,image_size,1,input_matrix_size(3));

if is_adjust == 1
    if is_peak ==0
        % adjust phase and mod
        %experiment location for 60x
        S = 0.4251;
        G = 0.1498;
        % correct location
        s = 0.4077;
        g = 0.2110;
    else

        %experiment location for 60x
        S = 0.3439;
        G = 0.1365;
        % correct location
        s = 0.3349;
        g = 0.1289;
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
phase=atan2(S_t,G_t);
modfac=sqrt((S_t.*S_t)+(G_t.*G_t));
figure()
imagesc(phase)
axis square;
figure()
imagesc(modfac)
axis square;

%% phase is in radian
draw_phasor_points_fig3_mod_phase(G_t,S_t,phase,1,input_matrix_size(3))
axis square;
%%
draw_phasor_points_fig3_mod_phase(G_t,S_t,modfac,1,input_matrix_size(3))
axis square;


end