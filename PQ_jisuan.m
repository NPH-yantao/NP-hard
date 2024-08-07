function [PQ]=PQ_jisuan(RX,LP,weizhi_LP,P_PV,weizhi_PV,P_ES,weizhi_ES)
PQ=zeros(length(RX(:,1))+1,2);
for i=1:size(weizhi_LP,1)  
   PQ(weizhi_LP(i,2),1)=LP(weizhi_LP(i,1));
   PQ(weizhi_LP(i,2),2)=0.3287*LP(weizhi_LP(i,1));
end
   for i=1:length(weizhi_PV)
      PQ(weizhi_PV(i),1)=PQ(weizhi_PV(i),1)-P_PV(i); 
      PQ(weizhi_PV(i),2)=PQ(weizhi_PV(i),2)+0.3287*P_PV(i);   %%��������޹�  
   end
   for i=1:length(weizhi_ES)
      PQ(weizhi_ES(i),1)=PQ(weizhi_ES(i),1)+P_ES(i); 
      PQ(weizhi_ES(i),2)=PQ(weizhi_ES(i),2)+0.3287*abs(P_ES(i));%%��ŵ綼���޹�     
   end


% if qie==1%%�����г�1��
%    PQ([30,31],1)=0;
%    PQ([30,31],2)=0;     
% elseif qie==2%%�����г�2��
%    PQ([15,16,30,31],1)=0;
%    PQ([15,16,30,31],2)=0;  
% elseif qie==3%%�����г�3��
%    PQ([15,16,30,31,22,23,24],1)=0;
%    PQ([15,16,30,31,22,23,24],2)=0;  
% elseif qie==4%%�����г�4��
%    PQ([15,16,17,30,31,22,23,24],1)=0;
%    PQ([15,16,17,30,31,22,23,24],2)=0;  
% end