function [top, bottom] = time_decay_slice(image_combine, slice_point)
    top = image_combine(:,:,1:slice_point);
    bottom = image_combine(:,:,slice_point+1:end);
end