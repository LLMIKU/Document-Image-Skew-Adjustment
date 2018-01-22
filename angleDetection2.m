%%本版基于最小距离法直线拟合原理 
%%2018.01.19 by Cooper Liu
%%Questions? Contact me: angelpoint@foxmail.com
clear;clc; %清空之前的变量
I=imread('line5.bmp'); %读取图像
level=graythresh(I); %使用最大类间方差法找到图片的一个合适的阈值
bw=im2bw(I,level); %根据阈值，使用im2bw函数将灰度图像转换为二值图像时
figure(1);imshow(bw);

[m,n]=size(bw); %获取尺寸
xSum=0;xCount=0;
ySum=0;yCount=0;
tic; %计时开始
for i=1:m
    for j=1:n
        if bw(i,j)==0
           xSum=xSum+i;xCount=xCount+1;
           ySum=ySum+j;yCount=yCount+1;
        end
    end
end
xMean=xSum/xCount;
yMean=ySum/yCount;

Lxx=0;
Lyy=0;
Lxy=0;
for i=1:m
    for j=1:n
        if bw(i,j)==0
          Lxx=Lxx+(i-xMean)^2;
          Lyy=Lyy+(j-yMean)^2;
          Lxy=Lxy+(i-xMean)*(j-yMean);
        end
    end
end
toc %获取计时时间
tmp=((Lyy-Lxx) + nthroot((Lyy-Lxx)^2 + 4*Lxy^2, 2))/(2*Lxy);
if isnan(tmp) 
    tmp=inf; %如果求得tmp是NaN，那么不需要旋转
end
%tmp=atan(2*Lxy/(Lxx-Lyy))/2; %如果倾斜角相对于水平超过正负45
angle=atan(tmp); %用atan求出来的角度在-pi/2到+pi/2之间
angle=angle*180/pi

rot=90-angle;
pic=imrotate(I,rot,'crop'); %旋转图像
figure(2);imshow(pic);