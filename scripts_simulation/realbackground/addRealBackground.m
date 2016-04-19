% Add real backgrounds to renders
% We need to keep all the prior (already generated information): images and
% heatmaps. 
close all;
clear all;

ped_dir = 'ims/';
bg_dir = 'bg_selection/';
seg_dir = 'segs/';

bgfind = [bg_dir, '*.jpg'];
bg_files = dir(bgfind);

pedfind = [ped_dir, 'pe*.jpg'];
ped_files = dir(pedfind);

ind = randi(length(ped_files), 1,1);
for ii = ind:ind %1:length(ped_files)
   ped_name = ped_files(ii).name;
   ped_path = [ped_dir, ped_name];
   seg_path = [seg_dir, ped_name];
   bg_name = bg_files(randi(length(bg_files),1,1)).name;
   bg_path = [bg_dir, bg_name];
   
   ped = imread(ped_path);
   figure(1); imshow(ped, []);
   seg = imread(seg_path);
%    blurfilter = fspecial('average', 3);
%    seg = imfilter(seg, blurfilter);
   background = imread(bg_path);
   figure(2); imshow(seg);
   pos_large = (im2bw(seg, 0.10));
   se = strel('square', 2);
   pos_small = imerode(pos_large, se);
   pos_extrasmall = imerode(pos_small, se);
% pos = seg_bw;
   pos_copy = pos_small;
   neg_large = double(~pos_large);
   neg_small = double(~pos_small);
   neg_extrasmall = double(~pos_extrasmall);
   pos_extrasmall = double(pos_extrasmall);
   pos_extrasmall = cat(3, pos_extrasmall, pos_extrasmall, pos_extrasmall);
   pos_small = double(pos_small);
   pos_small = cat(3, pos_small, pos_small, pos_small);
   pos_large = cat(3, pos_large, pos_large, pos_large);
   neg_large = cat(3, neg_large, neg_large, neg_large);
   neg_small = cat(3, neg_small, neg_small, neg_small);
   neg_extrasmall = cat(3, neg_extrasmall, neg_extrasmall, neg_extrasmall);
   ped = im2double(ped);
   background = im2double(background);
   
   synth = (pos_large.*(ped));
   background = (neg_large.*(background));
   figure(7); imshow(synth);
   synth = (background + synth);
   
   blur_filter1 = fspecial('gaussian', 10, 3);
   blur_filter2 = fspecial('gaussian', 5, 3);
   mix = imfilter(synth, blur_filter1);
%    alpha = 0.9;
%    mix = alpha*(background) + (1-alpha)*(ones(size(ped))-(ped));
   figure(3); imshow(mix);
   mix = mix.*pos_large;
   figure(4); imshow(mix);
   mix = mix.*neg_small;
   figure(5); imshow(mix);
   mix = mix + pos_small.*ped;
   figure(6); imshow(mix);
   mix = imfilter(mix, blur_filter2);
%    mix = mix.
   figure(8); imshow(mix);
   mix = mix.*neg_extrasmall;
   figure(9); imshow(mix);
   mix = mix.*pos_small;
   figure(11); imshow(mix);
   mix = mix + ped.*pos_extrasmall;
   figure(10); imshow(mix);
   mix = mix + neg_large.*background;

   figure(7); imshow(mix);
%    figure(4); imshow(seg_bw);
%    
%    figure(5); imshow(pos);
%    figure(6); imshow(neg);
%    synth = uint8(pos.*im2double(ped));
%    background = uint8(neg.*im2double(background));
%    figure(7); imshow(synth);
%    synth = (background + synth);
%    figure(8); imshow(synth);
   
%    % Smooth pedestrian borders: mix it in with the background image
%    border = bwboundaries(pos_copy);
%    avg_size = 3;
%    avg_filter = fspecial('gaussian', avg_size, 0.5);
%    avg_filter = cat(3, avg_filter, avg_filter, avg_filter);
%    for jj = 1:length(border)
%       for kk = 1:size(border{jj},1)
%           step = (avg_size-1)/2;
%           x = border{jj}(kk, 2);
%           y = border{jj}(kk, 1);
%           synth(y-step:y+step, x-step:x+step, :) = uint8(double(synth(y-step:y+step,...
%               x-step:x+step, :)).*avg_filter);  
%       end
%    end
%    
%    figure(9); imshow(synth);
end


%% 





