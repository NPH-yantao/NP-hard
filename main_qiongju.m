%%穷举算法主程序,修改于2024年8月8日
clear
SolarData=xlsread('Solar Data.xls','sheet1');%光数据
SolarData(SolarData>1)=1;
weizhi_PV=[8,30,14,25];%%PV接入节点位置
weizhi_LP=[18 2;19 3;20 4;21 5;22 6; 23 17;24 18;25 10;26 25;27 12;28 13;29 15;30 16;...
    31 19;32 30;33 21;34 22;35 23;36 25;37 31;38 27; 39 28;40 29];%%接入节点位置
weizhi_ES=[18,30,14];%ES接入节点位置
%%设置源荷储分段状态数
duan_PV=2;%%每个光伏状态分段容量，MW
duan_ES=0.5;%%每个储能状态分段容量，MW
duan_LP=1;%%每个负荷状态分段容量，MW
ES_pingheng=5;
PV00=[8 10 6 2]; 
ES00=[1 1 1];
t=10;%%故障起始时刻
TTR=4;%%故障持续时间
RX=xlsread('RX.xlsx');
%%负荷大小
shu_fangan0=10;
mubiao=zeros(1,shu_fangan0);
fengxian=zeros(5,shu_fangan0);
simulation=zeros(1,shu_fangan0);
shoulian=0;
bushoulian=0;
xxx=[];
 for   fangan=1:shu_fangan0

 %%非平衡节点储能输入
ES=ES00;
PV=PV00; 
LP=xlsread('L24')*2;
%%初始化所有方案的负荷状态
fangan_chushihua
%%初始化所有状态组合的潮流
state_zuhe
%%初始化各类标签

MPS=zeros(shu_NP,shu_pingheng,TTR,size(QL,1),size(QG,1));
MSOC=zeros(shu_NP,shu_pingheng,TTR,size(QL,1),size(QG,1));
state_fengxian=zeros(shu_NP,shu_pingheng,TTR,size(QL,1),size(QG,1));
for i=1:size(QL,1)-1%%初始化不同源荷序列组合下的潮流计算结果，全切不考虑
    for j=1:size(QG,1)-1%%初始化不同源荷序列组合下的潮流计算结果，全切不考虑
      LP0=QL_neirong(QL(i,:),LP);
      PV0=QG_neirong(QG(j,:),PV);
     [MPS(:,:,:,i,j),MSOC(:,:,:,i,j),state_fengxian(:,:,:,i,j)]=chushihua_qiantui(shu_NP,state_GP,state_ES,PV0,ES,Pr...
    ,LP0,weizhi_PV,weizhi_LP,weizhi_ES,shu_PV,shu_ES,t,TTR,RX,shu_pingheng,ES_pingheng,Pr_pingheng,duan_ES);
    end
end
qie_L=zeros(shu_NP,shu_pingheng,TTR,length(QL00)-sum(QL00),length(QG00)-sum(QG00));
qie_G=zeros(shu_NP,shu_pingheng,TTR,length(QL00)-sum(QL00),length(QG00)-sum(QG00));
for i=1:size(QL,1)%%计算所有组合状态下的系统稳定序列状态
 for j=1:size(QG,1)
    [qie_L(:,:,:,i,j),qie_G(:,:,:,i,j)]=wendingzhuangtai(MPS,shu_pingheng,shu_NP,t,TTR,i,j,QL,QG);
 end
end
%计算光伏各状态概率
   [pv_state]=changjinggailv(SolarData,PV,shu_PV,duan_PV,t,TTR);
    %%初始系统级储能SOC    
    SOC0=ceil(ES_pingheng/duan_ES)/2;
    SOC1=ceil(ES(1)/duan_ES)/2+1;
    SOC2=ceil(ES(2)/duan_ES)/2+1;
    SOC3=ceil(ES(3)/duan_ES)/2+1;
 %%统计仿真时间1   
 haoshi1=clock;
 [mubiao(fangan),fengxian(:,fangan),xxx]=bianlijisuan1(TTR,ES_pingheng,duan_ES,MSOC,pv_state,state_GP,...
    QL,QG,qie_L,qie_G,fuheshu,PV,PV00,SOC0,SOC1,SOC2,SOC3,shu_NP,state_ES,ES,xxx);
xxx=[xxx;zeros(1,TTR+1)];
%%统计仿真时间2
haoshi2=clock;
simulation(fangan)=etime(haoshi2,haoshi1);
 end
 jieguo=[roundn(simulation,-2); roundn(mubiao,-2); roundn(fengxian*100,-2)];
