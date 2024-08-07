 function [shu_solar,solar_v,solar_p]=MS_solar(SolarData)
solar_Data=zeros(24,365);
for j=1:24
    for i=1:365
        solar_Data(j,i)=SolarData((i-1)*24+j);
    end
end
shu_solar=10;
% for i=1:24
%     for j=1:365
% %         if solar_Data(i,j)<Rc
% %            solar_P(i,j)=(solar_Data(i,j)^2/(Gstd*Rc));
% %        else
%            solar_P(i,j)=(solar_Data(i,j)/Gstd);
% %         end
%     end
% end
    max_solar_Data=1;
    solar_p=zeros(24,shu_solar);
       %求代表值
     for j=1:shu_solar
        solar_v(j)=max_solar_Data*j/shu_solar-max_solar_Data/shu_solar/2;
    end
for i=1:24
    %求概率
    for j=1:365
        for k=1:shu_solar
          if solar_Data(i,j)>=(max_solar_Data*(k-1)/shu_solar)&&solar_Data(i,j)<=(max_solar_Data*(k)/shu_solar)
           solar_p(i,k)=solar_p(i,k)+1/365;
           break
         end
        end
    end
end
