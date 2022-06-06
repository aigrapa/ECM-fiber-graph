function [ kernel2D ] = GaborKernel2D( lambda, sigma_x, sigma_y, theta, phase )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%fills up a matrix of size (2*n+1)*(2*n+1)with the values of a Gabor
%%%%function, where n depends on gaussian standard deviation.
%%%%LAMBDA is the period of the cosinus term (wavelength in pixels >2)
%%%%SIGMA_X, SIGMA_Y is the standard deviation of the gaussian term
%%%%(bivariate gaussian function 2D)
%%%%THETA is the the orientation value of the cosinus term, in radians
%%%%PHASE is the pahse of the cosinus term in radians
%%%%We perfom the normalization of the Gabor kernel
%%%% Example
%%%% sigma_x=15; sigma_y=15;
%%%% lambda=5;theta=30*pi/180;phase=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

max_sigma = max(sigma_x, sigma_y); 
n = ceil(3*max_sigma);
freq = 1/lambda;
dim_noyau = 2*n+1;

[y,x] = meshgrid(-n:n); % definition coordinates
y=-y;
R_theta = [cos(theta), -sin(theta); % definition rotation matrix anti-clockwise
          sin(theta), cos(theta)];
Sigma_aniso = [sigma_x^2,0;
            0, sigma_y^2];
Inv_Covar = inv(Sigma_aniso);

mesh =[y(:)';x(:)'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%build the argument of the exponential of the bivariate gaussian
%%%%function and also make sure to apply the rotation
LeftRightCoord = (mesh'*R_theta*Inv_Covar).*(mesh'*R_theta);
LeftRightCoord = LeftRightCoord';
LeftRightCoord = sum(LeftRightCoord)';
LeftRightCoord = reshape(LeftRightCoord,[dim_noyau,dim_noyau]);

%%%%%build the cosinus term -follwong the x axis
TempWave = mesh'*R_theta;
TempWave = TempWave(:,2);
TempWave = reshape(TempWave,[dim_noyau,dim_noyau]);

%%%%%build the Gabor wave function
GaussWave = exp(-1/2*LeftRightCoord);
%kernel2D = GaussWave;
%kernel2D = cos(2*pi*freq*TempWave+phase);
kernel2D = GaussWave.*cos(2*pi*freq*TempWave+phase);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NORMALIZATION of positive and negative values to ensure that the integral of the kernel is 0.
% This is needed when phi is different from pi/2.
 ppos = find(kernel2D > 0); %pointer list to indices of elements of result which are positive
 pneg = find(kernel2D < 0); %pointer list to indices of elements of result which are negative 
% 
 pos =     sum(kernel2D(ppos));  % sum of the positive elements of result
 neg = abs(sum(kernel2D(pneg))); % abs value of sum of the negative elements of result
%  meansum = (kernel2D+kernel2D)/2;
%  if (meansum > 0) 
%      kernel2D = kernel2D / meansum; % normalization coefficient for negative values of result
%      kernel2D = kernel2D / meansum; % normalization coefficient for psoitive values of result
%  end
 
 
 meansum = (pos+neg)/2;
if (meansum > 0) 
    pos = pos / meansum; % normalization coefficient for negative values of result
    neg = neg / meansum; % normalization coefficient for psoitive values of result
end
 
 
 kernel2D(pneg) = pos*kernel2D(pneg);
 kernel2D(ppos) = neg*kernel2D(ppos);

end

