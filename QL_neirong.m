function [LP]=QL_neirong(QL,LP)%%根据序列初始情况更新负荷状态

if QL(5)==1
  LP(39:40,:)=0;
end
if QL(4)==1
  LP(29:30,:)=0;
end
if QL(3)==1
  LP(33:35,:)=0;
end
if QL(2)==1
 LP(23,:)=0;
end