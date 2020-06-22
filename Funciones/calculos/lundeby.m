function [Lu,C]=lundeby(varargin)
%% Implementa el algoritmo de Lundeby, para determinar el extremo de integración de Schroeder
% [Lu,C]=lundeby(IR, Fs, 1)
% IR=respuesta al impulso
% Fs=frecuencia de muestreo
% (1) Plotea
% (0) No Plotea
%
% Devuelve:
% Lu = el punto de truncado 
% C = la constante de correlacion C 
%
% Autor:
% AcMus - Room Acoustic Parameters  version 1.0.0.0 (22 KB) by Bruno S. Masiero
% https://in.mathworks.com/matlabcentral/fileexchange/11392-acmus-room-acoustic-parameters

%%
warning off
energia_impulso = varargin{1}.^2;
Fs = varargin{2};
if nargin == 3
    flag = varargin{3};
else
    flag = 0;
end
%Calcula o nivel de ruido del ultimo 10% de la señal, donde se asume que es ruido
rms_dB = 10*log10(mean(energia_impulso(round(.9*length(energia_impulso)):end))/max(energia_impulso));
%divide en intervalos y obtiene la media 
t = floor(length(energia_impulso)/Fs/0.01);
v = floor(length(energia_impulso)/t);
media=zeros(1,t);   %Reserva memoria
tiempo=zeros(1,t);
for n=1:t
    media(n) = mean(energia_impulso((((n-1)*v)+1):(n*v)));
    tiempo(n) = ceil(v/2)+((n-1)*v);
end
mediadB = 10*log10(media/max(energia_impulso));
%regresión linear en intervalo de 0dB y la media mas cercana a al ruido de fondo rms+5dB
r = max(find(mediadB > rms_dB+5));
if any (mediadB(1:r) < rms_dB+5)
    r = min(find(mediadB(1:r) < rms_dB+5));
end
if isempty(r)
    r=10
elseif r<10
    r=10;
end
[A,B] = cuadMin(tiempo(1:r),mediadB(1:r));
cruce = (rms_dB-A)/B;
if rms_dB > -20
    %Relación  señal ruido insuficiente
    disp('Relación  señal ruido insuficiente');
    Lu=length(energia_impulso);
    if nargout==2
        C=0;
    end
else
    
    %% Iteraciones %%
    error=1;
    INTMAX=50;
    veces=1;
    while (error > 0.0001 && veces <= INTMAX)
    
        %Calcula nuevos intervalos de tiempo para la media, con aproximadamente p pasos por 10dB
        clear r t v n media tiempo;
        p = 5;                          %número de pasos por década
        delta = abs(10/B);              %número de muestras para la tendencia decaimiento 10dB
        v = floor(delta/p);             %intervalo para obtención de la media
        t = floor(length(energia_impulso(1:round(cruce-delta)))/v);
        if t < 2                        %número de intervalos para obtención de la  nueva media 
            t=2;                        %en el intervalo que va del inicio a 10dB antes del punto de cruce
        elseif isempty(t)
            t=2;
        end
    
        for n=1:t
            media(n) = mean(energia_impulso((((n-1)*v)+1):(n*v)));
            tiempo(n) = ceil(v/2)+((n-1)*v);
        end
        mediadB = 10*log10(media/max(energia_impulso));
    
        clear A B noise energia_ruido rms_dB;
        [A,B] = cuadMin(tiempo,mediadB);
        %nueva media de energia de ruido, iniciando en el punto de la linea de tendencia 10dB debajo del cruce
        noise = energia_impulso(round(cruce+delta):end);
        if (length(noise) < round(.1*length(energia_impulso)))
            noise = energia_impulso(round(.9*length(energia_impulso)):end); 
        end       
        rms_dB = 10*log10(mean(noise)/max(energia_impulso));
        %nuevo punto de crue.
        error = abs(cruce - (rms_dB-A)/B)/cruce;
        cruce = round((rms_dB-A)/B);
        veces = veces + 1;
    end
end
if nargout == 1
    if cruce > length(energia_impulso)     
        Lu = length(energia_impulso);        
    else                                        
        Lu = cruce;                     
    end
elseif nargout == 2
    if cruce > length(energia_impulso)
        Lu = length(energia_impulso);
    else
        Lu = cruce;
    end
    C=max(energia_impulso)*10^(A/10)*exp(B/10/log10(exp(1))*cruce)/(-B/10/log10(exp(1)));
end
if (nargout == 0 | flag == 1)
    figure
    plot((1:length(energia_impulso))/Fs,10*log10(energia_impulso/max(energia_impulso)));
    hold;
    stairs(tiempo/Fs,mediadB,'r');
    plot((1:cruce+1000)/Fs,A+(1:cruce+1000)*B,'g');
    line([cruce-1000,length(energia_impulso)]/Fs,[rms_dB,rms_dB],'Color',[.4,.4,.4]);
    plot(cruce/Fs,rms_dB,'o','MarkerFaceColor','y','MarkerSize',10);
    hold;
end