function [f,con,CTX_f,CTX_con] = draw_PSF(img1,img2,band,pixel_size1,img5,pixel_size2,min_flag)
   [num_row,num_col,num_band] = size(img1);
%    for i = 1:num_band
%    img1(:,:,i) = imadjust(img1(:,:,i));
%    img2(:,:,i) = imadjust(img2(:,:,i));
%    end
%    img5 = imadjust(img5);
   while 1
%    sub_img1 = choosesubfig(1,band,img1);
%    sub_img2 = choosesubfig(1,band,img2);
   sub_img5 = choosesubfig(1,1,img5);
   sub_img = choosesubfig(2,band,img1,img2);
   sub_img1 = sub_img(:,:,1:num_band);
   sub_img2 = sub_img(:,:,num_band+1:end);
%    sub_img = choosesubfig(2,1,img3,img4);
%    sub_img3 = sub_img(:,:,1);
%    sub_img4 = sub_img(:,:,2);
%    sub_img5 = choosesubfig(1,1,img5);
%    sub_img1 = imadjust(sub_img1);
%    sub_img2 = imadjust(sub_img2);
% %    sub_img3 = imadjust(sub_img3);
% %    sub_img4 = imadjust(sub_img4);
%    sub_img5 = imadjust(sub_img5);
%    img1 = imadjust(img1);
%    img2 = imadjust(img2);
%    img5 = imadjust(img5);
%    [X1,Y1] = distance(img1,[193,425],pixel_size1);
%    [X2,Y2] = distance(img5,[165,402],pixel_size3);
   
   [CTX_f,CTX_con] = draw_figure(sub_img1(:,:,band),sub_img2(:,:,band),sub_img5,pixel_size1,pixel_size2,min_flag);
   FWHM = zeros(1,2*num_band);
   contrast = FWHM;
   for i = 1:num_band
   [FWHM(i),contrast(i),~,~] = calculate_FWHM(sub_img1(:,:,i),pixel_size1,min_flag);
   
   [FWHM(i+num_band),contrast(i+num_band),~,~] = calculate_FWHM(sub_img2(:,:,i),pixel_size1,min_flag);
   end
   f = FWHM;
   con = contrast;
   operate = inputdlg('Continue to choose another area? Yes:Any number No:0');
   tmp = str2double(cell2mat(operate));
   if tmp ==0 
         break;
   end
   end
end

function [X,Y] = PSF(img1,pixel_size,min_flag)
   
   [num_rows,num_cols] = size(img1);
   if min_flag == true
       tmp = find(img1 == max(img1(:)));
   else
       tmp = find(img1 == min(img1(:)));
   end
   if length(tmp) > 1
      tmp = tmp(floor(length(tmp)/2)); 
   end
   center_row = mod(tmp-1,num_rows)+1;
   center_col = floor((tmp-1)/num_rows)+1;
   row = ([1:num_rows]-center_row)*pixel_size;
   col = ([1:num_cols]-center_col)*pixel_size;
   [X,Y] = meshgrid(col,row);   
end

function [f,contrast,sub_img_new,sub_img_adj] = calculate_FWHM(img,pixel_size,min_flag)
   [X,Y] = PSF(img,pixel_size,min_flag);
   contrast = (max(img(:))-min(img(:)))/(1/2*(max(img(:))+min(img(:))));
%    sub_img_grey = choosesubfig(4,1,img1,img2,X1,Y1);
%    sub_img_grey2 = choosesubfig(3,1,img5,X2,Y2);
%    sub_img_MLM = imadjust(sub_img_grey(:,:,1));
%    sub_img_SGLT = imadjust(sub_img_grey(:,:,2));
%    X1_sub = sub_img_grey(:,:,3);
%    Y1_sub = sub_img_grey(:,:,4);
%    sub_img_grey_CTX = imadjust(sub_img_grey2(:,:,1));
%    X2_sub = sub_img_grey2(:,:,2);
%    Y2_sub = sub_img_grey2(:,:,3);
%    [X3,Y3] = PSF(sub_img3,pixel_size2);
%    [X4,Y4] = PSF(sub_img4,pixel_size2);
%    [X5,Y5] = PSF(sub_img5,pixel_size3);
   x_min = min(Y(:));
   x_max = max(Y(:));
   y_min = min(X(:));
   y_max = max(X(:));
%    x_min = -100;
%    x_max = 100;
%    y_min = -100;
%    y_max = 100;
   deta = 1;
   [xq,yq] = meshgrid([y_min:deta:y_max],[x_min:deta:x_max]);
   sub_img_new = interp2(X,Y,img,xq,yq,'spline');
   sub_img_adj = sub_img_new/max(sub_img_new(:));
   sub_img_adj(sub_img_adj < 0) = 0;
   sub_img_adj = imadjust(sub_img_adj,[min(sub_img_adj(:)),1],[0,1]);  

   thre = 0.9;
   
%    mask_larger = sub_img_new > 1-thre;
%    mask_smaller = sub_img_new < thre;
%    x_larger = yq(mask_larger);
%    y_larger = xq(mask_larger);
%    x_smaller = yq(mask_smaller);
%    y_smaller = xq(mask_smaller);
%    f = compute_distance([x_larger,y_larger],[x_smaller,y_smaller]);
   C_large = contourc(sub_img_adj,[thre,thre]);
   C_small = contourc(sub_img_adj,[1-thre,1-thre]);
   f = (max(img(:))-min(img(:)))/compute_distance(C_large',C_small');
   
end
function [f,con] = draw_figure(sub_img1,sub_img2,sub_img5,pixel_size1,pixel_size2,min_flag)
   [X1,Y1] = PSF(sub_img1,pixel_size1,min_flag);
   [X2,Y2] = PSF(sub_img2,pixel_size1,min_flag);
   [X3,Y3] = PSF(sub_img5,pixel_size2,min_flag);
%    sub_img_grey = choosesubfig(4,1,img1,img2,X1,Y1);
%    sub_img_grey2 = choosesubfig(3,1,img5,X2,Y2);
%    sub_img_MLM = imadjust(sub_img_grey(:,:,1));
%    sub_img_SGLT = imadjust(sub_img_grey(:,:,2));
%    X1_sub = sub_img_grey(:,:,3);
%    Y1_sub = sub_img_grey(:,:,4);
%    sub_img_grey_CTX = imadjust(sub_img_grey2(:,:,1));
%    X2_sub = sub_img_grey2(:,:,2);
%    Y2_sub = sub_img_grey2(:,:,3);
%    [X3,Y3] = PSF(sub_img3,pixel_size2);
%    [X4,Y4] = PSF(sub_img4,pixel_size2);
%    [X5,Y5] = PSF(sub_img5,pixel_size3);
%    x_min = max([min(Y1(:)),min(Y2(:)),min(Y3(:))]);
%    x_max = min([max(Y1(:)),max(Y2(:)),max(Y3(:))]);
%    y_min = max([min(X1(:)),min(X2(:)),min(X3(:))]);
%    y_max = min([max(X1(:)),max(X2(:)),max(X3(:))]);
   [xq1,yq1] = meshgrid([min(X1(:)):1:max(X1(:))],[min(Y1(:)):1:max(Y1(:))]);
   [xq2,yq2] = meshgrid([min(X2(:)):1:max(X2(:))],[min(Y2(:)):1:max(Y2(:))]);
   [xq3,yq3] = meshgrid([min(X3(:)):1:max(X3(:))],[min(Y3(:)):1:max(Y3(:))]);
%    x_min = -100;
%    x_max = 100;
%    y_min = -100;
%    y_max = 100;
%    deta = 1;
%    [xq,yq] = meshgrid([y_min:deta:y_max],[x_min:deta:x_max]);
%    sub_img1_new = interp2(X1,Y1,sub_img1,xq,yq,'spline');
%    sub_img1_adj = sub_img1_new/max(sub_img1_new(:));
%    sub_img1_adj(sub_img1_adj <0) = 0;
%    sub_img1_adj = imadjust(sub_img1_adj,[min(sub_img1_adj(:)),1],[0,1]);  
%    sub_img2_new = interp2(X2,Y2,sub_img2,xq,yq,'spline');
%    sub_img2_adj = sub_img2_new/max(sub_img2_new(:));
%    sub_img2_adj(sub_img2_adj <0) = 0;
%    sub_img2_adj = imadjust(sub_img2_adj,[min(sub_img2_adj(:)),1],[0,1]);
%    sub_img5_new = interp2(X3,Y3,sub_img5,xq,yq,'spline');
%    sub_img5_adj = sub_img5_new/max(sub_img5_new(:));
%    sub_img5_adj(sub_img5_adj <0) = 0;
%    sub_img5_adj = imadjust(sub_img5_adj,[min(sub_img5_adj(:)),1],[0,1]);
   [FWHM1,contrast1,sub_img1_new,sub_img1_adj] = calculate_FWHM(sub_img1,pixel_size1,min_flag);
   [FWHM2,contrast2,sub_img2_new,sub_img2_adj] = calculate_FWHM(sub_img2,pixel_size1,min_flag);
   [FWHM3,contrast3,sub_img3_new,sub_img3_adj] = calculate_FWHM(sub_img5,pixel_size2,min_flag);
   f = FWHM3;
   con = contrast3;
%    sub_img1_adj = imadjust(sub_img1_new);
%    sub_img2_adj = imadjust(sub_img2_new);
%    sub_img5_adj = imadjust(sub_img5_new);
%    contrast1 = (max(sub_img1_new(:))-min(sub_img1_new(:)))/(1/2*(max(sub_img1_new(:))+min(sub_img1_new(:))));
%    contrast2 = (max(sub_img2_new(:))-min(sub_img2_new(:)))/(1/2*(max(sub_img2_new(:))+min(sub_img2_new(:))));
%    contrast3 = (max(sub_img5_new(:))-min(sub_img5_new(:)))/(1/2*(max(sub_img5_new(:))+min(sub_img5_new(:))));
% %    
%    thre = 0.05;
% %    if min_flag == true
%    mask_larger = sub_img1_adj > 1-thre;
%    mask_smaller = sub_img1_adj < thre;
%    x_larger = yq(mask_larger);
%    y_larger = xq(mask_larger);
%    x_smaller = yq(mask_smaller);
%    y_smaller = xq(mask_smaller);
%    FWHM1 = compute_distance([x_larger,y_larger],[x_smaller,y_smaller]);
%    mask_larger = sub_img2_adj > 1-thre;
%    mask_smaller = sub_img2_adj < thre;
%    x_larger = yq(mask_larger);
%    y_larger = xq(mask_larger);
%    x_smaller = yq(mask_smaller);
%    y_smaller = xq(mask_smaller);
%    FWHM2 = compute_distance([x_larger,y_larger],[x_smaller,y_smaller]);
%    mask_larger = sub_img5_adj > 1-thre;
%    mask_smaller = sub_img5_adj < thre;
%    x_larger = yq(mask_larger);
%    y_larger = xq(mask_larger);
%    x_smaller = yq(mask_smaller);
%    y_smaller = xq(mask_smaller);
%    FWHM3 = compute_distance([x_larger,y_larger],[x_smaller,y_smaller]);
%    FWHM1 = sqrt((max(xq(mask1)) - min(xq(mask1)))^2 + (max(yq(mask1)) - min(yq(mask1)))^2);
%    FWHM2 = sqrt((max(xq(mask2)) - min(xq(mask2)))^2 + (max(yq(mask2)) - min(yq(mask2)))^2);
%    FWHM3 = sqrt((max(xq(mask3)) - min(xq(mask3)))^2 + (max(yq(mask3)) - min(yq(mask3)))^2);
%    else
%    mask1 = sub_img1_new < thre;
%    mask2 = sub_img2_new < thre;
%    mask3 = sub_img5_new < thre;
%    end
%    FWHM1 = (Find_continues_one(mask1(xq == 0))^2+Find_continues_one(mask1(yq == 0))^2)*deta;
%    FWHM2 = (Find_continues_one(mask2(xq == 0))^2+Find_continues_one(mask2(yq == 0))^2)*deta;
%    FWHM3 = (Find_continues_one(mask3(xq == 0))^2+Find_continues_one(mask3(yq == 0))^2)*deta;
   
   figure;
%    subplot(2,2,1);
   h = mesh(xq1(1:5:end,1:5:end),yq1(1:5:end,1:5:end),sub_img1_new(1:5:end,1:5:end));
   h.FaceColor = 'none';
   h.EdgeColor = 'k';
   h.Marker = 'o';
   h.MarkerFaceColor = 'k';
   hold on;
   h = mesh(xq2(1:5:end,1:5:end),yq2(1:5:end,1:5:end),sub_img2_new(1:5:end,1:5:end));
   h.FaceColor = 'none';
   h.EdgeColor = 'r';
   h.Marker = 'd';
   h.MarkerFaceColor = 'r';
   hold on;
   h = mesh(xq3(1:5:end,1:5:end),yq3(1:5:end,1:5:end),sub_img3_new(1:5:end,1:5:end));
   h.FaceColor = 'none';
   h.EdgeColor = 'b';
   h.Marker = 'x';
   h.MarkerFaceColor = 'b';
   legend(['MLM with sharpness ',num2str(FWHM1),' and contrast ',num2str(contrast1)],['SGLT with sharpness ',num2str(FWHM2),' and contrast ',num2str(contrast2)],['CTX with sharpness ',num2str(FWHM3),' and contrast ',num2str(contrast3)],'Location','Best');
%    axis([x_min x_max y_min y_max 0 1]);
   title('Rock PSFs of three image at about 0.6 \mum');
   xlabel('X distance (m)');
   ylabel('Y distance (m)');
   zlabel('Pixel value');
   
   figure;
   [~,h] = contour(xq1,yq1,sub_img1_adj,[0.9,0.1],'ShowText','on');
   h.LineColor = 'k';
   hold on;
   [~,h] = contour(xq2,yq2,sub_img2_adj,[0.9,0.1],'ShowText','on');
   h.LineColor = 'r';
   hold on;
   [~,h] = contour(xq3,yq3,sub_img3_adj,[0.9,0.1],'ShowText','on');
   h.LineColor = 'b';
   legend('MLM','SGLT','CTX','Location','Best');
   title('Contour');
   xlabel('Relative x distance (m)');ylabel('Relative y distance (m)');
%    subplot(2,2,1);
%    h = mesh(xq,yq,sub_img1_adj);
%    h.FaceColor = 'none';
%    h.EdgeColor = 'k';
%    h.Marker = 'o';
%    h.MarkerFaceColor = 'k';
%    hold on;
%    h = mesh(xq,yq,sub_img2_adj);
%    h.FaceColor = 'none';
%    h.EdgeColor = 'r';
%    h.Marker = 'd';
%    h.MarkerFaceColor = 'r';
%    hold on;
%    h = mesh(xq,yq,sub_img5_adj);
%    h.FaceColor = 'none';
%    h.EdgeColor = 'b';
%    h.Marker = 'x';
%    h.MarkerFaceColor = 'b';
%    legend(['MLM with HW ',num2str(FWHM1),' m and contrast ',num2str(contrast1)],['SGLT with HW ',num2str(FWHM2),' m and contrast ',num2str(contrast2)],['CTX with FWHM ',num2str(FWHM3),' m and contrast ',num2str(contrast3)],'Location','Best');
% %    axis([x_min x_max y_min y_max 0 1]);
%    title('Rock PSFs of three image at band 40');
%    xlabel('X distance (m)');
%    ylabel('Y distance (m)');
%    zlabel('Enhanced pixel value');
end 