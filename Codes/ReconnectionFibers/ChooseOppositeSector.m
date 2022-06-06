

function [opposite_sector ] = ChooseOppositeSector(Cadr,MeshAllRows,MeshAllCols, indic_sector )


    opposite_sector = zeros (size(indic_sector));      
                 
                        
                                
             if Cadr == 1 %%%% cone should point to Cadr 3 or 4
%                   if (Col_point < ColFirst && Row_point > RowFirst)...
%                           || (Col_point > ColFirst && Row_point > RowFirst)
% 
% 
%                   end
                %opposite_sector (MeshAllRows > 0)=1;
                opposite_sector (MeshAllRows > 0 & MeshAllCols < 0)=1;

             else %%% Cadr should be 3 and cone should point to Cadr 1 or 4
                 if Cadr ==3
%                  if (Col_point > ColFirst && Row_point < RowFirst)...
%                       || ( Col_point > ColFirst && Row_point > RowFirst)
% %                                             
%                  end
                 opposite_sector (MeshAllRows < 0 & MeshAllCols > 0)=1;
                  %opposite_sector (MeshAllCols > 0)=1;
                 end
             end

 %else %%%% cadr 2 or cadr 4
             if Cadr == 2 %%%% cone should point to Cadr 4 or 3
                 %Cadr
%                   if (Col_point > ColFirst && Row_point > RowFirst)...
%                           || (Col_point < ColFirst && Row_point > RowFirst)
% 
             opposite_sector (MeshAllRows > 0 & MeshAllCols > 0)=1;                              
%                   end


             else %%% Cadr should be 4 and cone should point to Cadr 2 or 1
%                   if (Col_point < ColFirst && Row_point < RowFirst)...
%                           || (Col_point > ColFirst && Row_point < RowFirst)
% %                                              
%                   end
              if Cadr == 4
              opposite_sector (MeshAllRows < 0 & MeshAllCols < 0)=1;
              end

             end

                
                                 
          


end

