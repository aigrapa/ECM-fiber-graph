function [ ShortestPathMat ] = DistanceLength(AdjMat,coord,type,order) 

%DistanceLength is computing a matrix of shortest path distances between any 
%2 pair of nodes for a graph whose adjacency matrix is AdjMat
 
a = sum(coord.^2); b = sum(coord.^2);
d = repmat(b,size(AdjMat,1),1) + repmat(a',1,size(AdjMat,1)) - 2*coord'*coord;
DistanceMatI = sqrt(max(d,0));  

DistanceMat = DistanceMatI;
DistanceMat = DistanceMat.*AdjMat;
epsi = 1e-6;
sizeGraph = size(AdjMat,1);

if (order <4)
    if type == 'INT'
       % [ShortestPathMat,NodePath] = dijkstra(AdjMat,AdjMat); %costsG = costsG./max(costsG(:)); 
       [ShortestPathMat,NodePath] = dijkstra(DistanceMat,DistanceMat);
       [OrderGuide,~] = dijkstra(AdjMat,AdjMat);
            if order~=0
            ShortestPathMat(OrderGuide>order) =0;
            %DistanceMat  = FiberLength(DistanceMat,ShortestPathMat,NodePath);
            end

    else
        if type == 'SUB'
            %[ShortestPathMat,NodePath] = dijkstra(AdjMat,AdjMat);
            [ShortestPathMat,NodePath] = dijkstra(DistanceMat,DistanceMat);
            [OrderGuide,~] = dijkstra(AdjMat,AdjMat);
            ShortestPathMat = 1./(ShortestPathMat+epsi);ShortestPathMat(ShortestPathMat==1e+6) = 0; 
            if order~=0
                ShortestPathMat(OrderGuide<1/(order+1)) =0;
                %DistanceMat  = FiberLength(DistanceMat,ShortestPathMat,NodePath);
                %DistanceMat(DistanceMat>0) = 1./DistanceMat(DistanceMat>0); 
                %ShortestPathMat(ShortestPathMat>0) = 1./ShortestPathMat(ShortestPathMat>0); 
            end


        end
    end
else
    if type == 'INT'
        %[ShortestPathMat,NodePath] = dijkstra(AdjMat,AdjMat); 
        [ShortestPathMat,NodePath] = dijkstra(DistanceMat,DistanceMat);
         ShortestPathMat(ShortestPathMat == Inf) = 0;
        %DistanceMat  = FiberLength(DistanceMat,ShortestPathMat,NodePath);
    else
        if type == 'SUB'
            %[ShortestPathMat,NodePath] = dijkstra(AdjMat,AdjMat);
            [ShortestPathMat,NodePath] = dijkstra(DistanceMat,DistanceMat);
            ShortestPathMat = 1./(ShortestPathMat+epsi);ShortestPathMat(ShortestPathMat==1e+6) = 0; 
            %DistanceMat  = FiberLength(DistanceMat,ShortestPathMat,NodePath);
            %DistanceMat(DistanceMat>0) = 1./DistanceMat(DistanceMat>0); 
           % ShortestPathMat(ShortestPathMat>0) = 1./ShortestPathMat(ShortestPathMat>0);
           
        end
    end
    
end


 
 
 %G = G./max(G(:)); 
 %G = G.*AdjG;G = G./max(G(:)); 



end