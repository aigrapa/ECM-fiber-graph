function [ DeformMap ] = deformHspacepores( fibersImage, rows,cols )

%deformHspacepores forms a parametric pore orientation isotropy map (DeformMap) 
%starting from a morphological skeleton graph fibersImage

DeformMap = zeros (rows, cols);

rgbImage = fibersImage;
binaryImage = 1-(rgbImage);
binaryImage = double(binaryImage);
labeledImage = bwlabel(binaryImage,4);labeledImage = labeledImage +1;      

allArea = struct2array( regionprops(labeledImage, 'Area')); 
allOrientation = struct2array( regionprops(labeledImage, 'Orientation'));


labelsBorders = [labeledImage(:,1);labeledImage(1,:)';...
                 labeledImage(:,size(labeledImage,1));labeledImage(size(labeledImage,1),:)'];

labelsBorders = unique(labelsBorders);
for ii = 1: length(labelsBorders)
    labeledImage(labeledImage == labelsBorders(ii)) = -1;
end       

allOrientation(labelsBorders) = [-1];    


aux = labeledImage;
for ii = 1: max(max(labeledImage))
aux(labeledImage ==ii) = allOrientation(ii);     
end 

DeformMap = aux;

%%%%%%% add for Orientation only
negOrientation = find(DeformMap<0 & DeformMap~=-1) ;
ToReplace = DeformMap(negOrientation);
ToReplace = ToReplace + 180;
DeformMap(negOrientation) = ToReplace;


PosRegions = find(allArea~=-1);        
CountRegions = length(PosRegions);

CurrOr = allOrientation(PosRegions);
negOrientation = find(CurrOr<0) ;
ToReplace = CurrOr(negOrientation);
ToReplace = ToReplace + 180;
CurrOr(negOrientation) = ToReplace;      
RegMedAngle = median(CurrOr);
RegMedAngle = round(RegMedAngle*pi/180,1);


JustReg = find(DeformMap~=-1);
DeformMap(JustReg) = DeformMap(JustReg)*pi/180;

DeformMap(JustReg) = round(DeformMap(JustReg),1);
DeformMap(DeformMap ==RegMedAngle) =  DeformMap(DeformMap ==RegMedAngle) +1/15;

DeformMap(JustReg) =min(1./(abs(DeformMap(JustReg) -RegMedAngle)),15);
DeformMap(DeformMap == -1) = NaN;
%DeformMap(DeformMap == -1) = 0;
 
end