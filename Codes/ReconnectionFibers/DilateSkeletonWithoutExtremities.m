function [ DilatedSkelWExtrem ] = DilateSkeletonWithoutExtremities( LabeledComponents, Reper_dilate)

%%%%%%%%%%this function dilates the original skeleton with the desired size
%%%%%%%%%%(in this case predefined = 5) and makes sure that the vicinities
%%%%%%%%%%around extremn nodes are not dilated, to allof wor going and
%%%%%%%%%%arriving to the points


                    DilatedSkelWExtrem = LabeledComponents;
                    DilatedSkelWExtrem(DilatedSkelWExtrem > 0) = 1;
                    JustOne = DilatedSkelWExtrem;

                    se1 = strel('line',5,0);
                    se2 = strel('line',5,90);
                    DilatedSkelWExtrem = imdilate(DilatedSkelWExtrem, [se1 se2], 'same'); 

                    Diff = DilatedSkelWExtrem;
                    Diff(JustOne ==1) = 10;
                    %figure, colormap gray, imagesc (Diff);

                    Diff(Reper_dilate > 0) = 5;

                    find_extreme = find (Diff ==5);
                    
                    for nr = 1: length(find_extreme)
                        [gety, getx] = ind2sub(size(Diff), find_extreme(nr));

                          for SignX = [-2,-1,0, 1,2] % go through the whole 8 neighbours
                                for SignY = [-2,-1,0, 1,2]                                    
                                        if SignX ==0 && SignY ==0 %%% avoid considering the element itself
                                            continue %%%passes control to the next iteration of for,enclosing it
                                        end

                                        if gety+SignX > 0 && gety+SignX <= size(Diff,1) && getx+SignY > 0 && getx+SignY <= size(Diff,2)
                                            if (Diff(gety+SignX,getx+SignY)==1)
                                                Diff(gety+SignX,getx+SignY) = 0;
                                            end

                                        end
                                end
                          end

                    end

                    Diff(Diff>0) =1;
                    DilatedSkelWExtrem = Diff;



end

