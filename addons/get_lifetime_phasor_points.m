function [G_t, S_t, omega] = get_lifetime_phasor_points(decay_matrix,sz,gate,n_time_bin,is_draw)
G_t = zeros(sz,sz);
S_t = zeros(sz,sz);
for i = 1:sz
    %i
    TRES = decay_matrix(i,:,gate:n_time_bin);
    matrix_size = size(TRES);
    TRES = reshape(TRES, [matrix_size(2) matrix_size(3)]);
    [G_t(i,:),S_t(i,:)] = PhasorTransform(TRES,2);

end
figure();
omega = plot_PhasorCircle_with_reference_lifetime(gate,n_time_bin);
if is_draw == 0
    fprintf('no draw\n')
else
    figure();
    omega = plot_PhasorCircle_with_reference_lifetime(gate,n_time_bin);
    %out = scatplot(reshape(G_t,1,[]),reshape(S_t,1,[]));
    %scatter_kde(reshape(G_t,1,[]),reshape(S_t,1,[]));
    %scatter(reshape(G_t,1,[]),reshape(S_t,1,[]),'MarkerFaceColor','b','MarkerEdgeColor','b','MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2);

    if is_draw == 1
        G_a = reshape(G_t,1,[]);
        S_a = reshape(S_t,1,[]);
        G_S = [G_a', S_a'];
        G_S = unique(G_S,'rows')
        %scatplot(G_S(:,1),G_S(:,2));
        %scatplot(G_S(:,1),G_S(:,2),'circles');
        density_scatter(G_S(:,1), G_S(:,2), 'bins', [30, 30],'size',5);
        axis equal
    else
        scatter(reshape(G_t,1,[]),reshape(S_t,1,[]),'MarkerFaceColor','b','MarkerEdgeColor','b','MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2);
    end
end
end


