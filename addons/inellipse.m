function p = inellipse(x, y, xc, yc, a, b, theta) 
% return a logical array, indices of the points in the ellipse
xr = x - xc;
yr = y - yc;
x0 = cos(theta)*xr + sin(theta)*yr;
y0 = -sin(theta)*xr + cos(theta)*yr;
p = x0.^2 / a^2 + y0.^2 / b^2 < 1;
end