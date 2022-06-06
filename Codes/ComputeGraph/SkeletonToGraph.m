function [AdjMat,skel2,g] = SkeletonToGraph(draw_graph, bw)


%convert a morphological skeleton representation into a network associated
%graph (see getMorphoSkelGraph)
    
    
[x_length, y_length] = size(bw);
ExtremNode = cell(1,1);

k = 1;
ExtOneByOne = zeros([x_length, y_length]);
ExtOneByOne(bw == k) = k;


skel = bw;
skel(bw > 0) = 1;

skel = Skeleton3D(bw);
%skel = bwmorph(skel, 'spur');
skel = bwmorph(skel, 'clean');
%[graph,node,link] = Skel2Graph3D(skel,0);
[graph,node,link] = Skel2Graph3D(skel,2);
skel2 = Graph2Skel3D(node,link,x_length,y_length,1);
[graph2,node2,link2] = Skel2Graph3D(skel2,0);

wl = sum(cellfun('length',{node.links}));

AdjMat = graph2;
node = node2;
link = link2;

g=struct('node',{node},'link',{link});

    
    ExtremNode{k}=[];
    if draw_graph
        fig = figure;hold on;
    end
    for i=1:length(node)
        %i
        if(g.node(i).ep==1)   %%%%%%%%%%%%%%%%%%%%%%if the node is an endpoint
            indix=g.node(i).idx;
            [X,Y] = ind2sub(size(ExtOneByOne),indix);
            ExtremNode{k}=[ExtremNode{k};X Y];  % Coordinates of extrem nodes  

        end
        
        X1 = g.node(i).comx;
        Y1 = g.node(i).comy;
    
        if draw_graph
            
            if (g.node(i).ep ==1)
                %ncol = 'c';
                ncol = 'r';
            else
                %ncol = 'm';
                ncol = 'r';
            end
           
            for n=1:length(g.node(i).links)    % draw all connections of each node
                if(g.node(g.link(g.node(i).links(n)).n2).ep==1)
                    col='k'; % branches are blue
                    idxb=g.node(g.link(g.node(i).links(n)).n2).idx;

                else
                    col='k'; % links are red
                end
                if(g.node(g.link(g.node(i).links(n)).n1).ep==1)
                    col='k';
                end


                % draw edges as lines using voxel positions
                for l = 1:length(g.link(g.node(i).links(n)).point)-1            
                    [x3,y3]=ind2sub([x_length, y_length],g.link(g.node(i).links(n)).point(l));
                    [x2,y2]=ind2sub([x_length, y_length],g.link(g.node(i).links(n)).point(l+1));
                    line([y2 y3],[x2 x3],'Color',col,'LineWidth',2);
                    

                end
            end
            % draw all nodes as yellow circles or blue cycles
           plot(Y1,X1,'o','Markersize',7,...
                'MarkerFaceColor',ncol,...
                'Color','k');axis([1 x_length 1 y_length]);   
        end
    end

    if draw_graph
        set(gcf,'Color','white');
       axis([1 x_length 1 y_length]); axis off;
       axis ('square'); 
       set(gca, 'YDir','reverse');
       %set(h, 'Ydir', 'reverse');
        drawnow;
        %title('Graph of the skeleton')
    end
 %print(fig,'Graph','-dpng');
% export_fig(fig, 'VoronoiGraph.png');
     
%toc;
end

