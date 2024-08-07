%微网内DG负荷功率差P_dgl
%储能充放电额定功率Pr
%储能充放电功率Pcod
%储能额定容量ES
%储能荷电状态SOC
%状态持续时间1h
function [MPS,Pcod]=cod_strategy_test1(ES,Pr,P_dgl,SOC)

if P_dgl>0%%充电
    if P_dgl>=ES*(1-SOC)
        if Pr>=ES*(1-SOC)
        Pcod=ES*(1-SOC)/1;
        else Pcod=Pr;
        end
    else 
       if P_dgl>=Pr
            Pcod=Pr;
        else Pcod=P_dgl;
       end
    end  
elseif P_dgl<0%%放电
    if abs(P_dgl)>=ES*SOC
        if Pr>=ES*SOC
       Pcod=-ES*SOC/1;
        else 
            Pcod=-Pr;
        end
    else
        if abs(P_dgl)>Pr
            Pcod=-Pr;
        else
            Pcod=-abs(P_dgl);
        end
    end
elseif P_dgl==0    
    Pcod=0;
end

MPS=P_dgl-Pcod;
