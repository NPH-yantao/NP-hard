
if fangan==1
  LP(25:40,:)=0;
  PV(2:4)=0;
  ES(2:3)=0;
  fuheshu=size(weizhi_LP,1)-size(LP(25:40,:),1);
  QL00=[0 0 1 1 1];%%按隔离开状态初始化负荷动态开关状态，闭合是0，断开是1
  QG00=[0 0 1 1 1];%%按隔离开状态初始化电源动态开关状态，闭合是0，断开是1
 elseif fangan==2
  LP(25:30,:)=0;
  LP(36:40,:)=0;
  PV([3,4])=0;
  ES(3)=0;
  fuheshu=size(weizhi_LP,1)-size(LP(25:30,:),1)-size(LP(36:40,:),1);
    QL00=[0 0 1 1 0];
    QG00=[0 0 0 1 1];
 elseif fangan==3
  LP(28:40,:)=0;
  PV([2,3,4])=0;
  ES(2:3)=0;
  fuheshu=size(weizhi_LP,1)-size(LP(28:40,:),1);
    QL00=[0 0 1 1 1];
    QG00=[0 0 1 1 1];
  elseif fangan==4
   LP(28:30,:)=0;
   LP(36:40,:)=0;
   PV([3,4])=0;
  ES(3)=0;
  fuheshu=size(weizhi_LP,1)-size(LP(28:30,:),1)-size(LP(36:40,:),1);
  QL00=[0 0 1 1 0];
  QG00=[0 0 0 1 1];
  elseif fangan==5
  LP(36:40,:)=0;
  PV(4)=0;
  fuheshu=size(weizhi_LP,1)-size(LP(36:40,:),1);
  QL00=[0 0 0 1 0];
  QG00=[0 0 0 0 1];
  elseif fangan==6
  LP(28:30,:)=0;
  PV(3)=0;
  ES(3)=0;
  fuheshu=size(weizhi_LP,1)-size(LP(28:30,:),1);
  QL00=[0 0 1 0 0];
  QG00=[0 0 0 1 0];
 elseif fangan==7
 fuheshu=size(weizhi_LP,1)-size(LP(31:35,:),1);
  QL00=[0 0 0 0 0];
  QG00=[0 0 0 0 0];
  elseif fangan==8
  LP(31:35,:)=0;
  PV(2)=0;
  ES(2)=0;
  fuheshu=size(weizhi_LP,1)-size(LP(31:35,:),1);
    QL00=[0 0 0 0 1];
     QG00=[0 0 1 0 0];
   elseif fangan==9
  P(31:35,:)=0;
  LP(36:40,:)=0;
  PV([2,4])=0;
  ES(2)=0;
  fuheshu=size(weizhi_LP,1)-size(LP(31:35,:),1)-size(LP(36:40,:),1);
     QL00=[0 0 0 1 1];
     QG00=[0 0 1 0 1];
   elseif fangan==10
  LP(28:35,:)=0;
  PV([2,3])=0;
  ES([2,3])=0;
  fuheshu=size(weizhi_LP,1)-size(LP(28:35,:),1);
  QL00=[0 0 1 0 1];
  QG00=[0 0 1 1 0];
end

QL=zeros(length(find(QL00==0))+1,length(QL00));%%初始化动态切负荷状态序列
for i=1:size(QL,1)
QL(i,:)=QL(i,:)+QL00;
end
QL0=find(QL00==0);
if ~isempty(QL0)
for i=1:length(QL0)
   QL(i+1,QL0(1,length(find(QL00==0))-i+1:length(find(QL00==0))))=1;
end
end

QG=zeros(length(find(QG00==0))+1,length(QG00));%%初始化动态切电源状态序列
for i=1:size(QG,1)
QG(i,:)=QG(i,:)+QG00;
end
QG0=find(QG00==0);
if ~isempty(QG0)
for i=1:length(QG0)
   QG(i+1,QG0(1,length(find(QG00==0))-i+1:length(find(QG00==0))))=1;
end
end
