%%前推回带算法，储能系统为平衡节点，DG为就地补偿功率因数为0.9，可看做负的负荷
%%系统节点编号：主馈线-主分支线-次分支线-次次分支线...第二条分支线顺序编号
%%支路编号准则为：例如2-8支路为末节点-1，即支路编号为7，RXexcel编写按支路编号从高到低
function [P_zong,shoulian]=qiantui(PQ,RX)

%%第一步，计算支路功率
%%从最大编号节点开始，逐步递归至存在分叉节点，然后记录分叉节点的单支功率并检查
%%是否可合并分叉功率为节点总功率，若可以则合并，从上述涉及节点（未完成合并的分叉节
%%点除外）的剩余节点继续从最大编号节点开始，。。。停止条件为计算节点0的合并注入功率
shu_jiedian= size(PQ,1);%结点数
c=setdiff(RX(:,2),RX(:,1));%%找到支路路末端所有节点
%%循环计算节点功率直到PQ统计矩阵不存
biaoya=33;
V(1:shu_jiedian)=biaoya;%%初始电压纵分量为系统额定电压，kV
V0(1:shu_jiedian)=biaoya-1;
e=0.01;%%迭代停止条件数值
diedai=0;%%迭代次数统计
shoulian=1;%%收敛了
 while max(abs(V-V0))>=e%是否迭代停止
     V0=V;
    if diedai>100      
        shoulian=0;%%不收敛
       break
    end
RX0=RX(:,1:2);
 yunsuan_P=zeros(shu_jiedian,1);%%kW%%其节点注入有功功率
 yunsuan_Q=zeros(shu_jiedian,1);%%kvar%%其节点注入无功功率
shouduan_P=zeros(shu_jiedian-1,1);%%支路有功功率
shouduan_Q=zeros(shu_jiedian-1,1);%%支路无功功率
I=zeros(shu_jiedian-1,1);%%支路电流统计
% I2=zeros(shu_jiedian-1,1);
detaP=0;%%线损统计
 while ~isempty(RX0)%%若不存在有功未计算的情况，则支路功率迭代计算的停止深度优先搜索，搜索编号从大到小
   jiedian=max(RX0(:,2));%%支路末节点
    [hang,~]=find(RX0(:,2)==jiedian);
   jiedian0=RX0(hang,1);%%支路首节点
   if find(c==jiedian)
     yunsuan_P(jiedian,1)=PQ(jiedian,1);%%其节点注入有功功率等于负荷功率
    yunsuan_Q(jiedian,1)=PQ(jiedian,2);%%其节点注入无功功率等于负荷功率
   end
   detaP0=RX(jiedian-1,3)*(yunsuan_P(jiedian)^2+yunsuan_Q(jiedian)^2)/V(jiedian)^2/1000;%%线路有功损耗
   detaQ0=RX(jiedian-1,4)*(yunsuan_P(jiedian)^2+yunsuan_Q(jiedian)^2)/V(jiedian)^2/1000;%%线路无功损耗
%    I2(jiedian-1)=((detaP0^2+detaQ0^2)^0.5*1000/((RX(jiedian-1,3)^2+RX(jiedian-1,4)^2))^0.5)^0.5;
   detaP=detaP+detaP0;
   shouduan_P(jiedian-1)=yunsuan_P(jiedian)+detaP0;
   shouduan_Q(jiedian-1)=yunsuan_Q(jiedian)+detaQ0;
   I(jiedian-1)=(shouduan_P(jiedian-1)^2+shouduan_Q(jiedian-1)^2)^0.5/V(jiedian);

  [xx0,~]= find(RX(:,1)==jiedian0);
  if length(xx0)>1
   yunsuan_P(jiedian0)= yunsuan_P(jiedian0)+yunsuan_P(jiedian)+PQ(jiedian0,1)/length(xx0)+detaP0;
   yunsuan_Q(jiedian0)= yunsuan_Q(jiedian0)+yunsuan_Q(jiedian)+PQ(jiedian0,2)/length(xx0)+detaQ0; 
  else
   yunsuan_P(jiedian0)=yunsuan_P(jiedian)+PQ(jiedian0,1)+detaP0;
   yunsuan_Q(jiedian0)=yunsuan_Q(jiedian)+PQ(jiedian0,2)+detaQ0; 
  end
   RX0(hang,:)=[]; 
 end
%%第二步，计算节点电压幅值和相角
   RX0=RX(:,1:2);
   V(1:shu_jiedian)=biaoya;
    while ~isempty(RX0)%%若不存在节点电压未计算的情况，节点电压的迭代计算的停止深度优先搜索，搜索编号从小到大
    jiedian0=min(RX0(:,1));%%支路首节点
    [hang,~]=find(RX0==jiedian0);  
    jiedian=RX0(hang(1),2);%%支路末节点
    V(jiedian)=0.5*V(jiedian0)+(V(jiedian0)^2-...%%节点电压幅值计算方法1
       4*(yunsuan_P(jiedian)*RX(jiedian-1,3)+yunsuan_Q(jiedian)*RX(jiedian-1,4))/1000)^0.5*0.5;
%     thetaV = (shouduan_P(jiedian-1)*RX(jiedian-1,3)+shouduan_Q(jiedian-1)*RX(jiedian-1,4))/V(jiedian0)/1000;%%电压降落纵分量
%      jthetaV = (shouduan_P(jiedian-1)*RX(jiedian-1,4)-shouduan_Q(jiedian-1)*RX(jiedian-1,3))/V(jiedian0)/1000;%%电压降落横分量
% %     V(jiedian)=((V(jiedian0)-thetaV)^2+jthetaV^2)^0.5;%%节点电压幅值计算方法2
%     alefa(jiedian)=atan(jthetaV/V(jiedian));%%相角差
     RX0(hang(1),:)=[]; %%在RX0去除该节点为末节点的支路
    end
   diedai=diedai+1;
 end
%  shoulian
  loss=sum(detaP); %%线损
%   jiedian_VU=zeros(1,shu_jiedian);
%    jiedian_VD=zeros(1,shu_jiedian);
%     xianlu_OL=zeros(1,shu_jiedian-1);
%     VU=find(V>biaoya*(1+lim_VU));
%  if ~isempty(VU)
%     jiedian_VU(VU)=1;
%  end
%  VD=find(V<biaoya*(1-lim_VD));
%  if ~isempty(VD)
%      jiedian_VD(VD)=1;
%  end
%  OL=find(I>lim_OL);
%  if ~isempty(OL)
%      xianlu_OL(OL)=1;
%  end
 P_zong=real(yunsuan_P(1));%%平衡节点发出功率
