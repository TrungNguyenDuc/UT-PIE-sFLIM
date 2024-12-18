% Make sure you have the Fuzzy Logic Toolbox installed
if ~license('test', 'Fuzzy_Toolbox')
    error('Fuzzy Logic Toolbox is not installed.');
end

num_clusters = 5;   % Set the number of clusters
num_samples = 500;  % Number of data points
data_dim = 4;       % Dimensionality of data (changed to 4)
true_means = [1, 1, 1, 1; 5, 5, 5, 5; 9, 1, 9, 1; 2, 3, 2, 3; 3, 3, 3, 3];  % True cluster means (adjusted for 4 dimensions)

% Generate synthetic dataset
rng(1); % Set random seed for reproducibility
data = [];
for i = 1:num_clusters
    data = [data; mvnrnd(true_means(i,:), eye(data_dim), num_samples)];
end

min_clusters = 1;
max_clusters = 6;
validity_values = zeros(1, max_clusters - min_clusters + 1);

for k = min_clusters:max_clusters
    % Create a fuzzy c-means clustering object
    options = [2.0; 100; 1e-5; 0]; % FCM options: [exponent, max_iter, min_improvement, info_display]
    [centers, U] = fcm(data, k, options);
    
    % Calculate the Xie-Beni index as a validity measure
    dists = U.^2 * pdist2(data, centers).^2;
    validity_values(k) = sum(dists(:)) / (num_samples * k);
end

% Find the optimal number of clusters with the minimum validity index
[~, optimal_num_clusters] = min(validity_values);

% Perform Fuzzy C-Means clustering
options = [2.0; 100; 1e-5; 0]; % FCM options [exponent; max iterations; minimum improvement; verbose]
[centers, U, obj_fcn] = fcm(data, optimal_num_clusters, options);

% Convert membership values to cluster assignments
[~, cluster_idx] = max(U);

% Visualize the results
figure;
scatter(data(:, 1), data(:, 2), 36, '.');
hold on;
color_map = lines(num_clusters);

for i = 1:num_clusters
    scatter(data(cluster_idx == i, 1), data(cluster_idx == i, 2), 36, color_map(i, :), 'filled', 'MarkerFaceAlpha', 0.3);
end

scatter(centers(:, 1), centers(:, 2), 100, 'rx', 'LineWidth', 2);
title('Fuzzy C-Means Clustering');
xlabel('Feature 1');
ylabel('Feature 2');
legend('Data Points', 'Cluster Members', 'Cluster Centers');
grid on;
hold off;

% Visualize the results
figure;
scatter(data(:, 3), data(:, 4), 36, '.');
hold on;
color_map = lines(num_clusters);

for i = 1:num_clusters
    scatter(data(cluster_idx == i, 3), data(cluster_idx == i, 4), 36, color_map(i, :), 'filled', 'MarkerFaceAlpha', 0.3);
end

scatter(centers(:, 3), centers(:, 4), 100, 'rx', 'LineWidth', 2);
title('Fuzzy C-Means Clustering');
xlabel('Feature 3');
ylabel('Feature 4');
legend('Data Points', 'Cluster Members', 'Cluster Centers');
grid on;
hold off;
