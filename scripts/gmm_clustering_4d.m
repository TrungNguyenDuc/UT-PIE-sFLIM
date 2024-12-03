function [optimal_num_clusters,optimal_gmmodel,cluster_idx,probs] = gmm_clustering_4d(data, num_clusters, initial_means)
% Input:
% data: 4D data for clustering
% num_clusters: number of clusters or 'auto' for automatic selection
% initial_means: initial guess for cluster means

covType = 'full';
if strcmp(num_clusters, 'auto')
    min_clusters = 1;
    max_clusters = 10;
    bic_values = zeros(1, max_clusters - min_clusters + 1);
    for k = min_clusters:max_clusters
        gmmodel = fitgmdist(data, k, 'Replicates', 10);
        bic_values(k) = gmmodel.BIC;
    end
    [~, optimal_num_clusters] = min(bic_values);
else
    optimal_num_clusters = num_clusters;
end
% Initialize other parameters randomly
data_dim = size(data, 2);
initial_covs = repmat(eye(data_dim), [1, 1, optimal_num_clusters]);
initial_weights = ones(1, optimal_num_clusters) / optimal_num_clusters;
rng default
%% Re-fit the model with the optimal number of clusters
if initial_means == 0
    optimal_gmmodel = fitgmdist(data, optimal_num_clusters, 'RegularizationValue', 1e-6, 'Options', statset('MaxIter', 1000),'CovarianceType', covType,'SharedCovariance',false);
else
    optimal_gmmodel = fitgmdist(data, optimal_num_clusters, 'Start', struct('mu', initial_means, 'Sigma', initial_covs, 'PComponents', initial_weights));
end
%% Visualize the results (you can customize this part if needed)
figure;
% scatter(data(:, 1), data(:, 2), 36, '.');
hold on;
cluster_idx = cluster(optimal_gmmodel, data);
color_map = lines(optimal_num_clusters);
for i = 1:optimal_num_clusters
    scatter(data(cluster_idx == i, 1), data(cluster_idx == i, 2), 36, color_map(i, :), 'filled', 'MarkerFaceAlpha', 0.3);
end
hold on;
%%
for i = 1:16
    simulated_spectra = zeros(1,16);
    simulated_spectra(i) = 1;
    %simulated_spectra = reshape(simulated_spectra, [1 16]);
    [G_l_reference(i),S_l_reference(i)] = PhasorTransform_Spectra(simulated_spectra,2);
end
channel_wavelength = {'500 nm', '513.3 nm', '526.6 nm', '539.9 nm', '553.2 nm', '566.5 nm', '579.8 nm', '593.1 nm', '606.4 nm', '619.7 nm', '633 nm', '646.3 nm', '659.6 nm', '672.9 nm', '686.2 nm', '700 nm'};
%a = [1:10]'; b = num2str(a); c = cellstr(b);
scatter(G_l_reference,S_l_reference,'Marker','o','MarkerEdgeAlpha',1,'MarkerEdgeColor','red','MarkerFaceColor','red');
text(G_l_reference+0.02,S_l_reference+0.02,channel_wavelength)
plot_FullPhasorCircle()
%%
scatter(optimal_gmmodel.mu(:, 1), optimal_gmmodel.mu(:, 2), 100, 'rx', 'LineWidth', 2);
title('Gaussian Mixture Model Clustering');
xlabel('Feature 1');
ylabel('Feature 2');
legend('Data Points', 'Cluster Contours', 'Cluster Means');
axis square
hold off;
%%
figure;
% scatter(data(:, 1), data(:, 2), 36, '.');
hold on;
cluster_idx = cluster(optimal_gmmodel, data);
color_map = lines(optimal_num_clusters);
for i = 1:optimal_num_clusters
    scatter(data(cluster_idx == i, 3), data(cluster_idx == i, 4), 36, color_map(i, :), 'filled', 'MarkerFaceAlpha', 0.3);
end
hold on
plot_PhasorCircle_with_reference_lifetime(1,70);
scatter(optimal_gmmodel.mu(:, 3), optimal_gmmodel.mu(:, 4), 100, 'rx', 'LineWidth', 2);
title('Gaussian Mixture Model Clustering');
xlabel('Feature 3');
ylabel('Feature 4');
legend('Data Points', 'Cluster Contours', 'Cluster Means');
axis square
hold off;
%% Visualize results
% Extract parameters from the optimal 4D GMM model
mu_2d = optimal_gmmodel.mu(:, 1:2);  % Extract means for the first two dimensions
sigma_2d = optimal_gmmodel.Sigma(1:2, 1:2, :);  % Extract 2x2 covariance matrices
p = optimal_gmmodel.PComponents;  % Extract cluster probabilities
% Create a grid of points in the first two dimensions
x = linspace(min(data(:, 1)), max(data(:, 1)), 100);
y = linspace(min(data(:, 2)), max(data(:, 2)), 100);
[X, Y] = meshgrid(x, y);
XY = [X(:), Y(:)];
% Calculate probability density for each point on the grid for each cluster
pdf_values = zeros(length(XY), optimal_num_clusters);
for i = 1:optimal_num_clusters
    pdf_values(:, i) = p(i) * mvnpdf(XY, mu_2d(i, :), sigma_2d(:, :, i));
end
% Visualize the contours of the probability density on the scatter plot
figure;
scatter(data(:, 1), data(:, 2), 36, '.');
hold on;
for i = 1:optimal_num_clusters
    contour(X, Y, reshape(pdf_values(:, i), size(X)), 'LineWidth', 2);
end
scatter(mu_2d(:, 1), mu_2d(:, 2), 100, 'rx', 'LineWidth', 2);
hold on
%%
for i = 1:16

    simulated_spectra = zeros(1,16);
    simulated_spectra(i) = 1;
    %simulated_spectra = reshape(simulated_spectra, [1 16]);
    [G_l_reference(i),S_l_reference(i)] = PhasorTransform_Spectra(simulated_spectra,2);
end
channel_wavelength = {'500 nm', '513.3 nm', '526.6 nm', '539.9 nm', '553.2 nm', '566.5 nm', '579.8 nm', '593.1 nm', '606.4 nm', '619.7 nm', '633 nm', '646.3 nm', '659.6 nm', '672.9 nm', '686.2 nm', '700 nm'};
%a = [1:10]'; b = num2str(a); c = cellstr(b);
scatter(G_l_reference,S_l_reference,'Marker','o','MarkerEdgeAlpha',1,'MarkerEdgeColor','red','MarkerFaceColor','red');
text(G_l_reference+0.02,S_l_reference+0.02,channel_wavelength)
plot_FullPhasorCircle()
%%
title('Gaussian Mixture Model Clustering');
xlabel('Feature 1');
ylabel('Feature 2');
legend('Data Points', 'Cluster Contours', 'Cluster Means');
axis square
hold off;
%%
% Extract parameters from the optimal 4D GMM model
mu_2d = optimal_gmmodel.mu(:, 3:4);  % Extract means for the third and fourth dimensions
sigma_2d = optimal_gmmodel.Sigma(3:4, 3:4, :);  % Extract 2x2 covariance matrices for the third and fourth dimensions
p = optimal_gmmodel.PComponents;  % Extract cluster probabilities

% Create a grid of points in the third and fourth dimensions
z = linspace(min(data(:, 3)), max(data(:, 3)), 100);
w = linspace(min(data(:, 4)), max(data(:, 4)), 100);
[Z, W] = meshgrid(z, w);
ZW = [Z(:), W(:)];

% Calculate probability density for each point on the grid for each cluster
pdf_values = zeros(length(ZW), optimal_num_clusters);
for i = 1:optimal_num_clusters
    pdf_values(:, i) = p(i) * mvnpdf(ZW, mu_2d(i, :), sigma_2d(:, :, i));
end

% Visualize the contours of the probability density on the scatter plot
figure;

scatter(data(:, 3), data(:, 4), 36, '.');
hold on;
for i = 1:optimal_num_clusters
    contour(Z, W, reshape(pdf_values(:, i), size(Z)), 'LineWidth', 2);
end
scatter(mu_2d(:, 1), mu_2d(:, 2), 100, 'rx', 'LineWidth', 2);

%%
hold on
plot_PhasorCircle_with_reference_lifetime(1,70);
%%
title('Gaussian Mixture Model Clustering');
xlabel('Feature 3');
ylabel('Feature 4');
legend('Data Points', 'Cluster Contours', 'Cluster Means');
axis square
hold off;
%%
figure;
axis square
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
scatter(optimal_gmmodel.mu(:, 1), optimal_gmmodel.mu(:, 2), 100, 'rx', 'LineWidth',2,'MarkerEdgeColor','black');

%%
hold on
for i = 1:16

    simulated_spectra = zeros(1,16);
    simulated_spectra(i) = 1;
    %simulated_spectra = reshape(simulated_spectra, [1 16]);
    [G_l_reference(i),S_l_reference(i)] = PhasorTransform_Spectra(simulated_spectra,2);
end
channel_wavelength = {'500 nm', '513.3 nm', '526.6 nm', '539.9 nm', '553.2 nm', '566.5 nm', '579.8 nm', '593.1 nm', '606.4 nm', '619.7 nm', '633 nm', '646.3 nm', '659.6 nm', '672.9 nm', '686.2 nm', '700 nm'};
%a = [1:10]'; b = num2str(a); c = cellstr(b);
scatter(G_l_reference,S_l_reference,'Marker','o','MarkerEdgeAlpha',1,'MarkerEdgeColor','red','MarkerFaceColor','red');
text(G_l_reference+0.02,S_l_reference+0.02,channel_wavelength)
plot_FullPhasorCircle()

%%
colorbar;
title('Point Probabilities for Each Cluster');
xlabel('Feature 1');
ylabel('Feature 2');
axis square
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
    scatter(data_filtered(:, 3), data_filtered(:, 4), [], hsv2rgb(hsvcmap), 'filled','MarkerFaceAlpha',0.3); % errrow when not 3 cluster
    hold on
end
scatter(optimal_gmmodel.mu(:, 3), optimal_gmmodel.mu(:, 4), 100, 'rx', 'LineWidth',2,'MarkerEdgeColor','black');

%%
hold on
plot_PhasorCircle_with_reference_lifetime(1,70);
%%
colorbar;
title('Point Probabilities for Each Cluster');
xlabel('Feature 3');
ylabel('Feature 4');
axis square
end
