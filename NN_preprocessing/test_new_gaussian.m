clear all;
%% Meshgrid approach
x0 = 620; y0 = 460;
sigma = 10;
[x,y] = meshgrid(1:1000, 1:480);
filter = exp(-((x-x0).^2+(y-y0).^2)/(2*sigma^2));
filter = filter/max(max(filter));
filter = single(filter);