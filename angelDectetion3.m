%%本版基于斜率空间投票原理 
%%2018.01.20_14:09 by Cooper Liu
%%Questions? Contact me: angelpoint@foxmail.com
clear;clc; %清空之前的变量
I=imread('line5.bmp'); %读取图像
level=graythresh(I); %使用最大类间方差法找到图片的一个合适的阈值
bw=im2bw(I,level); %根据阈值，使用im2bw函数将灰度图像转换为二值图像
figure(1);imshow(bw);
[m,n]=size(bw); %获取尺寸
flag=0;
tic; %计时开始
 for i=1:m
    for j=1:n
        if bw(i,j)==0
            if flag==0
                x0=i;y0=j; %获取第一个点
                flag=1;
            end
        end
    end
 end
range=10000; %range越大对角度分得更细，计算量更大
low=-1;
high=3;

a=zeros(range,1);
 for i=1:m
   for j=1:n
        if bw(i,j)==0
            if i==x0
                k=2;
                area=floor((k-(-1))/4*range); %向下取整
                a(area+1,1)=a(area+1,1)+1; %区间计数
            else
                k=(j-y0)/(i-x0);
                k2=k;
                if  k>1 || k<-1
                    k2=2-1/k; %转换斜率，保证斜率范围（-1, 3）
                end
                area=floor((k2-(-1))/4*range); %向下取整
                a(area+1,1)=a(area+1,1)+1;
            end 
        end
    end
 end
 toc %获取时间
[s_i,index] = sort(a,'descend'); %降序排序并获取原来序列的序号至index
max=index(1);
tmp=(-1)+max/range*4;
if tmp>1
    k=1/(2-tmp); %还原原来的斜率
else
    k=tmp;
end
angle=atan(k); %用atan求出来的角度在-pi/2到+pi/2之间
angle=angle*180/pi

rot=90-angle;
pic=imrotate(I,rot,'crop'); %旋转图像
figure(2);imshow(pic);