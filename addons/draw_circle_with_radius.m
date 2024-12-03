
function draw_circle_with_radius(radius,style,color)
% Define the radius


% Generate points for the circle
theta = linspace(0, 2*pi, 100);
x = radius * cos(theta);
y = radius * sin(theta);

% Plot the circle
plot(x, y,style,'Color',color);
end