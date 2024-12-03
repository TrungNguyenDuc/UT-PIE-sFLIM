function g=Gaussian(x,sigma,center,height)

%g=height*(1/(sqrt(2*sigma.^2)))*(exp(-(x-center).^2/(2*sigma.^2)));
g=height*(exp(-(x-center).*(x-center)/(2*sigma.*sigma)));

end
