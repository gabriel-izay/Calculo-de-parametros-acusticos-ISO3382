function [b,m]= cuadMin(n,r)
%% Calcula recta de Ajuste por Cuadrados Mínimos.
% Devuelve pendiente y ordenada.  
    A = ones(length(n),2); 
    A(:,2) = n';            
    U = (inv((A')*A))*((A')*r');
    b = U(1);
    m = U(2);

end