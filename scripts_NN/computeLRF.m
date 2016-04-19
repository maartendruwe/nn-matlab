% Compute LRF from network
clear;
dims = {'C3', 'C5', 'C9', 'C11', 'R3', 'M2', 'R3', 'R3', 'R3', 'M2', 'R3'};

lrf = 0;
switch dims{1}(1)
    case 'C'
        lrf = str2double(dims{1}(2:end));
    case 'R'
        lrf = 2*str2double(dims{1}(2:end))-1;
    case 'M'
        lrf = 0;
end

for ii = 2:length(dims)
   if ischar(dims{ii})
       switch dims{ii}(1)
           case 'C'
               lrf = lrf + str2double(dims{ii}(2:end))-1;
           case 'R'
               lrf = lrf + (2*str2double(dims{ii}(2:end))-1)-1;
           case 'M'
               fac = str2double(dims{ii}(2:end));
               lrf = lrf*fac;
               
           otherwise
               return
               
       end
       
   end
end

%% Max pooling
width = 200; height = 200; kW = 2; kH = 2; dW = 2; dH = 2; 
padW = 0; padH = 0;

owidth  = floor((width  + 2*padW - kW) / dW + 1);
oheight = floor((height + 2*padH - kH) / dH + 1);

% floor can be changed to ceil if called