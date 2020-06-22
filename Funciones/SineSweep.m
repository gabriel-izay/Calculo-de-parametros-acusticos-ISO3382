function SineSweep(handles)

%% CALLBACKS 
set(handles.btnGrabarSS,'callback',{@SineSw,handles});
set(handles.btnRepSS,'callback',{@PlaySS});
set(handles.btnRepISS,'callback',{@PlayISS});
set(handles.btnStopSS,'callback',{@Stop});

%% Genera un barrido senoidal y su respectivo filtro inverso.
    function SineSw(~,~,handles)
        try
            f1 = str2double(handles.txtf1.String);
            f2 = str2double(handles.txtf2.String);
            fm = str2double(handles.txtfm.String);
            T = str2double(handles.txtT.String);
            w1 = 2*pi*f1; % w inicial
            w2 = 2*pi*f2; % w final
            t = 0:(1/fm):T-(1/fm); % Vector tiempo
           % Sine Sweep
           ss = sin((w1*(T/log(w2/w1)))*((exp(t/(T/log(w2/w1))))-1));
           ss = ss./max(abs(ss));
           audiowrite('Generados\SineSweep.wav',ss,fm);
           % Filtro Inverso
           iss = (1./exp(t./(T/log(w2/w1)))).*fliplr(ss);
           iss = iss./max(abs(iss));
           audiowrite('Generados\ISS.wav',iss,fm);
           msgbox('Se generaron SineSweep.wav e ISS.wav correctamente')
        catch
           warndlg('Ingrese parámetros válidos', 'Error')
        end  
    end
%% BOTÓN PLAY SS
    function PlaySS(~,~)
        global SSplayer
        try
            arch_audio = 'Generados\SineSweep.wav';
            [y,fs]  = audioread(arch_audio);
            SSplayer = audioplayer(y,fs);
            play(SSplayer);
        catch
            warndlg('Debe generar archivo SineSweep', 'Error')
        end
    end
%% BOTÓN PLAY ISS
    function PlayISS(~,~)
        global SSplayer
        try
            arch_audio = 'Generados\ISS.wav';
            [y,fs]  = audioread(arch_audio);
            SSplayer = audioplayer(y,fs);
            play(SSplayer);
        catch
            warndlg('Debe generar archivo ISS', 'Error')
        end
    end
%% BOTÓN STOP
    function Stop(~,~)
        global SSplayer
        pause(SSplayer);
    end
end
