%%本版基于斜率空间投票原理，改进自angleDetection3.m 
%%2018.01.20_15:41 by Cooper Liu
%%Questions? Contact me: angelpoint@foxmail.com
clear;clc; %清空之前的变量
I=imread('line5.bmp'); %读取图像
level=graythresh(I); %使用最大类间方差法找到图片的一个合适的阈值
bw=im2bw(I,level); %根据阈值，使用im2bw函数将灰度图像转换为二值图像时
figure(1);imshow(bw);
[m,n]=size(bw); %获取尺寸
flag=0;

 for i=1:m
    for j=1:n
        if bw(i,j)==0
            if flag==0
                x0=i;y0=j;
                flag=1;
            end
        end
    end
 end
range=10; %整个斜率区间分为10个子区间
low=-1;
high=3;
tmpLow=low;
tmpHigh=high;
max=0;
areaAddtion=0; 
tic; %开始计时
while high-low>0.0001
a=zeros(range,1);
    for i=1:m
        for j=1:n
            if bw(i,j)==0
                if i==x0 %如果x坐标与x0相同
                    k=2; %则固定k为2
                    if k>=low && k<=high
                        area=floor((k-low)/(high-low)*range); %向下取整
                        if area==range %如果等于最后一个区间
                            area=area-1; %请考虑到后面区间计数的area+1
                        end
                        a(area+1,1)=a(area+1,1)+1; %区间计数
                    end
                else     %如果x坐标与x0不同
                    k=(j-y0)/(i-x0); %则计算斜率
                    k2=k;
                    if  k>1 || k<-1
                        k2=2-1/k;
                    end
                    if k2>=low && k2<=high
                        area=floor((k2-low)/(high-low)*range); %向下取整
                        if area==range
                            area=area-1;
                        end
                        a(area+1,1)=a(area+1,1)+1;
                    end
                end 
            end
        end
    end
[s_i,index] = sort(a,'descend');
max = index(1);
tmpLow = low;
tmpHigh = high;
if max>=2 && max<=9
    areaAddition=0; %根据需要可以更改子区间的范围
else
    areaAddtion=0;
end
low = tmpLow + (max - 1 - areaAddition)/range*(tmpHigh - tmpLow);
high = tmpLow + (max + areaAddtion)/range*(tmpHigh - tmpLow);
end

toc %获取计时时间

tmp=tmpLow+max/range*(tmpHigh-tmpLow);
if tmp>1
    k=1/(2-tmp);
else
    k=tmp;
end
angle=atan(k); %用atan求出来的角度在-pi/2到+pi/2之间
angle=angle*180/pi

rot=90-angle;
pic=imrotate(I,rot,'crop'); %旋转图像
figure(2);imshow(pic);