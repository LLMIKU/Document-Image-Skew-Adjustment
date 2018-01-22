%% 文档图像倾斜角检测及校正（基于最小距离直线拟合原理）
% Version_1.02 2018.01.21_20:30 by Cooper Liu 
% 代码使用说明：本程序为matlab程序，由代码段A、B、C组成，可选用A+C或者B+C
% 测试图片目前有line.bmp系列和23.bmp，请将这些图片与程序放在同一目录下
% Questions? Contact me: angelpoint@foxmail.com

%% 代码段A：单纯的测试图片line.bmp系列请启用以下代码，以下是图像预处理部分
% clear;clc;
% I=imread('line5.bmp'); %读取图像
% level=graythresh(I); %使用最大类间方差法找到图片的一个合适的阈值
% bw=im2bw(I,level); %根据阈值，使用im2bw函数将灰度图像转换为二值图像
% I1=~bw; %二值图像取反
% figure(1);imshow(I1);


%% 代码段B：测试文档图像23.bmp请启用以下代码，以下是图像预处理部分
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
I1=bwareaopen(I1, meanArea+1); %去除聚团灰度值小于平均的部分
figure(5);imshow(I1);


%% 代码段C：倾斜角检测及校正部分

f=I1;
[L,n]=bwlabel(f,4);
mark=0;
for k=1:n
    [r,c]=find(L==k);
    [s_i,index] = sort(c,'descend'); %排序
    if mark<(max(c)-min(c))
        mark=k; %寻找水平方向最长的直线
    end
end
tic;
for k=mark
    [r,c]=find(L==k);
    
    xMean=mean(r);yMean=mean(c);
    xSum=sum(r);ySum=sum(c);
    
    LxxCol=(r(:,1)-xMean).^2;
    Lxx=sum(LxxCol);
    
    LyyCol=(c(:,1)-yMean).^2;
    Lyy=sum(LyyCol);
    
    LxyCol=(r(:,1)-xMean).*(c(:,1)-yMean);
    Lxy=sum(LxyCol);
    
    tmp=((Lyy-Lxx) + nthroot((Lyy-Lxx)^2 + 4*Lxy^2, 2))/(2*Lxy);
    if isnan(tmp) 
       tmp=inf; %如果求得tmp是NaN，那么不需要旋转
    end
    angle=atan(tmp); %用atan求出来的角度在-pi/2到+pi/2之间
    angle=angle*180/pi
end
toc

rot=90-angle;
pic=imrotate(I,rot,'crop'); %旋转图像
figure(9);imshow(pic);