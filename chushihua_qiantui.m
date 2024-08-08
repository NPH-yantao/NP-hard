function [MPS,MSOC,state_fengxian]=chushihua_qiantui(shu_NP,state_GP,state_ES,PV,ES,...
Pr,LP,weizhi_PV,weizhi_LP,weizhi_ES,shu_PV,shu_ES,t,TTR,RX,shu_pingheng,ES_pingheng,Pr_pingheng,duan_ES)

%%计算每个状态的净功率值和风险值
state_fengxian=zeros(shu_NP,shu_pingheng,TTR);%%记录目标约束状态

shu_shoulian=0;
   MPS=10^10*ones(shu_NP,shu_pingheng,TTR);
MSOC=10^10*ones(shu_NP,shu_pingheng,TTR);
for k=t:t+TTR-1
                      ttt= mod(k,24);
                   if ttt==0
                      ttt=24;
                   end
  for    i=1:shu_NP
       for es=1:shu_pingheng
           state_SOC=zeros(size(ES,2),1);
      for  j=1:length(weizhi_PV)-1
          if shu_PV(j)==1
              P_PV(j)=0;
          else   P_PV(j)=(state_GP(j,i)-1)/(shu_PV(j)-1)*PV(j)*1000;
          end
      end 

      P_PV(4)=PV(4)*1000;
      P_dgl(1)=-LP(24,ttt)*1000;%%ES1跟踪负荷24
      P_dgl(2)=P_PV(2)-LP(32,ttt)*1000;%%ES2跟踪pv1和负荷32
      if P_PV(3)>0.8*PV(3)*1000%%ES3跟踪pv2，大于80%充电，小于20%放电
        P_dgl(3)=P_PV(3)*1000;
      elseif P_PV(3)<0.2*PV(3)*1000
        P_dgl(3)=-P_PV(3)*1000; 
      else  
        P_dgl(3)=0;
      end
      for j=1:length(weizhi_ES)
if ES(j)==0
         P_ES(j)=0;
        state_SOC(j)=1;   
else
        [~,P_ES(j)]=ES_strategy(ES(j)*1000,Pr(j)*1000,P_dgl(j),(state_ES(j+1,es)-1)/(shu_ES(j)-1));
        state_SOC(j)=ceil((state_ES(j+1,es)-1)/(shu_ES(j)-1)+P_ES(j)/1000/ES(j))*(shu_ES(j)-1)+1;
         if state_SOC(j)==1
            state_SOC(j)=2;
        end
end
      end  
      [PQ]=PQ_jisuan(RX,LP(:,ttt)*1000,weizhi_LP,P_PV,weizhi_PV,P_ES,weizhi_ES);
      [P_zong,shoulian0]=qiantui(PQ,RX);
      if shoulian0==1

      shu_shoulian=shu_shoulian+1;
      state_fengxian(i,es,k-t+1)=-(P_zong)/1000; %%平衡节点返送的功率为正
      else  
          state_fengxian(i,es,k-t+1)=10^10; 
      end



   if state_fengxian(i,es,k-t+1)~=10^10 
  
 [MPS(i,es,k-t+1),Pcod]=ES_strategy(ES_pingheng,Pr_pingheng,state_fengxian(i,es,k-t+1),state_ES(1,es)/(ES_pingheng/duan_ES));  
                      if MPS(i,es,k-t+1)==0
                            
 soc_pingheng=ceil((state_ES(1,es)/(ES_pingheng/duan_ES)+Pcod/ES_pingheng)*ES_pingheng/duan_ES);
                      if soc_pingheng==0
                         soc_pingheng=1;
                      end
                          for kk=1:size(state_ES,2)
                               ma=sum(abs(state_ES(:,kk)-[soc_pingheng,state_SOC(1),state_SOC(2),state_SOC(3)]'));
                            if  ma==0
                     MSOC(i,es,k-t+1)=kk;
                            end
                          end
                      else
%                        [MPS(i,es,k-t+1),Pcod,state_fengxian(i,es,k-t+1)]    
                       MSOC(i,es,k-t+1)=10^10;
                      end
   else
          MPS(i,es,k-t+1)=10^10;
         MSOC(i,es,k-t+1)=10^10;
   end
       end 
  end
end 
if shu_shoulian/shu_NP/shu_pingheng/TTR<0.9999
  shu_shoulian/shu_NP/shu_pingheng/TTR
end
