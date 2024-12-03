num_samples = 500;  % Number of data points
data_dim = 4;       % Dimensionality of data (changed to 4)
true_means = [1, 1, 1, 1; 5, 5, 5, 5; 9, 1, 9, 1; 2, 3, 2, 3; 3, 3, 3, 3];  % True cluster means (adjusted for 4 dimensions)

% Generate synthetic dataset
rng(1); % Set random seed for reproducibility
data = [];
for i = 1:size(true_means, 1)
    data = [data; mvnrnd(true_means(i,:), eye(data_dim), num_samples)];
end

% Automatic selection of the optimal number of clusters using the elbow method
max_clusters = 10;
distortions = zeros(1, max_clusters);
for k = 1:max_clusters
    [~, ~, sumd] = kmeans(data, k);
    distortions(k) = sum(sumd);
end

% Plot the elbow curve
figure;
plot(1:max_clusters, distortions, 'bx-');
title('Elbow Method for Optimal K');
xlabel('Number of Clusters');
ylabel('Distortion');
grid on;

% Select the optimal number of clusters based on the elbow curve (visual inspection)
optimal_num_clusters = input('Enter the optimal number of clusters: ');

% Perform K-Means clustering with the optimal number of clusters
[idx, centroids] = kmeans(data, optimal_num_clusters);

% Visualize the results
figure;
hold on;
color_map = lines(optimal_num_clusters);
for i = 1:optimal_num_clusters
    scatter(data(idx == i, 1), data(idx == i, 2), 36, color_map(i, :), 'filled', 'MarkerFaceAlpha', 0.3);
end
scatter(centroids(:, 1), centroids(:, 2), 100, 'rx', 'LineWidth', 2);
title('K-Means Clustering');
xlabel('Feature 1');
ylabel('Feature 2');
legend('Data Points', 'Cluster Centers');
grid on;
hold off;

% Visualize results in other dimensions
figure;
hold on;
for i = 1:optimal_num_clusters
    scatter(data(idx == i, 3), data(idx == i, 4), 36, color_map(i, :), 'filled', 'MarkerFaceAlpha', 0.3);
end
scatter(centroids(:, 3), centroids(:, 4), 100, 'rx', 'LineWidth', 2);
title('K-Means Clustering');
xlabel('Feature 3');
ylabel('Feature 4');
legend('Data Points', 'Cluster Centers');
grid on;
hold off;
