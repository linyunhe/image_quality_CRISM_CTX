function f = compute_distance(set1,set2)
   set1_mean = mean(set1);
   set1_std = std(set1);
   mask1 = abs(set1(:,1)-set1_mean(1)) < 2*set1_std(1) & abs(set1(:,2)-set1_mean(2)) < 2*set1_std(2);
   mask1 = repmat(mask1,[1,2]);
   set1_new = reshape(set1(mask1),[length(set1(mask1))/2,2]);
   set2_mean = mean(set2);
   set2_std = std(set2);
   mask2 = abs(set2(:,1)-set2_mean(1)) < 2*set2_std(1) & abs(set2(:,2)-set2_mean(2)) < 2*set2_std(2);
   mask2 = repmat(mask2,[1,2]);
   set2_new = reshape(set2(mask2),[length(set2(mask2))/2,2]);
   [point1_num,~] = size(set1_new);
   [point2_num,~] = size(set2_new);
%    point1 = mean(set1);
%    point2 = mean(set2);
%    f = norm([point1,point2]);
   tmp = 1000;
   for i = 1:point1_num
       for j = 1:point2_num
           dist = norm([set1_new(i,1)-set2_new(j,1),set1_new(i,2)-set2_new(j,2)]);
           tmp = min(tmp,dist);
       end
   end
   f = tmp;
end