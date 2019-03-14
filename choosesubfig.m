function sub_img_grey = choosesubfig(varargin)
   if length(varargin) < 2
       error('Inputs must be at least 2');
   end
   num = cell2mat(varargin(1));
   band = cell2mat(varargin(2));
   
   num_img = length(varargin) - 2;
   if num ~= num_img
      error('Invalid inputs') 
   end
   [num_rows,num_cols,num_unit] = size(cell2mat(varargin(3)));
   if band > num*num_unit
      error('Showing band should be covered in the image'); 
   end
   img_multi = zeros(num_rows,num_cols,num*num_unit);
%    new = img_multi;
   if num_unit == 1
   for i = 1:num
      img_multi(:,:,i) = cell2mat(varargin(i+2)); 
   end
   else
   for i = 1:num
      img_multi(:,:,(i-1)*num_unit+1:i*num_unit) = cell2mat(varargin(i+2)); 
   end   
   end
   figure;
%    if num == 2
% %        imshow(show_overlap(img_multi(:,:,band),img_multi(:,:,num_unit+band),0.5));
%        imshow(imadjust(img_multi(:,:,band)));
%    else       
       imshow(imadjust(img_multi(:,:,band)));
       title('Please select the area')
%    end
   h=imfreehand(gca);
%    BW=createMask(h);
%    BW = repmat(BW,[1,1,num]);
%    new(BW) = img_multi(BW);
   pos = getPosition(h);
   xmin = round(min(pos(:,2)));
   xmax = round(max(pos(:,2)));
   ymin = round(min(pos(:,1)));
   ymax = round(max(pos(:,1)));
   sub_img_grey = img_multi(xmin:xmax,ymin:ymax,:);
%    sub_img_grey = sub_img_grey - min(sub_img_grey(:));
   

end