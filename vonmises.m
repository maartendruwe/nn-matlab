%% Generate angles according to Von Mises - Fischer distribution around
% angle theta

theta1 = pi;
theta2 = 0;
K = 5; %concentration parameter. The higher, the more concentrated around
%theta
N = 1000; %number of samples

a1 = circ_vmrnd(theta1, K, N);
a2 = circ_vmrnd(theta2, K, N);
a = [a1;a2];
a = 180/pi*a;

% write to .txt file
fid = fopen('angle_road.txt', 'wt'); % Open for writing
for i=1:size(a,1)
   fprintf(fid, '%d ', a(i,:));
   fprintf(fid, '\n');
end
fclose(fid);


