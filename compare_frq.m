function [f,u,v] = compare_frq(sub_img,pixel_size)
   [num_rows,num_cols,num] = size(sub_img);
   frq = zeros(num_rows,num_cols,num);
   u = zeros(num_rows,num);
   v = zeros(num_cols,num);
   for i = 1:num
   frq(:,:,i) = abs(fftshift(fft2(sub_img(:,:,i))));
   tmp = max(max(frq(:,:,i)));
   frq(:,:,i) = frq(:,:,i)/tmp;
   center_row = mod(find(frq(:,:,i) == 1),num_rows);
   center_col = ceil(find(frq(:,:,i) == 1)/num_rows);
   u(:,i) = ([1:num_rows]'-center_row)/num_rows/pixel_size*2;
   v(:,i) = ([1:num_cols]'-center_col)/num_cols/pixel_size*2;
   end
   f = frq;
end