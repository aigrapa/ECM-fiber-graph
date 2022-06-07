function [ TangentExtrem ] = GetOrientationBetweenExtremities(Energy, linearIndFirstPoint, linearIndLastPoint )


 [getyfirst, getxfirst] = ind2sub(size(Energy), linearIndFirstPoint);
 [vectylast, vectxlast] = ind2sub(size(Energy), linearIndLastPoint);
 TangentExtrem = [];

 
    for elements_last = 1: length(vectylast)
       if getxfirst ~= vectxlast(elements_last)
       tang_angle = (getyfirst-vectylast(elements_last))/(getxfirst-vectxlast(elements_last));

           if atan(tang_angle)<0

               TangentExtrem = [TangentExtrem; (atan(tang_angle)+pi)/(pi)];
               else
               TangentExtrem = [TangentExtrem; atan(tang_angle)/(pi)];  

           end

       else
           TangentExtrem = [TangentExtrem; (pi/2)/(pi)];
       end
    end



end

