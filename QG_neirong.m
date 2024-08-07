function [PV]=QG_neirong(QG,PV)%%根据序列初始情况更新电源状态

if QG(5)==1
  PV(4)=0;
end
if QG(4)==1
  PV(3)=0;
end
if QG(3)==1
  PV(2)=0;
end
if QG(2)==1
  PV(1)=0;
end
