function [im_croped, im_histequal, im_lowpass, im_highpass, MASK, labels] = PP(im)
%% In

%   im (n x m x 3) an RGB fingerprint image

% MASK, labels ~ parameters from function <<seg_and_crop_fingerprint(.)>>

%% Out

% im_croped (n x m) the cropped greylevel image

% im_croped (n x m) the cropped greylevel smoothed image

% im_croped (n x m) the cropped greylevel image with edges highlighted

%% Method


% If the image is RGB then turn it in a greylevel image
if size(im,3) == 3
    im = uint8(rgb2gray(im));
end

% The same image with the histogram equalized using "Contrast-limited 
%adaptive histogram equalization (CLAHE)" - <<adapthisteq(.)>>
im_histequal = adapthisteq(im);

% Original image
[im_croped, MASK, labels] = seg_and_crop_fingerprint(im);

% Enhanced image
kernel = -1*ones(5);
kernel(5,5) = 30;
im_highpass = adapthisteq(imfilter(im, kernel));
% The mask will be the same in all the cases

% Low pass image
im_lowpass = adapthisteq(uint8(imgaussfilt(im,1)));

end

