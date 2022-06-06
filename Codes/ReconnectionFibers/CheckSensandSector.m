function [position_last ] = CheckSensandSector(RowFirst,ColFirst, Cadr, linearIndLastPoint )


     position_last = [];           
                 
             for  j = 1: length(linearIndLastPoint)
               % [Row_point,Col_point] = ind2sub(size(Energy), j); %%%take all the element of the Energy crop/Image
               Row_point = La1(j);  Col_point = Lb1(j); 
                %if Row_point ~= RowFirst && Col_point ~= ColFirst

                    % if  moyenne_angle_first_point < 0.5  %%%%% cadr 1 or cadr 3 to check
                                
                                 if Cadr == 1 %%%% cone should point to Cadr 3 or 4
                                      if (Col_point < ColFirst && Row_point > RowFirst)...
                                              || (Col_point > ColFirst && Row_point > RowFirst)
                                         
                                         %tangent_dest = abs(Row_point - RowFirst)/abs(Col_point - ColFirst);
%                                          artang_dest = atan(abs(Row_point - RowFirst)/abs(Col_point - ColFirst));
%                                          if artang_dest < 0
%                                              artang_dest = artang_dest + pi;
%                                          end
                                             
                                         
                                        % if artang_dest < AngleGamma2 && artang_dest > AngleGamma1
                                             [~, posit] = ismember(j, linearIndLastPoint); 
                                             %position_last = [position_last; posit];
                                             position_last = [position_last; j];
                                         %end
                                      end
                                      
                                 
                                 else %%% Cadr should be 3 and cone should point to Cadr 1 or 4
                                     if Cadr ==3
                                     if (Col_point > ColFirst && Row_point < RowFirst)...
                                          || ( Col_point > ColFirst && Row_point > RowFirst)
%                                              artang_dest = atan(abs(Row_point - RowFirst)/abs(Col_point - ColFirst));
%                                              if artang_dest < 0
%                                                  artang_dest = artang_dest + pi;
%                                              end


%                                              if artang_dest < AngleGamma2 && artang_dest > AngleGamma1
%                                                  [~, posit] = ismember(j, linearIndLastPoint); 
%                                                  %position_last = [position_last; posit];
%                                                  position_last = [position_last; j];
%                                              end
                                     end
                                 end

                                 end

                     %else %%%% cadr 2 or cadr 4
                                 if Cadr == 2 %%%% cone should point to Cadr 4 or 3
                                     %Cadr
                                      if (Col_point > ColFirst && Row_point > RowFirst)...
                                              || (Col_point < ColFirst && Row_point > RowFirst)
                                              
%                                              artang_dest = atan(abs(Row_point - RowFirst)/abs(Col_point - ColFirst));
%                                              if artang_dest < 0
%                                                  artang_dest = artang_dest + pi;
%                                              end

% 
%                                              if artang_dest < AngleGamma2 && artang_dest > AngleGamma1
%                                                  [~, posit] = ismember(j, linearIndLastPoint); 
%                                                  %position_last = [position_last; posit];
%                                                  position_last = [position_last; j];
%                                              end
                                      end


                                 else %%% Cadr should be 4 and cone should point to Cadr 2 or 1
                                      if (Col_point < ColFirst && Row_point < RowFirst)...
                                              || (Col_point > ColFirst && Row_point < RowFirst)
%                                                  artang_dest = atan(abs(Row_point - RowFirst)/abs(Col_point - ColFirst));
%                                              if artang_dest < 0
%                                                  artang_dest = artang_dest + pi;
%                                              end


%                                              if artang_dest < AngleGamma2 && artang_dest > AngleGamma1
%                                                  [~, posit] = ismember(j, linearIndLastPoint); 
%                                                  %position_last = [position_last; posit];
%                                                  position_last = [position_last; j];
%                                              end
                                      end


                                 end

                    % end
                    
                %else   %%%%% 
                    
                    
                    
                    
              %  end 
                                 
             end


end

