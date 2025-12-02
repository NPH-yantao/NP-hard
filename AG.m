
function [mubiao,fengxian]=AG(yuce,SOC0,TTR,N_ZY0,N_ZY,state_GP ...
    ,state_ES,M_WS,P_WS,N_RV)
xulie_GP=zeros(TTR,size(state_GP,2)^TTR);
for i=1:size(state_GP,2)^TTR
           yushu=i;
           chushu=size(state_GP,2)^TTR;
    for yu=1:TTR
        chushu=chushu/size(state_GP,2);
         xulie_GP(yu,i)=ceil(yushu/chushu);
         if mod(yushu,chushu)~=0
         yushu=mod(yushu,chushu);
         else
         yushu=chushu;
         end
    end
end

xulie_ZY=zeros(TTR,N_ZY0^TTR);
jishu=zeros(1,N_ZY0^TTR);
  for i=1:N_ZY0^TTR       
           yushu=i;
           chushu=N_ZY0^TTR;
    for yu=1:TTR
        chushu=chushu/N_ZY0;
         xulie_ZY(yu,i)=ceil(yushu/chushu);
         if mod(yushu,chushu)~=0
         yushu=mod(yushu,chushu);
         else
         yushu=chushu;
         end
         if yu>1&&xulie_ZY(yu,i)>xulie_ZY(yu-1,i)
              jishu(i)=1;
         end
    end
  end
  xulie_ZY(:,jishu==1)=[];
  hang=[];
  for i=2:size(xulie_ZY,1)
      if sum(abs(xulie_ZY(:,i)-xulie_ZY(:,i-1)))==0
         hang=[hang i];
      end
  end
  xulie_ZY(:,hang)=[];
  xulie_ES=zeros(TTR,(size(state_ES,2))^TTR);
  for i=1:(size(state_ES,2))^TTR
           yushu=i;
           chushu=(size(state_ES,2))^TTR;
    for yu=1:TTR
        chushu=chushu/(size(state_ES,2));
         xulie_ES(yu,i)=ceil(yushu/chushu);
         if mod(yushu,chushu)~=0
         yushu=mod(yushu,chushu);
         else
         yushu=chushu;
         end
    end
  end

tongji=[];
i=1;
while (i<=size(xulie_ZY,2))
    k=1;
     zong_chongfu=[];
    while (k<=size(xulie_GP,2))
      j=1;  
       while (j<=size(xulie_ES,2))
      gailv=1;
      chongfu=zeros(1,2*TTR+1);
     for t=1:TTR
            if t>1
         jishu=0;
       for ji=N_ZY0:-1:xulie_ZY(t-1,i)
           if ji>xulie_ZY(t-1,i)
          jishu=jishu+ji; 
           end
       end
                if xulie_ZY(t,i)~=1
   if ~isnan(M_WS(xulie_GP(t,k),xulie_ES(t-1,j),jishu+xulie_ZY(t,i),xulie_ES(t,j),1))
         for l=1:size(yuce,1)
            if l>3
               if  N_RV(l)>2&&state_GP(l,xulie_GP(t,k))>1
    gailv=gailv*yuce(l,state_GP(l,xulie_GP(t,k))-1,t);
               end
            else
                if N_RV(l)>1
    gailv=gailv*yuce(l,state_GP(l,xulie_GP(t,k)),t);
                end
            end
         end
   else
       gailv=0;
       break
   end    
     if  gailv>0
       gailv=gailv*P_WS(xulie_GP(t,k),xulie_ES(t-1,j),jishu+xulie_ZY(t,i),xulie_ES(t,j));
     else
        break 
     end
                  chongfu(t)=xulie_GP(t,k);                 
                  chongfu(TTR+t+1)=xulie_ES(t,j)+1;
                elseif xulie_ZY(t-1,i)~=1&&xulie_ZY(t,i)==1
   if ~isnan(M_WS(xulie_GP(t,k),xulie_ES(t-1,j),jishu+xulie_ZY(t,i),xulie_ES(t,j),1))
         for l=1:size(yuce,1)
            if l>3
               if  N_RV(l)>2&&state_GP(l,xulie_GP(t,k))>1
    gailv=gailv*yuce(l,state_GP(l,xulie_GP(t,k))-1,t);
               end
            else
                if N_RV(l)>1
    gailv=gailv*yuce(l,state_GP(l,xulie_GP(t,k)),t);
                end
            end
         end
   else
       gailv=0;
       break
   end
      if  gailv>0
       gailv=gailv*P_WS(xulie_GP(t,k),xulie_ES(t-1,j),jishu+xulie_ZY(t,i),xulie_ES(t,j));
     else
        break 
     end
                  chongfu(t)=xulie_GP(t,k);                 
                  chongfu(TTR+t+1)=1;      
                end
            else
         if  ~isnan(M_WS(xulie_GP(t,k),SOC0,xulie_ZY(t,i),xulie_ES(t,j),1))         
         for l=1:size(yuce,1)
            if l>3
               if  N_RV(l)>2&&state_GP(l,xulie_GP(t,k))>1
    gailv=gailv*yuce(l,state_GP(l,xulie_GP(t,k))-1,t);
               end
            else
                if N_RV(l)>1
    gailv=gailv*yuce(l,state_GP(l,xulie_GP(t,k)),t);
                end
            end
         end
         else
             gailv=0;
             break
         end    
             if  gailv>0
       gailv=gailv*P_WS(xulie_GP(t,k),SOC0,xulie_ZY(t,i),xulie_ES(1,j));
             else
                 break
             end
              if  xulie_ZY(t,i)~=1
                 chongfu(t)=xulie_GP(t,k); 
                 chongfu(TTR+1)=SOC0;
                 chongfu(TTR+2)=xulie_ES(1,j)+1;
              else
                  chongfu(t)=xulie_GP(t,k); 
                  chongfu(TTR+1)=SOC0;
                  chongfu(TTR+2)=1;
              end
            end
     end
              if  gailv>0
              if size(zong_chongfu,1)>0
               if all(any(zong_chongfu-chongfu,2)')
              zong_chongfu=[zong_chongfu;chongfu];  
              tongji=[tongji;i j k gailv];
              end
              else
              zong_chongfu=chongfu;   
              tongji=[tongji;i j k gailv];
              end      
              end
              j=j+1;
       end
       k=k+1;
    end
    i=i+1;
end
tongji=vpa(tongji, 15);
      E_f=zeros(size(tongji,1),TTR);
      p_h1=zeros(size(tongji,1),TTR);
      p_h2=zeros(size(tongji,1),TTR);
      p_h3=zeros(size(tongji,1),TTR);
      p_h4=zeros(size(tongji,1),TTR);     
      p_h5=zeros(size(tongji,1),TTR);
      jilu=zeros(size(tongji,1),TTR);
     chai=[];
for i=1:size(tongji,1)
for t=1:TTR
    jishu=0;
       if t>1     
       for ji=N_ZY0:-1:xulie_ZY(t-1,tongji(i,1))
           if ji>xulie_ZY(t-1,tongji(i,1))
          jishu=jishu+ji; 
           end
       end
       end
       zhuanyi=jishu+xulie_ZY(t,tongji(i,1));
    if xulie_ZY(t,tongji(i,1))~=1
        jilu(i)=t;
    end
    if zhuanyi<=N_ZY
        if t>1
        E_f(i,t) =M_WS(xulie_GP(t,tongji(i,3)),xulie_ES(t-1,tongji(i,2)),zhuanyi,xulie_ES(t,tongji(i,2)),2)/...
            M_WS(xulie_GP(t,tongji(i,3)),xulie_ES(t-1,tongji(i,2)),zhuanyi,xulie_ES(t,tongji(i,2)),1);    
        p_h1(i,t)=M_WS(xulie_GP(t,tongji(i,3)),xulie_ES(t-1,tongji(i,2)),zhuanyi,xulie_ES(t,tongji(i,2)),3)/...
            M_WS(xulie_GP(t,tongji(i,3)),xulie_ES(t-1,tongji(i,2)),zhuanyi,xulie_ES(t,tongji(i,2)),1);
        p_h2(i,t)=M_WS(xulie_GP(t,tongji(i,3)),xulie_ES(t-1,tongji(i,2)),zhuanyi,xulie_ES(t,tongji(i,2)),4)/...;
            M_WS(xulie_GP(t,tongji(i,3)),xulie_ES(t-1,tongji(i,2)),zhuanyi,xulie_ES(t,tongji(i,2)),1);
        p_h3(i,t)=M_WS(xulie_GP(t,tongji(i,3)),xulie_ES(t-1,tongji(i,2)),zhuanyi,xulie_ES(t,tongji(i,2)),5)/...
            M_WS(xulie_GP(t,tongji(i,3)),xulie_ES(t-1,tongji(i,2)),zhuanyi,xulie_ES(t,tongji(i,2)),1);
        p_h4(i,t)=M_WS(xulie_GP(t,tongji(i,3)),xulie_ES(t-1,tongji(i,2)),zhuanyi,xulie_ES(t,tongji(i,2)),6)/...;
            M_WS(xulie_GP(t,tongji(i,3)),xulie_ES(t-1,tongji(i,2)),zhuanyi,xulie_ES(t,tongji(i,2)),1);
        p_h5(i,t)=M_WS(xulie_GP(t,tongji(i,3)),xulie_ES(t-1,tongji(i,2)),zhuanyi,xulie_ES(t,tongji(i,2)),7)/...
            M_WS(xulie_GP(t,tongji(i,3)),xulie_ES(t-1,tongji(i,2)),zhuanyi,xulie_ES(t,tongji(i,2)),1);
        else
        E_f(i,t)=M_WS(xulie_GP(t,tongji(i,3)),SOC0,zhuanyi,xulie_ES(1,tongji(i,2)),2)/...
            M_WS(xulie_GP(t,tongji(i,3)),SOC0,zhuanyi,xulie_ES(1,tongji(i,2)),1);
        p_h1(i,t)=M_WS(xulie_GP(t,tongji(i,3)),SOC0,zhuanyi,xulie_ES(1,tongji(i,2)),3)/...
            M_WS(xulie_GP(t,tongji(i,3)),SOC0,zhuanyi,xulie_ES(1,tongji(i,2)),1);
        p_h2(i,t)=M_WS(xulie_GP(t,tongji(i,3)),SOC0,zhuanyi,xulie_ES(1,tongji(i,2)),4)/...
            M_WS(xulie_GP(t,tongji(i,3)),SOC0,zhuanyi,xulie_ES(1,tongji(i,2)),1);
        p_h3(i,t)=M_WS(xulie_GP(t,tongji(i,3)),SOC0,zhuanyi,xulie_ES(1,tongji(i,2)),5)/...
            M_WS(xulie_GP(t,tongji(i,3)),SOC0,zhuanyi,xulie_ES(1,tongji(i,2)),1);
        p_h4(i,t)=M_WS(xulie_GP(t,tongji(i,3)),SOC0,zhuanyi,xulie_ES(1,tongji(i,2)),6)/...
            M_WS(xulie_GP(t,tongji(i,3)),SOC0,zhuanyi,xulie_ES(1,tongji(i,2)),1);
        p_h5(i,t)=M_WS(xulie_GP(t,tongji(i,3)),SOC0,zhuanyi,xulie_ES(1,tongji(i,2)),7)/...
            M_WS(xulie_GP(t,tongji(i,3)),SOC0,zhuanyi,xulie_ES(1,tongji(i,2)),1);
        end
    else
         E_f(i,t)=size(N_RV,2);%%Exp_K(size(QL0,1)-1,QL0);
          p_h1(i,t)=0;
          p_h2(i,t)=0;
          p_h3(i,t)=0;
          p_h4(i,t)=0;
          p_h5(i,t)=0;
    end
end 
       E_f0(i)=sum(E_f(i,:))*tongji(i,4);
       if jilu(i)>0
          p_h10(i)=mean(p_h1(i,1:jilu(i)))*tongji(i,4);
          p_h30(i)=mean(p_h3(i,1:jilu(i)))*tongji(i,4);
          p_h40(i)=mean(p_h4(i,1:jilu(i)))*tongji(i,4);
       else
          p_h10(i)=0;
          p_h30(i)=0;
          p_h40(i)=0;
       end
       p_h20(i)=prod(p_h2(i,:))*tongji(i,4);
       p_h50(i)=prod(p_h5(i,:))*tongji(i,4);
end
mubiao=sum(E_f0)/sum(tongji(:,4));
fengxian=[sum(p_h10) sum(p_h20) sum(p_h30) sum(p_h40) sum(p_h50)]/sum(tongji(:,4));
