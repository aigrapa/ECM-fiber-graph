function [NodesImg] = NodeIdentificationFinal(Graph,g)


TotalNbNodes = length(g.node);
size_G       = size(Graph,1);
NodesImg     = zeros(size_G,size_G);
%NodesOrd2 = [];
%ct = 1;
for i = 1:TotalNbNodes
    
    if(g.node(i).ep ~= 1)
       %if length(g.node(i).idx)~= 2 
          Y = round(g.node(i).comx);
          X = round(g.node(i).comy);
          NodesImg(Y,X) = i;
       %else
         %  NodesOrd2 = [NodesOrd2;i];
       %end
          
    else
        indix = g.node(i).idx;
        [X,Y] = ind2sub([size_G,size_G], indix);
         NodesImg(X,Y) = i;
    end
  
   
end



%figure, colormap gray, imagesc (NodesImg);
end


% MiddleCoordX = zeros(1,TotalNbNodes);
% MiddleCoordY = zeros(1,TotalNbNodes);
% 
% for i = 1:TotalNbNodes
%     MiddleCoordY(i) = g.node(i).comx;
%     MiddleCoordX(i) = g.node(i).comy;
%     
% end