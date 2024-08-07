function [pv_state]=changjinggailv(SolarData,PV,shu_PV,duan_PV,t,TTR)
[shu_solar,solar_v,solar_p]=MS_solar(SolarData);
    pv_state=zeros(length(PV)-1,max(shu_PV),TTR);
for T=t:t+TTR-1%%统计各个光伏的各个状态概率
                      ttt= mod(T,24);
                   if ttt==0
                      ttt=24;
                   end
    for j=1:length(PV)-1
        if PV(j)>0
          for i=1:shu_solar
      PV_state(j)=ceil(PV(j)*solar_v(i)/duan_PV)+1;
      if  PV_state(j)==1
           PV_state(j)=2;
      end
       pv_state(j,PV_state(j),T-t+1)=pv_state(j,PV_state(j),T-t+1)+solar_p(ttt,i);
          end
        end
    end
end

