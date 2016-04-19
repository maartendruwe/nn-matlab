% Select N random images from dataset as small evaluation set.

filepath = 'C:\Users\MD\Documents\datasets\Caltech\Training\set00\seq007_jpgs';
labels = true;
filespath = [filepath, '\*.jpg'];
files = dir(filespath);
N = 100;
ind_rand = randi([1 length(files)], N, 1);
ind_rand = unique(ind_rand);
while length(ind_rand) < N
    ind_rand(end+1, 1) = randi([1 length(files)], 1, 1);
    ind_rand = unique(ind_rand);
end

for ii = 1:N
   name = files(ind_rand(ii)).name;
   path_ = [filepath, '\', name];
   
   path_selection{ii} = path_;
end

zip('testing_selection', path_selection);