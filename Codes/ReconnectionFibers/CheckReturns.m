function [ indic] = CheckReturns(indic, CoordExNode, AllAngleStart, AllAngleEnd )


%             if ~isempty(find(indic,1))  
%                      [ptx,pty] = ind2sub(size(indic),find(indic>0));
%                         for count = 1: size(ptx,1)
%                                
%                             if (find(Reper_aux == Reper_aux(ptx(count), pty(count))))
%                                 index_anterior = find(Reper_aux == Reper_aux(ptx(count),pty(count)));
%                                  for counter = 1: length (index_anterior)
% 
%                                     [row, col] = ind2sub(size(Reper_aux), index_anterior(counter));
%                                     [existance, IndexRow] = ismember ([row,col],AllAngleStart, 'rows');
%                                     if existance
% 
%                                         rowEnd = AllAngleEnd (IndexRow, 1);
%                                         colEnd = AllAngleEnd (IndexRow, 2);
% 
%                                         if (rowEnd ~=0 && colEnd~=0 && rowEnd ~= -1 && colEnd ~= -1)
%                                             if (Reper_aux(rowEnd,colEnd) == Reper_aux(coord(1), coord(2)))
%                                                 indic(Reper_aux == Reper_aux(row,col)) = 0;
%                                             end
%                                         end
% 
%                                     end
%                                  end
%                             end
%                         end
%             end   
                
            
           if ~isempty(AllAngleEnd)
                if ismember([CoordExNode(1), CoordExNode(2)], AllAngleEnd, 'rows')
                   [~, IndexRow] =  ismember([CoordExNode(1), CoordExNode(2)], AllAngleEnd, 'rows');
                   if indic(AllAngleStart(IndexRow,1), AllAngleStart(IndexRow,2) ) == 1
                      indic(AllAngleStart(IndexRow,1), AllAngleStart(IndexRow,2)) = 0;
                   end

                end
           end
            




end

