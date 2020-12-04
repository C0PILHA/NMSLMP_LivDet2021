function r = u(x , c, sig)

%  r = exp((-(x-c)^2)/sig);
% 
%  r = 1/(1+r);
 
% r = sigmf(x,[1.0/sig c]); melhor: 7.5, pior: 8.4
% 
% r = sigmf(x,[0.75/sig c]); melhor: 8.6, pior: 9.2

% r = sigmf(x,[1.25/sig c]); melhor: 5.7, pior: 6.4

% r = sigmf(x,[1.5/sig c]); melhor: 6.8, pior 7.1

%r = sigmf(x,[1.25/sig c]); 
%\lambda = 0.1: [7.7,10.1],
%\lambda = 0.2: [7.8,9.8], 
%\lambda = 0.3: [5.5,6.1],
%\lambda = 0.4: [6.9,7.8],
%\lambda = 0.5: [8.0,8.8],
%\lambda = 0.6: [15.5,17.2],
%\lambda = 0.35: [7.3,8.8],
%\lambda = 0.25: [1.8,2.6].

r = sigmf(x,[sig c]);
end