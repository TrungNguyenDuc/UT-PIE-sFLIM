% function [fig_intensity, fig_time_decay] = visualize_time_decay_image(image_combine, color)
%     test = sum(image_combine,3);
%     fig_intensity = figure();
%     imagesc(test);
%     colorbar;
%     cMAP = cmap(color,1024,5,5);
%     colormap(cMAP);
%     axis square;
%     test2 = sum(image_combine,1);
%     test3 = sum(test2,2);
%     test4 = reshape(test3,1,[]);
%     fig_time_decay = figure();
%     plot(test4);
% end

function [fig_intensity_and_time_decay, decay, tiff] = visualize_time_decay_image_FLIO(image_combine, color)
    tiff = sum(image_combine,3);
    fig_intensity_and_time_decay = figure();
    
    imagesc(tiff);
    colorbar;
    cMAP = cmap(color,1024,5,5);
    colormap(cMAP);
    title(color);
    axis square;
    
    test2 = sum(image_combine,1);
    test3 = sum(test2,2);
    decay = reshape(test3,1,[]);
    
    plot(decay);
end