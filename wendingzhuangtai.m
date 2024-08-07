%%生成不同源荷状态下各类序列的稳定序列情况
function [qie_L,qie_G]=wendingzhuangtai(MPS,shu_pingheng,shu_NP,t,TTR,qie_QL0,qie_QG0,QL,QG)  
qie_L=zeros(shu_NP,shu_pingheng,TTR);
qie_G=zeros(shu_NP,shu_pingheng,TTR);
    for i=1:shu_NP
          for j=1:shu_pingheng
              for k=t:t+TTR-1

                  qie_QG=qie_QG0;
                  qie_QL=qie_QL0;
                  if qie_QL==size(QL,1)||qie_QG==size(QG,1)
                  qie_L(i,j,k-t+1)=qie_QG;
                  qie_G(i,j,k-t+1)=qie_QL;
                  else
                  shengyugonglv=MPS(i,j,k-t+1,qie_QL,qie_QG);
                  if shengyugonglv~=10^10%%包含重复项和不收敛项
                  while(shengyugonglv~=0)
                  if shengyugonglv>0%%储能吸收不了剩余功率，则切柴油机后切光伏,,按从后往前顺序切
                       qie_QG=qie_QG+1;
                   if  qie_QG==size(QG,1)
                        shengyugonglv=0;
                   else
                             if MPS(i,j,k-t+1,qie_QL,qie_QG)~=10^10
                              shengyugonglv=MPS(i,j,k-t+1,qie_QL,qie_QG);
                             else
                        qie_L=10^10;
                        qie_G=10^10;
                        shengyugonglv=0;
                             end
                   end
                       
                  elseif shengyugonglv<0%%储能补足不了剩余，则切负荷,按从后往前顺序切
                        qie_QL=qie_QL+1;
                         if  qie_QL==size(QL,1)
                        shengyugonglv=0;
                         else
                             if MPS(i,j,k-t+1,qie_QL,qie_QG)~=10^10
                              shengyugonglv=MPS(i,j,k-t+1,qie_QL,qie_QG);
                             else
                        qie_L=10^10;
                        qie_G=10^10;
                        shengyugonglv=0;
                             end
                         end                  
                  end
                
                  end
                 
                  qie_L(i,j,k-t+1)=qie_QL;
                  qie_G(i,j,k-t+1)=qie_QG;
                  else
                   qie_L(i,j,k-t+1)=10^10;
                  qie_G(i,j,k-t+1)=10^10;
                  end
                  end
              end
          end
    end
