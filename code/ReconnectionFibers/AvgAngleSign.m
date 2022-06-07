function [ moyenne_angle_first_point, Cadr] = AvgAngleSign( Angle, RowFirst,ColFirst, Rows_En,Cols_En, Extensions_labelized_crop)
%compute the average orientation around an extrem node



 moyenne_angle_first_point = 0;
 testang  = [];
 count_fiber = 0;
Extension_SignX = 0;
Extension_SignY = 0;
%  
 for SignX = [-2,-1,0, 1,2] % go through the whole 8 neighbours
        for SignY = [-2,-1,0, 1,2]  

        if SignX == 0 && SignY == 0
            continue
        end
        Row_point_end = RowFirst + SignX;
        Col_point_end = ColFirst + SignY;
        
        if Row_point_end > 0 && Row_point_end <= Rows_En && Col_point_end > 0 && Col_point_end <= Cols_En
            
                %index_neighbour = sub2ind([Rows_En, Cols_En], Row_point_end, Col_point_end);
                
               % if (Extensions_labelized_crop(RowsDisk(index_neighbour),ColsDisk(index_neighbour)))
           if (Extensions_labelized_crop(Row_point_end,Col_point_end))
                %if (Extensions_labelized_crop(Rows_En,Cols_En))
                   Extension_SignX = Extension_SignX + SignX;
                   Extension_SignY = Extension_SignY + SignY;
                   count_fiber = count_fiber + 1;
                   moyenne_angle_first_point = moyenne_angle_first_point + Angle(Row_point_end,Col_point_end);
                   %testang = [testang; Angle(Row_point_end,Col_point_end), SignX, SignY];
                   testang = [testang; Angle(Row_point_end,Col_point_end)];
            end

         end
        
        end

 end
 %
 if count_fiber > 0
%      UniqueVal = unique(testang);
%      NbCounts = histc(testang, UniqueVal);
     %moyenne_angle_first_point = min(testang);
     %moyenne_angle_first_point = mean2(testang);
     moyenne_angle_first_point = moyenne_angle_first_point./count_fiber; 
 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%define cadrans (1,2,3,4, anti clockwise)
 
%  if Extension_SignX < 0 
%      if Extension_SignY > 0
%          Cadr = 1;
%      else
%          Cadr = 2;
%          
%      end
%  else
%      if Extension_SignY > 0
%          Cadr = 4;
%      else
%          Cadr = 3;
%          
%      end
%      
%  end


if moyenne_angle_first_point >= 0 && moyenne_angle_first_point <= pi/2
    if Extension_SignY < 0
        if Extension_SignX >= 0
        Cadr = 3;
        else
        Cadr = 2; 
        end
    else
        if Extension_SignX >= 0
        Cadr = 4;
        else
        Cadr = 1;
        end
    end
else
    if Extension_SignY <= 0
        Cadr = 2;
    else
        Cadr = 4;
    end
end
 
 
 

end


