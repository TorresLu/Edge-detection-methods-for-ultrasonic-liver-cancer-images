%�˺���Ϊ�����������ڵ���phasecong2.m�ļ���nonmaxsup.mʵ�ֱַ���λһ���Դ���ͷǼ���ֵ���ƴ���������ʾͼ��
%������������������������������������������������������������������������
%%����load_nii��������nii��ʽ�ĳ���ҽѧͼ����ͨͼ��������imread����
img=load_nii('E:\��ѧ\document\successful\successful\ʾ��ͼ��\������ͼ��\001.nii');
img=img.img;
img=img(150:350,130:300);
imshow(img,[]),title('ԭʼͼ��');
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
figure,imshow(img,[]),title('�Ҷ�ֱ��ͼ���⻯����');
%����phasecong2����ʵ����λһ���Դ���
[pc or ft] = phasecong2(img);
figure,imshow(pc);  
%ʵ�ַǼ���ֵ����
im=nonmaxsup(pc,or,1.5);
figure,imshow(im,[]);
