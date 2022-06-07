function [ indexSorted,AdjSorted,NodeCoordSorted ] = SortIndex( NodeCoord,AdjMat )


[~,indexSorted]=sort(NodeCoord(2,:));
NodeCoordSorted = NodeCoord(:,indexSorted);

AdjSorted = AdjMat(:,indexSorted);
AdjSorted = AdjSorted(indexSorted,:);


end

