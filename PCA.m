%
%�������ݣ�40�ˣ�ÿ��10����Ƭ��ÿ��ȡǰph����Ƭ��Ϊѵ��������10��ph������Ƭ��Ϊ���Լ���
clear;
clc;
ph=2;
%%
%��һ�������������������������ռ�

tic
%����¼�����ݾ����ڴ�
imdata=zeros(112*92,40*ph);
for i=1:40    
    for j=1:ph  
        addr=strcat('/Users/sean/Documents/untitled folder/orl_faces/s',num2str(i),'/',num2str(j),'.pgm');
        a=imread(addr);
        b=a(1:112*92); 
        imdata(:,ph*(i-1)+j)=b';
    end; 
end;

%����ƽ����
imaverage=mean(imdata,2);
clear i j a b addr

%ͼ��Ԥ����
immin=zeros(112*92,40*ph);
for i=1:40*ph  
    %��һ������������������ٶȣ���С�����Ȳ�������Ӱ��ƥ����
    %immin(:,i) = (imdata(:,i)-imaverage)/col2medivation(imdata(:,i)-imaverage,112*92);
    %����ȥƽ������������һ������
    immin(:,i) = imdata(:,i)-imaverage;
end;
clear i imdata
%%
%����Э�������
W=immin*immin';
%������������������ֵ��������
[V,~]=eig(W);
%������������������
VT=fliplr(V);
clear V W


%��ʾǰ32��������
for i=1:32
    v=VT(:,i);
    %��������
    out=col2mat2(v,112,92);
    subplot(4,8,i);
    imshow(out,[]);
    title(strcat('Face',num2str(i)));
end;
clear i v out
%%
%�ڶ�����ӳ��ѵ����ͼ�������ռ�

%����ѵ�����ݾ����ڴ�
featuretrain=zeros(112*92,40*ph);
for i=1:40*ph;
    %ӳ��ѵ����ͼ��
    add=VT'*immin(:,i);
    featuretrain(:,i)=add;
end;
clear i add
%%
%��������ӳ����Լ�ͼ�������ռ�

%����¼�����ݾ����ڴ�
test=zeros(112*92,40*(10-ph));
for i=1:40    
    for j=(ph+1):10  
        addr=strcat('/Users/sean/Documents/untitled folder/orl_faces/s',num2str(i),'/',num2str(j),'.pgm');
        a=imread(addr);
        b=a(1:112*92); 
        test(:,(10-ph)*(i-1)+(j-ph))=b';
    end; 
end;

%ͼ��Ԥ����
testmin=zeros(112*92,40*(10-ph));
for i=1:40*(10-ph)     
    testmin(:,i) = test(:,i)-imaverage;
end;
clear i j a b addr test

%����������ݾ����ڴ�
featuretest=zeros(112*92,40*(10-ph));
for i=1:40*(10-ph);
    %ӳ����Լ�ͼ��
    add=VT'*testmin(:,i);
    featuretest(:,i)=add;
end;
clear i add
%%
%ƥ�����
count=0;
for t=1:40*(10-ph)
    point=figureNum(featuretest,t,featuretrain,40*ph);
    %����ƥ�����
    if(round(point/ph+0.4)==round(t/(10-ph)+0.4))
        count=count+1;
    end;
end;
tol=count/(40*(10-ph));
clear count point t
display(strcat('ƥ���ʣ�',num2str(tol*100),'%'));
clear ph tol
toc