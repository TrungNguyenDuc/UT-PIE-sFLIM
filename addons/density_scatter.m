function density_scatter(x, y, varargin)
    % Scatter plot colored by 2D histogram
    
    % Parse optional input arguments
    p = inputParser;
    addParameter(p, 'ax', gca, @ishandle);
    addParameter(p, 'sort', true, @islogical);
    addParameter(p, 'bins', [30, 30], @isnumeric);
    addParameter(p, 'size', 5, @isnumeric);
    
    parse(p, varargin{:});
    
    ax = p.Results.ax;
    sort_flag = p.Results.sort;
    bins = p.Results.bins;
    spot_size = p.Results.size;
    
    % Create scatter plot
    data = histcounts2(x, y, bins, 'Normalization', 'pdf');
    [X, Y] = meshgrid(linspace(min(x), max(x), bins(1)), linspace(min(y), max(y), bins(2)));
    Z = interp2(X, Y, data', x, y, 'spline');
    
    % To be sure to plot all data
    Z(isnan(Z)) = 0.0;
    
    % Sort the points by density, so that the densest points are plotted last
    if sort_flag
        [~, idx] = sort(Z);
        x = x(idx);
        y = y(idx);
        Z = Z(idx);
    end
    
    scatter(ax, x, y,spot_size, Z, 'filled');
    
    % Add colorbar
    c = colorbar(ax);
    c.Label.String = 'Density';
end