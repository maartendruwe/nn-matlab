clear all;
tic;
%

sim_dir = 'G:\experiments\scene1';
render = '\renders1';

modeldirs = dir([sim_dir, render, '\m*']);

% Stored will contain the widths, heights and associated depths of
% pedestrian models in the processed segmentation maps. This will then be
% used to compute aspect ratios via averaging and find a relationship 
% between the height and depth of a pedestrian, via a regression model.
% Like this we can compute an expected bounding box (width and height) for
% every (x,y,z) position.
stored = zeros(1,3); 

for aa = 1:20 % for 10 different models
    clear segfiles
    modelname = modeldirs(aa).name;
    model = ['\', modelname];
    parent_dir = [sim_dir, render, model];
    seg_dir = [parent_dir, '\seg'];
    annotations_dir = [parent_dir, '\annotations'];
  
    segfiles = dir([seg_dir, '\ped001*.jpg']); %get list of all images 
    % in directory with 1 pedestrian
    
    
    for ii = 1:length(segfiles) % 1:length(imfiles) %1:length(imfiles)
        updateText = ['file ', num2str(ii), ' out of ', ...
            num2str(length(segfiles)), ' from ', modelname];
        updateText
         
        name_seg = segfiles(ii).name; %name for image, depth and segmentation
        name_gen = name_seg(1:end-4); %name without format
        name_ann = [name_gen, '.txt']; %name for annotations

        seg = imread([seg_dir, '\', name_seg]);
        [H,W,~] = size(seg);
    %     figure(); imshow(im, []);
    %     hold on;
        seg_bin = im2bw(seg, 0.01);
        labeled = bwlabel(seg_bin);
        blobmeas = regionprops(labeled, 'BoundingBox');
        thisbb = blobmeas.BoundingBox;
        W_ = thisbb(3); H_ = thisbb(4);
        joint_path = [annotations_dir, '\', 'center', '\', name_ann];
        pos = load(joint_path);
        stored(end+1, 1:3) = [W_, H_, pos(1,3)];
    end
    
end

stored(1, :) = [];