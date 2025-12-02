function [mubiao,yueshu]=AB(yuce,SOC0,TTR,N_ZY0,N_HV0,state_GP ...
    ,~,M_WS,P_WS,N_RV,QL0)
jishu=1;
p_h100=[];
p_h200=[];
p_h300=[];
p_h400=[];
p_h500=[];
E_f0=[];
for i1=1:TTR+1
    for i2=i1:TTR+1
           if size(QL0,1)<3
               i2=TTR+1;
           end
       for i3=i2:TTR+1 
           if size(QL0,1)<4
               i3=TTR+1;
           end
           for i4=i3:TTR+1
               if size(QL0,1)<5
                   i4=TTR+1;
               end
                 xulie_qiefuhe=zeros(1,TTR+1);
                 xulie_qiefuhe(1)=0;
              SOC00=zeros(N_HV0,TTR+1);
              SOC00(SOC0,1)=1;
                 keneng=[];
                 gai=0;
              for tt=1:TTR  
                 keneng=[keneng;0 0 0 0 0];
                 E_f10=[];
                 p_h10=[];
                 p_h20=[];
                 p_h30=[];
                 p_h40=[];
                 p_h50=[];
                if xulie_qiefuhe(tt)<size(QL0,1)-1
                  [L_m,L_n] =find([i1,i2,i3,i4]==tt); 
              if isempty(L_m) 
                    xulie_qiefuhe(tt+1)=xulie_qiefuhe(tt);
              else
                    xulie_qiefuhe(tt+1)=max(L_n);
              end
              if xulie_qiefuhe(tt+1)<size(QL0,1)-1
                 gai=tt;
              end
              zhuanyi=0; 
              for i=N_ZY0:-1:N_ZY0-xulie_qiefuhe(tt)
              if  i>N_ZY0-xulie_qiefuhe(tt)
                 zhuanyi=zhuanyi+i;
              end
              end
             zhuanyi=zhuanyi+N_ZY0-xulie_qiefuhe(tt+1); 
             [m0,n0]=find(P_WS(:,:,zhuanyi,:)>0);
             if ~isempty(m0)
              for shu=1:length(m0)
                 gailvJI=1;
                  for i=1:size(state_GP,1)
                     if i>3
                      if N_RV(i)>2&&state_GP(i,m0(shu))-1>0
                      gailvJI=gailvJI*yuce(i,state_GP(i,m0(shu))-1,tt);
                      end
                     else
                      if N_RV(i)>1
                      gailvJI=gailvJI*yuce(i,state_GP(i,m0(shu)),tt);
                      end                         
                     end
                  end 
              shen=fix((n0(shu)-1)/N_HV0)+1;
              lie=rem((n0(shu)-1),N_HV0)+1; 
              if tt==1&&lie~=SOC0
                  gailvJI=0;
              else
                  gailvJI=gailvJI*SOC00(lie,tt)*P_WS(m0(shu),lie,zhuanyi,shen);
                  SOC00(shen,tt+1)=SOC00(shen,tt+1)+gailvJI;
              end
              if  gailvJI>0
                keneng=[keneng;m0(shu),lie,zhuanyi,shen,gailvJI/SOC00(lie,tt)];
              end
              end
             else
                SOC00(:,tt+1)=zeros(N_HV0,1);  
             end           
                else
                 keneng=[keneng;nan*ones(1,4),1];   
                 xulie_qiefuhe(tt+1)=xulie_qiefuhe(tt);
                 SOC00(:,tt+1)= SOC00(:,tt);
                end
              end

            if sum(SOC00(:,TTR+1))>0
             xulie=[];
          if size(keneng,1)>TTR
             [hang,~]= find(sum(abs(keneng),2)==0);
             if length(hang)==1
             k10=size(keneng,1)-hang(1);
             k20=0;
             k30=0;
             k40=0;
             elseif length(hang)==2
             k10=hang(2)-hang(1)-1;
             k20=size(keneng,1)-hang(2);
             k30=0;
             k40=0;
             elseif length(hang)==3
             k10=hang(2)-hang(1)-1;
             k20=hang(3)-hang(2)-1;
             k30=size(keneng,1)-hang(3);
             k40=0;
             elseif length(hang)==4
             k10=hang(2)-hang(1)-1;
             k20=hang(3)-hang(2)-1;
             k30=hang(4)-hang(3)-1;
             k40=size(keneng,1)-hang(4);
             end 
             for k1=1:k10  
                  xulie_linshi1=keneng(k1+1,:);
              if k20>0
                  xulie_linshi2=[];
               for k2=1:k20  
                   if keneng(k1+1,4)==keneng(k10+1+k2+1,2)
                      xulie_linshi2=keneng(k10+1+k2+1,:); 
                   elseif isnan(keneng(k10+1+k2+1,2))&&keneng(k1+1,4)==1
                      xulie_linshi2=keneng(k10+1+k2+1,:); 
                   elseif isnan(keneng(k10+1+k2+1,2))&&isnan(keneng(k1+1,4))
                      xulie_linshi2=keneng(k10+1+k2+1,:); 
                   else
                       continue
                   end
                if k30>0
                    xulie_linshi3=[];
                    for k3=1:k30
                        if keneng(k10+1+k2+1,4)==keneng(k10+1+k20+1+k3+1,2)
                           xulie_linshi3=keneng(k10+1+k20+1+k3+1,:);
                        elseif isnan(keneng(k10+1+k20+1+k3+1,2))&&keneng(k10+1+k2+1,4)==1
                           xulie_linshi3=keneng(k10+1+k20+1+k3+1,:); 
                        elseif isnan(keneng(k10+1+k20+1+k3+1,2))&&isnan(keneng(k10+1+k2+1,4))
                           xulie_linshi3=keneng(k10+1+k20+1+k3+1,:);                       
                        else
                            continue
                        end    
                    if  k40>0  
                        xulie_linshi4=[];
                       for k4=1:k40
                          if keneng(k10+1+k20+1+k3+1,4)==keneng(k10+1+k20+1+k30+1+k4+1,2)   
                            xulie_linshi4=keneng(k10+1+k20+1+k30+1+k4+1,:); 
                          elseif isnan(keneng(k10+1+k20+1+k30+1+k4+1,2))&&keneng(k10+1+k20+1+k3+1,4)==1
                            xulie_linshi4=keneng(k10+1+k20+1+k30+1+k4+1,:); 
                          elseif isnan(keneng(k10+1+k20+1+k30+1+k4+1,2))&&isnan(keneng(k10+1+k20+1+k3+1,4))
                            xulie_linshi4=keneng(k10+1+k20+1+k30+1+k4+1,:); 
                          else
                            continue
                          end     
                            xulie=[xulie;xulie_linshi1  xulie_linshi2 xulie_linshi3 xulie_linshi4];
                       end
                    else
                      xulie=[xulie;xulie_linshi1  xulie_linshi2 xulie_linshi3];
                   end
                    end
                else
                 xulie=[xulie;xulie_linshi1  xulie_linshi2];
                end
               end
              else
                 xulie=[xulie;xulie_linshi1];
              end
             end
          end
          zhi=[];
          for i=1:size(xulie,1)
              linshi=zeros(1,6);
              linshi(3)=1;
              linshi(6)=1;
                 gailv=1;
             for j=1:length(hang)
               for k=1:6
                     if  k==3||k==6
                         if ~isnan(sum(xulie(i,1+(j-1)*5:j*5)))
                          linshi(k)=linshi(k)*M_WS(xulie(i,1+(j-1)*5),xulie(i,2+(j-1)*5),xulie(i,3+(j-1)*5),xulie(i,4+(j-1)*5),1+k)/...
                          M_WS(xulie(i,1+(j-1)*5),xulie(i,2+(j-1)*5),xulie(i,3+(j-1)*5),xulie(i,4+(j-1)*5),1);
                         else
                          linshi(k)=0;
                         end
                    elseif k==1
                        if ~isnan(sum(xulie(i,1+(j-1)*5:j*5)))
              linshi(k)=linshi(k)+M_WS(xulie(i,1+(j-1)*5),xulie(i,2+(j-1)*5),xulie(i,3+(j-1)*5),xulie(i,4+(j-1)*5),1+k)/...
                        M_WS(xulie(i,1+(j-1)*5),xulie(i,2+(j-1)*5),xulie(i,3+(j-1)*5),xulie(i,4+(j-1)*5),1);    
                        else
              linshi(k)=linshi(k)+size(N_RV,2); 
                        end
                     end     
               end 
               gailv=gailv*xulie(i,5+(j-1)*5);
              end             
              for j=1:gai
                  for k=1:6
                      if k==2||k==4||k==5
                if ~isnan(sum(xulie(i,1+(j-1)*5:j*5)))
                 linshi(k)=linshi(k)+M_WS(xulie(i,1+(j-1)*5),xulie(i,2+(j-1)*5),xulie(i,3+(j-1)*5),xulie(i,4+(j-1)*5),1+k)/...
                        M_WS(xulie(i,1+(j-1)*5),xulie(i,2+(j-1)*5),xulie(i,3+(j-1)*5),xulie(i,4+(j-1)*5),1)/gai; 
                end
                       end
                  end
              end
              
              if gailv>0
                 zhi=[zhi;linshi gailv];
              end
          end
             zong_gailvJI(jishu)=sum(SOC00(:,TTR+1));
             E_f0=[E_f0;zhi(:,1).*zhi(:,7)];
             p_h100=[p_h100;zhi(:,2).*zhi(:,7)];
             p_h300=[p_h300;zhi(:,4).*zhi(:,7)];
             p_h400=[p_h400;zhi(:,5).*zhi(:,7)];
             p_h200=[p_h200;zhi(:,3).*zhi(:,7)];
             p_h500=[p_h500;zhi(:,6).*zhi(:,7)];
             jishu=jishu+1;
             end
                  if i4==TTR+1
                    break
                  end
           end
           if i3==TTR+1
             break
           end
       end
    if i2==TTR+1
        break
    end
    end
end

mubiao=sum(E_f0);
yueshu=[sum(p_h100) sum(p_h200) sum(p_h300) sum(p_h400) sum(p_h500)];
