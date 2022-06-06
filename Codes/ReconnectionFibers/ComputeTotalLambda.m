function [ totalLambda ] = ComputeTotalLambda( rowsS, colsS, g, i, LambdaMaxGabor )

totalLambda = 0;

%%% get indices of the nodes in both cluster of nodes "n1" and "n2"
indix1 = g.node(g.link(i).n1).idx; 
indix2 = g.node(g.link(i).n2).idx;

%%% get coordinates of the "center of the cluster of nodes"
Y1 = round(g.node(g.link(i).n1).comx); X1 = round(g.node(g.link(i).n1).comy);
Y2 = round(g.node(g.link(i).n2).comx); X2 = round(g.node(g.link(i).n2).comy);    

l1 = length(indix1);
l2 = length(indix2);

%%% compute length of the intermediary fibers
for j = 1: length(g.link(i).point)
    [CoordX, CoordY]  = ind2sub([rowsS,colsS],g.link(i).point(j));
    totalLambda       = totalLambda + LambdaMaxGabor(CoordX, CoordY);
end

%%% make sure to count the "centers of the clusters" as belonging to the
%%% fibers, counted for the length
%%% if l1 == 2, no need to add the center to the length because oftenly,
%%% the nodes of degree 2 are on the diagonal which means that this center
%%% is between (not technically a fiber pixel). 


if l1 >= 3
    totalLambda = totalLambda + LambdaMaxGabor(X1,Y1);
end

if l2 >= 3
    totalLambda = totalLambda + LambdaMaxGabor(X2,Y2);
end
    


end

