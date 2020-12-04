%Função que implementa a medida de Fisher - uma medida estatística para
% indicar a distancia entre duas distribuições - (no caso aplicação para
% separar o background e o foreground de uma fingerprint)
%
% mf = fisher ( im, w,);
%
% Entradas: ->
%           -> im: recebe o nome do arquivo com a imagem de fingerprint do
%           bancos de dados DB1 FVC2004, NIST Rolled ou NIST Latents;
%           ->blksze: tamanho do bloco usado para dividir a fingerprint
%           inicial
%           
% Saída: -> A imagem Mf: matriz com a mesma dimensão da impressão digital,
%           cujos pontos indicam o valor da medida de fisher no bloco.
%
% Técnica Implementada por Inês Boaventura e Maurílio Boaventura, no
% programa de Pós-Doutorado junto a MSU
%
% Baseado no artigo [1].
%
%---
%[1] Zheng, X; Wang, Y; Zhao, X. "Fingerprint Image Segmentation using
%Active Contour Model

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Mf] = fisher1(im, blksze)
[rows, cols] = size(im);

Mf = zeros(size(im));

nbloco = 0;    

for r = 1 : blksze : rows-blksze
    for c = 1 : blksze : cols-blksze
          nbloco = nbloco + 1;  
          bloco = im(r:r+blksze-1, c:c+blksze-1); 

          ml = mean(mean(bloco));
          u(1:blksze,1:blksze) = u_bloco(bloco, ml);
          Mupper = M_upper(bloco, u);
          Munder = M_under(bloco,u);
          Vupper = V_upper(bloco,u);
          Vunder = V_under(bloco,u);


          if abs(Vupper+Vunder)<0.0000000000000005 
                Mf(r:r+blksze-1, c:c+blksze-1) = 0;
          else
                Mf(r:r+blksze-1, c:c+blksze-1) = (Mupper - Munder)^2/(Vupper+Vunder+0.00000001);
          end

    end
   
end


%%%%%%%%%%%%%%% Funções Auxiliares

function ug = u_bloco(g,media) % u(g(x,y))

[lg,cg] = size(g);
ug = zeros(lg,cg);
for i=1:lg
    for j=1:cg
      if(g(i,j)>=media) 
          ug(i,j) = 1;
      end
    end
end

function r = M_upper(g,ug)
 num = 0;
 den = 0;
 [l,c] = size(g);
 
 for i=1:l
     for j=1:c
       num = num + ug(i,j)*g(i,j);
       den = den + ug(i,j);
     end
 end
 
 r = num/den;
 
function r = M_under(g,ug)
 num = 0;
 den = 0;
 [l,c] = size(g);
 
 for i=1:l
     for j=1:c
       num = num + (1-ug(i,j))*g(i,j);
       den = den + (1-ug(i,j));
     end
 end
 
 r = num/den;
 
 
function r = V_upper(g, ug)
 num = 0;
 mupper = 0;
 [l,c] = size(g);
 
 
 for i=1:l
     for j=1:c
       mupper = mupper + ug(i,j)*g(i,j);
     end
 end
 
 mupper = mupper/(l*c);
 
 for i=1:l
     for j=1:c
       num = num + (ug(i,j)*g(i,j) - mupper)^2;
     end
 end
 
 r = num/(l*c-1); 
 
function r = V_under(g, ug)
 num = 0;
 munder = 0;
 [l,c] = size(g);
 
 
 for i=1:l
     for j=1:c
       munder = munder + (1-ug(i,j))*g(i,j);
     end
 end
 
 munder = munder/(l*c);
 
 for i=1:l
     for j=1:c
       num = num + ((1-ug(i,j))*g(i,j) - munder)^2;
     end
 end
 
 r = num/(l*c-1);

 

