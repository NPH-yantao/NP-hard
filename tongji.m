function [tongji0,chongfu]=tongji(A,B,QL,QG,TTR,tongji0,chongfu)

if A(1,size(QL,1)-1)<TTR+1||B(1,size(QG,1)-1)<TTR+1
    if A(1,size(QL,1)-1)<B(1,size(QG,1)-1)%%先切负荷完
       B(B>A(1,size(QL,1)-1))=TTR+1;
    elseif A(1,size(QL,1)-1)>B(1,size(QG,1)-1)
       A(A>B(1,size(QG,1)-1))=TTR+1;
    end
end
tongji0(A(1),A(2),A(3),A(4),A(5),B(1),B(2),B(3),B(4),B(5))=...
  tongji0(A(1),A(2),A(3),A(4),A(5),B(1),B(2),B(3),B(4),B(5))+1;
if tongji0(A(1),A(2),A(3),A(4),A(5),B(1),B(2),B(3),B(4),B(5))==1
   chongfu=1;
end