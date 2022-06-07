function [ExtremNode, skel2] = ReconnexionCleaning(pgmFileName,draw_graph, ThreshOnSkeletonLengthBranch, AllConnected)


[x_length, y_length] = size(AllConnected);
%ExtremNode = cell(ConnectedComponentsNr,1);
ExtremNode = cell(1,1);
k = 1;
ExtOneByOne = zeros([x_length, y_length]);
ExtOneByOne(AllConnected == k) = k;
skel = AllConnected;
skel(AllConnected > 0) = 1;

skel = Skeleton3D(AllConnected);
%[graph,node,link] = Skel2Graph3D(skel,0);
[graph,node,link] = Skel2Graph3D(skel,10);
wl = sum(cellfun('length',{node.links}));

skel2 = Graph2Skel3D(node, link, x_length, y_length, 1);
[~,node2,link2] = Skel2Graph3D(skel2,10);

% calculate new total length of network
wl_new = sum(cellfun('length',{node2.links}));

% iterate the same steps until network length changed by less than 0.5%
while(wl_new~=wl)

    wl = wl_new;   

    skel2 = Graph2Skel3D(node2,link2,x_length,y_length,1);
    [graph,node2,link2] = Skel2Graph3D(skel2,10);

    wl_new = sum(cellfun('length',{node2.links}));

end
    
    
node = node2;
link = link2;

%  [graph,node,link] = Skel2Graph3D(skel2,10);

%     skel = skel2;
%figure, colormap gray, imagesc (skel2), title ('Skel2');
g=struct('node',{node},'link',{link});
    %skel = Graph2Skel3D(node,link,w,l,h)
    

ExtremNode{k}=[];
%if draw_graph
    fig = figure;hold on;
%end
for i=1:length(node)

    if(g.node(i).ep==1)   %%%%%%%%%%%%%%%%%%%%%%if the node is an endpoint
        indix=g.node(i).idx;
        [X,Y] = ind2sub(size(ExtOneByOne),indix);
        ExtremNode{k}=[ExtremNode{k};X Y];  % Coordinates of extrem nodes  

    end

    X1 = g.node(i).comx;
    Y1 = g.node(i).comy;

    %if draw_graph

        if (g.node(i).ep ==1)
            ncol = 'r';
        else
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
       plot(Y1,X1,'o','Markersize',5,...
            'MarkerFaceColor',ncol,...
            'Color','k');axis([1 x_length 1 y_length]);   
    %end
end

%if draw_graph
    set(gcf,'Color','white');
   axis([1 x_length 1 y_length]);
   axis ('square'); axis off;
   set(gca, 'YDir','reverse');
   %set(h, 'Ydir', 'reverse');
    drawnow;
    title('Graph representation for the skeleton after reconnexion')
   
    hold off;
%end
    
    save_dir = './stats/img/';
    save_namefile = [fullfile(save_dir, pgmFileName, 'Reconnected_Morphological_skeleton_graph.png')];
    export_fig(fig,save_namefile);
    if draw_graph == 0
     fig.Visible = 'off';
    end
    
    



end

