function [G_t_reference,S_t_reference] = get_expected_gs(gate,n_time_bin,lifetime)
IRFres = 50/256;    % Resolution of IRF


model.num_chan_exp=256;   % channel # of ideal exponential decay
model.left= 0;             % # of data points on the left of the peak. 5 is also fine
model.right= 100;          % # of data points on the right of the peak
model.width=IRFres;        % channel width in ns

t_data = model.width*(0:model.num_chan_exp-1);
t_data = t_data(gate:n_time_bin)';
%t_data = t_data(210:256)';

simulated_decay =exp(-t_data/lifetime);

simulated_decay = reshape(simulated_decay, [1 n_time_bin-gate+1]);
%simulated_decay = reshape(simulated_decay, [1 46+1]);
[G_t_reference,S_t_reference] = PhasorTransform(simulated_decay,2)
end