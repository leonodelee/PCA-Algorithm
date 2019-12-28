function point = figureNum( test,t1,train,num)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
T=100000;
for t2=1:num
        distance=norm(test(:,t1)-train(:,t2));
        if (distance<T)      
            point=t2;      
            T=distance;    
        end; 
end;
end

