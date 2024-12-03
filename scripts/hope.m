% Generate synthetic dataset

num_samples = 300;
num_features = 2;
num_true_clusters = 3;

% Generate random cluster centers
true_cluster_centers = rand(num_true_clusters, num_features);

% Generate data around the cluster centers
data = [];
for i = 1:num_true_clusters
    cluster_center = true_cluster_centers(i, :);
    cluster_samples = mvnrnd(cluster_center, eye(num_features), num_samples/num_true_clusters);
    data = [data; cluster_samples];
end

% Visualize the original data
figure;
scatter(data(:, 1), data(:, 2), 20, 'b', 'filled');
title('Original Data');
xlabel('Feature 1');
ylabel('Feature 2');

% Parameters for the Gaussian Mixture Model
num_clusters_range = 1:6; % Range of potential cluster numbers
num_initializations = 10; % Number of initializations for each cluster number

% Perform clustering for different cluster numbers
best_bic = Inf;
best_num_clusters = 0;
best_cluster_means = [];
best_cluster_covariances = [];
best_cluster_weights = [];

for num_clusters = num_clusters_range
    fprintf('Fitting model with %d clusters...\n', num_clusters);
    
    % Initialize the cluster means based on user-defined seeding positions
    initial_cluster_means = true_cluster_centers(1:num_clusters, :);
    
    % Initialize other cluster parameters randomly
    initial_cluster_covariances = repmat(eye(num_features), [1, 1, num_clusters]);
    initial_cluster_weights = ones(1, num_clusters) / num_clusters;
    
    % Perform multiple initializations and choose the best result based on BIC
    for i = 1:num_initializations
        gm = fitgmdist(data, num_clusters, ...
            'Start', struct('mu', initial_cluster_means, ...
                            'Sigma', initial_cluster_covariances, ...
                            'ComponentProportion', initial_cluster_weights), ...
            'Regularize', 1e-5);
        
        % Calculate BIC
        bic = gm.BIC;
        if bic < best_bic
            best_bic = bic;
            best_num_clusters = num_clusters;
            best_cluster_means = gm.mu;
            best_cluster_covariances = gm.Sigma;
            best_cluster_weights = gm.ComponentProportion;
        end
    end
end

fprintf('Best number of clusters: %d\n', best_num_clusters);

% Visualize the clustered data
cluster_indices = cluster(gm, data);
figure;
gscatter(data(:, 1), data(:, 2), cluster_indices);
hold on;
scatter(best_cluster_means(:, 1), best_cluster_means(:, 2), 100, 'k', 'x');
title('Clustered Data with Cluster Centers');
xlabel('Feature 1');
ylabel('Feature 2');
legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster Centers');