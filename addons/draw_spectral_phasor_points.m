function fig = draw_spectral_phasor_points(G_t,S_t,gate,n_time_bin)
fig = figure();
plot_PhasorCircle_with_reference_lifetime(gate,n_time_bin);
%scatplot(reshape(G_t,1,[]),reshape(S_t,1,[]));
%scatter_kde(reshape(G_t,1,[]),reshape(S_t,1,[]));
%scatterC(reshape(G_t,1,[]),reshape(S_t,1,[]));

%scatter(reshape(G_t,1,[]),reshape(S_t,1,[]),'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',.01,'MarkerEdgeAlpha',.01);

%scatter(reshape(G_t,1,[]),reshape(S_t,1,[]),'MarkerEdgeColor','r','MarkerEdgeAlpha',.01);


G_a = reshape(G_t,1,[]);
S_a = reshape(S_t,1,[]);
G_S = [G_a', S_a'];
G_S = unique(G_S,'rows');
%scatplot(G_S(:,1),G_S(:,2));
scatplot(G_S(:,1),G_S(:,2),'circles');

% 

axis equal

% xlim([min(G_a) max(G_a)*1.1])
% ylim([min(S_a) max(S_a)*1.1])

% set(gca,'xtick',[])
% set(gca,'xticklabel',[])
% set(gca,'ytick',[])
% set(gca,'yticklabel',[])
end


