%% “Caracterización de recintos por medicion de IR”
% Almaraz, Juan; Montemanaro, Marcos; Gonzalez Zayas, Ian
% ******* ¡ IMPORTANTE ! ********
% Verificar que sean añadidas al path la carpeta contenedora de este
% proyecto y sus subcarpetas.
% ejecutar este script (MAIN.m) que llama a la GUI y subprocesos implicados

%%
clear;  
clc;
%Limpia AppData
    appdata = get(0,'ApplicationData');
    a = fieldnames(appdata);
    for ii = 1:numel(a)
      rmappdata(0,a{ii});
    end
addpath('Funciones')  
addpath('Funciones\calculos')

%% Creación de interfaz gráfica de usuario y carga de archivo de filtros
handles=gui();
set(handles.seleccionararchivo,'enable','off');
set(handles.seleccionararchivo,'String','Espere...');
drawnow;

%% Inicializacion de callbacks/handles (sin esto, hay que presionar dos veces cada pushbutton)

    % DESCOMENTAR CUANDO LAS FUNCIONES ESTÉN DISPONIBLES
% Filtros
    % esta seccion carga el archivo de filtros, mientras no esta cargado el
    % boton dice "espere", al finalizar le vuelve a cambiar el nombre a
    % "Cargar impulso" y lo habilita, 
% Carga de archivo "Filtros" 
[FC1,FC3, filter144, filter344, filter148, filter348, filter196, filter396] = Filtros;
setappdata(handles.d,'FC1',FC1);
setappdata(handles.d,'FC3',FC3);
setappdata(handles.d,'filter144',filter144);
setappdata(handles.d,'filter344',filter344);
setappdata(handles.d,'filter148',filter148);
setappdata(handles.d,'filter348',filter348);
setappdata(handles.d,'filter196',filter196);
setappdata(handles.d,'filter396',filter396);
set(handles.seleccionararchivo,'enable','on');
set(handles.seleccionararchivo,'String','Cargar impulso(s)...');

%% Ajuste: Rreproducir ruido rosa
 RuidoRosa(handles);
%% Funciones para generar SineSweep y Filtro Inverso
 SineSweep(handles);
%% Grabación
 Medicion(handles);
%% Calculos de los parámetros y descriptores
calculos(handles);