function  plotGraph(GraphPlot,x,taille1, taille2)

myplot = @(x,y,ms,col)plot(x,y, 'o', 'MarkerSize', ms, 'MarkerEdgeColor', 'k', ...
    'MarkerFaceColor', col, 'LineWidth', 2); 
% myscatter = @(x,y,ms,col)scatter(x,y, 'o','SizeData', ms, 'MarkerEdgeColor', 'k', ...
%     'MarkerFaceColor', col, 'LineWidth', 2); 
myplots = @(x,y,ms,col,lwidth)plot(x,y, 'o', 'MarkerSize', ms, 'MarkerEdgeColor', 'k', ...
    'MarkerFaceColor', col, 'LineWidth', lwidth); 
%%%%% x = 2D coordinates of G 
%%%%% taille = plot size

p = size(GraphPlot,1); 
cmp = (getPyPlot_cMap('rainbow',p));      
ccG = cmp;
ccG = jet(p);
labels = cellstr( num2str([1:p]') );

%figure, hold on, title 'Graph';



for i =1:p
    for j = 2:p
        if (GraphPlot(i,j)==1)  

            line([(x(2,i)) (x(2,j))],[(taille1 -x(1,i)+1) (taille2 -x(1,j)+1)],'Color','k','LineWidth',4/10);
        else 
            if (GraphPlot(i,j)>0 && GraphPlot(i,j)<1 )
            line([(x(2,i)) (x(2,j))],[(taille1 -x(1,i)+1) (taille2 -x(1,j)+1)],'Color','k','LineWidth',GraphPlot(i,j)*3/10);
            else
                if (GraphPlot(i,j)>1)
            line([(x(2,i)) (x(2,j))],[(taille1 -x(1,i)+1) (taille2 -x(1,j)+1)],'Color','k','LineWidth',GraphPlot(i,j)/10);
                end
            end
        end
    end
end
%axis([0 taille 0 taille]); 
%axis off;set(gcf,'color','w');
axis([0 taille1 0 taille2]); 
axis off;
set(gcf,'color','w');
    
    
 for i=1:p  
     if(sum(GraphPlot(i,:))~=0)
         %text(x(2,i)+1,  taille -x(1,i)+2,labels(i), 'VerticalAlignment',...
                 %     'bottom','HorizontalAlignment','right'); 
    %     myplot(x(2,i), taille -x(1,i)+1, 10, ccG(i,:)); axis('square'); 
    %myplot(x(2,i), taille -x(1,i)+1, 8, [0.6 0.8 0.4]); axis('square'); 
   % myplot(x(2,i), taille -x(1,i)+1, 8, [0.6 0.8 1]); axis('square'); 
   myplot(x(2,i), taille1 -x(1,i)+1, 6, [1 0 0]); axis('square'); 
     else
       % myplot(x(2,i), taille -x(1,i)+1, 10, 'k'); axis('square');
     end
     
end   
   
    
   
     
    
    


    
