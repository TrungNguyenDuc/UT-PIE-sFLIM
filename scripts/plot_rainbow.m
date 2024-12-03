function plot_rainbow(x,y,linemarker,cmap)

if nargin<4
    cmap = jet(length(x));
if nargin<3
    linemarker = 'o';
end
end
line_flag = strcmp(linemarker,'-');

if isempty(line_flag)
    if length(x) == length(y)
    figure(gcf)
    hold on
    L = length(x);
    for i = 1:L
        plot(x(i),y(i),linemarker,'Color',cmap(i,:))
    end
    else
    fprintf('Vectors have not the same length')
    end
else
    if length(x) == length(y)
    figure(gcf)
    hold on
    L = length(x);
%    cmap = cmap(1:end-1,:);
    for i = 2:L
        plot(x(i-1:i),y(i-1:i),linemarker,'Color',cmap(i-1,:))
    end
    else
    fprintf('Vectors have not the same length')
    end
end
end