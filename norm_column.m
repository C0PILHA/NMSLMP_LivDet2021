function X_norm = norm_column(X, x_max, x_min)

[n, m] = size(X);

X_norm = zeros(n,m);

for j=1:m
    x = X(:,j);
    
    den = (x_max(j) - x_min(j));
    
    if den ~= 0    
        X_norm(:,j) = (x-x_min(j))/den;        
    end
end

end

