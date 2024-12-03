function fig = draw_spectra_phasor_points(G_l,S_l)
    
    fig = figure();
    
    for i = 1:16
        
        simulated_spectra = zeros(1,16);
        simulated_spectra(i) = 1;
        %simulated_spectra = reshape(simulated_spectra, [1 16]);
        [G_l_reference(i),S_l_reference(i)] = PhasorTransform_Spectra(simulated_spectra,2);
        
    end
    channel_wavelength = {'500 nm', '513.3 nm', '526.6 nm', '539.9 nm', '553.2 nm', '566.5 nm', '579.8 nm', '593.1 nm', '606.4 nm', '619.7 nm', '633 nm', '646.3 nm', '659.6 nm', '672.9 nm', '686.2 nm', '700 nm'}; 
    
    %a = [1:10]'; b = num2str(a); c = cellstr(b);
    scatter(G_l_reference,S_l_reference,'Marker','o','MarkerEdgeAlpha',1,'MarkerEdgeColor','red','MarkerFaceColor','red');
    text(G_l_reference+0.02,S_l_reference+0.02,channel_wavelength)
    plot_FullPhasorCircle()
    %out = scatplot(reshape(G_l,1,[]),reshape(S_l,1,[]));
    G_a = reshape(G_l,1,[]);
S_a = reshape(S_l,1,[]);
G_S = [G_a', S_a'];
G_S = unique(G_S,'rows');
density_scatter(G_S(:,1), G_S(:,2), 'bins', [30, 30],'size',5);
%scatplot(G_S(:,1),G_S(:,2));
%scatplot(G_S(:,1),G_S(:,2));
    %out = scatplot(reshape(G_l,1,[]),reshape(S_l,1,[]),'circles');
    axis equal
end
