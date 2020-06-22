function [Hil,Sch] = Suavizado(y)
%% Calcula la transformada de Hilbert y luego le aplica la integral de Schroeder.
% Devuelve la envolvente de la señal (Hil) y la señal suavizada (Sch).
    Hil = hilbert(y);
    Hil = abs(Hil);    
    Sch = fliplr(cumsum(fliplr(y'.^2)));
    Sch = 10*log10(Sch'./max(abs(Sch)));  
    
end