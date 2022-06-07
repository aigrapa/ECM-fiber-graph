function [ indic_from_dest ] = ChoosePerpendicularSector( MeshAllRows,MeshAllCols, indic_from_dest,moyenne_angle_first_point, CoordExNode, AngleDelta,crow, ccol )
%%%%%%%%%%%%%% you do not normally pass through ChooseConeSector beacuse there is no need for you to compute
%%%%%%%the average orientation or the Cadran 
%%%%%%%%%%%%%%%%%%%%%%%%%%%build perpendicularsector(should work for
%%%%%%%%%%%%%%%%%%%%%%%%%%%AngleDelta < = pi/2,by adding and substractiong
%%%%%%%%%%%%%%%%%%%%%%%%%%%pi/2
          
        AngleGamma1 = mod(moyenne_angle_first_point - AngleDelta +pi/2 ,pi);
        AngleGamma2 = mod(moyenne_angle_first_point + AngleDelta +pi/2,pi);


                ConeSmallAngle = zeros(size(indic_from_dest));
                ConeBigAngle = zeros(size(indic_from_dest));
                
%                 ConeSmallAngle = zeros(size(indic_sector));
%                 ConeBigAngle = zeros(size(indic_sector));
%                 
                MeshAllRowsInv = MeshAllRows;
                MeshAllRowsInv = MeshAllRows.* (-1);
                
                indic_sector = atan2 (MeshAllRowsInv,MeshAllCols);
                indic_sector (MeshAllRowsInv <= 0 & MeshAllCols <= 0) = indic_sector (MeshAllRowsInv <= 0 & MeshAllCols <= 0) +pi;
                indic_sector (MeshAllRowsInv <0 & MeshAllCols > 0) = indic_sector (MeshAllRowsInv <0 & MeshAllCols > 0) +pi;
                
                
                            
                if moyenne_angle_first_point <= AngleDelta || moyenne_angle_first_point >= (pi-AngleDelta) || (moyenne_angle_first_point >= pi/2 -AngleDelta && moyenne_angle_first_point <= pi/2 +AngleDelta)
                  % auxiliary_indices = ones(size(indic_from_dest)); 
                  auxiliary_indices = ones(size(indic_sector)); ConeSmallAngle = auxiliary_indices;
                   auxiliary_indices(indic_sector> min(AngleGamma1, AngleGamma2) & indic_sector < max(AngleGamma1,AngleGamma2)) = zeros;
                  
                   %indic_from_dest = indic_from_dest.* (auxiliary_indices > 0);
                   indic_sector = indic_sector.* (auxiliary_indices > 0);
                   
                   
                   if (moyenne_angle_first_point >= pi/2 -AngleDelta && moyenne_angle_first_point <= pi/2 +AngleDelta)
                       ConeSmallAngle(indic_sector >0) = ConeSmallAngle(indic_sector > 0).*0;
                   else
                       ConeSmallAngle(indic_sector >0) = ConeSmallAngle(indic_sector > 0).*0;
                   ConeSmallAngle(crow,:) = ConeSmallAngle(crow,:).*0;
                   
                   if indic_sector(CoordExNode(1),CoordExNode(2) == 0) %%%%I do not find the starting point on the perpendicular sector, I remove it form the indic_from_dest
                          indic_from_dest(crow, ccol) = 0;
                   end
                   
                   %figure,colormap gray, imagesc (ConeSmallAngle);
                   
                   end
                  % opposite_sector_smallangles  = ChooseOppositeSectorSmallAngles(Cadr,MeshAllCols, indic_sector );
                   %ConeSmallAngle(opposite_sector_smallangles == 0) = 0;
                   %indic = indic.*(opposite_sector_smallangles > 0);
                  % indic_from_dest = indic_from_dest.*(ConeSmallAngle > 0);
                else
                                         
                       ConeBigAngle(indic_sector > min(AngleGamma1, AngleGamma2) & indic_sector < max(AngleGamma1,AngleGamma2)) = 1;
                       indic_sector = indic_sector.* (indic_sector > min(AngleGamma1, AngleGamma2) & indic_sector < max(AngleGamma1,AngleGamma2));                  
                       %opposite_sector  = ChooseOppositeSector(Cadr,MeshAllRows,MeshAllCols, indic_sector );                   
                       %indic = indic.*(opposite_sector > 0);
                       %ConeBigAngle(opposite_sector == 0) = 0;
                      % indic_from_dest = indic_from_dest.*(ConeBigAngle > 0);
                      indic_sector = indic_sector.*(ConeBigAngle > 0);
                      if indic_sector(CoordExNode(1),CoordExNode(2) == 0) %%%%I do not find the starting point on the perpendicular sector, I remove it form the indic_from_dest
                          indic_from_dest(crow, ccol) = 0;
                      end
                      
                      %figure, colormap gray, imagesc (indic_sector);
                   
                    
                end


end

