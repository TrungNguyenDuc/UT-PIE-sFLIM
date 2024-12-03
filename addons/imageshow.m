% colormapeditorString = fileread(strcat(matlabroot,'\toolbox\matlab\graph3d\colormapeditor.m'));
% posStart = strfind(colormapeditorString,'stdcmap(maptype');
% posEnd = strfind(colormapeditorString(posStart:end),'end') + posStart;
% stdcmapString = colormapeditorString(posStart:posEnd);
% split = strsplit(stdcmapString, '(mapsize)');
% list_colormap = cellfun(@(x)x(find(x==' ', 1,'last'):end), split,'uni',0);
% list_colormap(end) = [];

channel_color = {'darkblue','mediumblue','royalblue','deepskyblue','palegreen','forestgreen','darkgreen','greenyellow','yellow','orange','darkorange','orangered','red','firebrick','red','darkred'}


[file,path] = uigetfile('*.tif');
if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
end
file_temp = fullfile(path,file)
file_temp = file_temp(1:end-5)

for i = 1:16
    channelname = sprintf('%d.tif',i)
    fname = strcat(file_temp,channelname)
    info = imfinfo(fname)
    num_images = numel(info) 
        imgs = zeros(256,256, num_images);
        for jj = 1:num_images

            imgs(:,:,jj) = double(imread(fname, jj, 'Info', info));
        end
    
    typename = sprintf('%d_intensity.png',i)
    savefile = strcat(file_temp,typename)
    test = sum(imgs,3)
    imag1 = test
    fig = figure()
    imagesc(imag1)
    colorbar
    cmap(channel_color{i},256,5,5)
    
    axis square;
    saveas(fig,savefile)

    test2 = sum(imgs,1)
%     imag2 = permute(test2,[3 2 1])
%     figure()
%     imagesc(imag2)
%     axis square;

    test3 = sum(test2,2)
    test4 = reshape(test3,1,[])
    fig = figure()
    plot(test4)
    typename = sprintf('%d_total_decay.png',i)
    savefile = strcat(file_temp,typename)
    saveas(fig,savefile)
    % imag3 = permute(test2,[2 3 1])
    % figure()
    % imagesc(imag3)
    % axis square;
    % 
    % test4 = sum(imgs,2)
    % imag4 = permute(test4,[1 3 2])
    % figure()
    % imagesc(imag4)
    % axis square;
    % 
    % test5 = sum(imgs,2)
    % imag5 = permute(test5,[3 1 2])
    % figure()
    % imagesc(imag5)
    % axis square;
end