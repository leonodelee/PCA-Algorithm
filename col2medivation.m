function med = col2medivation( col, t )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
max=col(1,1);
min=col(1,1);
for i=1:t
    if(col(i,1)>max)
        max=col(i,1);
    end
    if(col(i,1)<min)
        min=col(i,1);
    end
end
med=max-min;

end

