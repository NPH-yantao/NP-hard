%%ǰ�ƻش��㷨������ϵͳΪƽ��ڵ㣬DGΪ�͵ز�����������Ϊ0.9���ɿ������ĸ���
%%ϵͳ�ڵ��ţ�������-����֧��-�η�֧��-�δη�֧��...�ڶ�����֧��˳����
%%֧·���׼��Ϊ������2-8֧·Ϊĩ�ڵ�-1����֧·���Ϊ7��RXexcel��д��֧·��ŴӸߵ���
function [P_zong,shoulian]=qiantui(PQ,RX)

%%��һ��������֧·����
%%������Žڵ㿪ʼ���𲽵ݹ������ڷֲ�ڵ㣬Ȼ���¼�ֲ�ڵ�ĵ�֧���ʲ����
%%�Ƿ�ɺϲ��ֲ湦��Ϊ�ڵ��ܹ��ʣ���������ϲ����������漰�ڵ㣨δ��ɺϲ��ķֲ��
%%����⣩��ʣ��ڵ����������Žڵ㿪ʼ��������ֹͣ����Ϊ����ڵ�0�ĺϲ�ע�빦��
shu_jiedian= size(PQ,1);%�����
c=setdiff(RX(:,2),RX(:,1));%%�ҵ�֧··ĩ�����нڵ�
%%ѭ������ڵ㹦��ֱ��PQͳ�ƾ��󲻴�
biaoya=33;
V(1:shu_jiedian)=biaoya;%%��ʼ��ѹ�ݷ���Ϊϵͳ���ѹ��kV
V0(1:shu_jiedian)=biaoya-1;
e=0.01;%%����ֹͣ������ֵ
diedai=0;%%��������ͳ��
shoulian=1;%%������
 while max(abs(V-V0))>=e%�Ƿ����ֹͣ
     V0=V;
    if diedai>100      
        shoulian=0;%%������
       break
    end
RX0=RX(:,1:2);
 yunsuan_P=zeros(shu_jiedian,1);%%kW%%��ڵ�ע���й�����
 yunsuan_Q=zeros(shu_jiedian,1);%%kvar%%��ڵ�ע���޹�����
shouduan_P=zeros(shu_jiedian-1,1);%%֧·�й�����
shouduan_Q=zeros(shu_jiedian-1,1);%%֧·�޹�����
I=zeros(shu_jiedian-1,1);%%֧·����ͳ��
% I2=zeros(shu_jiedian-1,1);
detaP=0;%%����ͳ��
 while ~isempty(RX0)%%���������й�δ������������֧·���ʵ��������ֹͣ�������������������ŴӴ�С
   jiedian=max(RX0(:,2));%%֧·ĩ�ڵ�
    [hang,~]=find(RX0(:,2)==jiedian);
   jiedian0=RX0(hang,1);%%֧·�׽ڵ�
   if find(c==jiedian)
     yunsuan_P(jiedian,1)=PQ(jiedian,1);%%��ڵ�ע���й����ʵ��ڸ��ɹ���
    yunsuan_Q(jiedian,1)=PQ(jiedian,2);%%��ڵ�ע���޹����ʵ��ڸ��ɹ���
   end
   detaP0=RX(jiedian-1,3)*(yunsuan_P(jiedian)^2+yunsuan_Q(jiedian)^2)/V(jiedian)^2/1000;%%��·�й����
   detaQ0=RX(jiedian-1,4)*(yunsuan_P(jiedian)^2+yunsuan_Q(jiedian)^2)/V(jiedian)^2/1000;%%��·�޹����
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
%%�ڶ���������ڵ��ѹ��ֵ�����
   RX0=RX(:,1:2);
   V(1:shu_jiedian)=biaoya;
    while ~isempty(RX0)%%�������ڽڵ��ѹδ�����������ڵ��ѹ�ĵ��������ֹͣ�������������������Ŵ�С����
    jiedian0=min(RX0(:,1));%%֧·�׽ڵ�
    [hang,~]=find(RX0==jiedian0);  
    jiedian=RX0(hang(1),2);%%֧·ĩ�ڵ�
    V(jiedian)=0.5*V(jiedian0)+(V(jiedian0)^2-...%%�ڵ��ѹ��ֵ���㷽��1
       4*(yunsuan_P(jiedian)*RX(jiedian-1,3)+yunsuan_Q(jiedian)*RX(jiedian-1,4))/1000)^0.5*0.5;
%     thetaV = (shouduan_P(jiedian-1)*RX(jiedian-1,3)+shouduan_Q(jiedian-1)*RX(jiedian-1,4))/V(jiedian0)/1000;%%��ѹ�����ݷ���
%      jthetaV = (shouduan_P(jiedian-1)*RX(jiedian-1,4)-shouduan_Q(jiedian-1)*RX(jiedian-1,3))/V(jiedian0)/1000;%%��ѹ��������
% %     V(jiedian)=((V(jiedian0)-thetaV)^2+jthetaV^2)^0.5;%%�ڵ��ѹ��ֵ���㷽��2
%     alefa(jiedian)=atan(jthetaV/V(jiedian));%%��ǲ�
     RX0(hang(1),:)=[]; %%��RX0ȥ���ýڵ�Ϊĩ�ڵ��֧·
    end
   diedai=diedai+1;
 end
%  shoulian
  loss=sum(detaP); %%����
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
 P_zong=real(yunsuan_P(1));%%ƽ��ڵ㷢������
