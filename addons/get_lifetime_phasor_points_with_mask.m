function [G_t, S_t, omega] = get_lifetime_phasor_points(decay_matrix,mask,sz,gate,n_time_bin)
    G_t = zeros(sz,sz);
    S_t = zeros(sz,sz);
    for i = 1:sz
        %i
        TRES = decay_matrix(i,:,gate:n_time_bin);
        matrix_size = size(TRES);
        TRES = reshape(TRES, [matrix_size(2) matrix_size(3)]);
        [G_t(i,:),S_t(i,:)] = PhasorTransform(TRES,2);
            
    end

    figure()
    omega = plot_PhasorCircle_with_reference_lifetime(gate,n_time_bin);
    out = scatplot(reshape(G_t,1,[]),reshape(S_t,1,[]));
    axis equal
end


