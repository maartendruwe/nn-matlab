%Generate all possible combinations of models and poses
clear all;
M = 139;
P = 32;

O = zeros(M*P, 2);
for ii = 1:M
    for jj = 1:P
        O((ii-1)*P+1:ii*P, 1) = ii;
        O((ii-1)*P+1:ii*P, 2) = 1:P;
    end
end

%%

fid = fopen('model_pose.txt', 'wt'); % Open for writing
for i=1:size(O,1)
   fprintf(fid, '%d ', O(i,:));
   fprintf(fid, '\n');
end
fclose(fid);