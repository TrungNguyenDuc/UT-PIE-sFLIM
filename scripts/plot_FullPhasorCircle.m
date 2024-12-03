
function plot_FullPhasorCircle()

hold on
th = 0:pi/50:4*pi;
xunit = cos(th);
yunit = sin(th);
plot(xunit, yunit,':k');
end


