function [ MaxGabor, ThetaMaxGabor,LambdaMaxGabor ] = MaxGaborComputation(CurrIm)

% MaxGaborComputation computes the maximum response in each pixel, among a pre-defined range 
% of values and keeps in MaxGabor the Gabor coefficient, in ThetaMaxGabor its angle and 
% in LambdaMaxGabor the spatial wavelength (fiber thickness), corresponding to the best local 
% response of the range of values when applied to the current image sample CurrIm

SamplingInterval = 0.157;
SigmaX =           5;
SigmaY =           3;
Phase =            0;
Lambda = [6,8,10];
Theta_vect = [0:SamplingInterval:pi];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nh, nw]       = size(CurrIm);
imfft          = fft2(CurrIm, nh, nw);

LambdaMaxGabor = ones(1,nh*nw)*6;
ThetaMaxGabor  = zeros(1,nh*nw);

compar_vect = zeros(1,nh*nw);
MaxGabor    = zeros(1,nh*nw);


counter = 1;
for j=1: length(Lambda)
   for i=1:length(Theta_vect)
 
    kernel2D       = GaborKernel2D( Lambda(j), SigmaX, SigmaY,Theta_vect(i), Phase );
    
    Img_convoluted = filterGabor2D(imfft, kernel2D);  
    %Img_convoluted = (Img_convoluted-min(Img_convoluted(:)))/(max(Img_convoluted(:))-min(Img_convoluted(:)));
   
    counter = counter + 1;
    img_flatten = Img_convoluted(:)';
    %difference_max = (img_flatten-compar_vect);
    difference_max = img_flatten > compar_vect;

    img_flatten(img_flatten<0) = 0;
    compar_vect(difference_max>0 ) = img_flatten(difference_max>0 );% 
    LambdaMaxGabor(difference_max>0 ) = Lambda(j);
    ThetaMaxGabor(difference_max>0 ) = Theta_vect(i);
    MaxGabor(difference_max>0) = img_flatten(difference_max>0 );
     
    end
end


LambdaMaxGabor = reshape(LambdaMaxGabor,[nh nw]);
ThetaMaxGabor = reshape(ThetaMaxGabor,[nh nw]);
MaxGabor = reshape(MaxGabor,[nh nw]);

end