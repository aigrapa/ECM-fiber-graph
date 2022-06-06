function [ReconnectedFibers, AllAngleStart, AllAngleEnd, aux_recon_fibers, FinalEnergy, print_avg] = fiberReconnexionDynamic(OriginalImage,DetectedFibersWithGabor,OrientationMat, ReconnectedFibers, Radius, ExtremNode, SkeletonMaxGabor)

%fiberReconnexionDynamic reconnects missing fibers within a cone of AngleDelta rad around each node,
%building on previously detected fibers and morphological graph network representation
%For more info about the implementation, please check: Characterization of fibronectin networks using 
%graph-based representations of the fibers from 2D confocal images, Anca-Ioana Grapa, https://tel.archives-ouvertes.fr/tel-03052167

[RowsSize, ColsSize] = size(ReconnectedFibers);
aux_recon_fibers = ReconnectedFibers;
Extreme_Points = ReconnectedFibers;
FinalEnergy = [];
print_avg = [];
ProhibitMatrix = zeros(size(ReconnectedFibers));

OriginalImage = OriginalImage./max(max(OriginalImage));

AngleDelta = 0.4;

AllAngleStart = [];
AllAngleEnd = [];    


SkeletonOne = SkeletonMaxGabor;
SkeletonOne(SkeletonMaxGabor > 0) = 1;
AllTheAngles = OrientationMat;
%OrientationMat = OrientationMat.*SkeletonOne;

% EnergyTotal = 1./(double(OriginalImage)+1);
% MatrixATotal = FillCostMatrixTotal(EnergyTotal, OriginalImage);

            

   for EveryNode = 1:size(ExtremNode{1},1)  % For every extremity on the fiber number component
      
        CoordExNode = ExtremNode{1}(EveryNode,:);  %% coordinates of the extreme nodes on the kth fiber
   % if ReconnectedFibers(coord(1),coord(2)) ~= 0  %%%% check that the nodes is not labeled as part of a component
        %%%%begin research of the fibers around CoordExNode by
        %%%%first defining your area of research with the
        %%%%coordinates RelativeRowSize, RelativeColSize (meshgrid)
        keep_first = [];
        keep_last = [];

        RelativeRowSize = [1:RowsSize] - CoordExNode(1);
        RelativeColSize = [1:ColsSize] - CoordExNode(2); 
        [MeshAllRows,MeshAllCols] = ndgrid(RelativeRowSize,RelativeColSize); %%% coordinates (+/- where you can extend the research)

        DistanceCard = MeshAllRows.^2+MeshAllCols.^2;  
        indic = DistanceCard < Radius^2;  
        boolean_sphere = indic;              

        %OrientationMat = OrientationMat.*SkeletonOne;
        Angle = OrientationMat;
        AngleStartPoint = Angle(CoordExNode(1), CoordExNode(2)); %%%%coordinates of the point in the whole image represents now the average orientation in that starting point
        AllAngleStart = [AllAngleStart; CoordExNode];

        [ptx,pty] = ind2sub(size(boolean_sphere),find(boolean_sphere>0)); 
        RowMaxDisk = max(ptx);  Beta_max = max(pty);                                     
        RowMinDisk = min(ptx);  ColMaxDisk = min(pty);  

        Energy = 1./(double(OriginalImage)+1); EnergyGabor = 1./(double(DetectedFibersWithGabor)+1);

        Extensions_labelized_use = SkeletonMaxGabor;             


        Energy(~boolean_sphere) = Inf;  EnergyGabor(~boolean_sphere) = Inf;                
        Energy = Energy(RowMinDisk:RowMaxDisk,ColMaxDisk:Beta_max);
        EnergyGabor = EnergyGabor(RowMinDisk:RowMaxDisk,ColMaxDisk:Beta_max);
        

        [RowsDisk,ColsDisk]  = LinearCoord2(size(Energy));
        Angle = Angle(RowMinDisk:RowMaxDisk,ColMaxDisk:Beta_max);
        Extensions_labelized_crop = Extensions_labelized_use(RowMinDisk:RowMaxDisk,ColMaxDisk:Beta_max); 
        AllTheAnglesAux = AllTheAngles (RowMinDisk:RowMaxDisk,ColMaxDisk:Beta_max);

        %DilatedSkelWExtrem = DilateSkeletonWithoutExtremities( SkeletonMaxGabor, Reper_dilate);
        DilatedSkelWExtrem = SkeletonOne;
        DilatedSkelWExtrem = DilatedSkelWExtrem(RowMinDisk:RowMaxDisk,ColMaxDisk:Beta_max);               

        indic = indic.*(SkeletonOne>0);
        indic(CoordExNode(1),CoordExNode(2))= 0;  
        optionAngleEstimation = 0; 

        if AngleDelta ~= pi/2
        [ indic, ConeSmallAngle, ConeBigAngle, moyenne_angle_first_point, Cadr ] = ChooseConeSector( indic, RowMinDisk,ColMaxDisk, MeshAllRows,MeshAllCols,AngleDelta, Angle, Energy,CoordExNode,Extensions_labelized_crop, AngleStartPoint,optionAngleEstimation);          
        else                
        [ indic,ConePiAngle, Cadr, moyenne_angle_first_point] = ChoosePISector(indic, RowMinDisk,ColMaxDisk, MeshAllRows,MeshAllCols,AngleDelta, Angle, Energy,CoordExNode,Extensions_labelized_crop, AngleStartPoint,optionAngleEstimation );
        end


        optionAngleEstimation = 1;
%                 if AngleDelta ~= pi/2
        indic = SelectSymCone( indic, Extreme_Points,CoordExNode, AngleDelta, OrientationMat, OriginalImage,SkeletonOne, RowsSize, ColsSize, Radius,optionAngleEstimation,moyenne_angle_first_point);
%                 end


        indic (ProhibitMatrix ==1) = 0;
        indic = CheckReturns(indic, CoordExNode, AllAngleStart, AllAngleEnd );        

        if ProhibitMatrix (CoordExNode(1), CoordExNode(2))
            indic = zeros(size(indic));
        end


        if ~isempty(find(indic,1))  % if labeled pixels are detected

           if  AngleDelta ~= pi/2
                if moyenne_angle_first_point <= AngleDelta || moyenne_angle_first_point >= pi-AngleDelta
                   DelimitedCone = ConeSmallAngle(RowMinDisk:RowMaxDisk,ColMaxDisk:Beta_max); 
                   DelimitedCone (CoordExNode(1)-RowMinDisk+1, CoordExNode(2)-ColMaxDisk+1) = 1;
                   Energy (~DelimitedCone) = Inf; EnergyGabor (~DelimitedCone) = Inf;
                else

                   DelimitedCone = ConeBigAngle(RowMinDisk:RowMaxDisk,ColMaxDisk:Beta_max); 
                   DelimitedCone (CoordExNode(1)-RowMinDisk+1, CoordExNode(2)-ColMaxDisk+1) = 1;
                   Energy(~DelimitedCone) = Inf; EnergyGabor (~DelimitedCone) = Inf;

                end
           else
               DelimitedCone = ConePiAngle(RowMinDisk:RowMaxDisk,ColMaxDisk:Beta_max);
               DelimitedCone (CoordExNode(1)-RowMinDisk+1, CoordExNode(2)-ColMaxDisk+1) = 1;
               Energy(~DelimitedCone) = Inf; EnergyGabor (~DelimitedCone) = Inf;

           end

            %%% when pi/2

            linearIndFirstPoint = sub2ind(size(Energy), CoordExNode(1)-RowMinDisk+1, CoordExNode(2)-ColMaxDisk+1);
            linearIndLastPoint = find(indic(RowMinDisk:RowMaxDisk,ColMaxDisk:Beta_max)); 

             %%%%%%%%%%%%%%%%%%%%%%%                        

            compute = true;

            if compute 

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Oriented graph and Dikstra

                %MatrixA = FillCostMatrix(RowsDisk,ColsDisk, Energy,DilatedSkelWExtrem, linearIndLastPoint); 
                MatrixA = FillCostMatrix(RowsDisk,ColsDisk, Energy,DilatedSkelWExtrem, linearIndLastPoint); 
                %[ MatrixA] = FillCostMatrixAngleConstraint(RowsDisk,ColsDisk, Energy,AllTheAnglesAux,DilatedSkelWExtrem, linearIndLastPoint, AngleStartPoint);
                [costs,paths] = dijkstra(MatrixA,MatrixA,linearIndFirstPoint,linearIndLastPoint,0); 
                %[ TangentExtrem ] = GetOrientationBetweenExtremities(Energy, linearIndFirstPoint, linearIndLastPoint );                     


               if (iscell(paths)) 
                   checkpathNull = cellfun(@any,paths); 
                   else
                   checkpathNull = any(paths);  
               end

                if (sum(checkpathNull)~=0) %%%%%meaning that the path is non-null

                    IndexPixelPath = paths; 
                    PathTotalCost = costs;  
                    
                    

                    
                    
                    DecisionMin = PathTotalCost; 
                    [indPathMinCost] = find(DecisionMin == min(DecisionMin));                           


%                             AngleDiff = ComputeAngleDiff( AngleStartPoint, linearIndLastPoint, Angle);
%                             indPathMinCost = find( AngleDiff == min( AngleDiff));

                    if (length(indPathMinCost)>1)
                     indPathMinCost = indPathMinCost(1);
                    end




                     %if  DecisionMin(indPathMinCost) <= 0.7   
                    if  DecisionMin(indPathMinCost) <= 500
                        FinalEnergy = [FinalEnergy; DecisionMin(indPathMinCost)];
                     
                         if ~iscell(IndexPixelPath)
                          pixPath_intermed = IndexPixelPath(indPathMinCost); 
                        else
                          pixPath_intermed = IndexPixelPath{indPathMinCost};   
                        end
                        
     [~, pathsGabor ] = RecomputeMinPath(RowsDisk,ColsDisk, EnergyGabor,AllTheAnglesAux,DilatedSkelWExtrem,linearIndFirstPoint, linearIndLastPoint, indPathMinCost,AngleStartPoint);
%                        
                       pixPath_intermed = pathsGabor;
      
                        pixPath = pixPath_intermed;  
                        %labelPath = ReconnectedFibers(RowsDisk(pixPath(end))+RowMinDisk-1,ColsDisk(pixPath(end))+ColMaxDisk-1); %%%meaning the label of destination point (of the extremity 
                         %labelPath = DecisionMin(indPathMinCost);
                         labelPath = 1;
                        for pix = 1:length(pixPath)-1
                            ReconnectedFibers(RowsDisk(pixPath(pix))+RowMinDisk-1,ColsDisk(pixPath(pix))+ColMaxDisk-1) = labelPath;
                            SkeletonOne(RowsDisk(pixPath(pix))+RowMinDisk-1,ColsDisk(pixPath(pix))+ColMaxDisk-1) = 1;
                        end
                       %ReconnectedFibers(ExtOneByOne>0) = labelPath;
                        aux_recon_fibers(CoordExNode(1),CoordExNode(2)) = labelPath;


                        [~, PositionLastPoint] = ismember(pixPath_intermed(end),linearIndLastPoint);                                 

                         if (PositionLastPoint)
                              AllAngleEnd = [AllAngleEnd; RowsDisk(pixPath_intermed(end))+RowMinDisk-1,ColsDisk(pixPath_intermed(end))+ColMaxDisk-1];
                              ProhibitMatrix (RowsDisk(pixPath_intermed(end))+RowMinDisk-1, ColsDisk(pixPath_intermed(end))+ColMaxDisk-1 ) = 1;
                              SkeletonOne(RowsDisk(pixPath_intermed(end))+RowMinDisk-1, ColsDisk(pixPath_intermed(end))+ColMaxDisk-1) = 1;
                              ProhibitMatrix(CoordExNode(1), CoordExNode(2)) = 1;

                         else
%                                               
                              AllAngleEnd = [AllAngleEnd; 0,0];
                         end


                         %figure, colormap hot, imagesc (ReconnectedFibers), title (['Intermediar Komponent =' num2str(Komponent) 'EveryNode =' num2str(EveryNode)]);

                   else
                       AllAngleEnd = [AllAngleEnd; 0,0];
                   end
                                %end


                else
                    AllAngleEnd = [AllAngleEnd; 0,0];
                end



            end

         print_avg = [print_avg; Cadr];    
        else

            AllAngleEnd = [AllAngleEnd; 0,0];

        end
  


   end





