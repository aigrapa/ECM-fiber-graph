function [ MatrixA] = FillCostMatrix(RowsDisk,ColsDisk, Energy,DilatedSkelWExtrem, linearIndLastPoint)

  MatrixA = zeros([length(RowsDisk), length(RowsDisk)]); 
  
            for j = 1:size(MatrixA,1) 

                [Row_point_start,Col_point_start] = ind2sub(size(Energy), j); %%%take all the element of the Energy crop/Image

                            for SignX = [-1,0, 1] % go through the whole 8 neighbours
                                for SignY = [-1,0, 1]                                    
                                        if SignX ==0 && SignY ==0 %%% avoid considering the element itself
                                            continue %%%passes control to the next iteration of for,enclosing it
                                        end

                                        Row_point_end = Row_point_start + SignX;
                                        Col_point_end = Col_point_start + SignY;

                                        if Row_point_end > 0 && Row_point_end <= size(Energy,1) && Col_point_end > 0 && Col_point_end <= size(Energy,2) %%check that I'm within borders
                                            index_neighbour = sub2ind(size(Energy), Row_point_end, Col_point_end);

                                            weight = Energy(RowsDisk(index_neighbour),ColsDisk(index_neighbour)); 



                                             if (DilatedSkelWExtrem(RowsDisk(index_neighbour),ColsDisk(index_neighbour)) && ~ismember( index_neighbour,linearIndLastPoint))

                                                 weight = 500;
                                            end
                                         
                                            cost = weight;
                                           %                                            
                                            if ~isinf(cost) %%%% if the weight is noninfinite meaning tha(Extensions_labelized_crop(RowsDisk(index_neighbour),ColsDisk(index_neighbour)))t it corresponds to the research area defined by the radius

                                                   MatrixA(j,index_neighbour) = cost;
                                                  %end
                                            end
                                                %  end
                                        end                                    
                                end
                            end

             end



end

