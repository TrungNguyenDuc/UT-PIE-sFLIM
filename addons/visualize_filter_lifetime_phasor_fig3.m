function [G_t,S_t,total_top_tiff,fig_phasor_plot]= visualize_filter_lifetime_phasor_fig3(top_matrix,color,left,right,image_size,path,gate)
prompt = {'Filter Type:','Filter threshold','Intensity threshold'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'gauss','0.8','100'};
%definput = {'median','3','20'};
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

G_t_uncorrected = G_t;
S_t_uncorrected = S_t;

if strcmp(color, 'green')
    % adjust phase and mod
    
    % correct location
    s = 0.4381;
    g = 0.2591;
    
    %experiment location for green
    S = 0.4362;
    G = 0.2114;
else
    % correct location
    s = 0.4221;
    g = 0.2320;
    %experiment location for red
    S = 0.3892;
    G = 0.1552;
end
% % adjust phase and mod
% %experiment location for 20x
% S = 0.150;
% G = 0.035;
% % correct location
% s = 0.435;
% g = 0.255;
%%
phasediff=atan2(s,g)-atan2(S,G);
modfac=sqrt((s*s)+(g*g))/sqrt((S*S)+(G*G));


pha=atan2(S_t,G_t)+phasediff;
modu=sqrt((S_t.*S_t)+(G_t.*G_t))*modfac;
S_t=modu.*sin(pha); % calibration for ST- repeate for each channel
G_t=modu.*cos(pha); % calibration for GT- repeate for each channel

G_t_corrected = G_t;
S_t_corrected = S_t;


fig_phasor_plot = draw_phasor_points_fig3(G_t_corrected,S_t_corrected,G_t_uncorrected,S_t_uncorrected,1,input_matrix_size(3));



end