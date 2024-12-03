function plot_ellipse(xc, yc, a, b, theta,linewidth,color)
% plot an ellipse
alpha = linspace(0,2*pi,101);
x0 = a*cos(alpha);
y0 = b*sin(alpha);
x = cos(theta)*x0 - sin(theta)*y0 + xc; % rotate and translate
y = sin(theta)*x0 + cos(theta)*y0 + yc;
plot(x,y,'-','LineWidth',linewidth,'Color',color)
end