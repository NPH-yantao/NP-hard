 haoshi1=clock;
 [mubiao(fangan),fengxian(:,fangan),xxx]=bianlijisuan(TTR,ES_pingheng,duan_ES,MSOC,pv_state,state_GP,...
    QL,QG,qie_L,qie_G,fuheshu,PV,PV00,SOC0,SOC1,SOC2,SOC3,shu_NP,state_ES,ES,xxx);
xxx=[xxx;zeros(1,TTR+1)];
%%统计仿真时间2
haoshi2=clock;
simulation(fangan)=etime(haoshi2,haoshi1);
%  format long
 jieguo=[roundn(simulation,-2); roundn(mubiao,-2); roundn(fengxian*100,-2)];