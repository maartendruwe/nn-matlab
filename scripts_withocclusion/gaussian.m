% Create Gaussian

label = zeros(480, 640);
label(125, 300) = 1;
figure(); imshow(label, []);

% Let's base Gaussian width on head size.
headsize = pdist(pos

for W=10:100
    filter = fspecial('gaussian', W, W/4);
    filtered = imfilter(label, filter);
    figure(); imshow(filtered, []);
end
