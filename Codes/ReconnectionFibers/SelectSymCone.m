function [ indic ] = SelectSymCone( indic, Extreme_Points, CoordExNode, AngleDelta, OrientationMat, OriginalImage,LabeledComponents, RowsSize, ColsSize, Radius,optionAngleEstimation,moyenne_angle_first_point)

%%%%%%for every candidate from the estination points list, 
%%compute its cone sector depending on the angle in its neighbourhood and
%%the "destinations points" of the destinations points are stored in
%%indic_from_dest.
%%% if the starting point does not exist in indic_from_dest, then the
%%% destination point i(crow, col) will not be considered as a destination


testAngle = zeros(size(indic));


index_candidates = find(indic == 1); %%%% destination list

for i = 1:length(index_candidates)
    [crow, ccol] = ind2sub(size(indic), index_candidates(i));
    AngleStartPoint = OrientationMat (crow, ccol); %%%%% AngleStartPoint of the pixel belonging to the destinationcandidates
    testAngle(crow, ccol) = AngleStartPoint;
    
    CoordDest = [crow ccol];
    RelativeRowSize = [1:RowsSize] - crow;
    RelativeColSize = [1:ColsSize] - ccol; 
    
    [MeshAllRows,MeshAllCols] = ndgrid(RelativeRowSize,RelativeColSize);
    DistanceCard = MeshAllRows.^2+MeshAllCols.^2;  % 
    indic_from_dest = DistanceCard < Radius^2;   
    boolean_sphere = indic_from_dest; 
    
    [ptx,pty] = ind2sub(size(boolean_sphere),find(boolean_sphere>0));  
    RowMaxDisk = max(ptx);  Beta_max = max(pty);  %%%%maximum  CoordExNode x,y   in the whole image                                    
    RowMinDisk = min(ptx);  ColMaxDisk = min(pty);  %%%% min y%%%% min x    in the whole image
    
    Energy = 1./(double(OriginalImage)+1);
    Energy(~boolean_sphere) = Inf;
    Energy = Energy(RowMinDisk:RowMaxDisk,ColMaxDisk:Beta_max);
    
    %[RowsDisk,ColsDisk]  = LinearCoord2(size(Energy));
     Angle = OrientationMat(RowMinDisk:RowMaxDisk,ColMaxDisk:Beta_max);
     Extensions_labelized_crop = LabeledComponents(RowMinDisk:RowMaxDisk,ColMaxDisk:Beta_max); 
     indic_from_dest = indic_from_dest.*(LabeledComponents>0);
     indic_from_dest(crow, ccol)= 0; 
    
    %[~, Cadr] = AvgAngleSign( Angle, RowFirst,ColFirst, Rows_En,Cols_En, Extensions_labelized_crop, RowsDisk,ColsDisk);
    
    if Extreme_Points(crow, ccol) == 1 %%%% extrema points
    
        if AngleDelta ~= pi/2
        [ indic_from_dest, ConeSmallAngle, ConeBigAngle, moyenne_angle_first_point, Cadr ] = ChooseConeSector( indic_from_dest, RowMinDisk,ColMaxDisk,...
                                           MeshAllRows,MeshAllCols,AngleDelta, Angle, Energy,CoordDest,Extensions_labelized_crop, AngleStartPoint,optionAngleEstimation);
         else
          [indic_from_dest, ~,~, ~] = ChoosePISector(indic_from_dest,RowMinDisk,ColMaxDisk,MeshAllRows,MeshAllCols, AngleDelta, Angle, Energy,CoordDest,Extensions_labelized_crop, AngleStartPoint,optionAngleEstimation);  
        end   
        
          if indic_from_dest(CoordExNode(1), CoordExNode(2)) == 0 %%%%% if starting point is not in the cone of the destination, then it won't be considered a s a destination
            indic (crow,ccol) = 0;        

          end
    else %%%%%% if points on the fiber
        moyenne_angle_fibre = AngleStartPoint; %%%AngleStartPoint of the destination candidates
       % [indic_from_dest, ~,~, ~] = ChoosePISector(indic_from_dest,RowMinDisk,ColMaxDisk,MeshAllRows,MeshAllCols, AngleDelta, Angle, Energy,CoordDest,Extensions_labelized_crop, AngleStartPoint,optionAngleEstimation);  

       [ indic_from_dest ] = ChoosePerpendicularSector( MeshAllRows,MeshAllCols, indic_from_dest,moyenne_angle_fibre, CoordExNode, AngleDelta,crow, ccol );
       if indic_from_dest(CoordExNode(1), CoordExNode(2)) == 0 %%%%% if starting point is not in the cone of the destination, then it won't be considered a s a destination
            indic (crow,ccol) = 0;        

       end
        
    end
        
         
    
    
                                 
end


end

