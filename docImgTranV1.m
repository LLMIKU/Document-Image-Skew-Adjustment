%% 文档图像倾斜角检测及校正（基于霍夫变换原理）
% Version_1.01 2018.01.21_15:12 by Cooper Liu 
% 代码使用说明：本程序为matlab程序
% 测试图片目前有line.bmp系列和23.bmp，请将这些图片与程序放在同一目录下
% Questions? Contact me: angelpoint@foxmail.com

%% 以下是图像预处理部分
clear;clc;
I=imread('23.bmp'); %读取图像
level=graythresh(I); %使用最大类间方差法找到图片的一个合适的阈值
bw=im2bw(I,level); %根据阈值，使用im2bw函数将灰度图像转换为二值图像时
bw=~bw; %二值图像取反
figure(1);imshow(bw);

se=strel('square',16);
I1=imclose(bw,se); %闭运算
figure(2);imshow(I1);

se=strel('square',12);
I1=imdilate(I1,se); %膨胀
figure(3);imshow(I1);

se=strel('disk',18);
I1=imerode(I1,se); %腐蚀
figure(4);imshow(I1);

total = bwarea(I1);
[L, num]=bwlabel(I1,4); %标记连通域的个数
meanArea=round(total/num); %求平均连通域
I1=bwareaopen(I1, meanArea+1);%去除聚团灰度值小于平均的部分
figure(5);imshow(I1);

bw=~I1; %取反


%% 以下是基于霍夫变换的倾斜校正
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
toc;
[m,n]=size(countMatrix);
for i=1:m
    for j=1:n
        if countMatrix(i,j)>countMatrix(1,1)
            countMatrix(1,1)=countMatrix(i,j); %获取最多曲线的相交点
            angle=j; %获取相交点处对应的角度
        end
    end
end
angle %这里得到的角度是 原点到直线的垂线 与X轴的夹角
if angle<=90
    rot=-angle;
else
    rot=180-angle;
end
pic=imrotate(I,rot,'crop'); %旋转图像
figure(9);imshow(pic);