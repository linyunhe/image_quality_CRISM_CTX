function [f,r] = relative(freq)
   [num_u,num_v,num_band] = size(freq);
%    coef = pi*(3*(num_u+num_v)-sqrt((3*num_u+num_v)*(num_u+3*num_v)));
   radius = round(max(num_u,num_v));
   r = [1:2:radius];
   r = r/radius;
   tmp_l = length(r);
   f = zeros(length(r),num_band);
%    contrast = f;
%    tmp_pre = 0;
   tmp_r_pre = 0;
for n = 1:num_band
    img = freq(:,:,n);
   for i = 1:tmp_l
       tmp_r = r(i);
       mask1 = generate_circle(num_u,num_v,tmp_r_pre);
       mask2 = generate_circle(num_u,num_v,tmp_r);
       mask = xor(mask1,mask2);
       tmp = img(mask);
       f(i,n) = mean(tmp(~isnan(tmp)));
       tmp_r_pre = tmp_r;
%        contrast(i) = (f(i)-tmp_pre)/coef/r(i);
%        tmp_pre = f(i);
%        if contrast(i) < thre
%           break;          
%        end
%        if mod(r,20) == 0
%        fprintf('->%4.2f \n',i/tmp_l);
%        end
   end
end
%    r = [50:100:radius];
end

