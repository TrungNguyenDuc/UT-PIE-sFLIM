% Change the current folder to the folder of this m-file.
if(~isdeployed)
  cd(fileparts(matlab.desktop.editor.getActiveFilename));
end
%%

% Initialization steps.
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
addpath('./scripts');
addpath('./functions')
addpath('./flimtools')
addpath('./addons')
%set(gcf,'color','w');

%% all setting
is_adjust = 1; %calib the phasor plot
is_peak = 1; %calib with decay calculate from peak location
lifetime_limit = [0 5]; % for visualization only, still keep the data without filtering
nonlinear_cmap_setting = [0.1 3]; % for visualization only, with non linear color code
cluster_number = 2; % cluster number 3-6
isfilter = 1; % apply median filter or not on G_t, S_t separately
medfilt_size = 3; % median filter size default 3/ extreme 5
ntimes = 1; % median filter repeat
ITrel = 1; % relative percentage of intensity as lower threshold
outliers_remove = 1; % remove outlier in boxplot and nhist

%% Threshold option for spatial segmentation
%set_threshold = false;
set_threshold = true;
threshold_percent = 0.05;

%% rgb setting
rgb_colormap_resolution = 4096;

%% Gate setting
gate1 = [1, 125];
gate2 = [126, 256];

%% Rotate
rotate_point = 20;
%rotate_point = 40;
%% Channel combination
green_combine = [1 4];
orange_combine = [5 8];
orange_combine = [9 12];
red_combine = [13 16];


%% Lifetime fitting range
model.top_left= 0;             % # of data points on the left of the peak. 5 is also fine- Important
model.top_right= 70;          % # of data points on the right of the peak

model.bottom_left= 10;             % # of data points on the left of the peak. 5 is also fine- Important
model.bottom_right= 80;          % # of data points on the right of the peak


%% Multi subplot
[image_channels, file_temp,path,file,save_folder] = get_image_channels_subplot(100);
image_channels_matrix = cat(4,image_channels{:});
image_channels_matrix_rotate = zeros(size(image_channels_matrix));

%% Image size
image_channels_size = size(image_channels_matrix);
image_size = image_channels_size(1);
bin_size = image_channels_size(3);

%% Rotate
image_channels_matrix_rotate(:,:,1:(bin_size-rotate_point+1),:) = image_channels_matrix(:,:,rotate_point:bin_size,:);
image_channels_matrix_rotate(:,:,(bin_size-rotate_point+2):bin_size,:) = image_channels_matrix(:,:,1:(rotate_point-1),:);
image_channels_matrix = image_channels_matrix_rotate;
get_image_channels_subplot_rotate(image_channels_matrix,100,path,file_temp,file)

%% Combine function
green_combine = [1 4];
orange_combine = [6 8];
%orange_combine = [9 10];
red_combine = [15 16];
%% Green
[image_combine, fig_combine, top_green_matrix, bottom_green_matrix,green_decay_combine] = get_top_and_bottom_matrix...
    (image_channels_matrix,green_combine,gate1,gate2,set_threshold,threshold_percent,...
    file_temp,rgb_colormap_resolution);
%% Yellow
[image_combine, fig_combine,top_orange_matrix, bottom_orange_matrix,orange_decay_combine] = get_top_and_bottom_matrix...
    (image_channels_matrix,orange_combine,gate1,gate2,set_threshold,threshold_percent,...
    file_temp,rgb_colormap_resolution);
%% Orange

[image_combine, fig_combine,top_orange_matrix, bottom_orange_matrix,orange_decay_combine] = get_top_and_bottom_matrix...
    (image_channels_matrix,orange_combine,gate1,gate2,set_threshold,threshold_percent,...
    file_temp,rgb_colormap_resolution);
%% Red
[image_combine, fig_combine,top_red_matrix, bottom_red_matrix,red_decay_combine] = get_top_and_bottom_matrix...
    (image_channels_matrix,red_combine,gate1,gate2,set_threshold,threshold_percent,...
    file_temp,rgb_colormap_resolution);

%% Total intensity image
total_intensity = sum(image_channels_matrix,4);
total_intensity = sum(total_intensity,3);
total_intensity = reshape(total_intensity, [image_size image_size]);
total_intensity_fig = figure();
imagesc(total_intensity)
axis square;
colorbar;
%% Spectral phasor based on 16 channels
image_for_spectra_phasor = cell(3,1);
image_for_spectra_phasor{1} = top_green_matrix;
image_for_spectra_phasor{2} = top_orange_matrix;
image_for_spectra_phasor{3} = bottom_red_matrix;

[spectra_tiff,spectra_G_l,spectra_S_l,spectra_intensity_mask] = visualize_filter_spectra_phasor_3_emissions(image_channels_matrix_rotate,image_size,file_temp,image_for_spectra_phasor);
% Filtering the spectra phasor
 [SS_smooth,GG_smooth] = phasorSmooth(spectra_S_l,spectra_G_l,3,1,0);
 draw_spectra_phasor_points(GG_smooth,SS_smooth)
% Unmixing using GMM for spectra phasor
[cluster_prob,cluster_intensity]=GMM_unmixing_spectra(GG_smooth,SS_smooth,total_intensity,cluster_number,3,3,0.05,path,'spectra');


%% Lifetime phasor plot for each color (green, orange, orange, red)
%% Green 

[G_t_green,S_t_green,total_top_tiff_green,n_time_bin,omega,top_matrix_gauss,fig_phasor_plot,top_intensity_mask_green]=visualize_filter_lifetime_phasor_sFLIM_with_hand_select_peak(top_green_matrix,'green',model.top_left,model.top_right,image_size,save_folder,'top',is_adjust,is_peak);

% Filtering the lifetime phasor
[SS_green,GG_green] = phasorSmooth(S_t_green,G_t_green,3,1,0);
%draw_phasor_points(GG_green,SS_green,1,70)

% Unmixing using GMM for lifetime phasor
[cluster_prob_green,cluster_intensity_green,IDX_green,G_green,S_green,phasor_lifetime_green,intensity_for_cluster_unmixing]=GMM_unmixing(GG_green,SS_green,total_top_tiff_green,cluster_number,3,1,0.05,1,n_time_bin,save_folder,'green',omega,lifetime_limit,nonlinear_cmap_setting);


%% Orange
[G_t_orange,S_t_orange,total_top_tiff_orange,n_time_bin,omega,top_matrix_gauss,fig_phasor_plot,top_intensity_mask_orange]=visualize_filter_lifetime_phasor_sFLIM_with_hand_select_peak(top_orange_matrix,'orange',model.top_left,model.top_right,image_size,save_folder,'top',is_adjust,is_peak);

%
[SS_orange,GG_orange] = phasorSmooth(S_t_orange,G_t_orange,3,1,0);
%draw_phasor_points(GG_orange,SS_orange,1,70)

%
[cluster_prob_orange,cluster_intensity_orange,IDX_orange,G_orange,S_orange,phasor_lifetime_orange,intensity_for_cluster_unmixing]=GMM_unmixing(GG_orange,SS_orange,total_top_tiff_orange,2,3,1,0.05,1,n_time_bin,save_folder,'orange',omega,lifetime_limit,nonlinear_cmap_setting);

%% Red
[G_t_red,S_t_red,total_top_tiff_red,n_time_bin,omega,mask_combine,fig_phasor_plot]=visualize_filter_lifetime_phasor_sFLIM_with_hand_select_peak(top_red_matrix,'red',model.top_left,model.top_right,image_size,save_folder,'top',is_adjust,is_peak);

%
[SS_red,GG_red] = phasorSmooth(S_t_red,G_t_red,3,1,0);
%draw_phasor_points(GG_red,SS_red,1,70)
%
[cluster_prob_red,cluster_intensity_red,IDX_red,G_red,S_red,phasor_lifetime_red,intensity_for_cluster_unmixing]=GMM_unmixing(GG_red,SS_red,total_top_tiff_red,2,3,1,0.05,1,n_time_bin,save_folder,'red',omega,lifetime_limit,nonlinear_cmap_setting);


