function [h] = histograma(labels, A)
    n = length(labels);
    h = zeros(1,n);
    [l, c] = size(A);
    for i = 1:l
        for j = 1:c
            for k = 1:n
                if labels(k) == A(i,j)
                    h(k) = h(k) + 1;
                    break;
                end
            end
        end
    end
    h = (1.0*h)/(l*c);
end