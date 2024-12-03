function omega = plot_PhasorCircle_with_reference_lifetime_PIE2(gate,n_time_bin)
    IRFres = 50/256;    % Resolution of IRF 
    
    
    model.num_chan_exp=256;   % channel # of ideal exponential decay
    model.left= 0;             % # of data points on the left of the peak. 5 is also fine
    model.right= 100;          % # of data points on the right of the peak
    model.width=IRFres;        % channel width in ns 
    
    t_data = model.width*(0:model.num_chan_exp-1);
    t_data = t_data(gate:n_time_bin)';
    %t_data = t_data(210:256)';
    for i =1:10
    simulated_decay =exp(-t_data/i);
    
    simulated_decay = reshape(simulated_decay, [1 n_time_bin-gate+1]);
    %simulated_decay = reshape(simulated_decay, [1 46+1]);
    [G_t_reference(i),S_t_reference(i)] = PhasorTransform_PIE2(simulated_decay,2);
    
    %[G_t_reference(i),S_t_reference(i)] = PhasorTransform(simulated_decay(:,gate:n_time_bin),2);
    end
    omega = S_t_reference(1)/G_t_reference(1);
    
    a = [1:10]'; b = num2str(a); c = cellstr(b);
    scatter(G_t_reference,S_t_reference,'Marker','.','MarkerEdgeAlpha',0.5);
    text(G_t_reference,S_t_reference,c)
    plot_PhasorCircle();
end