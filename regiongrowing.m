%此函数为区域生长过程的功能实现函数
%输入： I  — 待处理的图像
%       x  — 人工选取初始种子点的横坐标
%       y  — 人工选取初始种子点的纵坐标
%       reg_maxdist — 设置的特征分割阈值
%输出： 输入J为分割后的二值图像
function J=regiongrowing(I,x,y,reg_maxdist,i)

J = zeros(size(I)); % 建立输出函数
Isizes = size(I);

reg_mean = I(x,y); % 分割区域的灰度均值
reg_size = 1;  % 已分割区域的像素个数

%分配领域像素的存储空间，用来存储邻域
neg_free = 10000; neg_pos=0;
neg_list = zeros(neg_free,3); 
%待检定像素的灰度与分割区域均值的灰度差
pixdist=0; 

% 已分割区域中某一像素点领域像素检测的四个方向
neigb=[-1 0; 1 0; 0 -1;0 1];

% 区域生长条件
while(pixdist<reg_maxdist&&reg_size<numel(I))
    i=i+1;
   % 四个方向领域的检测
    for j=1:4,
        %检测领域像素是否超过图像的边界
        xn = x +neigb(j,1); yn = y +neigb(j,2);
        
         % 添加新的存储空间若分割区域较大
        ins=(xn>=1)&&(yn>=1)&&(xn<=Isizes(1))&&(yn<=Isizes(2));
        
       % 将四个方向领域的灰度与已分割区域的灰度差最小像素并入分割区域
        if(ins&&(J(xn,yn)==0)) 
                neg_pos = neg_pos+1;
                neg_list(neg_pos,:) = [xn yn I(xn,yn)]; J(xn,yn)=1;
        end
    end
    
    % 添加新的存储空间若分割区域较大
    if(neg_pos+10>neg_free), neg_free=neg_free+10000; neg_list((neg_pos+1):neg_free,:)=0; end
    
    % 将四个方向领域的灰度与已分割区域的灰度差最小像素并入分割区域
    dist = abs(neg_list(1:neg_pos,3)-reg_mean);
    [pixdist, index] = min(dist);
    J(x,y)=2; reg_size=reg_size+1;
    
   %重新计算分割区域的灰度均值
    reg_mean= (reg_mean*(reg_size-1) + neg_list(index,3))/(reg_size);
    
    %保存新并入像素的坐标
    x = neg_list(index,1); y = neg_list(index,2);
    
   %移除并入分割区域的领域像素
    neg_list(index,:)=neg_list(neg_pos,:); neg_pos=neg_pos-1;
    if(mod(i,10) == 0) 
        J=J>1;
        imshow(J,[]);
    end
end

%返回分割区域









