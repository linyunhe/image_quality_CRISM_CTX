function [r_img1,r_img2,r_img3,MTF_img1,MTF_img2,MTF_img3] = draw_MTF(img1,img2,pixel_size1,img3,pixel_size3)
   sub = choosesubfig(2,1,img1,img2);
   img3_sub = choosesubfig(1,1,img3);
   [freq,u,v] = compare_frq(sub,pixel_size1);
   [freq_img3,u_img3,v_img3] = compare_frq(img3_sub,pixel_size3);
   freq_img1 = freq(:,:,1);
   freq_img2 = freq(:,:,2);
   freq_img1 = imadjust(freq_img1);
   freq_img2 = imadjust(freq_img2);
   freq_img3 = imadjust(freq_img3);
   u_min = min(u(:));
   u_max = max(u(:));
   v_min = min(v(:));
   v_max = max(v(:));
   [uf,vf] = meshgrid(v(:,1)',u(:,1)');
   n = 501;
   [uq,vq] = meshgrid([v_min:(v_max-v_min)/(n-1):v_max],[u_min:(u_max-u_min)/(n-1):u_max]);
   freq_img1_new = interp2(uf,vf,freq_img1,uq,vq);
   freq_img2_new = interp2(uf,vf,freq_img2,uq,vq);
   [MTF_img1,r_img1] = relative(freq_img1_new);
   r_img1 = r_img1 * 1/pixel_size1;
   [MTF_img2,r_img2] = relative(freq_img2_new);
   r_img2 = r_img2 * 1/pixel_size1;
   u_min = min(u_img3(:));
   u_max = max(u_img3(:));
   v_min = min(v_img3(:));
   v_max = max(v_img3(:));
   [uf,vf] = meshgrid(v_img3',u_img3');
   n = 501;
   [uq,vq] = meshgrid([v_min:(v_max-v_min)/(n-1):v_max],[u_min:(u_max-u_min)/(n-1):u_max]);
   freq_img3_new = interp2(uf,vf,freq_img3,uq,vq);
   [MTF_img3,r_img3] = relative(freq_img3_new);
   r_img3 = r_img3 * 1/pixel_size3;
   figure;
   plot(r_img1,MTF_img1);
   hold on;
   plot(r_img2,MTF_img2);
   hold on;
   plot(r_img3,MTF_img3);
   xlabel('Spatial frequency (1/m)');
   ylabel('MTF');
   legend('SuperGLT','MLM','CTX','Location','Best');
end