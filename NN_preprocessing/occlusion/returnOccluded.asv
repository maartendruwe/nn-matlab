function [occluded] = returnOccluded( center, threshold, aspect_ratio )
%Compute the occluded pedestrians (using their center position (x,y,z) and
%an estimate for the height and width using fixed H-Z relation and
%aspect_ratio. Return the indices of the occluded pedestrians.

occluded = 0;
[~, order] = sort(center(:,3), 'descend');
center_sorted = center(order, :); %sort from big to small
np = size(center,1);
ind = 1:np; ind = ind(order); %to get the right elements at the end

height = zeros(np, 1);
width = zeros(np, 1);

for ii = 1:np
   height(ii) = estimateHeight(center_sorted(ii,3));
   width(ii) = aspect_ratio*height(ii);  
end

bbx = center_sorted(:,1)-width/2;
bby = center_sorted(:,2)-height/2;

bb = [bbx, bby, width, height];

for jj=1:np-1
   bb1 = bb(jj,:);
   overlaparea = rectint(bb1, bb(jj+1:end, :))';
   area = width(jj+1:end, 1).*height(jj+1:end, 1);
   overlap = overlaparea./area;
   occ = overlap > threshold;
   tmp = cat(1, zeros(jj,1), occ);
   tmp = logical(tmp);
   occ = ind(tmp);
   if size(occ,2)>0
    occluded = cat(1, occluded, occ);
   end
end
   occluded(1) = [];

end

