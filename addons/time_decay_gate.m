function [top, bottom] = time_decay_gate(image_combine, gate1_start, gate1_stop, gate2_start, gate2_stop)
    top = image_combine(:,:,gate1_start:gate1_stop);
    bottom = image_combine(:,:,gate2_start:gate2_stop);
end