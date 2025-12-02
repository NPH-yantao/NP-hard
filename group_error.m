
function  [sign_error]=group_error(state_GP,TTR,...
    N_ZY0,N_HV0,M_WS,yuce,KONG0)
fangxiang=zeros(5,size(KONG0,1));
cuowu=zeros(5,size(KONG0,1));
jilu=[];
   for i=1:size(KONG0,1)
       linshi_state_GP= state_GP;
       for j=1:length(KONG0(i,:))
         if KONG0(i,j)>0  
          if KONG0(i,j)>3  
           [~,lie]=find(linshi_state_GP(KONG0(i,j),:)>2);
           if ~isempty(lie)
            linshi_state_GP(KONG0(i,j),lie)=2;
           end
          else
           [~,lie]=find(linshi_state_GP(KONG0(i,j),:)>1);
           if ~isempty(lie)
            linshi_state_GP(KONG0(i,j),lie)=1;
           end
          end
         end
       end
       linshi_state_GP0=zeros(size(state_GP,1),size(state_GP,2),N_ZY0);
       for j=2:N_ZY0
        linshi_state_GP1=linshi_state_GP;
        if  j<N_ZY0
          linshi_state_GP1(j+2:size(state_GP,1),:)=1;
        end
        linshi_state_GP0(:,:,j)=linshi_state_GP1;
       end
       linshi_state_GP=linshi_state_GP0;
       total=zeros(1,length(KONG0(i,:)));
       jinsi2=zeros(N_ZY0,length(KONG0(i,:)));
      for ii=2:N_ZY0
          for jj=1:length(KONG0(i,:))
              if KONG0(i,jj)>0&&KONG0(i,jj)<4 
       [~,jinsi20]=find(linshi_state_GP(KONG0(i,jj),:,ii)==1);
       total(jj)=total(jj)+length(jinsi20);
       if ~isempty(jinsi20)
          jinsi2(ii,jj)=jinsi20(1);
       end
              elseif KONG0(i,jj)>3&&KONG0(i,jj)<7
       [~,jinsi20]=find(linshi_state_GP(KONG0(i,jj),:,ii)==2);
       total(jj)=total(jj)+length(jinsi20);
       if ~isempty(jinsi20)
          jinsi2(ii,jj)=jinsi20(1);
       end
              end
          end
      end
       while  sum(total)>0            
               jishu=0;
    for  i0=N_ZY0:-1:2
        if sum(jinsi2(i0,:))>0
           shou=find(jinsi2(i0,:)>0);
           Ind= find(sum(abs(linshi_state_GP(:,:,i0)-linshi_state_GP0(:,jinsi2(i0,shou(1)),i0)))==0);
        end
           if length(Ind)>1
                  for t=1:TTR
                      for j0=i0:-1:1
                           for k0=1:N_HV0
                               for l0=1:N_HV0
                                   tongji=nan(1,size(cuowu,1));
                                 if sum(M_WS(Ind,l0,jishu+j0,k0,1))>0
                                     tongji=zeros(1,size(cuowu,1));
                                     chongfu_shijian=ones(1,length(Ind));
                                         for m0=1:length(Ind)
                                                 if M_WS(Ind(m0),l0,jishu+j0,k0,1)>0
                                                     for  j=1:length(KONG0(i,:))
                                                           if KONG0(i,j)>3&&linshi_state_GP(KONG0(i,j),Ind(m0),i0)>1
                                                         chongfu_shijian(m0)=chongfu_shijian(m0)*yuce(KONG0(i,j),state_GP(KONG0(i,j),Ind(m0))-1,t);  
                                                           elseif KONG0(i,j)<=3&&KONG0(i,j)>0
                                                         chongfu_shijian(m0)=chongfu_shijian(m0)*yuce(KONG0(i,j),state_GP(KONG0(i,j),Ind(m0)),t);  
                                                           end
                                                     end
                                                 end
                                         end
                                    for ms=1:size(cuowu,1)
                                         for m0=1:length(Ind)
                                             if M_WS(Ind(m0),l0,jishu+j0,k0,1)>0
                                               tongji(ms)=tongji(ms)+chongfu_shijian(m0)/sum(chongfu_shijian)...
                                              *M_WS(Ind(m0),l0,jishu+j0,k0,ms+1)/M_WS(Ind(m0),l0,jishu+j0,k0,1); 
                                              end
                                          end
                                   end
                                 end
                              if  ~isnan(tongji(1))
                                 for ms=1:size(cuowu,1)
                                  if tongji(ms)>sum(M_WS(Ind,l0,jishu+j0,k0,ms+1))...
                                     /sum(M_WS(Ind,l0,jishu+j0,k0,1))&&fangxiang(ms,i)<=0
                                     fangxiang(ms,i)=-1;
                                  elseif tongji(ms)>sum(M_WS(Ind,l0,jishu+j0,k0,ms+1))...
                                     /sum(M_WS(Ind,l0,jishu+j0,k0,1))&&fangxiang(ms,i)>0
                                     cuowu(ms,i)=1;
                                  elseif tongji(ms)<sum(M_WS(Ind,l0,jishu+j0,k0,ms+1))...
                                     /sum(M_WS(Ind,l0,jishu+j0,k0,1))&&fangxiang(ms,i)>=0
                                     fangxiang(ms,i)=1;
                                  elseif tongji(ms)<sum(M_WS(Ind,l0,jishu+j0,k0,ms+1))...
                                     /sum(M_WS(Ind,l0,jishu+j0,k0,1))&&fangxiang(ms,i)<0
                                     cuowu(ms,i)=1;
                                  end
                                 end
                               end
                               end
                           end
                      end
                  end
                linshi_state_GP0(:,Ind,i0)=0;
           else
                linshi_state_GP0(:,Ind,i0)=0;
           end
                  jishu=jishu+i0;    
    end         
       total=zeros(1,length(KONG0(i,:)));
       jinsi2=zeros(N_ZY0,length(KONG0(i,:)));
      for ii=2:N_ZY0
          for jj=1:length(KONG0(i,:))
              if KONG0(i,jj)>0&&KONG0(i,jj)<4 
       [~,jinsi20]=find(linshi_state_GP0(KONG0(i,jj),:,ii)==1);
       total(jj)=total(jj)+length(jinsi20);
       if ~isempty(jinsi20)
          jinsi2(ii,jj)=jinsi20(1);
       end
              elseif KONG0(i,jj)>3&&KONG0(i,jj)<7
       [~,jinsi20]=find(linshi_state_GP0(KONG0(i,jj),:,ii)==2);
       total(jj)=total(jj)+length(jinsi20);
       if ~isempty(jinsi20)
          jinsi2(ii,jj)=jinsi20(1);
       end
              end
          end
      end
       end
   end

for i=2:4
    for j=1:size(cuowu,2)
        if  cuowu(i-1,j)>0
            sign_error(j,i-1)="N";
        else 
           if fangxiang(i,j)==0
              sign_error(j,i-1)="Y";
           else
            if i==2&& fangxiang(i,j)==1
                sign_error(j,i-1)="Y";
            elseif i==3&& fangxiang(i,j)==-1
                sign_error(j,i-1)="Y";
            else
                sign_error(j,i-1)="N";
            end
           end
        end
    end
end