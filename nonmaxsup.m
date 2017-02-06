% �˺���ʵ�ַǼ���ֵ���ƣ�����ϸ����Ե��ȥ������α��Ե
% Ҫʵ�ִ˺����Ĺ��ܣ���Ҫ���������ͼ��������ķ���������ֻ�����ڲ�������
%�Ĵ���Ĭ����0��-180��
% 
% ���룺  inimage - ������ͼ��
% 
%         orient  - ������ͼ��������ķ������
% 
%         radius  - ���ص�λ�����������ֵ���صľ���
% 
%  �����  im        - �Ǽ���ֵ���ƴ�����ͼ��
%      
%
% �뾶�����ý�����1.2-1.5֮��

function im= nonmaxsup(inimage, orient, radius)

if any(size(inimage) ~= size(orient))
  error('image and orientation image are of different sizes');
end
%��֤����뾶����1����С��1��ĳһ���ز����������������н���
if radius < 1
  error('radius must be >= 1');
end
   
[rows,cols] = size(inimage);
im = zeros(rows,cols);       

iradius = ceil(radius);

%�����������ص�������Ƚ�����������������ص�ƫ��ֵ
 % x��y����������ض��İ뾶�ͽǶȵ�ƫ��
angle = [0:180].*pi/180;    
xoff = radius*cos(angle);  
yoff = radius*sin(angle);  
%��ȡxoff��yoff����ķ���
hfrac = xoff - floor(xoff);
vfrac = yoff - floor(yoff); 
orient = fix(orient)+1;    
%�������Բ�ֵ����ÿ�����ؽ��д���
for row = (iradius+1):(rows - iradius)
  for col = (iradius+1):(cols - iradius) 

    or = orient(row,col);  
    x = col + xoff(or);   
    y = row - yoff(or);
%�õ���������3��3�����Ľǵ���������
    fx = floor(x);         
    cx = ceil(x);
    fy = floor(y);
    cy = ceil(y);
    tl = inimage(fy,fx);    
    tr = inimage(fy,cx);    
    bl = inimage(cy,fx);    
    br = inimage(cy,cx);   
%�������Բ�ֵ�����������صĴ�С
    upperavg = tl + hfrac(or) * (tr - tl);  
    loweravg = bl + hfrac(or) * (br - bl);  
    v1 = upperavg + vfrac(or) * (loweravg - upperavg);
%�Ƚ��������غ��������صĴ�С������������С����Ǳ�Ե�㣬�޳�
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
    %�ж���������Ϊ�ֲ���󣬼�¼�˵�
    if inimage(row,col) > v2           
      im(row, col) = inimage(row, col);  
    end

   end
  end
end



