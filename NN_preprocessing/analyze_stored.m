% Script used to analyze the relationship between the depth and the height
% of bounding boxes, based on data coming from getBB_data.m (which based
% itself on the segmentation maps of 1 person images)

clear; close all;
load 'stored.mat';
aspect_ratio = mean(stored(:,4));

% Find relation between H (stored(:,2)) and depth (stored(:,3)) via
% regression
figure(); scatter(stored(:,3), stored(:,2));
ind = stored(:,3)>-1500;
data_close = stored(ind, :);
data_far = stored(~ind, :);
figure();
scatter(data_close(:,3), data_close(:,2)); 
hold on;
scatter(data_far(:,3), data_far(:,2));

% fit the far part - linearly
coeffs = polyfit(data_far(:,3), data_far(:,2), 1);
x_lin = linspace(min(data_far(:,3)), max(data_far(:,3)), 1000);
y_fit = polyval(coeffs, x_lin);
scatter(x_lin, y_fit);

% fit the close part - exponentially
f = fit(data_close(:,3), data_close(:,2), 'exp2');
% plot(f);
coeffs2 = [178.1, 0.0009016, 761, 0.006654]; % obtained from f
% I haven't found a way to automatically read parameters from f (fit)
expo = @(x, c) c(1)*exp(c(2)*x) + c(3)*exp(c(4)*x);
x_lin2 = linspace(min(data_close(:,3)), max(data_close(:,3)), 1000);
y_fit2 = expo(x_lin2, coeffs2);
scatter(x_lin2, y_fit2);

