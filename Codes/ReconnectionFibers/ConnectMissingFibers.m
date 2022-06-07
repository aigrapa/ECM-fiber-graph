function [ g,FinalSkeleton ] = ConnectMissingFibers(pgmFileName, MaxGabor, CurrIm, SkeletonMaxGabor,ExtremNode,ThetaMaxGabor, Radius, draw_graph, ThreshOnSkeletonLengthBranch )



    ThetaMaxGabor(ThetaMaxGabor == pi) =0;
    %%%fiber reconnexion starting from graph representation 
    nb_ext_nodes = 1;
    NewReperExtremit = zeros (size(SkeletonMaxGabor));
    for nb_comp = 1: length(ExtremNode)
        if ~isempty(ExtremNode{nb_comp})
        ExtPointCoord = ExtremNode{nb_comp};
           for nr_nod = 1: size(ExtPointCoord,1)
              NewReperExtremit(ExtPointCoord(nr_nod,1),ExtPointCoord(nr_nod,2)) = nb_ext_nodes;
              nb_ext_nodes = nb_ext_nodes +1;
           end
        end
        nb_ext_nodes = nb_ext_nodes +1;
    end
    ReconnectedFibers = NewReperExtremit;   
    [ReconnectedFibers, ~, ~, ~, ~, ~] = fiberReconnexionDynamic(CurrIm,MaxGabor,ThetaMaxGabor, ReconnectedFibers, Radius, ExtremNode, SkeletonMaxGabor);
    
    %%%% compute again statistics on reconnected fibers
Reconnexions = ReconnectedFibers;
Reconnexions(ReconnectedFibers>1) = 1;
AllConnected = ReconnectedFibers + SkeletonMaxGabor;
AllConnected(AllConnected >0) = 1;
AllConnected = logical(AllConnected);
%[~, FinalSkeleton] = ReconnexionCleaning(draw_graph, ThreshOnSkeletonLengthBranch, AllConnected);
[g, FinalSkeleton] = ReconnexionCleaning(pgmFileName,draw_graph, ThreshOnSkeletonLengthBranch, AllConnected);


end

