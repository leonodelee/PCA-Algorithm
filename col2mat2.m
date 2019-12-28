function im2 = col2mat2( im1, maxrow , maxcol)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
t=0;
im2=zeros(maxrow,maxcol);
for col=1:maxcol
    for row=1:maxrow
        t=t+1;
        im2(row,col)=im1(t,1);
    end;
end;

end

