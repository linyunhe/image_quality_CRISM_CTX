function f = generate_circle(num_rows,num_cols,r)
   if mod(num_rows,2) == 0
   m = -1:2/num_rows:1-2/num_rows;
   else
   m = -1:2/(num_rows-1):1;    
   end
   
   if mod(num_cols,2) == 0
   n = -1:2/num_cols:1-2/num_cols;
   else
   n = -1:2/(num_cols-1):1;      
   end
   [x,y] = meshgrid(m,n);
   circle = x.^2+y.^2;
   circ_mask = circle <= r^2;
   f = circ_mask';
end