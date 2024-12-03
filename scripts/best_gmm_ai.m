% Parameters
num_clusters = 3;   % Set the number of initial clusters
num_samples = 300;  % Number of data points
data_dim = 2;       % Dimensionality of data
true_means = [1, 1; 5, 5; 9, 1];  % True cluster means
true_covs = cat(3, [1 0.5; 0.5 1], [1 -0.5; -0.5 1], [1 0; 0 1]);  % True cluster covariances

% Generate synthetic dataset
rng(1); % Set random seed for reproducibility
data = [];
for i = 1:num_clusters
    data = [data; mvnrnd(true_means(i,:), true_covs(:,:,i), num_samples)];
end

% Initialize cluster means with provided seeding positions
initial_means = [1, 1; 3, 3; 5, 5];

% Initialize other parameters randomly
initial_covs = repmat(eye(data_dim), [1, 1, num_clusters]);
initial_weights = ones(1, num_clusters) / num_clusters;

% Perform Gaussian Mixture Model clustering
gmmodel = fitgmdist(data, num_clusters, 'Start', struct('mu', initial_means, 'Sigma', initial_covs, 'PComponents', initial_weights));

% Determine optimal number of clusters using BIC
min_clusters = 1;
max_clusters = 6;
bic_values = zeros(1, max_clusters - min_clusters + 1);
for k = min_clusters:max_clusters
    gmmodel = fitgmdist(data, k, 'Replicates', 10);
    bic_values(k) = gmmodel.BIC;
end
[~, optimal_num_clusters] = min(bic_values);

% Re-fit the model with the optimal number of clusters
optimal_gmmodel = fitgmdist(data, optimal_num_clusters,'Start', struct('mu', initial_means, 'Sigma', initial_covs, 'PComponents', initial_weights));

% Visualize results
figure;
scatter(data(:, 1), data(:, 2), 36, '.');
hold on;
ezcontour(@(x, y)pdf(optimal_gmmodel, [x y]), [min(data(:, 1)), max(data(:, 1)), min(data(:, 2)), max(data(:, 2))]);
scatter(optimal_gmmodel.mu(:, 1), optimal_gmmodel.mu(:, 2), 100, 'rx', 'LineWidth', 2);
title('Gaussian Mixture Model Clustering');
xlabel('Feature 1');
ylabel('Feature 2');
legend('Data Points', 'Cluster Contours', 'Cluster Means');
grid on;
hold off;

% Visualize results with cluster colors and probabilities
figure;
scatter(data(:, 1), data(:, 2), 36, '.');
hold on;

% Plot data points with different colors based on their assigned clusters
cluster_idx = cluster(optimal_gmmodel, data);
color_map = lines(optimal_num_clusters);
for i = 1:optimal_num_clusters
    scatter(data(cluster_idx == i, 1), data(cluster_idx == i, 2), 36, color_map(i, :), 'filled');
end

% Plot cluster contours
ezcontour(@(x, y)pdf(optimal_gmmodel, [x y]), [min(data(:, 1)), max(data(:, 1)), min(data(:, 2)), max(data(:, 2))]);

% Plot cluster means
scatter(optimal_gmmodel.mu(:, 1), optimal_gmmodel.mu(:, 2), 100, 'rx', 'LineWidth', 2);

% Display probabilities for each point belonging to each cluster
probs = posterior(optimal_gmmodel, data);
for i = 1:optimal_num_clusters
    text(data(:, 1) + 0.1, data(:, 2) + 0.1, num2str(probs(:, i)), 'Color', color_map(i, :));
end

title('Gaussian Mixture Model Clustering with Probabilities');
xlabel('Feature 1');
ylabel('Feature 2');
legend('Data Points', 'Cluster Points', 'Cluster Contours', 'Cluster Means');
grid on;
hold off;

% Visualize probability of each point belonging to each cluster
figure;
probs = posterior(optimal_gmmodel, data);
scatter(data(:, 1), data(:, 2), 36, probs, 'filled');
colorbar;
title('Point Probabilities for Each Cluster');
xlabel('Feature 1');
ylabel('Feature 2');
grid on;

% Visualize results: Probability of each point belonging to each cluster
figure;
probs = posterior(optimal_gmmodel, data);
scatter(data(:, 1), data(:, 2), 36, probs, 'filled', 'MarkerFaceAlpha', 0.6);
colormap('parula');
title('Point Probabilities for Each Cluster');
xlabel('Feature 1');
ylabel('Feature 2');
colorbar;
grid on;

% % Visualize results
% figure;
% scatter(data(:, 1), data(:, 2), 36, '.');
% hold on;
% 
% figure;
% scatter(data(:, 1), data(:, 2), 36, '.');
% hold on;
% for k = 1:optimal_num_clusters
%     cluster_probs = posterior(optimal_gmmodel, data);
%     cluster_colors = jet(optimal_num_clusters);
%     scatter(data(cluster_probs(:, k) >= 0.01, 1), data(cluster_probs(:, k) >= 0.01, 2), 50, cluster_colors(k, :), 'filled', 'MarkerFaceAlpha', cluster_probs(cluster_probs(:, k) >= 0.01, k));
% end
% scatter(optimal_gmmodel.mu(:, 1), optimal_gmmodel.mu(:, 2), 100, 'rx', 'LineWidth', 2);
% title('Gaussian Mixture Model Clustering with Cluster Probabilities');
% xlabel('Feature 1');
% ylabel('Feature 2');
% legend('Data Points', 'Cluster Means');
% grid on;
% hold off;
