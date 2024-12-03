% function image_combine = combine_multi_channels(image_channels, start, stop, color)
% 
%     image_combine = zeros(size(image_channels{1}));
%     for i = start:stop
% 
%         image_combine = image_combine + image_channels{i};
% 
%     end
%     test = sum(image_combine,3);
%     imag1 = test;
%     fig = figure();
%     imagesc(imag1);
%     colorbar;
%     axis square
%     cMAP = cmap(color,256,5,5);
%     colormap(cMAP);
%     test2 = sum(image_combine,1);
%     test3 = sum(test2,2);
%     test4 = reshape(test3,1,[]);
%     fig = figure();
%     plot(test4);
% end

function [image_combine, fig] = combine_multi_channels(image_channels, start, stop, color)

    image_combine = zeros(size(image_channels{1}));
    for i = start:stop

        image_combine = image_combine + image_channels{i};

    end
    test = sum(image_combine,3);
    fig = figure();
    subplot(2,1,1);
    imagesc(test);
    colorbar;
    cMAP = cmap(color,256,5,5);
    colormap(cMAP);
    title(color);
    axis square;
   
    test2 = sum(image_combine,1);
    test3 = sum(test2,2);
    test4 = reshape(test3,1,[]);
    subplot(2,1,2);
    plot(test4);
    
end