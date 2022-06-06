function [H,y] = getgraph(rows, cols,Graph1)

%getgraph converts a morphological skeleton graph (Graph1) into a 
%graph-based representation, using first the network associated 
%representation derived with SkeletonToGraph and further on replaces 
%actual fibers between any 2 nodes with edges in H representation; y will
%hold the 2D coordinates of the nodes

Rws = []; Cls = [];

ok = 1;
ct = 1;
while (ok && ct <10)
    [AdjMat1,skel2,g] = SkeletonToGraph(0, Graph1);
    auxAdj = full(AdjMat1); auxAdj(auxAdj>0) = 1;
    DegOrdre = sum(auxAdj,1);
    if (find(DegOrdre == 2))
        ok = 1; ct = ct+1;
    else
        ok = 0;
    end
    Graph1 = skel2;
end


[NodesImg] = NodeIdentificationFinal(skel2,g);
Graph1 = NodesImg;
AdjMat1 = full(AdjMat1);
BWGraph1 = Graph1; 
BWGraph1(BWGraph1>0) =1;

var_aux = [];
for i =1: max(max(Graph1))
    idx = find(Graph1 == i);
    var_aux = [var_aux;idx];
end

[y1,y2] = ind2sub([rows cols],var_aux);
y = [y1';y2'];

AdjMat1(AdjMat1>0) = 1;
H = AdjMat1;

end