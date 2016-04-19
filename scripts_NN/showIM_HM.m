% read in original images and generated heatmaps and put them next to each
% other.
close all;
imdir = 'C:\Users\Maarten\Dropbox\testing_sequences\detnet_window1_RELU_epoch50\im';
hmdir = 'C:\Users\Maarten\Dropbox\testing_sequences\detnet_window1_RELU_epoch50\pred';

imtxt = [imdir, '\*.mat'];
hmtxt = [hmdir, '\*.mat'];

imfiles = dir(imtxt);
hmfiles = dir(hmtxt);

for ii = 1:length(imfiles)/2
   imname = imfiles(ii).name;
   hmname = hmfiles(ii).name;
   imname = [imdir, '\', imname];
   hmname = [hmdir, '\', hmname];
   
   
   load(imname);
   im = squeeze(x(1,:,:,:));
   im = permute(im, [2 3 1]);
   
   load(hmname);
   hm = squeeze(x(1,:,:,:));
  % hm = permute(hm, [2 3 1]);
   
   figure();
   subplot(1,2,1);
   imshow(im, []);
   subplot(1,2,2);
   imshow(hm(:,:), []);
end
