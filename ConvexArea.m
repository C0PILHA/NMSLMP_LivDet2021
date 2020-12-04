function [mask] = ConvexArea(mask)

[rows, cols] = size(mask);

L1=bwlabel(mask,4);
stats1=regionprops(L1,'Area');
[a1,b1]=size(stats1);
mask=zeros(rows,cols);
for i=1:a1
    mask1=ismember(L1,i);  
    L2=bwlabel(mask1,4);
    stats2=regionprops(L2,'ConvexHull');
    [a,b]=size(stats2.ConvexHull);
    y=stats2.ConvexHull(1:a,1);
    x=stats2.ConvexHull(1:a,2);
    mask=mask+roipoly(double(mask1),y,x)*i;
end                         
end