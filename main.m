%区域生长算法主函数，用于调用regiongrowing.m函数实现图像分割，并显示分割结果
%————————————————————————————————————————
%调用load_nii函数载入nii格式的超声医学图像，普通图像载入用imread函数
img=load_nii('H:\毕业设计\肝脏肿瘤数据\TrainingSet\OX-03\Data\003.nii');
img=img.img;
img=img(150:350,130:300);
figure,imshow(img,[]);

%灰度直方图均衡化处理
[M,N]=size(img);
NumPixel = zeros(1,256);%统计各灰度数目，共256个灰度级  

for i = 1:M  
    for j = 1:N  
        NumPixel(img(i,j) + 1) = NumPixel(img(i,j) + 1) + 1;%对应灰度值像素点数量增加一  
    end  
end  
%计算灰度分布密度  
ProbPixel = zeros(1,256);  
for i = 1:256  
    ProbPixel(i) = NumPixel(i) / (M*N);  
end  
%计算累计直方图分布  
CumuPixel = zeros(1,256);  
for i = 1:256  
    if i == 1  
        CumuPixel(i) = ProbPixel(i);  
    else  
        CumuPixel(i) = CumuPixel(i - 1) + ProbPixel(i);  
    end  
end  
%累计分布取整  
CumuPixel = uint8(256.* CumuPixel + 0.5);  
%对灰度值进行映射（均衡化）  
for i = 1:M  
    for j = 1:N  
        img(i,j) = CumuPixel(img(i,j)+1);  
    end  
end  
figure,imshow(img,[]);
count=0;
I=im2double(img);
%用鼠标获取生长点
[y,x]=getpts;
x=uint16(x);
y=uint16(y);
%区域生长
tic;
J = regiongrowing(I,x,y,52,i);
toc;

%形态学闭运算
se1=strel('disk',6);
J=imclose(J,se1);
figure,imshow(J);
%提取分割轮廓
outline = bwperim(J);
figure,imshow(outline,[]);
%在原图中显示轮廓
I(outline) = 255;

figure,imshow(I,[]);
%{
%以下程序为将分割的算法和标准分割算法对比，计算面积重叠率
%分割效果的检测均可以使用以下程序
%——————————————————————————————
img=load_nii('H:\毕业设计\肝脏肿瘤数据\TrainingSet\OX-03\Segmentation\001.nii');
img=img.img;
img=img(150:350,130:300);
figure,imshow(img,[]);
%循环函数为计算分割图像和标准图像面积重叠像素个数
new=zeros(M,N);
for i=1:M
    for j=1:N
        if img(i,j)==1 && J(i,j)==1
            new(i,j)=1;
        end
    end
end
figure,imshow(new,[]);
[r,c]=find(new==1);
a=length(r)
%标准图像的像素个数
[r,c]=find(J==1);
b=length(r);
%算法分割图像的像素个数
[r,c]=find(img==1);
c=length(r);

Dice=2*a/(b+c)
%}