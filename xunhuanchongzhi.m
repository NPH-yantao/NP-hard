function     [L2,L3,L4,L5,L6,G2,G3,G4,G5,G6]=xunhuanchongzhi(L2,L3,L4,L5,L6,G2,G3,G4,G5,G6,QL,QG,TTR)
               if size(QL,1)==2
                  L3=TTR+1;
                  L4=TTR+1;
                  L5=TTR+1;
                  L6=TTR+1;
                  
              end
             if size(QL,1)==3
                  L4=TTR+1;
                  L5=TTR+1;
                  L6=TTR+1;
                  
             end
             if size(QL,1)==4
                  L5=TTR+1;
                  L6=TTR+1;
                  
             end
              if size(QL,1)==5
                  L6=TTR+1;
                  
              end
               if size(QG,1)==2
                  G3=TTR+1;
                  G4=TTR+1;
                  G5=TTR+1;
                  G6=TTR+1;
                  
               end
               if size(QG,1)==3
                  G4=TTR+1;
                  G5=TTR+1;
                  G6=TTR+1;
                  
               end
                if size(QG,1)==4
                  G5=TTR+1;
                  G6=TTR+1;
                  
                end
             if size(QG,1)==5
                  G6=TTR+1;
                  
              end