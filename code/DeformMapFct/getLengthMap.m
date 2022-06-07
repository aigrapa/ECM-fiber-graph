function [DeformMap, stats_edges] = getLengthMap(AdjH,HFirstOrDist,y,rows,cols, LambdaMaxGabor,ThetaMaxGabor )

%getLengthMap forms a parametric length map (DeformMap), starting
%from a graph whose adjacency matrix is AdjH, and distance matrix is
%HFirstOrDist, whith y representing the nodes coordinates in 2D 

DeformMap = NaN(rows,cols);
UpperHalf = triu(AdjH,1);
[NodeI, NodeJ] = find(UpperHalf > 0);
stats_edges = cell(1,size(NodeI,1))';


for i = 1: size(NodeI,1) %% for all the edges
    
    %%% get coordinates of intermediary points between NodeI(i) and NodeJ(i) on the grid
    [c1,c2] = bresenham(y(1,NodeI(i)),y(2,NodeI(i)),y(1,NodeJ(i)),y(2,NodeJ(i))); 
    edgeIntermed = zeros(2,size(c1,1));
    edgeIntermed(1,:) = c1';
    edgeIntermed(2,:) = c2';         

    ratioLength = HFirstOrDist(NodeI(i),NodeJ(i));

    coordEdge = sub2ind(size(DeformMap),edgeIntermed(1,:),edgeIntermed(2,:));            
    DeformMap(coordEdge) = ratioLength;
    
    stats_edges{i,1} = i;
    stats_edges{i,2} = ratioLength;
    stats_edges{i,3} = LambdaMaxGabor(coordEdge);
    stats_edges{i,4} = ThetaMaxGabor(coordEdge);

end


stats_edges = array2table(stats_edges);
stats_edges.Properties.VariableNames(1:1) = {'fiber_ID'};
stats_edges.Properties.VariableNames(2:2) = {'fiber_length'};
stats_edges.Properties.VariableNames(3:3) = {'fiber_thickness'};
stats_edges.Properties.VariableNames(4:4) = {'fiber_orientation'};


%%%%% place NaN for the nodes
NodeCoordinates = sub2ind(size(DeformMap),y(1,:),y(2,:));
DeformMap(NodeCoordinates) = NaN;

end

