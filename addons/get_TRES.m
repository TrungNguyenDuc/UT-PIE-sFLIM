function TRES = get_TRES(image_channels_matrix,pixel_x,pixel_y)
TRES = image_channels_matrix(pixel_x,pixel_y,:,:);
TRES_size = size(TRES);
TRES = reshape(TRES,TRES_size(3),TRES_size(4));
end