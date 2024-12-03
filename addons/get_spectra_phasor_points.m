function [G_l, S_l,omega] = get_spectra_phasor_points(spectra_matrix,sz)
%     spectra_matrix= sum(image_channels_matrix,3);
%     spectra_matrix_size = size(spectra_matrix);
%     spectra_matrix = reshape(spectra_matrix,[spectra_matrix_size(1) spectra_matrix_size(2) spectra_matrix_size(4)]);
    G_l = zeros(sz,sz);
    S_l = zeros(sz,sz);
    for i = 1:sz
            %i
            TRES = spectra_matrix(i,:,:);
            matrix_size = size(TRES);
            TRES = reshape(TRES, [matrix_size(2) matrix_size(3)]);
            [G_l(i,:),S_l(i,:)] = PhasorTransform_Spectra(TRES,2);
    end            
    
    figure()
    
    for i = 1:16
        
        simulated_spectra = zeros(1,16);
        simulated_spectra(i) = 1;
        %simulated_spectra = reshape(simulated_spectra, [1 16]);
        [G_l_reference(i),S_l_reference(i)] = PhasorTransform_Spectra(simulated_spectra,2);
        
    end
    omega = S_l_reference(1)/G_l_reference(1);
    channel_wavelength = {'500 nm', '513.3 nm', '526.6 nm', '539.9 nm', '553.2 nm', '566.5 nm', '579.8 nm', '593.1 nm', '606.4 nm', '619.7 nm', '633 nm', '646.3 nm', '659.6 nm', '672.9 nm', '686.2 nm', '700 nm'}; 
    
    %a = [1:10]'; b = num2str(a); c = cellstr(b);
    scatter(G_l_reference,S_l_reference,'Marker','o','MarkerEdgeAlpha',1,'MarkerEdgeColor','red','MarkerFaceColor','red');
    text(G_l_reference+0.02,S_l_reference+0.02,channel_wavelength)
    plot_FullPhasorCircle()
    G_a = reshape(G_l,1,[]);
    S_a = reshape(S_l,1,[]);
    G_S = [G_a', S_a'];
    G_S = unique(G_S,'rows');
    scatter(G_S(:,1),G_S(:,2));
    %scatplot(G_S(:,1),G_S(:,2),'squares');
    %out = scatplot(reshape(G_l,1,[]),reshape(S_l,1,[]));
    axis equal
end
