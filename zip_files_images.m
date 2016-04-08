clear all;
addpath('occlusion');
tic;
%

sim_dir = 'G:\experiments\scene1';
render = '\renders1';
modeldirs = dir([sim_dir, render, '\m*']);

for aa = 1:10
    
   modelname = modeldirs(aa).name; 
   model = ['\', modelname];
   parent_dir = [sim_dir, render, model]; 
   image_dir = [parent_dir, '\image'];
   hm_dir_center = [parent_dir, '\heatmapscenter'];
%    heatmaps{aa} = hm_dir_center;
   images{aa} = image_dir;
   name = ['im', num2str(aa)];
   name = ['G:\', name, '.zip'];
   zip(name, images{aa});
   
end
%zip_location_hm = 'G:\hm.zip'; 
% zip_location_im = 'G:\im.zip';
% zip(zip_location_im, heatmaps);