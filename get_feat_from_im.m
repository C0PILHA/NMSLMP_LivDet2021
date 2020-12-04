function feat = get_feat_from_im(im, max_escala, tam_escala, lambda, MASK)

    feat = zeros(1,max_escala*tam_escala);
    
    %Agora vamos definir os labels dos possíveis valores de MSLBP das imagens.
    % (0,0,0,0,0,0,0,0) ~> 0
    % (1,0,0,0,0,0,0,0) ~> 1
    % (1,1,0,0,0,0,0,0) ~> 3
    % ...
    % (1,1,1,1,1,1,1,1) ~> 255
    labels = 0:255;
         
    U1 = [0,1,2,3,4,6,7,8,12,14,15,16,24,28,30,31,32,48,56,60,62,63,64,96,112,120,124,126,127,128,129,131,135,143,159,191,192,193,195,199,207,223,224,225,227,231,239,240,241,243,247,248,249,251,252,253,254,255];
    
    Rn = [1,2,3,4,5,6];

    i_escala = 1;
       for escala = 1:max_escala
%              disp(strcat('Scale: ',num2str(escala)));
            
%             rn = rn_1*alpha;
%             Rn = (rn_1+rn)/2; %Calcula-se o valor do raio atual.
%             rn_1 = rn; %Atualizando o valor de rn.
      
            L = new_LMP(im, lambda, Rn(escala), MASK);
            
%             disp('saiu lfp');
            %Calcula-se o histograma da matriz dos MSLBPs.
            hist = histograma(labels, L);
            %Toma-se como característica o histograma dos padrões
            %uniformes e depois se soma os não uniformes.
            for i_max = 1:58
                feat(i_escala) = hist(U1(i_max)+1);
                %Este valor será zerado para não influenciar na soma
                %depois.
                hist(U1(i_max)+1) = 0;
                i_escala = i_escala + 1;
            end
            feat(i_escala) = sum(hist); %Soma dos valores restantes do histograma.
            i_escala = i_escala + 1;
       end
end