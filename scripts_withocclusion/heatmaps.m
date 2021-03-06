% Generate heatmaps for pedestrian images based on location of multiple
% joints. 


% COMMENTS: 
% 1) check visibility of joints before making heatmaps
% 2) Visibility based on 2 aspects: 
% - pixel location within bounds
% - no huge overlap between pedestrians (use depth coordinate too)
% 3) Width of Gaussian can be determined by depth or by distance between
% multiple joints (e.g. head and center or head and feet or head and
% lowerneck)
%-------------------------------------------------------------------------
%
clear;
addpath('occlusion');
tic;
%

sim_dir = '/home/mdruwe/experiments/experiments0408';
modeldirs = dir([sim_dir, '/image', '/m*']);


for aa = 1:length(modeldirs) %don-t do model 12 this time
    
    clear imfiles
    modelname = modeldirs(aa).name;
    model = ['/', modelname];
    
    image_dir = [sim_dir, '/image', model];
    annotations_dir = [sim_dir, '/annotations'];
    seg_dir = [sim_dir, '/seg_occ', model];
    depth_dir = [sim_dir, '/depth', model];
    hm_dir = [sim_dir, '/heatmaps1p5', model];
    hm_dir_center = [sim_dir, '/heatmapscenter1p5', model];
    mkdir(hm_dir);
    mkdir(hm_dir_center);


    % annotations.feet = 'feet';
    % annotations.center = 'center';
    % annotations.head = 'head';
    % annotations.leftfoot = 'leftfoot';
    % annotations.rightfoot = 'rightfoot';
    % annotations.leftknee = 'leftknee';
    % annotations.rightknee = 'rightknee';
    % annotations.lowerneck = 'lowerneck';
    % annotations.upperneck = 'upperneck';

    annotation_joints = {'center', 'feet', 'head', 'upperneck', 'leftfoot',...
        'rightfoot', ...
        'leftknee', 'rightknee', 'lowerneck' };
    colorspec = {[0.19 0.91 0.5]; [0.9 0.9 0.9]; [0.0 0.7 0.7]; [0.6 0.6 0.0]; ...
      [0.5 0.9 0.2]; [0.1 0.5 0.9]; [0.8 0.0 0.8]; ...
      [0.9 0.5 0.1]; [0.15 0.55 0.22]};

    imfiles = dir([image_dir, '/p*.jpg']); %get list of all images in directory

    jointscales = {0.45, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3}; %scaling for gaussians
    jointStart = 1; jointEnd = 4; jointEndMaps = 3;
    threshold = 0.5; %Threshold for occlusion
    aspect_ratio = 0.4287;

    for ii = 1:length(imfiles) %1:length(imfiles)
        updateText = ['file ', num2str(ii), ' out of ', ...
            num2str(length(imfiles)), ' from ', modelname, ...
            ' already the ', num2str(aa), 'th model'];
        updateText
        clear ann_pos; clear hs; 
        name_im = imfiles(ii).name; %name for image, depth and segmentation
        name_gen = name_im(1:end-4); %name without format
        name_ann = [name_gen, '.txt']; %name for annotations

        im = imread([image_dir, '/', name_im]);
        [H,W,~] = size(im);
    %     figure(); imshow(im, []);
    %     hold on;

        for jj = jointStart:jointEnd %3 corresponds to feet, center, head and upperneck
           joint = annotation_joints{jj};
           joint_path = [annotations_dir, '/', joint, '/', ...
               model, '/', name_ann];
           pos = load(joint_path);
           ann_pos{jj} = pos;
    %        plot(pos(:,1),pos(:,2),'r.', 'MarkerSize', 20, ...
    %            'Color', colorspec{jj});
        end

        C = ann_pos{1}(:, 1:3); %x,y and z coordinates
        Cx = C(:,1)+1; Cy = C(:,2)+1; %center coordinates, was zero-based
        
        % Check which pedestrians are occluded and remove occluded ones
        % from labels
        for ff = 1:size(C,1)
           filepath_seg = [seg_dir, '/', name_gen, '_', num2str(ff), '.jpg'];
           segs{ff} = imread(filepath_seg);
        end
        
        occluded = returnOccluded(C, threshold, segs);
        numberOfJoints = length(ann_pos);
        if size(occluded,2)>0 && size(occluded,1)>0
            Cx(occluded,:) = [];
            Cy(occluded,:) = [];
            for xx = 1:numberOfJoints
              ann_pos{xx}(occluded, :) = [];   
            end
        end
        
        % Remove pedestrians with center outside of window
        remove_list = (Cx<1 + Cx>W + Cy<1 + Cy>H)>0; 
        numberOfJoints = length(ann_pos);
        for xx = 1:numberOfJoints
           ann_pos{xx}(remove_list, :) = []; 
        end

        % Compute head size
        headsize = zeros(2,2,size(ann_pos{1}, 1));
        headsize(1, :,:) = ann_pos{3}(:,1:2)';
        headsize(2, :,:) = ann_pos{4}(:,1:2)';
        for kk = 1:size(headsize, 3)
           hs(kk) = pdist(headsize(:,:,kk)); 
        end
        for jj = jointStart:jointEndMaps
            sigma{jj} = hs*jointscales{jj};
        end

        % Channel for every pedestrian to compute Gaussians for center
        % positions. All pedestrians with center position out of image 
        % window are removed.

        heatmap = zeros(H, W, jointEndMaps);
        for pp = 1:length(hs)
            hm = zeros(H,W, jointEndMaps);
            for zz = 1:jointEndMaps %annotate each joint map for pedestrian
                xpos = ann_pos{zz}(pp,1)+1; %was zero-based
                ypos = ann_pos{zz}(pp,2)+1;
                % Check if joint position is within image borders
                if ~(xpos<1 || xpos>W || ypos<1 || ypos>H)
                    hm(:,:,zz) = create_gaussian(W,H,[xpos,ypos],...
                        sigma{zz}(pp));
                end   
            end
            heatmap = heatmap + hm;
        end
        
        % Normalize heatmaps
        maxima = max(max(heatmap));
        for yy = 1:size(heatmap, 3)
            if maxima(yy) ~= 0
                heatmap(:,:,yy) = heatmap(:,:,yy)/maxima(yy);
            end
        end
        
        % Transform to right format (Torch tensor)
        heatmap = permute(heatmap, [3 1 2]);
        
        % save heatmap to .mat file in right folder
        heatmap = single(heatmap);
        filepath = [hm_dir, '/', name_gen, '.mat'];
        save(filepath, 'heatmap');
        filepath = [hm_dir_center, '/', name_gen, '.mat'];
        heatmap = heatmap(1,:,:);
        save(filepath, 'heatmap'); 
    end

    %
    toc
end
%
