function [ result ] = filterGabor2D(imfft, kernelGabor2D)
%FILTERGABOR2D Summary of this function goes here
%  imfft = fft2(Im);

% store the sizes of the filterkernel and image
[fh, fw] = size(kernelGabor2D); % size of the kernel is fh x fw
[imh,imw] = size(imfft); % size of the image is imh x imw
nh = (max(fh,imh)) + mod(max(fh,imh), 2); 
nw = (max(fw,imw)) + mod(max(fw,imw), 2); 

% calculate the size difference between the filterkernel & the convolution size
cfx = ceil((nw - fw)/2);
cfy = ceil((nh - fh)/2);

% calculate the size difference between the image & the convolution size
cix = fix((nw - imw)/2); 
ciy = fix((nh - imh)/2); 

%%%%%up until now, we made sure the kernel is in the middle
resultkernel = padarray(kernelGabor2D, [cfy cfx], 'both'); % padding with zero's
filterkernelfft = fft2(resultkernel, nh, nw); %%% fft of Gabor kernel padded with zero and placed in the middle


% convolution in frequency domain
convolResult = imfft .* filterkernelfft;

% translate the result back to image domain and swap quadrants using fftshift
resultUnclipped = real(fftshift(ifft2(convolResult)));
 
% only the image in the original size should be returned
result = resultUnclipped(ciy+1:ciy+imh, cix+1:cix+imw);

end
