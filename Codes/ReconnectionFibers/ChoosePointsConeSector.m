function [ indic, ConeSmallAngle, ConeBigAngle ] = ChoosePointsConeSector( MeshAllRows,MeshAllCols, indic,moyenne_angle_first_point, Cadr, AngleDelta, AngleGamma1, AngleGamma2 )
                  
                
                ConeSmallAngle = zeros(size(indic));
                ConeBigAngle = zeros(size(indic));
                
                MeshAllRowsInv = MeshAllRows;
                MeshAllRowsInv = MeshAllRows.* (-1);
                
                indic_sector = atan2 (MeshAllRowsInv,MeshAllCols);
                indic_sector (MeshAllRowsInv <= 0 & MeshAllCols <= 0) = indic_sector (MeshAllRowsInv <= 0 & MeshAllCols <= 0) +pi;
                indic_sector (MeshAllRowsInv <0 & MeshAllCols > 0) = indic_sector (MeshAllRowsInv <0 & MeshAllCols > 0) +pi;
            %    show_sector = zeros(size(indic_sector));
             %   show_sector(indic_sector> min(AngleGamma1, AngleGamma2) & indic_sector < max(AngleGamma1,AngleGamma2)) = 1;
                
                
                            
                if moyenne_angle_first_point <= AngleDelta || moyenne_angle_first_point >= (pi-AngleDelta)
                   auxiliary_indices = ones(size(indic)); 
                   auxiliary_indices(indic_sector> min(AngleGamma1, AngleGamma2) & indic_sector < max(AngleGamma1,AngleGamma2)) = zeros;
                   ConeSmallAngle = auxiliary_indices;
                   indic = indic.* (auxiliary_indices > 0);
                   opposite_sector_smallangles  = ChooseOppositeSectorSmallAngles(Cadr,MeshAllCols, indic_sector );
                   ConeSmallAngle(opposite_sector_smallangles == 0) = 0;
                   %indic = indic.*(opposite_sector_smallangles > 0);
                   indic = indic.*(ConeSmallAngle > 0);
                else
                                         
                       ConeBigAngle(indic_sector > min(AngleGamma1, AngleGamma2) & indic_sector < max(AngleGamma1,AngleGamma2)) = 1;
                       %indic = indic.* (indic_sector > min(AngleGamma1, AngleGamma2) & indic_sector < max(AngleGamma1,AngleGamma2));                  
                       opposite_sector  = ChooseOppositeSector(Cadr,MeshAllRows,MeshAllCols, indic_sector );                   
                       %indic = indic.*(opposite_sector > 0);
                       ConeBigAngle(opposite_sector == 0) = 0;
                       indic = indic.*(ConeBigAngle > 0);
                   
                end



end

