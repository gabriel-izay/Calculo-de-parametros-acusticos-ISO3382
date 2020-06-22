function RuidoRosa(handles)
%% seteamos los callbacks para que se llame dede los botones
set(handles.btnPlayRR,'callback',{@PlayRR});
set(handles.btnStopRR,'callback',{@StopRR});


%% Evento click en boton Reproducir llama a esta subfuncion
function PlayRR(~,~)
global PlayRR
    try
            arch_RR = 'Generados\RuidoRosa.wav';
            [y,fs]  = audioread(arch_RR);
            PlayRR = audioplayer(y,fs);
            play(PlayRR);
    catch
            % Cálculo de la cantidad de muestras a partir de la 
            % duración en segundos y frecuencia de muestreo.
            Nx = 44100*60;
            %definir coeficientes correspondientes al filtro de 3dB
            B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
            A = [1 -2.494956002 2.017265875 -0.522189400];
            % calculo de nro de muestras nT60
            nT60 = round(log(1000)/(1-max(abs(roots(A)))));
            % Se genera vector de valores Aleatorios
            v = randn(1,(Nx+nT60));
            % se le aplica a la señal aleatoria un filtrado 1/f
            x = filter(B,A,v);
            % se le quitan al vector los valores anteriores a nT60
            x = x(nT60+1:end);
            rr = x./max(abs(x));
            % creo archivo .wav del ruido
            audiowrite('Generados\RuidoRosa.wav',rr,44100);
            arch_RR = 'Generados\RuidoRosa.wav';
            [y,fs]  = audioread(arch_RR);
            player = audioplayer(y,fs);
            play(player);
    end
end
%% Botón Stop
    function StopRR(~,~)
        global PlayRR
        pause(PlayRR);
    end
end