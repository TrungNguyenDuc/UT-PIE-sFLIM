function [optimal_num_clusters, cluster_idx, centroids] = kmeans_clustering(data, num_clusters)
    % Input:
    % data: 4D data for clustering
    % num_clusters: number of clusters or 'auto' for automatic selection
    
    if strcmp(num_clusters, 'auto')
        % Determine the optimal number of clusters using the elbow method
        max_clusters = 10;
        inertias = zeros(1, max_clusters);
        
        for k = 1:max_clusters
            [~, ~, sumd] = kmeans(data, k, 'Replicates', 10);
            inertias(k) = sum(sumd);
        end
        
        % Use the 'elbow' point as the optimal number of clusters
        [~, optimal_num_clusters] = kElbow(inertias);
    else
        optimal_num_clusters = num_clusters;
    end
    
    % Perform K-means clustering
    [cluster_idx, centroids] = kmeans(data, optimal_num_clusters, 'Replicates', 10);
    
    % Visualize the results (customize if needed)
    figure;
    scatter(data(:, 1), data(:, 2), 36, cluster_idx, 'filled');
    hold on;
    scatter(centroids(:, 1), centroids(:, 2), 100, 'rx', 'LineWidth', 2);
    title('K-means Clustering');
    xlabel('Feature 1');
    ylabel('Feature 2');
    legend('Clusters', 'Centroids');
    grid on;
    hold off;

    % Visualize results for the other two dimensions (customize if needed)
    figure;
    scatter(data(:, 3), data(:, 4), 36, cluster_idx, 'filled');
    hold on;
    scatter(centroids(:, 3), centroids(:, 4), 100, 'rx', 'LineWidth', 2);
    title('K-means Clustering');
    xlabel('Feature 3');
    ylabel('Feature 4');
    legend('Clusters', 'Centroids');
    grid on;
    hold off;
end

function [bestK, K, elbow] = kElbow(Y)
    N = length(Y);
    K = 1:N;
    elbow = zeros(1, N);

    for i = 1:N
        elbow(i) = sum((Y - Y(i)) .^ 2);
    end

    elbow = elbow / max(elbow);

    second_derivative = diff(diff(elbow));
    [~, idx] = max(second_derivative);

    bestK = K(idx + 1);
end
