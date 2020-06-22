function x = Cortar(x,fm)
%% Recorta la señal recibida desde máximo pico hasta el piso de ruido 
% determinado por el algoritmo de Lundeby

    [~,npico] = max(abs(x));
    x=x(npico:end);
    [Lu,~]=lundeby(x,fm,0);
    if (Lu)<length(x)
        x=x(1:(Lu));
    end
end 