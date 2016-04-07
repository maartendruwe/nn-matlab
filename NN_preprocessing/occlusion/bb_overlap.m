% Compute bounding box overlap for every pair of (x,y,z) locations
tic;
for ii = 1:1000
    clear;
    W = 640; H = 480; aspect_ratio = 0.4287;
    overlap_th = 0.7;

    x_range = linspace(1,W,W/4);
    y_range = linspace(1,H,H/4);
    z_range = linspace(-3000,0,750);

    % for each person:
    z1 = -1400; %read from annotations
    center_x1 = 20; center_y1 = 40;
    height1 = estimateHeight(z1);
    width1 = height1*aspect_ratio;
    x1 = center_x1-width1/2; y1 = center_y1-height1/2;
    bb1 = [x1,y1,width1, height1];

    z2 = -500;
    center_x2 = 50; center_y2 = 20;
    height2 = estimateHeight(z2);
    width2 = height2*aspect_ratio;
    x2 = center_x2-width2/2; y2 = center_y2-height2/2;
    bb2 = [x2,y2,width2,height2];

    overlap = rectint(bb1,bb2);
    area_smallest = width1*height1;
    overlap = overlap/area_smallest;
end

toc







