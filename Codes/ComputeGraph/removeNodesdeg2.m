function [G,x] = removeNodesdeg2(G,x)


DegOrdre = sum(G,1); 
if (find(DegOrdre == 2))
     NodesOrdr2 = find(DegOrdre == 2);

    %%%%take care of nodes of order 2
    updateNodes2 = [];
    for ii = 1:length(NodesOrdr2)-1
        for jj = ii + 1: length(NodesOrdr2)
            if G(NodesOrdr2(ii),NodesOrdr2(jj))
                updateNodes2 = [updateNodes2; NodesOrdr2(ii) NodesOrdr2(jj)]; 
            end
        end
    end

    for ii = 1:size(updateNodes2,1)
        row_i = updateNodes2(ii,:);keep_node = [];
        for jj = 1: length(row_i)
            extrem_node = find(G(row_i(jj),:)==1);
            if sum(G(extrem_node(1),:)) ~= 2
                keep_node= [keep_node; extrem_node(1)];
            else
                if sum(G(extrem_node(2),:)) ~= 2
                    keep_node= [keep_node; extrem_node(2)];
                end
            end
        end
        G(keep_node(1), keep_node(2)) = 1;
        G(keep_node(2), keep_node(1)) = 1;
    end
    G(NodesOrdr2,:) = []; G(:,NodesOrdr2) = [];
    x(:,NodesOrdr2) = [];
end 
end