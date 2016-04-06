function [ filter ] = create_gaussian( W,H,center,sigma )
% Create Gaussian filter with width W, height H, center location of
% Gaussian center and sigma.

% Meshgrid approach
x0 = center(1); y0 = center(2);
[x,y] = meshgrid(1:W, 1:H);
filter = exp(-((x-x0).^2+(y-y0).^2)/(2*sigma^2));
filter = single(filter);

end

