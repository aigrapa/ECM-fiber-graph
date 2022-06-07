function [ indic, ConeSmallAngle, ConeBigAngle, moyenne_angle_first_point, Cadr ] = ChooseConeSector( indic, RowMinDisk,ColMaxDisk, MeshAllRows,MeshAllCols,AngleDelta, Angle, Energy,CoordExNode,Extensions_labelized_crop, AngleStartPoint,optionAngleEstimation)

  Rows_En = size(Energy,1);
  Cols_En = size(Energy,2);
  
  %[RowsDisk,ColsDisk]  = LinearCoord2(size(Energy));            
  RowFirst = CoordExNode(1)-RowMinDisk +1; %%%% CoordExNode of the first point in the disk region
  ColFirst = CoordExNode(2) -ColMaxDisk +1; 
%%% porion which before was after RowFirst, ColFirst

                %%%%incerc sa calculez anglestartpoint fata de moyenne si
                %%%%nu  fata de anglestartpoint 
                %%%% trebuie sa integrez chestia cu cadranele verificatul
                %%%% vezi mai jos functia check something
                
               % position_last  = CheckSensandSector(RowFirst,ColFirst, Cadr, linearIndLastPoint );
if optionAngleEstimation == 1
   moyenne_angle_first_point = AngleStartPoint;
   [~, Cadr] = AvgAngleSign( Angle, RowFirst,ColFirst, Rows_En,Cols_En, Extensions_labelized_crop);
else
   [moyenne_angle_first_point, Cadr] = AvgAngleSign( Angle, RowFirst,ColFirst, Rows_En,Cols_En, Extensions_labelized_crop);
end
%moyenne_angle_first_point = AngleStartPoint;

%if AngleDelta == pi/2
     
%     ConeSmallAngle = zeros(size(indic));
%     ConeBigAngle = zeros(size(indic));
%     
%        if Cadr == 1
%             ConeSmallAngle(MeshAllCols < 0 || MeshAllRows > 0) = 1;
%         else
%             if Cadr == 2
%               ConeSmallAngle(MeshAllCols > 0 || MeshAllRows > 0) = 1;  
%             else
%                 if Cadr == 3
%                    ConeSmallAngle(MeshAllCols > 0 || MeshAllRows  < 0) = 1; 
%                 else
%                     ConeSmallAngle(MeshAllCols < 0 || MeshAllRows < 0) = 1; 
%                 end
%             end
%        end
%     ConeBigAngle = ConeSmallAngle;
%     indic = indic.*(ConeSmallAngle > 0);

%else
AngleGamma1 = mod(moyenne_angle_first_point - AngleDelta,pi);
AngleGamma2 = mod(moyenne_angle_first_point + AngleDelta,pi); 
[ indic, ConeSmallAngle, ConeBigAngle ] = ChoosePointsConeSector( MeshAllRows,MeshAllCols, indic,moyenne_angle_first_point, Cadr, AngleDelta, AngleGamma1, AngleGamma2 );
%end               

end

