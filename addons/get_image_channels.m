function image_channels = get_image_channels(threshold)
    channel_color = {'darkblue','mediumblue','royalblue','deepskyblue','palegreen','forestgreen','darkgreen','greenyellow','yellow','gold','orange','darkorange','orangered','crimson','red','darkred'};
    [file,path] = uigetfile('*.tif');
    if isequal(file,0)
        disp('User selected Cancel');
    else
        disp(['User selected ', fullfile(path,file)]);
    end
    
    file_temp = fullfile(path,file);
    file_temp = file_temp(1:end-5);
    image_channels = cell(16,1);
    
    for i = 1:16
        channelname = sprintf('%d.tif',i);
        fname = strcat(file_temp,channelname);
        info = imfinfo(fname);
        num_images = numel(info) ;
        image_channels{i} = zeros(256,256, num_images);
        for jj = 1:num_images

            image_channels{i}(:,:,jj) = double(imread(fname, jj, 'Info', info));
        end


        typename = sprintf('%d_intensity.png',i);
        savefile = strcat(file_temp,typename);
        test = sum(image_channels{i},3);
        fig = figure();
        M = max(test, [], 'all');
        clims = [M/threshold M]
        imagesc(test, clims);
        colorbar;
        cmap(channel_color{i},256,5,5);

        axis square;
        axis off;
        saveas(fig,savefile);


        test2 = sum(image_channels{i},1);
        test3 = sum(test2,2);
        test4 = reshape(test3,1,[]);
        fig = figure();
        plot(test4);
        typename = sprintf('%d_total_decay.png',i);
        savefile = strcat(file_temp,typename);
        saveas(fig,savefile);


    end
end