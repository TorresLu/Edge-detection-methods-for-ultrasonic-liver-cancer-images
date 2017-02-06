%���������㷨�����������ڵ���regiongrowing.m����ʵ��ͼ��ָ����ʾ�ָ���
%��������������������������������������������������������������������������������
%����load_nii��������nii��ʽ�ĳ���ҽѧͼ����ͨͼ��������imread����
img=load_nii('H:\��ҵ���\������������\TrainingSet\OX-03\Data\003.nii');
img=img.img;
img=img(150:350,130:300);
figure,imshow(img,[]);

%�Ҷ�ֱ��ͼ���⻯����
[M,N]=size(img);
NumPixel = zeros(1,256);%ͳ�Ƹ��Ҷ���Ŀ����256���Ҷȼ�  

for i = 1:M  
    for j = 1:N  
        NumPixel(img(i,j) + 1) = NumPixel(img(i,j) + 1) + 1;%��Ӧ�Ҷ�ֵ���ص���������һ  
    end  
end  
%����Ҷȷֲ��ܶ�  
ProbPixel = zeros(1,256);  
for i = 1:256  
    ProbPixel(i) = NumPixel(i) / (M*N);  
end  
%�����ۼ�ֱ��ͼ�ֲ�  
CumuPixel = zeros(1,256);  
for i = 1:256  
    if i == 1  
        CumuPixel(i) = ProbPixel(i);  
    else  
        CumuPixel(i) = CumuPixel(i - 1) + ProbPixel(i);  
    end  
end  
%�ۼƷֲ�ȡ��  
CumuPixel = uint8(256.* CumuPixel + 0.5);  
%�ԻҶ�ֵ����ӳ�䣨���⻯��  
for i = 1:M  
    for j = 1:N  
        img(i,j) = CumuPixel(img(i,j)+1);  
    end  
end  
figure,imshow(img,[]);
count=0;
I=im2double(img);
%������ȡ������
[y,x]=getpts;
x=uint16(x);
y=uint16(y);
%��������
tic;
J = regiongrowing(I,x,y,52,i);
toc;

%��̬ѧ������
se1=strel('disk',6);
J=imclose(J,se1);
figure,imshow(J);
%��ȡ�ָ�����
outline = bwperim(J);
figure,imshow(outline,[]);
%��ԭͼ����ʾ����
I(outline) = 255;

figure,imshow(I,[]);
%{
%���³���Ϊ���ָ���㷨�ͱ�׼�ָ��㷨�Աȣ���������ص���
%�ָ�Ч���ļ�������ʹ�����³���
%������������������������������������������������������������
img=load_nii('H:\��ҵ���\������������\TrainingSet\OX-03\Segmentation\001.nii');
img=img.img;
img=img(150:350,130:300);
figure,imshow(img,[]);
%ѭ������Ϊ����ָ�ͼ��ͱ�׼ͼ������ص����ظ���
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
%��׼ͼ������ظ���
[r,c]=find(J==1);
b=length(r);
%�㷨�ָ�ͼ������ظ���
[r,c]=find(img==1);
c=length(r);

Dice=2*a/(b+c)
%}