function [feat] = pattern_extraction_MSLMP(grp, max_scale, lambda)
   
   
    tam_escala = 59;

    [N, ~] = size(grp);
 
    M = max_scale*tam_escala;

    feat = zeros(N,3*M);
  
    %Extração das características de cada imagem.
    %[29 61 89 137];%[11 13 17 19 23 29 61 89 137];%[1 2 3 5 7 11 13 17 19 23 29 61 89 137];%[17 19 23 29 61 89 137];
    for i = 1:N
        
        t = cputime;
        
       try
       disp(strcat('Processing image number: ',num2str(i)));
       %Leitura da i-ésima imagem.
       im = imread(grp{i});
       
%        disp('Pre-processing step...');
       [~, im_histequal, im_lowpass, im_highpass, MASK, ~] = PP(im);
       
       % Extrair o padrão da imagem com histograma equalizada
%        disp('Extracting the pattern from the original image...');
       feat(i,1:M) = get_feat_from_im(im_histequal, max_scale, tam_escala, lambda, MASK);
       
       % Extrair o padrão da imagem com filtro passa baixas
%        disp('Extracting the pattern from the smoothed image...');
       feat(i,M+1:2*M) = get_feat_from_im(im_lowpass, max_scale, tam_escala, lambda, MASK);
       
       % Extrair o padrão da imagem com filtro passa altas
%        disp('Extracting the pattern from the highlighted-edges image...');
       feat(i,2*M+1:end) = get_feat_from_im(im_highpass, max_scale, tam_escala, lambda, MASK);

       catch
           
           disp('Error in image: ');
           disp(grp{i});
           
           feat(i,1:max_scale*tam_escala) = -1000;
           continue;
       end
       
       disp(fprintf('Time spent: %f seconds',cputime-t));
    end
end