%΢����DG���ɹ��ʲ�P_dgl
%���ܳ�ŵ�����Pr
%���ܳ�ŵ繦��Pcod
%���ܶ����ES
%���ܺɵ�״̬SOC
%״̬����ʱ��1h
function [MPS,Pcod]=cod_strategy_test1(ES,Pr,P_dgl,SOC)

if P_dgl>0%%���
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
elseif P_dgl<0%%�ŵ�
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
