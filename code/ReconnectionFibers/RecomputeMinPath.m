function [costsGabor, pathsGabor ] = RecomputeMinPath(RowsDisk,ColsDisk, EnergyGabor,AllTheAnglesAux,DilatedSkelWExtrem,linearIndFirstPoint, linearIndLastPoint, indexFinalCandidate,AngleStartPoint)

  [MatrixAGabor] = FillCostMatrixAngleConstraint(RowsDisk, ColsDisk, EnergyGabor,AllTheAnglesAux,DilatedSkelWExtrem,linearIndLastPoint, AngleStartPoint);
  
  [costsGabor, pathsGabor] = dijkstra(MatrixAGabor,MatrixAGabor,linearIndFirstPoint, linearIndLastPoint(indexFinalCandidate), 0);


end

