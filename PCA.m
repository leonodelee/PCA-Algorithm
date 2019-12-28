%
%测试数据：40人，每人10张照片。每人取前ph张照片作为训练集，后（10－ph）张照片作为测试集。
clear;
clc;
ph=2;
%%
%第一步：计算特征脸并创建特征空间

tic
%申请录入数据矩阵内存
imdata=zeros(112*92,40*ph);
for i=1:40    
    for j=1:ph  
        addr=strcat('/Users/sean/Documents/untitled folder/orl_faces/s',num2str(i),'/',num2str(j),'.pgm');
        a=imread(addr);
        b=a(1:112*92); 
        imdata(:,ph*(i-1)+j)=b';
    end; 
end;

%计算平均脸
imaverage=mean(imdata,2);
clear i j a b addr

%图像预处理
immin=zeros(112*92,40*ph);
for i=1:40*ph  
    %归一化处理，提升矩阵计算速度，但小数精度不够，会影响匹配率
    %immin(:,i) = (imdata(:,i)-imaverage)/col2medivation(imdata(:,i)-imaverage,112*92);
    %仅减去平均脸，不做归一化处理
    immin(:,i) = imdata(:,i)-imaverage;
end;
clear i imdata
%%
%计算协方差矩阵
W=immin*immin';
%计算特征向量与特征值（向量）
[V,~]=eig(W);
%对特征向量进行排序
VT=fliplr(V);
clear V W


%显示前32个特征脸
for i=1:32
    v=VT(:,i);
    %向量矩阵化
    out=col2mat2(v,112,92);
    subplot(4,8,i);
    imshow(out,[]);
    title(strcat('Face',num2str(i)));
end;
clear i v out
%%
%第二步：映射训练集图像到特征空间

%申请训练数据矩阵内存
featuretrain=zeros(112*92,40*ph);
for i=1:40*ph;
    %映射训练集图像
    add=VT'*immin(:,i);
    featuretrain(:,i)=add;
end;
clear i add
%%
%第三步：映射测试集图像到特征空间

%申请录入数据矩阵内存
test=zeros(112*92,40*(10-ph));
for i=1:40    
    for j=(ph+1):10  
        addr=strcat('/Users/sean/Documents/untitled folder/orl_faces/s',num2str(i),'/',num2str(j),'.pgm');
        a=imread(addr);
        b=a(1:112*92); 
        test(:,(10-ph)*(i-1)+(j-ph))=b';
    end; 
end;

%图像预处理
testmin=zeros(112*92,40*(10-ph));
for i=1:40*(10-ph)     
    testmin(:,i) = test(:,i)-imaverage;
end;
clear i j a b addr test

%申请测试数据矩阵内存
featuretest=zeros(112*92,40*(10-ph));
for i=1:40*(10-ph);
    %映射测试集图像
    add=VT'*testmin(:,i);
    featuretest(:,i)=add;
end;
clear i add
%%
%匹配计算
count=0;
for t=1:40*(10-ph)
    point=figureNum(featuretest,t,featuretrain,40*ph);
    %计算匹配个数
    if(round(point/ph+0.4)==round(t/(10-ph)+0.4))
        count=count+1;
    end;
end;
tol=count/(40*(10-ph));
clear count point t
display(strcat('匹配率：',num2str(tol*100),'%'));
clear ph tol
toc