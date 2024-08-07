function  [mubiao,fengxian,xxx]=diguijisuan(ES,SOC0,TTR,shu_pingheng,MSOC,...
    pv_state,state_GP,QL,QG,qie_L,qie_G,fuheshu,PV,PV00,ES_pingheng,duan_ES,state_ES,xxx)
 tongji1=zeros(TTR+1,TTR+1,TTR+1,TTR+1,TTR+1,TTR+1,TTR+1,TTR+1,TTR+1,TTR+1); 
             jishu=1;
            kk1=0;
               for L2=1:TTR+1 %%负荷序列2的初始时刻
               for L3=L2:TTR+1%%%%负荷序列3的初始时刻
               for L4=L3:TTR+1%%%%负荷序列4的初始时刻
               for L5=L4:TTR+1%%%%负荷序列5的初始时刻
               for L6=L5:TTR+1%%%%负荷序列6的初始时刻
               for G2=1:TTR+1 %%电源序列2的初始时刻
               for G3=G2:TTR+1%%%%电源序列3的初始时刻
               for G4=G3:TTR+1%%%%电源序列4的初始时刻
               for G5=G4:TTR+1%%%%电源序列5的初始时刻
               for G6=G5:TTR+1%%%%电源序列6的初始时刻 
                 chongfu=0;
                 [L2,L3,L4,L5,L6,G2,G3,G4,G5,G6]=xunhuanchongzhi(L2,L3...
                    ,L4,L5,L6,G2,G3,G4,G5,G6,QL,QG,TTR);
                 [tongji1,chongfu]=tongji([L2,L3,L4,L5,L6],[G2,G3,G4,G5,G6],QL,QG,TTR,tongji1,chongfu);
                 if chongfu==1
                 xulie_qiguang=zeros(1,TTR+1);
                 xulie_qiefuhe=zeros(1,TTR+1);
                 xulie_qiguang(1)=0;
                 xulie_qiefuhe(1)=0;
              SOC00=zeros(shu_pingheng,TTR+1);
              SOC00(SOC0,1)=1;
                 E_f=zeros(1,TTR);
                 p_h1=zeros(1,TTR);
                 p_h2=zeros(1,TTR);
                 p_h3=zeros(1,TTR);
                 p_h4=zeros(1,TTR);
                 p_g1=zeros(1,TTR);
                 jishu1=zeros(shu_pingheng+1,shu_pingheng+1,TTR);
              for tt=1:TTR  %%一小时一小时判断
                [L_m,L_n] =find([L2,L3,L4,L5,L6]==tt);
                [G_m,G_n] =find([G2,G3,G4,G5,G6]==tt);
              
               if xulie_qiefuhe(tt)+1<size(QL,1)
              if isempty(L_m) %%此时段持续上时段负荷序列
                    xulie_qiefuhe(tt+1)=xulie_qiefuhe(tt);
              else%%序列发生了变化
                    xulie_qiefuhe(tt+1)=max(L_n);
              end
              if isempty(G_m) %%此时段持续上时段电源序列
                    xulie_qiguang(tt+1)=xulie_qiguang(tt);
              else%%序列发生了变化
                    xulie_qiguang(tt+1)=max(G_n);
              end
             [m0,n0]=find(qie_L(:,:,tt,xulie_qiefuhe(tt)+1,xulie_qiguang(tt)+1)==xulie_qiefuhe(tt+1)+1);
             m1=[];
             n1=[];
             kk=1; 
             if ~isempty(n0)
           for shu=1:length(n0)     
             if qie_G(m0(shu),n0(shu),tt,xulie_qiefuhe(tt)+1,xulie_qiguang(tt)+1)==xulie_qiguang(tt+1)+1
             m1(kk)=m0(shu);
             n1(kk)=n0(shu);
             kk=kk+1;
             end
           end
           if kk>1
              for shu=1:kk-1 
                 gailvJI=1;
                  for i=1:length(PV)-1%%一定注意别把PV=0和柴油机的考虑在内
                      if QG(xulie_qiguang(tt)+1,i+1)==0
                  if state_GP(i,m1(shu))>1
                      gailvJI=gailvJI*pv_state(i,state_GP(i,m1(shu)),tt);
                  else
                       gailvJI=0;
                   end
                      elseif  QG(xulie_qiguang(tt)+1,i+1)==1
                        if  state_GP(i,m1(shu))~=1
                       gailvJI=0;            
                        end
                      end
                  end
                if QG(xulie_qiguang(tt)+1,5)==0
                    if  state_GP(4,m1(shu))~=2
                        gailvJI=0;
                    
                    end
                elseif  QG(xulie_qiguang(tt)+1,5)==1
                    if  state_GP(4,m1(shu))~=1
                      gailvJI=0 ; 
                    end              
                end
                ES_tang=1;  
                for i=1:size(state_ES,1)-1
                     if ES(i)==0&&state_ES(i+1,n1(shu))~=1
                        ES_tang=0;
                     elseif ES(i)~=0&&state_ES(i+1,n1(shu))==1
                        ES_tang=0; 
                     end
                end
                if ES_tang==1
                gailvJI=gailvJI*SOC00(n1(shu),tt);
                else
                gailvJI=0;       
                end
                 if MSOC(m1(shu),n1(shu),tt,xulie_qiefuhe(tt+1)+1,xulie_qiguang(tt+1)+1)~=10^10
                  if gailvJI>0
                     jishu1(n1(shu)+1,1+MSOC(m1(shu),n1(shu),tt,xulie_qiefuhe(tt+1)+1,xulie_qiguang(tt+1)+1),tt)=...
                     jishu1(n1(shu)+1,1+MSOC(m1(shu),n1(shu),tt,xulie_qiefuhe(tt+1)+1,xulie_qiguang(tt+1)+1),tt)+gailvJI/SOC00(n1(shu),tt);
                 end
                     if MSOC(m1(shu),n1(shu),tt,xulie_qiefuhe(tt+1)+1,xulie_qiguang(tt+1)+1)~=0
                SOC00(MSOC(m1(shu),n1(shu),tt,xulie_qiefuhe(tt+1)+1,xulie_qiguang(tt+1)+1),tt+1)=...
                 SOC00(MSOC(m1(shu),n1(shu),tt,xulie_qiefuhe(tt+1)+1,xulie_qiguang(tt+1)+1),tt+1)+gailvJI;
                     else                        
                      SOC00(n1(shu),tt+1)= SOC00(n1(shu),tt+1)+gailvJI;              
                     end
                 end
              end
           end
             end             
              if   QG(xulie_qiguang(tt+1)+1,1)==1
                   E_f(tt) =0;
              else
                  E_f(tt) = huifu(fuheshu,QL(xulie_qiefuhe(tt+1)+1,:)-QL(1,:));
               end
                   if xulie_qiefuhe(tt+1)+1>1
                     p_h1(tt) =1;
                   end
                   if QL(xulie_qiefuhe(tt+1)+1,1)~=1
                   if sum(QG(xulie_qiguang(tt+1)+1,2:4).*PV00(1:3))>=0.5*sum(PV00(1:3))
                     p_h2(tt) =1;
                   end
                   else
                     p_h2(tt) =1;
                   end 

                   if QG(xulie_qiguang(tt+1)+1,5)==0&&QL(xulie_qiefuhe(tt+1)+1,1)~=1
                     p_h4(tt) =1;
                   end
                   if QG(xulie_qiguang(tt+1)+1,1)==1||QL(xulie_qiefuhe(tt+1)+1,1)==1
                     p_g1(tt) =1;
                   end
               else
           xulie_qiefuhe(tt+1)=xulie_qiefuhe(tt);
           xulie_qiguang(tt+1)=xulie_qiguang(tt);   
                 E_f(tt)=0;
                 if tt>1
                 p_h1(tt)=p_h1(tt-1);
                 p_h2(tt)=p_h2(tt-1);
                 p_h3(tt)=p_h3(tt-1);
                 p_h4(tt)=p_h4(tt-1);
                 p_g1(tt)=p_g1(tt-1);
                 end
                 SOC00(:,tt+1)= SOC00(:,tt);
               end
              end
              zong_gailvJI(jishu)=sum(SOC00(:,TTR+1));
             if zong_gailvJI(jishu)>0
             [kk10,xxx]=ph3_new(TTR,jishu1,zong_gailvJI(jishu),state_ES,xxx);
             kk1=kk1+kk10-1;
             E_f0(jishu)=sum(E_f)*zong_gailvJI(jishu);
             p_h10(jishu)=(1-prod(ones(1,TTR)-p_h1))*zong_gailvJI(jishu);
             p_h20(jishu)=(1-prod(ones(1,TTR)-p_h2))*zong_gailvJI(jishu);
             p_h30(jishu)=(1-prod(ones(1,TTR)-p_h3))*zong_gailvJI(jishu);
             p_h40(jishu)=(1-prod(ones(1,TTR)-p_h4))*zong_gailvJI(jishu);
             p_g10(jishu)=(1-prod(ones(1,TTR)-p_g1))*zong_gailvJI(jishu);
             jishu=jishu+1;
             end
                 end
               end
               end
               end
               end
               end
               end
               end
               end
               end
               end
        mubiao=zeros(1,1);
       fengxian=zeros(5,1);
       p_h30=zeros(1,kk1);
               p_h3=zeros(TTR,kk1);
               if kk1>0                
     for j=1:kk1
        for i=1:TTR
          if xxx(size(xxx,1)-j+1,i)~=0
            if xxx(size(xxx,1)-j+1,i)/(ES_pingheng/duan_ES)>=...
         0.8||xxx(size(xxx,1)-j+1,i)/(ES_pingheng/duan_ES)<=0.2
           p_h3(i,j)=1;
            end    
          end
        end
        p_h30(j)=(1-prod(ones(TTR,1)-p_h3(:,j)));
        fengxian(3)= fengxian(3)+p_h30(j)*xxx(size(xxx,1)-j+1,TTR+1)/...
            sum(xxx(size(xxx,1)-kk1+1:size(xxx,1),TTR+1));
     end  

               end

                 for i=1:jishu-1%%负荷序列2的初始时刻
                  mubiao=mubiao+E_f0(i)/sum(zong_gailvJI);
                fengxian(1)=fengxian(1)+p_h10(i)/sum(zong_gailvJI);
                fengxian(2)=fengxian(2)+p_h20(i)/sum(zong_gailvJI);
                fengxian(4)=fengxian(4)+p_h40(i)/sum(zong_gailvJI);
                fengxian(5)=fengxian(5)+p_g10(i)/sum(zong_gailvJI);
                 end
