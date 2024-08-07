function  [kk1,xxx]=ph3(TTR,jishu1,zong_gailvJI,state_ES,xxx)
              %%首先删除重复项，然后统计每个小时的占比

    xt=0;
    dd=[];
for i=1:TTR
    dd=[dd;zeros(1,3)];
    xt=xt+1;
    aa=jishu1(:,:,i);
     [bb,cc]=find(aa>0);
    if ~isempty(bb)
        for j=1:length(cc)
      dd(xt,:)=[bb(j),cc(j),aa(bb(j),cc(j))];
      xt=xt+1;
        end
    end
    aa(aa==0)=10^10;
    jishu1(:,:,i)=aa;
end
% if xt>1
%     dd
% end
 for i=1:TTR
    [a,b]=find(jishu1(:,:,i)>0&jishu1(:,:,i)<10^10);
    wei=[];
    for j=1:length(a)
        if b(j)==1
         wei=[wei j];
        end
    end
      c=a(wei);
      d=b(wei);  
      a(wei)=[];
      b(wei)=[];
      shu(i)=length(a) ;
    shu1(i)=length(d);
 end


kk1=1;
 %%上来就全切完了
   [a,b]=find(jishu1(:,:,1)>0&jishu1(:,:,1)<10^10);
    wei=[];
    for j=1:length(a)
        if b(j)==1
         wei=[wei j];
        end
    end
      c=a(wei);
      d=b(wei); 
 for i=1:shu1(1)  
   paixu0(kk1,:)=[zeros(1,TTR) jishu1(c(i),d(i),1)];
   kk1=kk1+1; 
 end
 %%%不考虑全切的组合
liang=prod(shu);
if  liang>0
zuhe=zeros(TTR,liang);
gailv=ones(liang,1);
for i=1:liang%%将每个组合转化各个源荷状态
           yushu=i;    
           chushu=liang;
    for j=1:length(shu)
        chushu=chushu/shu(j);
         zuhe(j,i)=ceil(yushu/chushu);
         if mod(yushu,chushu)~=0
         yushu=mod(yushu,chushu);
         else
         yushu=chushu;
         end
         [a,b]=find(jishu1(:,:,j)>0&jishu1(:,:,j)<10^10);
             wei=[];
    for l=1:length(a)
        if b(l)==1
         wei=[wei l];
        end
    end
            a(wei)=[];
            b(wei)=[];  
         gailv(i)=gailv(i)*jishu1(a(zuhe(j,i)),b(zuhe(j,i)),j);
    end
   %%判断所有序列的合规性
   hegui=1;
   [a,b]=find(jishu1(:,:,1)>0&jishu1(:,:,1)<10^10);
                wei=[];
    for l=1:length(a)
        if b(l)==1
         wei=[wei l];
        end
    end
            a(wei)=[];
            b(wei)=[];  
     paixu=state_ES(1,b(zuhe(1,i))-1);
    if TTR>1
       k=1;
   while(k<TTR)
       [a,b]=find(jishu1(:,:,k)>0&jishu1(:,:,k)<10^10);
        wei=[];
    for l=1:length(a)
        if b(l)==1
         wei=[wei l];
        end
    end
            a(wei)=[];
            b(wei)=[];  
       [c,d]=find(jishu1(:,:,k+1)>0&jishu1(:,:,k+1)<10^10);
               wei=[];
    for l=1:length(c)
        if d(l)==1
         wei=[wei l];
        end
    end
            c(wei)=[];
            d(wei)=[];  
     paixu=[paixu state_ES(1,d(zuhe(k+1,i))-1)];
    if b(zuhe(k,i))~=c(zuhe(k+1,i)) 
       hegui=0;
   end
    k=k+1;
   end
    end
   if hegui==1
    paixu0(kk1,:)=[paixu gailv(i)]; 
    kk1=kk1+1; 
   end
end
end

%%%考虑全切的组合,前面都是无全切，后面配合一个全切
if TTR>1
   for t=2:TTR
     if shu1(t)>0
         shu2=[shu(1:t-1),shu1(t)];
    liang=prod(shu2);
if  liang>0
zuhe=zeros(t,liang);
gailv=ones(liang,1);
for i=1:liang%%将每个组合转化各个源荷状态
           yushu=i;    
           chushu=liang;
    for j=1:length(shu2)
        chushu=chushu/shu2(j);
         zuhe(j,i)=ceil(yushu/chushu);
         if mod(yushu,chushu)~=0
         yushu=mod(yushu,chushu);
         else
         yushu=chushu;
         end
       if j<length(shu2)  
         [a,b]=find(jishu1(:,:,j)>0&jishu1(:,:,j)<10^10);
             wei=[];
    for l=1:length(a)
        if b(l)==1
         wei=[wei l];
        end
    end
            a(wei)=[];
            b(wei)=[];  
         gailv(i)=gailv(i)*jishu1(a(zuhe(j,i)),b(zuhe(j,i)),j);
       else
             [a,b]=find(jishu1(:,:,j)>0&jishu1(:,:,j)<10^10);
             wei=[];
    for l=1:length(a)
        if b(l)==1
         wei=[wei l];
        end
    end
          c=a(wei);
          d=b(wei);  
         gailv(i)=gailv(i)*jishu1(c(zuhe(j,i)),d(zuhe(j,i)),j);

       end
    end
   %%判断所有序列的合规性
   hegui=1;
   [a,b]=find(jishu1(:,:,1)>0&jishu1(:,:,1)<10^10);
                wei=[];
    for l=1:length(a)
        if b(l)==1
         wei=[wei l];
        end
    end
            a(wei)=[];
            b(wei)=[];  
   if b(zuhe(1,i))>1
     paixu=state_ES(1,b(zuhe(1,i))-1);
   else
     paixu=0;  
   end
       k=1;
   while(k<length(shu2))
      if k~= length(shu2)-1
       [a,b]=find(jishu1(:,:,k)>0&jishu1(:,:,k)<10^10);
        wei=[];
    for l=1:length(a)
        if b(l)==1
         wei=[wei l];
        end
    end
            a(wei)=[];
            b(wei)=[];  
       [c,d]=find(jishu1(:,:,k+1)>0&jishu1(:,:,k+1)<10^10);
               wei=[];
    for l=1:length(c)
        if d(l)==1
         wei=[wei l];
        end
    end
            c(wei)=[];
            d(wei)=[];  
    if d(zuhe(k+1,i))>1
     paixu=[paixu state_ES(1,d(zuhe(k+1,i))-1)];
   else
     paixu=[paixu 0];
    end
    if b(zuhe(k,i))~=c(zuhe(k+1,i)) 
       hegui=0;
   end
    k=k+1;
      else
          [a,b]=find(jishu1(:,:,k)>0&jishu1(:,:,k)<10^10);
        wei=[];
    for l=1:length(a)
        if b(l)==1
         wei=[wei l];
        end
    end
            a(wei)=[];
            b(wei)=[];  
       [c,d]=find(jishu1(:,:,k+1)>0&jishu1(:,:,k+1)<10^10);
               wei=[];
    for l=1:length(c)
        if d(l)==1
         wei=[wei l];
        end
    end
          e=c(wei);
          f=d(wei);

     paixu=[paixu zeros(1,TTR-length(shu2)+1)];

    if b(zuhe(k,i))~=e(zuhe(k+1,i)) 
       hegui=0;
   end
    k=k+1;       
   end
   end
   if hegui==1
    paixu0(kk1,:)=[paixu gailv(i)]; 
    kk1=kk1+1; 
    
   end
end
end
     end
   end
end

if kk1>1
    paixu0(:,TTR+1)=paixu0(:,TTR+1)/sum(paixu0(:,TTR+1))*zong_gailvJI;
    xxx=[xxx;paixu0];  
end
