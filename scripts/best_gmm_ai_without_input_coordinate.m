
% Generate a synthetic dataset
rng(2); % for reproducibility
num_points = 300;
num_dimensions = 2;
data = [];
data_means = [1, 1; 5, 5; 9, 1]; % Change these to set seeding positions
data_stddevs = [0.5, 0.5; 0.5, 0.5; 0.5, 0.5];
for i = 1:size(data_means, 1)
    cluster_points = data_stddevs(i, :) .* randn(num_points, num_dimensions) + data_means(i, :);
    data = [data; cluster_points];
end

% Determine the best number of clusters using BIC
max_clusters = 5; % Maximum number of clusters to consider
bic_values = zeros(1, max_clusters);
for k = 1:max_clusters
    gm = fitgmdist(data, k, 'RegularizationValue', 1e-6, 'Options', statset('MaxIter', 500));
    bic_values(k) = gm.BIC;
end
[~, best_num_clusters] = min(bic_values);

% Fit the Gaussian Mixture Model with the best number of clusters
gm_best = fitgmdist(data, best_num_clusters, 'RegularizationValue', 1e-6, 'Options', statset('MaxIter', 500));

% Assign points to clusters
cluster_idx = cluster(gm_best, data);

% Visualize the unmixed clusters
figure;
gscatter(data(:, 1), data(:, 2), cluster_idx, 'rgb', 'o', 8);
hold on;

% Plot the cluster centers
mu = gm_best.mu;
plot(mu(:, 1), mu(:, 2), 'kx', 'MarkerSize', 12, 'LineWidth', 2);
legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster Centers');
title('Unmixed Clusters');

hold off;
