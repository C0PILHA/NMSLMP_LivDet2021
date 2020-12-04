function [im_out, MASK, labels] = seg_and_crop_fingerprint(im_in)
%% In

% im_in (n x m x 3): original fingerprint RGB image/matrix in 
%[0,255]^{nxmx3}

%% Out

% im_out (n x m): greylevel segmented image/matrix in [0,255]^{nxm}

% MASK (n x m): membership matrix in {0,1}^{nxm}, where 1 means region 
%of interest and 0 means background

% labels (n x m): membership matrix in {-1,1}^{nxm}, where 1 means region 
%of interest and -1 means background


%% Algorithm

    % If the image is RGB then turn it in a greylevel image
    if size(im_in,3) == 3
        im_in = double(rgb2gray(im_in));
    else
        im_in = double(im_in);
    end
   
    % Block size window = 16
     blksze = 16;% 5 in the case of the basis is Swipe2013
     
    % extract the Fisher's measure from the image
    [Mf] = fisher1(im_in,blksze);

    % Calc the mean of the Fisher's measure image
    MMF = mean(mean(Mf));

    % Only consider the areas where the pixel value is greater than the 
    %mean of the Fisher's measure image
    % The MASK is defined by the convex hull of those areas
    MASK = imbinarize(ConvexArea((Mf>MMF)));

    % Greylevel segmented image
    im_out = uint8(im_in.*MASK);
    
    % Labels denoting the membership os back (-1) and foreground (1) in the
    %FingerPrint image
    labels = 2*MASK - 1;
end       
