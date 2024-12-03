num_samples = 500;  % Number of data points
data_dim = 4;       % Dimensionality of data (changed to 4)
true_means = [1, 1, 1, 1; 5, 5, 5, 5; 9, 1, 9, 1; 2, 3, 2, 3; 3, 3, 3, 3];  % True cluster means (adjusted for 4 dimensions)

% Generate synthetic dataset
rng(1); % Set random seed for reproducibility
data = [];
for i = 1:size(true_means, 1)
    data = [data; mvnrnd(true_means(i,:), eye(data_dim), num_samples)];
end

% Perform DBSCAN clustering
epsilon = 0.5;  % Distance threshold for neighborhood
minPts = 5;     % Minimum number of points to form a cluster

[idx, isCorePoint] = dbscan(data, epsilon, minPts);

% Visualize the results
figure;
hold on;

num_clusters = max(idx);
colors = lines(num_clusters);

for i = 1:num_clusters
    cluster_points = data(idx == i, :);
    scatter(cluster_points(:, 1), cluster_points(:, 2), 36, colors(i, :), 'filled', 'MarkerFaceAlpha', 0.3);
end

outlier_points = data(idx == 0, :);
scatter(outlier_points(:, 1), outlier_points(:, 2), 36, [0.5 0.5 0.5], 'x', 'LineWidth', 2);
title('DBSCAN Clustering');
xlabel('Feature 1');
ylabel('Feature 2');
grid on;
legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4', 'Outliers');
hold off;