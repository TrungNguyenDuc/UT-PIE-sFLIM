% Parameters
num_clusters = 5;   % Set the number of initial clusters
num_samples = 500;  % Number of data points
data_dim = 2;       % Dimensionality of data
true_means = [1, 1; 5, 5; 9, 1; 2,3;3,3];  % True cluster means
true_covs = cat(3, [1 0.5; 0.5 1], [1 -0.5; -0.5 1], [1 0; 0 1],[1 0; 0 1],[1 0; 0 1]);  % True cluster covariances

% Generate synthetic dataset
rng(1); % Set random seed for reproducibility
data = [];
for i = 1:num_clusters
    data = [data; mvnrnd(true_means(i,:), true_covs(:,:,i), num_samples)];
end


% Perform Gaussian Mixture Model clustering
%gmmodel = fitgmdist(data, num_clusters, 'Start', struct('mu', initial_means, 'Sigma', initial_covs, 'PComponents', initial_weights));

% Determine optimal number of clusters using BIC
min_clusters = 1;
max_clusters = 6;
bic_values = zeros(1, max_clusters - min_clusters + 1);
for k = min_clusters:max_clusters
    gmmodel = fitgmdist(data, k, 'Replicates', 10);
    bic_values(k) = gmmodel.BIC;
end
[~, optimal_num_clusters] = min(bic_values);

%%
% Initialize cluster means with provided seeding positions
initial_means = [1, 1; 5, 5; 9, 1; 2,3];

% Initialize other parameters randomly
initial_covs = repmat(eye(data_dim), [1, 1, optimal_num_clusters]);
initial_weights = ones(1, optimal_num_clusters) / optimal_num_clusters;

%%
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
%%
% Visualize results with cluster colors and probabilities
figure;
%scatter(data(:, 1), data(:, 2), 36, '.');
hold on;

% Plot data points with different colors based on their assigned clusters
cluster_idx = cluster(optimal_gmmodel, data);
color_map = lines(optimal_num_clusters);
for i = 1:optimal_num_clusters
    scatter(data(cluster_idx == i, 1), data(cluster_idx == i, 2), 36, color_map(i, :), 'filled', 'MarkerFaceAlpha',0.3);
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

%% Visualize probability of each point belonging to each cluster hsv plus transparent-Separated
figure;
probs = posterior(optimal_gmmodel, data);
color_map = lines(optimal_num_clusters);
number_of_point = length(data(:,1));
step = 1/optimal_num_clusters;
for i = 1:optimal_num_clusters
figure()
hsvcmap = [step*i*ones(number_of_point,1), probs(:,i), ones(number_of_point,1)];

scatter(data(:, 1), data(:, 2), [], hsv2rgb(hsvcmap), 'filled','MarkerFaceAlpha',0.3); % errrow when not 3 cluster
hold on
end
colorbar;
title('Point Probabilities for Each Cluster');
xlabel('Feature 1');
ylabel('Feature 2');
grid on;


%% Visualize probability of each point belonging to each cluster hsv + transparent
figure;
probs = posterior(optimal_gmmodel, data);
number_of_point = length(data(:,1));
step = 1/optimal_num_clusters;
for i = 1:optimal_num_clusters
hsvcmap = [step*i*ones(number_of_point,1), probs(:,i), ones(number_of_point,1)];
%hsvcmap = [step*i*ones(number_of_point,1), ones(number_of_point,1), probs(:,i)];
scatter(data(:, 1), data(:, 2), [], hsv2rgb(hsvcmap), 'filled','MarkerFaceAlpha',0.2); % errrow when not 3 cluster
hold on
end
colorbar;
title('Point Probabilities for Each Cluster');
xlabel('Feature 1');
ylabel('Feature 2');
grid on;

% need to have a funtion to select thresholde for probs
%% Visualize probability of each point belonging to each cluster hsv + transparent
figure;
probs = posterior(optimal_gmmodel, data);
number_of_point = length(data(:,1));
step = 1/optimal_num_clusters;
for i = 1:optimal_num_clusters
hsvcmap = [step*i*ones(number_of_point,1), probs(:,i), ones(number_of_point,1)];
%hsvcmap = [step*i*ones(number_of_point,1), ones(number_of_point,1), probs(:,i)];
scatter(data(:, 1), data(:, 2), [], hsv2rgb(hsvcmap), 'filled','MarkerFaceAlpha',0.2); % errrow when not 3 cluster
hold on
end
colorbar;
title('Point Probabilities for Each Cluster');
xlabel('Feature 1');
ylabel('Feature 2');
grid on;

%%
figure;
probs = posterior(optimal_gmmodel, data);
threshold = 0.1;
step = 1/optimal_num_clusters;
for i = 1:optimal_num_clusters
data_filtered = data(probs(:,i)>threshold,:);
number_of_point = length(data_filtered(:,1));
prob_filtered = probs(:,i);
prob_filtered = prob_filtered(prob_filtered>threshold);
hsvcmap = [step*i*ones(number_of_point,1), prob_filtered, ones(number_of_point,1)];
scatter(data_filtered(:, 1), data_filtered(:, 2), [], hsv2rgb(hsvcmap), 'filled','MarkerFaceAlpha',0.3); % errrow when not 3 cluster
hold on
end
colorbar;
title('Point Probabilities for Each Cluster');
xlabel('Feature 1');
ylabel('Feature 2');
grid on;

%% slow
figure;
probs = posterior(optimal_gmmodel, data); 
color_map = lines(optimal_num_clusters);
number_of_point = length(data(:,1));
hold on
for i = 1:optimal_num_clusters
    for j=1:number_of_point
    scatter(data(j, 1), data(j, 2), 36, color_map(i,:), 'filled','MarkerFaceAlpha', probs(j,i));
    end
end
title('Point Probabilities for Each Cluster');
xlabel('Feature 1');
ylabel('Feature 2');
grid on;
