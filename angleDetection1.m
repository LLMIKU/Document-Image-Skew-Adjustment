%%本版基于霍夫变换原理
%%2018.01.16 by Cooper Liu
%%Questions? Contact me: angelpoint@foxmail.com
clear;clc; %清空之前的变量
I=imread('line5.bmp'); %读取图像
level=graythresh(I); %使用最大类间方差法找到图片的一个合适的阈值
bw=im2bw(I,level); %根据阈值，使用im2bw函数将灰度图像转换为二值图像时
figure(1);imshow(bw);
[m,n]=size(bw); %获取尺寸
pMax=round(sqrt(m^2+n^2)); %计算最大p
thetaMax=180; %设定最大角度
countMatrix=zeros(pMax,thetaMax); %关于p和角度的计数矩阵
tic;
for i=1:m
    for j=1:n
        if bw(i,j)==0
            for theta=1:thetaMax %对theta作循环
                p=floor( abs( i*cos(3.14*theta/180) + j*sin(3.14*theta/180) ) ); %在theta循环过程中计算图像矩阵中一个像素点对应的p值
                countMatrix(p+1,theta)=countMatrix(p+1,theta)+1; %像素点对应的计数矩阵中(p+1,theta)处计数
            end
        end
    end
end
[m,n]=size(countMatrix);
for i=1:m
    for j=1:n
        if countMatrix(i,j)>countMatrix(1,1)
            countMatrix(1,1)=countMatrix(i,j); %获取最多曲线的相交点
            angle=j; %获取相交点处对应的角度
        end
    end
end
toc;
angle %这里得到的角度是 原点到直线的垂线 与X轴的夹角
if angle<=90
    rot=-angle;
else
    rot=180-angle;
end
pic=imrotate(I,rot,'crop'); %旋转图像
figure(2);imshow(pic);
                
