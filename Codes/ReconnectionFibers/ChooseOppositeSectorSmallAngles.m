

function [opposite_sector_smallangles ] = ChooseOppositeSectorSmallAngles(Cadr,MeshAllCols, indic_sector )


    opposite_sector_smallangles = zeros (size(indic_sector));      
                 
                        
                                
             if Cadr == 1 %%%% cone should point to Cadr 3 or 4

                opposite_sector_smallangles (MeshAllCols < 0)=1;

             else %%% Cadr should be 3 and cone should point to Cadr 1 or 4
                 if Cadr ==3

                opposite_sector_smallangles (MeshAllCols > 0)=1;
                 end
             end

 %else %%%% cadr 2 or cadr 4
             if Cadr == 2 %%%% cone should point to Cadr 4 or 3
  
             opposite_sector_smallangles (MeshAllCols > 0)=1;                              


             else %%% Cadr should be 4 and cone should point to Cadr 2 or 1

              if Cadr == 4
              opposite_sector_smallangles (MeshAllCols < 0)=1;
              end

             end

                
                                 
          


end

