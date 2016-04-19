function [occluded] = returnOccluded( center, threshold, segs )
%Compute the occluded pedestrians (using their center position (x,y,z) and
%an estimate for the height and width using fixed H-Z relation and
%aspect_ratio. Return the indices of the occluded pedestrians.

occluded = 0;
[~, order] = sort(center(:,3), 'descend');
center_sorted = center(order, :); %sort from big to small
for jj = 1:length(order)
   segs_sorted(:,:,:,jj) = segs{order(jj)}; 
end

np = size(center,1);
ind = 1:np; ind = ind(order); %to get the right elements at the end

for jj = 1:np
   seg_bw(:,:,jj) = im2bw(segs_sorted(:,:,:,jj), 0.1);
end

for jj=1:np-1
   clear overlaparea;
   for zz=jj+1:np
      sums = seg_bw(:,:,jj) + seg_bw(:,:,zz);
      overlaparea(zz-jj) = length(find(sums==2));
   end
   area = squeeze(sum(sum(seg_bw(:,:,jj+1:end), 1),2));
   overlap = overlaparea./area';
   occ = overlap > threshold;
   tmp = cat(1, zeros(jj,1), occ');
   tmp = logical(tmp);
   occ = ind(tmp);
   if size(occ,2)>0
    occluded = cat(2, occluded, occ);
   end
end
   occluded = unique(occluded);
   occluded(1) = [];
end

