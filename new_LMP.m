function LBP_Im = new_LMP(Input_Im, sig, R, MASK)

    if size(Input_Im, 3) == 3
        Input_Im = rgb2gray(Input_Im);
    end
    
    R = ceil(R);
    L = 2*R + 1; %% L = W: tamanho da vizinhança.
    C = R + 1;%round(L/2);
    Input_Im = uint8(Input_Im);
    row_max = size(Input_Im,1)-L+1;
    col_max = size(Input_Im,2)-L+1;
    LBP_Im = zeros(row_max, col_max);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    P = ones(L,L); % Define-se a matriz de pesos
    P(C,C) = 0;
    
    S = 8; % sum(sum(P));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    for i = 1:row_max
        for j = 1:col_max
            
            B = MASK(i:i+L-1, j:j+L-1); % Parcela da máscara
            
            if B(C,C) == 0 % Se o pixel do qual for extraído o LMP não for um pixel válido, então não extraia o micropadrão
                LBP_Im(i,j) = -1;
            else        
                
                A = Input_Im(i:i+L-1, j:j+L-1); % Parcela da imagem
                A = double(A);
                c = A(C,C); 
                
                % Calcula-se o padrão LMP(c) multiplicado por 255
                LBP_Im(i,j) = 255*(u(A(1,1), c, sig)*P(1,1) + u(A(1,C), c, sig)*P(1,C) + u(A(1,L), c, sig)*P(1,L) + u(A(C,1), c, sig)*P(C,1) + u(A(C,L), c, sig)*P(C,L) + u(A(L,1), c, sig)*P(L,1) + u(A(L,C), c, sig)*P(L,C) + u(A(L,L), c, sig)*P(L,L))/S;  
            end
        end
    end
    
    % Remover padrões referentes a áreas inválidas
    LBP_Im = LBP_Im(:); % vetorizar a matriz de padrões (continua funcionando na função de cálculo de histograma)
    LBP_Im = LBP_Im(LBP_Im ~= -1);
    
    
    % Finalmente, tem-se o padrão N_{LMP}(g)
    LBP_Im = round(LBP_Im);
    
end