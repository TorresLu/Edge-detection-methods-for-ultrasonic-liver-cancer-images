%此函数为主函数，用于调用phasecong2.m文件和nonmaxsup.m实现分别相位一致性处理和非极大值抑制处理，并可显示图像
%————————————————————————————————————
%%调用load_nii函数载入nii格式的超声医学图像，普通图像载入用imread函数
img=load_nii('E:\大学\document\successful\successful\示例图像\待处理图像\001.nii');
img=img.img;
img=img(150:350,130:300);
imshow(img,[]),title('原始图像');
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
figure,imshow(img,[]),title('灰度直方图均衡化处理');
%调用phasecong2函数实现相位一致性处理
[pc or ft] = phasecong2(img);
figure,imshow(pc);  
%实现非极大值抑制
im=nonmaxsup(pc,or,1.5);
figure,imshow(im,[]);
