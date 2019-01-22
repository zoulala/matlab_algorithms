function [ op_cut,op_cutv ,min_err,op_G] = C_cart( x,y,D )
%C_CART Summary of this function goes here
%   Detailed explanation goes here
[n,~]=size(x);
class_y=unique(y);
pre0=ones(n,1);

    for i=1:n-1
       cut(i)= (x(i)+x(i+1))/2;%分类阈值

    %----- %得到分类误差   
       pre(1:i)=class_y(1)*pre0(1:i);%归为类1
       pre(i+1:n)=class_y(2)*pre0(i+1:n);%归为类2
       G1=[pre(1:i),pre(i+1:n)]';
       err1=0;
       for j=1:n
          if y(j)~=pre(j)
              err1=err1+D(j);
          end
       end

       pre(1:i)=class_y(2)*pre0(1:i);%归为类2
       pre(i+1:n)=class_y(1)*pre0(i+1:n);%归为类1
       G2=[pre(1:i),pre(i+1:n)]';
       err2=0;
       for j=1:n
          if y(j)~=pre(j)
              err2=err2+D(j);
          end
       end

       if err1<=err2
           err(i)=err1;G(:,i)=G1;cut_v(i,:)=[class_y(1),class_y(2)];
       else
           err(i)=err2;G(:,i)=G2;cut_v(i,:)=[class_y(2),class_y(1)];
       end
    %--------------------------

    end
    
    
    min_err=min(err); %最小分类误差
    min_i=find(err==min_err);min_i=min_i(1);
    op_cut=cut(min_i);  %最优分类阈值
    op_G=G(:,min_i); %分类值
    op_cutv=cut_v(min_i,:);


end

