function statsPores = getStatpores( fibersImage, taille1,taille2 )

DeformMap = zeros (taille1, taille2);

rgbImage = fibersImage;
binaryImage = 1-(rgbImage);
binaryImage = double(binaryImage);
labeledImage = bwlabel(binaryImage,4);labeledImage = labeledImage +1;      
   
allEccentricity = struct2array( regionprops(labeledImage, 'Eccentricity'));
allArea = struct2array( regionprops(labeledImage, 'Area')); 
allOrientation = struct2array( regionprops(labeledImage, 'Orientation'));
allEquivDiameter = struct2array( regionprops(labeledImage, 'EquivDiameter'));
allPerimeter = struct2array( regionprops(labeledImage, 'Perimeter')); 
%allCircularity = struct2array( regionprops(labeledImage, 'Circularity'));


labelsBorders = [labeledImage(:,1);labeledImage(1,:)';...
                 labeledImage(:,size(labeledImage,1));labeledImage(size(labeledImage,1),:)'];

labelsBorders = unique(labelsBorders);
for ii = 1: length(labelsBorders)
    labeledImage(labeledImage == labelsBorders(ii)) = -1;
end       
       
allEccentricity(labelsBorders) = [];
allArea(labelsBorders) = [];    
allOrientation(labelsBorders) = []; 
allEquivDiameter(labelsBorders) = []; 
allPerimeter(labelsBorders) = [];  
%allCircularity(labelsBorders) = [];  

statsPores = table([1:1:length(allArea)]',allArea',allEccentricity',allOrientation',allEquivDiameter',allPerimeter');

statsPores.Properties.VariableNames(1:1) = {'pore_ID'};
statsPores.Properties.VariableNames(2:2) = {'pore_area'};
statsPores.Properties.VariableNames(3:3) = {'pore_eccentricity'};
statsPores.Properties.VariableNames(4:4) = {'pore_orientation'};
statsPores.Properties.VariableNames(5:5) = {'pore_equivdiameter'};
statsPores.Properties.VariableNames(6:6) = {'pore_perimeter'};
%statsPores.Properties.VariableNames(7:7) = {'allCircularity'};
      
end