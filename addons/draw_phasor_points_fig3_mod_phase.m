function fig = draw_phasor_points_fig3_mod_phase(G_t,S_t,mod_phase,gate,n_time_bin)
fig = figure();
plot_PhasorCircle_with_reference_lifetime(gate,n_time_bin);
%scatplot(reshape(G_t,1,[]),reshape(S_t,1,[]));
%scatter_kde(reshape(G_t,1,[]),reshape(S_t,1,[]));
%scatterC(reshape(G_t,1,[]),reshape(S_t,1,[]));

%scatter(reshape(G_t,1,[]),reshape(S_t,1,[]),'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',.01,'MarkerEdgeAlpha',.01);

%scatter(reshape(G_t,1,[]),reshape(S_t,1,[]),'MarkerEdgeColor','r','MarkerEdgeAlpha',.01);
colormap parula;

scatter(reshape(G_t,1,[]),reshape(S_t,1,[]),5,reshape(mod_phase,1,[]),"filled");

axis equal
end


