function [FC1,FC3, filter144, filter344, filter148, filter348, filter196, filter396] = Filtros
%% Genera un archivo con los filtros de octava y tercios de octava.

try 
    disp('Cargando Filtros..');
    load ('Funciones\filtros.mat','FC1','FC3','filter144','filter148','filter196','filter344','filter348','filter396');
catch
    disp('Archivo de Filtros no encontrado. Generando Filtros..');
% Arrays de frecuencias centrales de octava.
FC1 = [31.623 63.096 125.89 251.19 501.19 1000 1995.3 3981.1 7943.3 15849];
% Array de frecuencias centrales de tercios de octava.
FC3 = [25.119 31.623 39.811 50.119 63.096 79.433 100 125.89 158.49 199.53 251.19 316.23 398.11 501.19 630.96 794.33 1000 1258.9 1584.9 1995.3 2511.9 3162.3 3981.1 5011.9 6309.6 7943.3 10000 12589 15849 19953];

filter144 = {1:length(FC1)}; %inicializa la variable filtro de octavas
filter148 = {1:length(FC1)};
filter196 = {1:length(FC1)};
filter344 = {1:length(FC3)}; %inicializa la variable filtro de tercios de octavas
filter348 = {1:length(FC3)};
filter396 = {1:length(FC3)};
    
    for i = 1:length(FC1)
        f1 = (FC1(i))/(2^(1/2));
        f2 = (FC1(i))*(2^(1/2));
        if f2 > 22050
            f2 = 22050;
        end
        filter144{i} = designfilt('bandpassiir','FilterOrder',6,'HalfPowerFrequency1',f1,'HalfPowerFrequency2',f2,'SampleRate',44100);
        filter148{i} = designfilt('bandpassiir','FilterOrder',6,'HalfPowerFrequency1',f1,'HalfPowerFrequency2',f2,'SampleRate',48000);
        filter196{i} = designfilt('bandpassiir','FilterOrder',6,'HalfPowerFrequency1',f1,'HalfPowerFrequency2',f2,'SampleRate',96000);
    end
    for b = 1:length(FC3)
        f1 = (FC3(b))/(2^(1/2));
        f2 = (FC3(b))*(2^(1/2));
        if f2 > 22050
            f2 = 22050;
        end
        filter344{b} = designfilt('bandpassiir','FilterOrder',8,'HalfPowerFrequency1',f1,'HalfPowerFrequency2',f2,'SampleRate',44100);
        filter348{b} = designfilt('bandpassiir','FilterOrder',8,'HalfPowerFrequency1',f1,'HalfPowerFrequency2',f2,'SampleRate',48000);
        filter396{b} = designfilt('bandpassiir','FilterOrder',8,'HalfPowerFrequency1',f1,'HalfPowerFrequency2',f2,'SampleRate',96000);
    end
    save ('Funciones\filtros.mat','FC1','FC3','filter144','filter148','filter196','filter344','filter348','filter396');

%     function test
%         x = audioread('Generados\SineSweep.wav');
%         audioFilt = filtfilt(filter1{5},x);
%         audioFilt = audioFilt./max(abs(audioFilt));
%         audiowrite('Filtrado.wav',audioFilt,44100);
%         semilogx(audioFilt); grid on;
%         fvtool(filter144{1},filter144{2},filter144{3},filter144{4},filter144{5},filter144{6},filter144{7},filter144{8},filter144{9},filter144{10}); grid on;
%         fvtool(filter3{1},filter3{2},filter3{3},filter3{4},filter3{5},filter3{6},filter3{7},filter3{8},filter3{9},filter3{10},filter3{11},filter3{12},filter3{13},filter3{14},filter3{15},filter3{16},filter3{17},filter3{18},filter3{19},filter3{20},filter3{21},filter3{22},filter3{23},filter3{24},filter3{25},filter3{26},filter3{27},filter3{28},filter3{29},filter3{30});
%      end
%test
end