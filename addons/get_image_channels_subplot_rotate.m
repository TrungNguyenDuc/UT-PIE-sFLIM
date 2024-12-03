function get_image_channels_subplot_rotate(image_channels,threshold,path,file_temp,file)
%channel_color = {'palegreen','forestgreen','darkgreen','greenyellow','yellowgreen','khaki','lemonchiffon','palegoldenrod','yellow','gold','orange','darkorange','orangered','crimson','red','darkred'};
channel_color = linspace(500,700,16);
channel_wavelength = {'Ch1 500 nm', 'Ch2 513.3 nm', 'Ch3 526.6 nm', 'Ch4 539.9 nm', 'Ch5 553.2 nm', 'Ch6 566.5 nm', 'Ch7 579.8 nm', 'Ch8 593.1 nm', 'Ch9 606.4 nm', 'Ch10 619.7 nm', 'Ch11 633 nm', 'Ch12 646.3 nm', 'Ch13 659.6 nm', 'Ch14 672.9 nm', 'Ch15 686.2 nm', 'Ch16 700 nm'};

fig_intensity = figure(3);
fig_decay = figure(4);
for i = 1:16
    test = sum(image_channels(:,:,:,i),3);
    figure(3);
    ax(i) = subplot(4,4,i);

    % set threshold for visualization
    M = max(test, [], 'all');
    clims = [M/threshold M];
    try
        imagesc(test, clims);
    catch
        imagesc(test);
    end
    colorbar
    cMAP = cmap(spectrumRGB(channel_color(i),'1931_FULL'),1024,5,5);
    colormap(ax(i),cMAP);
    title(channel_wavelength{i})
    axis square;
    axis off;


    test2 = sum(image_channels(:,:,:,i),1);
    test3 = sum(test2,2);
    test4 = reshape(test3,1,[]);
    figure(4);
    subplot(4,4,i);
    plot(test4);
    title(channel_wavelength{i})
    typename = sprintf('%d_total_decay.png',i);
    savefile = strcat(file_temp,typename);

end
% currDate = strrep(datestr(datetime), ':', '_');
% mkdir(fullfile(path,'results',currDate));
% fig_intensity.Position = [0 0 1366 768];
% fig_decay.Position = [0 0 1366 768];
% save_folder =fullfile(path,'results',currDate)
% file_temp = fullfile(path,'results',currDate,file);
% file_temp = file_temp(1:end-7);
intensity_savefile = strcat(file_temp,'multi_intensity_rotate.png');
decay_savefile = strcat(file_temp,'multi_decay_rotate.png');
saveas(fig_intensity, intensity_savefile);
saveas(fig_decay, decay_savefile);
end