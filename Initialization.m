
function  [M_WS,state_GP,state_ES]=Initialization(QL0,N_RV,N_HV0,N_ZY,LP0_max,N_ZY0,ES0_max)
M_WS=zeros(prod(N_RV),N_HV0,N_ZY,N_HV0,1+1+2+3);
state_GP=zeros(size(LP0_max,2),prod(N_RV));
for i=1:prod(N_RV)
           yushu=i;
           chushu=prod(N_RV);
    for yu=1:size(LP0_max,2)
        chushu=chushu/N_RV(yu);
         state_GP(yu,i)=ceil(yushu/chushu);
         if mod(yushu,chushu)~=0
         yushu=mod(yushu,chushu);
         else
         yushu=chushu;
         end
    end
end
state_ES=zeros(size(ES0_max,2),prod(N_HV0));
for i=1:prod(N_HV0)
           yushu=i;
           chushu=prod(N_HV0);
    for yu=1:size(ES0_max,2)
        chushu=chushu/N_HV0(yu);
         state_ES(yu,i)=ceil(yushu/chushu);
         if mod(yushu,chushu)~=0
         yushu=mod(yushu,chushu);
         else
         yushu=chushu;
         end
    end
end
    jishu=0;
for  i=N_ZY0:-1:2
    for j=1:prod(N_RV)
        for k=1:N_HV0
         if k==1
            M_WS(j,k,jishu+1:jishu+i,:,:)=NaN; 
         else
          if  QL0(N_ZY0-i+1,2)==1&&state_GP(4,j)>1 
           M_WS(j,k,jishu+1:jishu+i,:,:)=NaN;
          end
           if  QL0(N_ZY0-i+1,2)==0&&state_GP(4,j)==1 
           M_WS(j,k,jishu+1:jishu+i,:,:)=NaN;
           end
          if  QL0(N_ZY0-i+1,3)==1&&state_GP(5,j)>1 
           M_WS(j,k,jishu+1:jishu+i,:,:)=NaN;
          end
           if  QL0(N_ZY0-i+1,3)==0&&state_GP(5,j)==1 
           M_WS(j,k,jishu+1:jishu+i,:,:)=NaN;
           end
           if  QL0(N_ZY0-i+1,4)==1&&state_GP(6,j)>1
           M_WS(j,k,jishu+1:jishu+i,:,:)=NaN;
           end
           if  QL0(N_ZY0-i+1,4)==0&&state_GP(6,j)==1
           M_WS(j,k,jishu+1:jishu+i,:,:)=NaN;
           end
          if ES0_max(1)==0&&state_ES(1,k)>1
            M_WS(j,k,jishu+1:jishu+i,:,:)=NaN;  
          end
          end
        end
    end
       jishu=jishu+i;        
end