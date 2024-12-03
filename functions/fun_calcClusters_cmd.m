function handles = fun_calcClusters_cmd(handles,K,Distance_val,Replicates,marker_size,line_width,gate,n_time_bin)    
%FUN_CALCCLUSTERS Summary of this function goes here
%   This function is used to calculate k-means clusters
%
%   Author: Yide Zhang
%   Email: yzhang34@nd.edu
%   Date: April 12, 2019
%   Copyright: University of Notre Dame, 2019

    
    
%     box = msgbox('Calculating clusters, please wait...');
    
% if isfield(handles, 'GSgood') && isfield(handles, 'xyzgood')
%     GS_good = handles.GSgood;
% else
[GS_good, xyz_good] = fun_calcPhasors_cmd(handles);
handles.GSgood = GS_good; 
handles.xyzgood = xyz_good; 
% end
if ~isempty(GS_good)
    
    %K = str2double(get(handles.Edit_K, 'String'));

    %Distance_val = get(handles.Pop_Distance, 'Value');
    switch Distance_val
        case 1
            Distance = 'sqeuclidean';
        case 2
            Distance = 'cityblock';
        otherwise
            Distance = 'cosine';
    end
    %Replicates = str2double(get(handles.Edit_Rep, 'String'));
    opts = statset('Display','iter');
    
    if size(GS_good, 1) >= K
    [idx, C] = fun_kmeans(GS_good, K,...
        'Distance', Distance,... % sqeuclidean, cityblock, cosine
        'MaxIter', 1000,...
        'OnlinePhase', 'off',...
        'Replicates', Replicates,...
        'Start', 'plus',... % cluster, plus, sample, uniform
        'Options',opts);
    else
        idx = (1:K)';
        C = zeros(K, 2);
    end

    % sort idx based on the centroids in C
    [C_sort, C_idx] = sortrows(C);
    idx_sort = idx;
    for iK = 1:K
        idx_sort(idx==C_idx(iK))=iK;
    end
    
    handles.Clusteridx = idx_sort; 
    handles.ClusterC= C_sort;
%    guidata(hObject,handles) 
    
%     close(box);

% else
%     msgbox('Please calculate phasors first.', 'Error','error');
end

if isfield(handles, 'Clusteridx') && isfield(handles, 'ClusterC')

    GS_good = handles.GSgood;
    Cluster_idx = handles.Clusteridx;
    Cluster_C = handles.ClusterC;
    
    cc = fun_HSVcolors(K, 1);
%     Gmin = str2double(get(handles.Edit_Gmin, 'String'));
%     Gmax = str2double(get(handles.Edit_Gmax, 'String'));
%     Smin = str2double(get(handles.Edit_Smin, 'String'));
%     Smax = str2double(get(handles.Edit_Smax, 'String'));

%     cla(handles.Axes_PC);
%     hold(handles.Axes_PC, 'on')
figure()
hold on
    if size(GS_good, 1)>=K
        for iK = 1:K
            plot(GS_good(Cluster_idx==iK,1),GS_good(Cluster_idx==iK,2),...
                'Color', cc(iK, :),...
                'LineStyle', 'none',...
                'Marker', '.',...
                'MarkerSize',marker_size)
        end
    end
    plot(Cluster_C(:,1),Cluster_C(:,2),'kx','MarkerSize',marker_size+4,'LineWidth', line_width)
    %theta = linspace(0, pi, 100); radius = 0.5;
    %plot(radius*cos(theta)+0.5, radius*sin(theta), 'k', 'LineWidth', line_width);
    plot_PhasorCircle_with_reference_lifetime(gate,n_time_bin)
    line([0 1], [0 0], 'Color', 'k', 'LineWidth', line_width);
    hold off
    axis 'auto y'
    axis 'auto x'
    axis square
end

%fun_updateFigures(handles, -1, 'PC');


end