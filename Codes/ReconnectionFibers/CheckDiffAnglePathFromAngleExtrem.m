function [ DecisionAngleDif ] = CheckDiffAnglePathFromAngleExtrem( IndexPixelPath,PathTotalCost )

    DecisionAngleDif = [];
    %%%%%%%%%%%%check whether the total
    %%%%%%%%%%%%average angle length is
    %%%%%%%%%%%%coherent 
    for numb = 1 : length(PathTotalCost)   %%%% for every candidate
            AvgAnglePath = 0; %%%% initialize for every destination candidate
             if ~iscell(IndexPixelPath)
                mypath = IndexPixelPath(numb); %%%% indicii pixelilor din path
             else
                mypath = IndexPixelPath{numb};   
             end

              if ~isempty(mypath)

%             [~, positiondest] = ismember(mypath(end),linearIndLastPoint); 
%              DecisionAngleDif
%               (positiondest~=0)
                     for elem = 1: length(mypath)
                         AvgAnglePath = AvgAnglePath + abs (Angle(RowsDisk(mypath(elem)), ColsDisk(mypath(elem)))-TangentExtrem(numb));
                     end

                     DecisionAngleDif =[DecisionAngleDif; AvgAnglePath];
                 % end
                     %AvgAnglePath = AvgAnglePath/(length(mypath));
              end


    end


end

