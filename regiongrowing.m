%�˺���Ϊ�����������̵Ĺ���ʵ�ֺ���
%���룺 I  �� �������ͼ��
%       x  �� �˹�ѡȡ��ʼ���ӵ�ĺ�����
%       y  �� �˹�ѡȡ��ʼ���ӵ��������
%       reg_maxdist �� ���õ������ָ���ֵ
%����� ����JΪ�ָ��Ķ�ֵͼ��
function J=regiongrowing(I,x,y,reg_maxdist,i)

J = zeros(size(I)); % �����������
Isizes = size(I);

reg_mean = I(x,y); % �ָ�����ĻҶȾ�ֵ
reg_size = 1;  % �ѷָ���������ظ���

%�����������صĴ洢�ռ䣬�����洢����
neg_free = 10000; neg_pos=0;
neg_list = zeros(neg_free,3); 
%���춨���صĻҶ���ָ������ֵ�ĻҶȲ�
pixdist=0; 

% �ѷָ�������ĳһ���ص��������ؼ����ĸ�����
neigb=[-1 0; 1 0; 0 -1;0 1];

% ������������
while(pixdist<reg_maxdist&&reg_size<numel(I))
    i=i+1;
   % �ĸ���������ļ��
    for j=1:4,
        %������������Ƿ񳬹�ͼ��ı߽�
        xn = x +neigb(j,1); yn = y +neigb(j,2);
        
         % ����µĴ洢�ռ����ָ�����ϴ�
        ins=(xn>=1)&&(yn>=1)&&(xn<=Isizes(1))&&(yn<=Isizes(2));
        
       % ���ĸ���������ĻҶ����ѷָ�����ĻҶȲ���С���ز���ָ�����
        if(ins&&(J(xn,yn)==0)) 
                neg_pos = neg_pos+1;
                neg_list(neg_pos,:) = [xn yn I(xn,yn)]; J(xn,yn)=1;
        end
    end
    
    % ����µĴ洢�ռ����ָ�����ϴ�
    if(neg_pos+10>neg_free), neg_free=neg_free+10000; neg_list((neg_pos+1):neg_free,:)=0; end
    
    % ���ĸ���������ĻҶ����ѷָ�����ĻҶȲ���С���ز���ָ�����
    dist = abs(neg_list(1:neg_pos,3)-reg_mean);
    [pixdist, index] = min(dist);
    J(x,y)=2; reg_size=reg_size+1;
    
   %���¼���ָ�����ĻҶȾ�ֵ
    reg_mean= (reg_mean*(reg_size-1) + neg_list(index,3))/(reg_size);
    
    %�����²������ص�����
    x = neg_list(index,1); y = neg_list(index,2);
    
   %�Ƴ�����ָ��������������
    neg_list(index,:)=neg_list(neg_pos,:); neg_pos=neg_pos-1;
    if(mod(i,10) == 0) 
        J=J>1;
        imshow(J,[]);
    end
end

%���طָ�����









