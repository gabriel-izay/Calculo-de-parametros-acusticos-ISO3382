function Medicion(handles)
% Callbacks
set(handles.btnAdquirir,'callback',{@SSrec});
set(handles.btnCargarGrab,'callback',{@convolucion});
%%
fm = str2double(handles.txtfm.String);
    function SSrec(~,~)
    try        
    % Reproduce un sine sweep al mismo tiempo que graba la respuesta del
    % recinto.  
        playRec = audioPlayerRecorder(fm);
        fileReader = dsp.AudioFileReader('Generados\SineSweep.wav','SamplesPerFrame',256);
        fm = fileReader.SampleRate;
        fileWriter = dsp.AudioFileWriter('Grabaciones\SSrec.wav','SampleRate',fm);
        while ~isDone(fileReader)
            audioToPlay = fileReader();
            [audioRecorded,nUnderruns,nOverruns] = playRec(audioToPlay);
            fileWriter(audioRecorded);
            if nUnderruns > 0
                fprintf('Se perdieron %d muestras al reproducir; ',nUnderruns);
            end
            if nOverruns > 0
                fprintf('Se perdieron %d muestras al grabar.',nOverruns);
            end
        end
        % Convolucion entre el filtro inverso y la grabacion del sine sweep
        yinv  = audioread('Generados\ISS.wav');
        Ninv = numel(yinv);
        yrec = audioread('Grabaciones\SSrec.wav');
        Nrec = numel(yrec);
        REC = [yrec' zeros(1,Ninv-1)];
        REC = REC./max(abs(REC));
        ISS = [yinv' zeros(1,Nrec-1)];
        ISS = ISS./max(abs(ISS));
        IR = ifft(fft(REC).*fft(ISS));
        IR = IR./max(abs(IR));
        nameIR = strcat('IRs\IR_SSrec.wav');
        audiowrite(nameIR,IR,fm);
        clear yrec;   
    catch
        warndlg('No se detecta dispositivo de audio FullDuplex ASIO');
        warndlg('Debe generar archivos wav de SineSweep', 'Error');
    end
    end

    function convolucion(~,~)   
    % Carga de un IR preexistente
        [file,path] = uigetfile('*.wav');
        if isequal(file,0)
           disp('Operación cancelada');
        else
           disp(['Archivo seleccionado: ', fullfile(path,file)]);
           pathfile = strcat(path,file);
           [x, fm] = audioread(pathfile);
           x = {x};
           filename = {file};
        end
        % Respuesta al impulso 
        [yinv]  = audioread('Generados\ISS.wav');
        Ninv = numel(yinv);
        yrec = x{1,1};
        Nrec = numel(yrec);
        REC = [yrec' zeros(1,Ninv-1)];
        REC = REC./max(abs(REC));
        ISS = [yinv' zeros(1,Nrec-1)];
        ISS = ISS./max(abs(ISS));
        IR = ifft(fft(REC).*fft(ISS));
        IR = IR./max(abs(IR));
        nameIR = strcat('IRs\IR_',filename{1,1});
        audiowrite(nameIR,IR,fm);
        clear yrec;
    end
end