%Plane 3
x11 = -3.63;
x12 = 5.077;
y11 = -4.131;
y12 = 83.992;

% M = 100;
% P = 500;
M = 15;
P = 30;
% for ii = 1:M
%     for jj = 1:P
%         x = x11 + ii*1/M*(x12-x11);
%         y = y11 + jj*1/P*(y12-y11);
%         O((ii-1)*P+1:ii*P, 1) = x;
%         O((ii-1)*P+1:ii*P, 2) = y;
%     end
% end

stepx = 1/M*(x12-x11);
stepy = 1/P*(y12-y11);
for ii = 1:M
   points3((ii-1)*P+1:ii*P, 1) = x11+(ii-1)*stepx;
   ys = linspace(y11,y12,P);
   points3((ii-1)*P+1:ii*P, 2) = ys;
   
end
points3 = points3*39.37;
points3(:, 3:4) = ones(size(points3, 1),1)*[0,2];

%% Plane 2

%Plane 2
x11 = -8.587;
x12 = -4.587;
y11 = 7.192;
y12 = 84;

% M = 200;
% P = 600;
% for ii = 1:M
%     for jj = 1:P
%         x = x11 + ii*1/M*(x12-x11);
%         y = y11 + jj*1/P*(y12-y11);
%         O((ii-1)*P+1:ii*P, 1) = x;
%         O((ii-1)*P+1:ii*P, 2) = y;
%     end
% end

stepx = 1/M*(x12-x11);
stepy = 1/P*(y12-y11);
for ii = 1:M
   points2((ii-1)*P+1:ii*P, 1) = x11 + (ii-1)*stepx;
   ys = linspace(y11,y12,P);
   points2((ii-1)*P+1:ii*P, 2) = ys;
   
end
points2 = points2*39.37;
points2(:, 3:4) = ones(size(points2, 1),1)*[0.231*39.37,1];

%% Plane 1

x11 = 7.464;
x12 = 17.464;
y11 = 14;
y12 = 84;

% M = 200;
% P = 600;
% for ii = 1:M
%     for jj = 1:P
%         x = x11 + ii*1/M*(x12-x11);
%         y = y11 + jj*1/P*(y12-y11);
%         O((ii-1)*P+1:ii*P, 1) = x;
%         O((ii-1)*P+1:ii*P, 2) = y;
%     end
% end

stepx = 1/M*(x12-x11);
stepy = 1/P*(y12-y11);
for ii = 1:M
   points1((ii-1)*P+1:ii*P, 1) = x11 + (ii-1)*stepx;
   ys = linspace(y11,y12,P);
   points1((ii-1)*P+1:ii*P, 2) = ys;
   
end

points1 = points1*39.37;
points1(:, 3:4) = ones(size(points1, 1),1)*[0.189*39.37,1];

%% Generate text file

points = [points1; points2; points3];
fid = fopen('locations.txt', 'wt'); % Open for writing
for i=1:size(points,1)
   fprintf(fid, '%d ', points(i,:));
   fprintf(fid, '\n');
end
fclose(fid);