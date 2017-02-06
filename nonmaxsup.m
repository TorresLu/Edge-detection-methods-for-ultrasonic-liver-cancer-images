% 此函数实现非极大值抑制，可以细化边缘，去除大量伪边缘
% 要实现此函数的功能，需要输入待处理图像的特征的方向矩阵（因此只适用于部分特征
%的处理）默认在0°-180°
% 
% 输入：  inimage - 待处理图像
% 
%         orient  - 待处理图像的特征的方向矩阵
% 
%         radius  - 像素单位与其两侧待插值像素的距离
% 
%  输出：  im        - 非极大值抑制处理后的图像
%      
%
% 半径的设置建议在1.2-1.5之间

function im= nonmaxsup(inimage, orient, radius)

if any(size(inimage) ~= size(orient))
  error('image and orientation image are of different sizes');
end
%保证输入半径大于1，若小于1则某一像素不能与其邻域像素有交点
if radius < 1
  error('radius must be >= 1');
end
   
[rows,cols] = size(inimage);
im = zeros(rows,cols);       

iradius = ceil(radius);

%计算中心像素的两侧待比较像素相对于中心像素的偏离值
 % x，y坐标相对于特定的半径和角度的偏离
angle = [0:180].*pi/180;    
xoff = radius*cos(angle);  
yoff = radius*sin(angle);  
%提取xoff和yoff距离的分子
hfrac = xoff - floor(xoff);
vfrac = yoff - floor(yoff); 
orient = fix(orient)+1;    
%进行线性插值，对每个像素进行处理
for row = (iradius+1):(rows - iradius)
  for col = (iradius+1):(cols - iradius) 

    or = orient(row,col);  
    x = col + xoff(or);   
    y = row - yoff(or);
%得到中心像素3×3邻域四角的像素坐标
    fx = floor(x);         
    cx = ceil(x);
    fy = floor(y);
    cy = ceil(y);
    tl = inimage(fy,fx);    
    tr = inimage(fy,cx);    
    bl = inimage(cy,fx);    
    br = inimage(cy,cx);   
%利用线性插值估计两侧像素的大小
    upperavg = tl + hfrac(or) * (tr - tl);  
    loweravg = bl + hfrac(or) * (br - bl);  
    v1 = upperavg + vfrac(or) * (loweravg - upperavg);
%比较中心像素和两侧像素的大小，若中心像素小，则非边缘点，剔除
  if inimage(row, col) > v1

    x = col - xoff(or);    
    y = row + yoff(or);

    fx = floor(x);
    cx = ceil(x);
    fy = floor(y);
    cy = ceil(y);
    tl = inimage(fy,fx);    
    tr = inimage(fy,cx);   
    bl = inimage(cy,fx);    
    br = inimage(cy,cx);   
    upperavg = tl + hfrac(or) * (tr - tl);
    loweravg = bl + hfrac(or) * (br - bl);
    v2 = upperavg + vfrac(or) * (loweravg - upperavg);
    %判定中心像素为局部最大，记录此点
    if inimage(row,col) > v2           
      im(row, col) = inimage(row, col);  
    end

   end
  end
end



