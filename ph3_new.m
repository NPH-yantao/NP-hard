function  [kk1,xxx]=ph3_new(TTR,jishu1,zong_gailvJI,state_ES,xxx)
              %%首先删除重复项，然后统计每个小时的占比
    xt=0;
    dd=[];
a0=[];
b0=[];
c0=[];
d0=[];
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
      shu(i)=length(a);
      shu1(i)=length(d);
      a0=[a0 a'];
      b0=[b0 b'];
      c0=[c0 c'];
      d0=[d0 d'];
 end

kk1=1;
 %%上来就全切完了
 for i=1:shu1(1)  
   paixu0(kk1,:)=[zeros(1,TTR) jishu1(c0(i),d0(i),1)];
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
         if j==1
         gailv(i)=gailv(i)*jishu1(a0(zuhe(j,i)),b0(zuhe(j,i)),j);
         else
         gailv(i)=gailv(i)*jishu1(a0(sum(shu(1:j-1))+zuhe(j,i)),b0(sum(shu(1:j-1))+zuhe(j,i)),j);
         end
    end
   %%判断所有序列的合规性
   hegui=1;
     paixu=state_ES(1,b0(zuhe(1,i))-1);
    if TTR>1
       k=1;
   while(k<TTR)  
     paixu=[paixu state_ES(1,b0(sum(shu(1:k))+zuhe(k+1,i))-1)];
     if k>1
    if b0(sum(shu(1:k-1))+zuhe(k,i))~=a0(sum(shu(1:k))+zuhe(k+1,i)) 
       hegui=0;
    end
     else
    if b0(zuhe(k,i))~=a0(sum(shu(1:k))+zuhe(k+1,i)) 
       hegui=0;
    end
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
           if j==1
         gailv(i)=gailv(i)*jishu1(a0(zuhe(j,i)),b0(zuhe(j,i)),j);
           else
          gailv(i)=gailv(i)*jishu1(a0(sum(shu(1:j-1))+zuhe(j,i)),b0(sum(shu(1:j-1))+zuhe(j,i)),j);
           end
       else
           if j==1
         gailv(i)=gailv(i)*jishu1(c0(zuhe(j,i)),d0(zuhe(j,i)),j);
           else
         gailv(i)=gailv(i)*jishu1(c0(sum(shu1(1:j-1))+zuhe(j,i)),d0(sum(shu1(1:j-1))+zuhe(j,i)),j);
           end
       end
    end
   %%判断所有序列的合规性
   hegui=1;
   if b0(zuhe(1,i))>1
     paixu=state_ES(1,b0(zuhe(1,i))-1);
   else
     paixu=0;  
   end
       k=1;
   while(k<length(shu2))
   if k~= length(shu2)-1 
    if b0(sum(shu(1:k))+zuhe(k+1,i))>1
     paixu=[paixu state_ES(1,b0(sum(shu(1:k))+zuhe(k+1,i))-1)];
   else
     paixu=[paixu 0];
    end
    if k>1
    if b0(sum(shu(1:k-1))+zuhe(k,i))~=a0(sum(shu(1:k))+zuhe(k+1,i)) 
       hegui=0;
    end
     else
    if b0(zuhe(k,i))~=a0(sum(shu(1:k))+zuhe(k+1,i)) 
       hegui=0;
    end
   end
    k=k+1;
      else
     paixu=[paixu zeros(1,TTR-length(shu2)+1)];
     if k>1
    if b0(sum(shu(1:k-1))+zuhe(k,i))~=c0(sum(shu1(1:k))+zuhe(k+1,i)) 
       hegui=0;
    end
     else
      if b0(zuhe(k,i))~=c0(sum(shu1(1:k))+zuhe(k+1,i)) 
       hegui=0;
      end
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
