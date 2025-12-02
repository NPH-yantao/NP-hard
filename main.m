clear
%%optional parameters 
solution=2;%% 1/2/3/4, respectively correspond to four initial solutions
search=1;%%1/2, respectively correspond to AB and AG
grouping_rule=2;%%0/1/2, respectively correspond to initial grouping rule,re-grouping rule and secondary re-grouping rule

%%basic parameters 
clock=2;%%number of clocks
duan=2;%%state number of E~G 
max_EJ=ones(1,6);%%MAX value of E~J  
max_CD=[1];%%MAX value of C~D  
if grouping_rule==2
 rgr=[1 0 0 0 0 6;0 2 0 0 0 6;0 0 3 0 0 6];
elseif grouping_rule==1
 rgr=[1 0 0 0 0 0;0 2 0 0 0 0;0 0 3 0 0 0;0 0 0 4 0 0;0 0 0 0 5 0;0 0 0 0 0 6];
end
state_AB=[0 0 0 0; 0 0 0 1;0 0 1 1;0 1 1 1;1 1 1 1];%%state of A or B
number_state_C=3;%%the state of C in first clock is always [0.5,1]

results_KN=[];
pro_EJ=zeros(size(max_EJ,2),duan,clock);
for i=1:length(max_EJ)
    if max_EJ(i)~=0
buqueding(i)=duan;
pro_EJ(i,:,:)=1/duan;
    else
buqueding(i)=0;
pro_EJ(i,:,:)=NaN;
    end
end
number_state_EJ=[buqueding(1:3) buqueding(4:6)+ones(1,3)];
if solution==1
    load('DFT_1.mat');
    DFT=M_WS;
     max_EJ(4:6)=0;
     state_AB(1:3,:)=[];
     number_state_EJ(4:6)=1;
     if size(rgr,1)>3
       rgr(4:size(rgr,1),:)=[];
     end
     rgr(:,4:size(rgr,2))=0;
elseif solution==2
    load('DFT_2.mat');
     DFT=M_WS;
     max_EJ(5:6)=0;
     state_AB(1:2,:)=[];
     number_state_EJ(5:6)=1;
    if size(rgr,1)>4
     rgr(5:size(rgr,1),:)=[];
    end
     rgr(:,5:size(rgr,2))=0;
elseif solution==3
    load('DFT_3.mat');
    DFT=M_WS;
     max_EJ(6)=0;
     state_AB(1,:)=[];
     number_state_EJ(6)=1;
     if size(rgr,1)>5
        rgr(6:size(rgr,1),:)=[];
     end
     rgr(:,6:size(rgr,2))=0;
else
    load('DFT_4.mat');
    DFT=M_WS;
end
number_state_A=size(state_AB,1);
N_AB=(number_state_A+1)*number_state_A/2-1;
[~,Seq_state_EJ,Seq_state_CD]=Initialization(state_AB,number_state_EJ,...
    number_state_C,N_AB,max_EJ,number_state_A,max_CD);
jishu=0;
    tongji=zeros(prod(number_state_EJ),number_state_C,number_state_A-1);
for  i=number_state_A:-1:2
    for j=i:-1:1
        for k=1:number_state_C
       tongji(:,:,i-1)=tongji(:,:,i-1)+DFT(:,:,jishu+j,k,1);
        end
    end
       jishu=jishu+i;          
end
jishu=0;
pro_CD=zeros(prod(number_state_EJ),number_state_C,N_AB,number_state_C);
for  i=number_state_A:-1:2
    for j=i:-1:1
        for k=1:number_state_C
           pro_CD(:,:,jishu+j,k)=DFT(:,:,jishu+j,k)./tongji(:,:,i-1);
        end
    end
       jishu=jishu+i;          
end
   [sign_error]=group_error(Seq_state_EJ,clock,number_state_A,number_state_C,DFT,pro_EJ,rgr); 

if grouping_rule==0
   da1(1)=datetime('now');
  if search==2
    [mubiao,fengxian]=AG(pro_EJ,number_state_C,clock,number_state_A,N_AB,...
     Seq_state_EJ,Seq_state_CD,DFT,pro_CD,number_state_EJ);
  else
    [mubiao,fengxian]=AB(pro_EJ,number_state_C,clock,number_state_A,number_state_C,...
     Seq_state_EJ,Seq_state_CD,DFT,pro_CD,number_state_EJ,state_AB);
  end
  da1(2)=datetime('now');
  results_KN=[results_KN;mubiao,fengxian(1,1:3),seconds(da1(2)-da1(1))];
else
for rule=1:size(rgr,1)
KONG=rgr(rule,:);
KONG(KONG==0)=[];
number_state_EJ1=number_state_EJ;
pro_EJ1=pro_EJ;
for zuhe=1:size(KONG,2)
     if KONG(zuhe)>3
     number_state_EJ1(KONG(zuhe))=2; 
     pro_EJ1(KONG(zuhe),1,1:clock)=1;
     pro_EJ1(KONG(zuhe),2:2,1:clock)=0;
     else
     number_state_EJ1(KONG(zuhe))=1;
     pro_EJ1(KONG(zuhe),1,1:clock)=1;
     pro_EJ1(KONG(zuhe),2:2,1:clock)=0;
     end
end
   [new_DFT,Seq_state_EJ1,Seq_state_CD1]=Initialization(state_AB,number_state_EJ1,...
       number_state_C,N_AB,max_EJ,number_state_A,max_CD);
jishu=0;
for  i=number_state_A:-1:2
  for i1=i:-1:1
   for i2=1:number_state_C      
   [hang,lie]=find(DFT(:,:,jishu+i1,i2,1)>0);
   if ~isempty(hang)
    for j=1:length(hang)
        B=Seq_state_EJ(:,hang(j));
        for zuhe=1:size(KONG,2)
                  if KONG(zuhe)>3
                      if B(KONG(zuhe))>1
                        B(KONG(zuhe))=2;
                      end
                  else
                      B(KONG(zuhe))=1;   
                  end
        end
   k = find(~any(Seq_state_EJ1-B)); 
         new_DFT(k,lie(j),jishu+i1,i2,1)=new_DFT(k,lie(j),jishu+i1,i2,1)+...
             DFT(hang(j),lie(j),jishu+i1,i2,1);
         new_DFT(k,lie(j),jishu+i1,i2,1+1)=new_DFT(k,lie(j),jishu+i1,i2,1+1)+...
             DFT(hang(j),lie(j),jishu+i1,i2,1+1);
         new_DFT(k,lie(j),jishu+i1,i2,1+2)=new_DFT(k,lie(j),jishu+i1,i2,1+2)+...
             DFT(hang(j),lie(j),jishu+i1,i2,1+2);
         new_DFT(k,lie(j),jishu+i1,i2,1+3)=new_DFT(k,lie(j),jishu+i1,i2,1+3)+...
             DFT(hang(j),lie(j),jishu+i1,i2,1+3);
         new_DFT(k,lie(j),jishu+i1,i2,1+4)=new_DFT(k,lie(j),jishu+i1,i2,1+4)+...
             DFT(hang(j),lie(j),jishu+i1,i2,1+4);
         new_DFT(k,lie(j),jishu+i1,i2,1+5)=new_DFT(k,lie(j),jishu+i1,i2,1+5)+...
             DFT(hang(j),lie(j),jishu+i1,i2,1+5);
         new_DFT(k,lie(j),jishu+i1,i2,1+6)=new_DFT(k,lie(j),jishu+i1,i2,1+6)+...
             DFT(hang(j),lie(j),jishu+i1,i2,1+6);
    end
   end    
   end
  end
  jishu=jishu+i; 
end
jishu=0;
    tongji=zeros(prod(number_state_EJ1),number_state_C,number_state_A-1);
for  i=number_state_A:-1:2
    for j=i:-1:1
        for k=1:number_state_C
       tongji(:,:,i-1)=tongji(:,:,i-1)+new_DFT(:,:,jishu+j,k,1);
        end
    end
       jishu=jishu+i;          
end
jishu=0;
pro_CD=zeros(prod(number_state_EJ1),number_state_C,N_AB,number_state_C);
for  i=number_state_A:-1:2
    ji=0;
    for j=i:-1:1
        for k=1:number_state_C
       pro_CD(:,:,jishu+j,k)=new_DFT(:,:,jishu+j,k,1)./tongji(:,:,i-1);
       ji=ji+pro_CD(:,:,jishu+j,k);
        end
    end
       jishu=jishu+i;          
end
da2(1)=datetime('now');
  if search==2
    [mubiao,fengxian]=AG(pro_EJ1,number_state_C,clock,number_state_A,N_AB,...
     Seq_state_EJ1,Seq_state_CD1,new_DFT,pro_CD,number_state_EJ1);
  else
    [mubiao,fengxian]=AB(pro_EJ1,number_state_C,clock,number_state_A,number_state_C,...
     Seq_state_EJ1,Seq_state_CD1,new_DFT,pro_CD,number_state_EJ1,state_AB);
  end
da2(2)=datetime('now');
results_KN=[results_KN;mubiao,fengxian(1,1:3),seconds(da2(2)-da2(1))];
end
end


