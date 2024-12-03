function [optimal_num_clusters, cluster_idx] = kmeans_clustering_4d(data, num_clusters)
    % Input:
    % data: 4D data for clustering
    % num_clusters: number of clusters or 'auto' for automatic selection
    
    if strcmp(num_clusters, 'auto')
        min_clusters = 1;
        max_clusters = 10;
        silhouette_values = zeros(1, max_clusters - min_clusters + 1);
        
        for k = min_clusters:max_clusters
            cluster_idx = kmeans(data, k);
            silhouette_values(k) = silhouette(data, cluster_idx);
        end
        
        [~, optimal_num_clusters] = max(silhouette_values);
    else
        optimal_num_clusters = num_clusters;
    end
    
    cluster_idx = kmeans(data, optimal_num_clusters);
    
    % Visualize the results (you can customize this part if needed)
    figure;
    hold on;
    color_map = lines(optimal_num_clusters);
    
    for i = 1:optimal_num_clusters
        scatter3(data(cluster_idx == i, 1), data(cluster_idx == i, 2), data(cluster_idx == i, 3), 36, color_map(i, :), 'filled', 'MarkerFaceAlpha', 0.3);
    end
    
    title('K-Means Clustering');
    xlabel('Feature 1');
    ylabel('Feature 2');
    zlabel('Feature 3');
    legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4'); % Add more as needed
    grid on;
    hold off;
end